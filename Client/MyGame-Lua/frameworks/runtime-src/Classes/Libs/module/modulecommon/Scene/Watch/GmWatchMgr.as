package modulecommon.scene.watch 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.corpscmd.gmViewUserCorpsKejiPropValueUserCmd;
	import modulecommon.net.msg.mountscmd.stGmViewOtherUserMountCmd;
	import modulecommon.net.msg.propertyUserCmd.stGmAddUserObjListPropertyUserCmd;
	import modulecommon.net.msg.sceneHeroCmd.ActiveHero;
	import modulecommon.net.msg.sceneHeroCmd.stGmViewedHeroListCmd;
	import modulecommon.net.msg.sceneHeroCmd.t_HeroData;
	import modulecommon.net.msg.sceneUserCmd.gmRetViewedMainUserDataUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stViewUserBaseData;
	import modulecommon.net.msg.zhanXingCmd.stGmViewOtherUserEquipedWuXueCmd;
	import modulecommon.scene.beings.MountsSys;
	import modulecommon.scene.prop.object.ObjectMgr;
	import modulecommon.scene.prop.object.Package;
	import modulecommon.scene.prop.object.stObjLocation;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.wu.WuMgr;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.scene.zhanxing.T_Star;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIGmWatch;
	/**
	 * ...
	 * @author 
	 */
	public class GmWatchMgr 
	{
		private var m_gkContext:GkContext;
		
		private var m_dicPackage:Dictionary;	//武将装备
		private var m_dicWu:Dictionary;	//武将数据
		public var m_otherKejiLearnd:Array;	//观察其他玩家军团科技信息
		public var m_vecStarOtherPlayer:Vector.<T_Star>;
		public var m_otherMountsSys:MountsSys;
		//private var m_otherTmpID:uint;
		public var m_otherTmpFlag:Boolean; 
		public var m_otherLoadModuleMode:Boolean;
		public var m_beingDic:Dictionary;
		public function GmWatchMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_otherLoadModuleMode = false;
			resetData();
		}
		public function resetData():void
		{
			m_beingDic = new Dictionary();
			m_otherTmpFlag = false;
			m_otherKejiLearnd = new Array();
			m_vecStarOtherPlayer = null;
			m_otherMountsSys = new MountsSys(null, m_gkContext);
			m_dicPackage = new Dictionary();
			m_dicPackage[ObjectMgr.toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON1)] = new Package(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON1, ObjectMgr.PACKAGE_MAIN_WIDTH, ObjectMgr.PACKAGE_MAIN_HEIGHT);
			m_dicPackage[ObjectMgr.toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON2)] = new Package(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON2, ObjectMgr.PACKAGE_MAIN_WIDTH, ObjectMgr.PACKAGE_MAIN_HEIGHT);
			m_dicPackage[ObjectMgr.toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON3)] = new Package(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON3, ObjectMgr.PACKAGE_MAIN_WIDTH, ObjectMgr.PACKAGE_MAIN_HEIGHT);
			m_dicPackage[ObjectMgr.toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_BAOWU)] = new Package(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_BAOWU, ObjectMgr.PACKAGE_MAIN_WIDTH, ObjectMgr.PACKAGE_MAIN_HEIGHT);
			m_dicPackage[ObjectMgr.toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_UEQUIP)] = new Package(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_UEQUIP, 1, ZObjectDef.EQUIP_MAX);
			m_dicWu = new Dictionary();
		}
		//GM被观察者的装备、物品数据-1
		public function processstGmAddUserObjListPropertyUserCmd(msg:ByteArray):void
		{
			resetData();
			var rev:stGmAddUserObjListPropertyUserCmd = new stGmAddUserObjListPropertyUserCmd();
			rev.deserialize(msg);
			var obj:ZObject;
			var pkage:Package;
			for (var i:uint = 0; i < rev.list.length; i++)
			{
				obj = new ZObject();
				if (false == obj.setObject(rev.list[i]))
				{
					continue;
				}
				pkage = m_dicPackage[obj.toPackageKey()] as Package;
				if (pkage == null)
				{
					addWuPakage(obj.m_object.m_loation.heroid);
					pkage = m_dicPackage[obj.toPackageKey()] as Package;
					if (pkage == null)
					{
						continue;
					}
				}
				pkage.addObject(obj);
			}
		}
		//这里放着武将的信息-2
		public function processstGmViewedHeroListCmd(msg:ByteArray):void
		{
			var cmd:stGmViewedHeroListCmd = new stGmViewedHeroListCmd();
			cmd.deserialize(msg);
			var i:uint = 0;
			var wu:WuHeroProperty_Watch;
			var fData:t_HeroData;
			var list:Dictionary;
			var relationList:Vector.<ActiveHero>;
			while (i < cmd.datas.length)
			{
				fData = cmd.datas[i].fData;
				list = cmd.datas[i].list;
				relationList = cmd.datas[i].relationList;
				wu = getWuByHeroID(fData.id) as WuHeroProperty_Watch;
				if (wu == null)
				{
					wu = new WuHeroProperty_Watch(m_gkContext);
					wu.setByHeroData(fData);
					wu.npcBase = m_gkContext.m_dataTable.getItem(DataTable.TABLE_NPCBATTLE, fData.tableID) as TNpcBattleItem;					
					wu.m_vecActiveHeros = relationList;
					if (wu.m_npcBase != null && wu.m_wuPropertyBase != null)
					{				
						
						addWuProperty(wu);
						addWuPakage(wu.m_uHeroID);
					}					
				}
				m_gkContext.m_wuMgr.updateProperty(wu, list);
				i++;
			}
		}
		//观察他人装备的武学-3
		public function processstGmViewOtherUserEquipedWuXueCmd(msg:ByteArray, param:uint):void
		{
			var rev:stGmViewOtherUserEquipedWuXueCmd = new stGmViewOtherUserEquipedWuXueCmd();
			rev.deserialize(msg);
			m_vecStarOtherPlayer = rev.m_list;
		}
		//观察玩家军团科技信息-4
		public function processgmViewUserCorpsKejiPropValueUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:gmViewUserCorpsKejiPropValueUserCmd = new gmViewUserCorpsKejiPropValueUserCmd();
			rev.deserialize(msg);
			m_otherKejiLearnd = rev.m_list;
		}
		
		//发送被观察者人物主信息-5
		public function processgmRetViewedMainUserDataUserCmd(msg:ByteArray):void
		{
			var cmd:gmRetViewedMainUserDataUserCmd = new gmRetViewedMainUserDataUserCmd();
			cmd.deserialize(msg);
			m_beingDic = cmd.m_money;
			var main:stViewUserBaseData = cmd.m_mainData;
			var wu:WuMainProperty_Watch;
			wu = getWuByHeroID(WuProperty.MAINHERO_ID) as WuMainProperty_Watch;
			if (wu == null)
			{
				wu = new WuMainProperty_Watch(m_gkContext);
				wu.m_uHeroID = WuProperty.MAINHERO_ID;
				addWuProperty(wu);
			}
			
			wu.setByMainUserDataUserCmd(main);
			wu.m_userSkillID = main.userskill;
			m_gkContext.m_wuMgr.updateProperty(wu, cmd.datas); 
			
			m_gkContext.m_UIMgr.showFormEx(UIFormID.UIGmWatch);
			var form:IUIGmWatch = m_gkContext.m_UIMgr.getForm(UIFormID.UIGmWatch) as IUIGmWatch;
			if (form)
			{
				form.updateData();
			}
		}
		//坐骑观察-6
		public function processstGmViewOtherUserMountCmd(msg:ByteArray, param:uint):void
		{
			m_otherTmpFlag = true;
			var cmd:stGmViewOtherUserMountCmd = new stGmViewOtherUserMountCmd();
			cmd.deserialize(msg);
			m_otherMountsSys.mountsAttr.baseAttr.mountlist = cmd.mountlist;
			m_otherMountsSys.mountsAttr.trainAttr.trainprops = cmd.trainprops;
			m_otherMountsSys.mountsAttr.clearSubLst();
			m_otherMountsSys.mountsAttr.buildSubLst();
			m_otherMountsSys.mountsAttr.buildTJAttr();
		}
		public function getWuByHeroID(id:uint):WuProperty
		{
			return m_dicWu[id] as WuProperty;
		}
		private function addWuProperty(wu:WuProperty):void
		{
			m_dicWu[wu.m_uHeroID] = wu;
		}
		private function addWuPakage(heroID:uint):void
		{
			var key:uint = ObjectMgr.toPackageKey(heroID, stObjLocation.OBJECTCELLTYPE_HEQUIP);
			if (m_dicPackage[key] == undefined)
			{
				m_dicPackage[key] = new Package(heroID, stObjLocation.OBJECTCELLTYPE_HEQUIP, 1, ZObjectDef.EQUIP_MAX);
			}
		}
		public function getWuList():Array
		{
			var wu:WuProperty;
			var ret:Array = new Array();
			for each (var item:*in m_dicWu)
			{			
				ret.push(item);				
			}
			ret.sort(WuMgr.compare);
			return ret;
		}
		public function getPakage(heroID:uint, location:uint):Package
		{
			return m_dicPackage[ObjectMgr.toPackageKey(heroID, location)];
		}
	}

}