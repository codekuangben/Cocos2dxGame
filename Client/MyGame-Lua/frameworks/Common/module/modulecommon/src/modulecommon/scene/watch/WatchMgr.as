package modulecommon.scene.watch 
{
	/**
	 * ...
	 * @author 
	 * 观察其它玩家时，这里存放这个玩家的相关数据
	 */
	
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.GkContext;
	import flash.utils.Dictionary;
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stViewedUserEquipListPropertyUserCmd;
	import modulecommon.net.msg.sceneHeroCmd.ActiveHero;
	import modulecommon.net.msg.sceneHeroCmd.stViewedHeroListCmd;
	import modulecommon.net.msg.sceneHeroCmd.t_HeroData;
	import modulecommon.net.msg.sceneUserCmd.retViewedMainUserDataUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stMainUserData;
	import modulecommon.net.msg.sceneUserCmd.stViewOtherUserGWSysInfoCmd;
	import modulecommon.net.msg.sceneUserCmd.stViewUserBaseData;
	import modulecommon.scene.prop.object.ObjectMgr;
	import modulecommon.scene.prop.object.Package;
	import modulecommon.scene.prop.object.stObjLocation;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.table.TWuPropertyItem;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuMgr;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	public class WatchMgr 
	{
		private var m_gkContext:GkContext;
		private var m_dicPackage:Dictionary;	//装备数据
		private var m_dicWu:Dictionary;	//武将数据
		
		//神兵信息
		public var m_weargwid:uint;		//佩戴中神兵(未获得神兵时为0)
		public var m_gwslevel:uint;		//号令天下等级
		
		public function WatchMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			resetData();
		}
		private function addWuPakage(heroID:uint):void
		{
			var key:uint = ObjectMgr.toPackageKey(heroID, stObjLocation.OBJECTCELLTYPE_HEQUIP);
			if (m_dicPackage[key] == undefined)
			{
				m_dicPackage[key] = new Package(heroID, stObjLocation.OBJECTCELLTYPE_HEQUIP, 1, ZObjectDef.EQUIP_MAX);
			}
		}
		public function processAddUserObjListProperty(msg:ByteArray):void
		{
			resetData();
			var rev:stViewedUserEquipListPropertyUserCmd = new stViewedUserEquipListPropertyUserCmd();
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
		public function getPakage(heroID:uint, location:uint):Package
		{
			return m_dicPackage[ObjectMgr.toPackageKey(heroID, location)];
		}
		
		private function addWuProperty(wu:WuProperty):void
		{
			m_dicWu[wu.m_uHeroID] = wu;
		}
		public function getWuByHeroID(id:uint):WuProperty
		{
			return m_dicWu[id] as WuProperty;
		}
		public function addMainProperty(msg:ByteArray):void
		{
			var cmd:retViewedMainUserDataUserCmd = new retViewedMainUserDataUserCmd();
			cmd.deserialize(msg);
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
			
			m_gkContext.m_UIMgr.showFormInGame(UIFormID.UIWatchPlayer);		
			var form:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIWatchPlayer);
			form.updateData();
		}
		
		public function processViewedHeroListCmd(msg:ByteArray):void
		{
			var cmd:stViewedHeroListCmd = new stViewedHeroListCmd();
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
						
						this.addWuProperty(wu);
						addWuPakage(wu.m_uHeroID);
					}					
				}
				m_gkContext.m_wuMgr.updateProperty(wu, list); 
				
				i++;
			}			
		}
		
		//神兵信息
		public function processViewOtherUserGWSysInfoUserCmd(msg:ByteArray):void
		{
			var rev:stViewOtherUserGWSysInfoCmd = new stViewOtherUserGWSysInfoCmd();
			rev.deserialize(msg);
			
			m_weargwid = rev.weargwid;
			m_gwslevel = rev.gwslevel;
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
		
		public function resetData():void
		{
			m_dicPackage = new Dictionary();
			m_dicWu = new Dictionary();
			m_dicPackage[ObjectMgr.toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_UEQUIP)] = new Package(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_UEQUIP, 1, ZObjectDef.EQUIP_MAX);
			
			m_weargwid = 0;
			m_gwslevel = 0;
		}
	}

}