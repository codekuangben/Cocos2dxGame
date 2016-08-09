package modulecommon.scene.wu
{
	import com.dnd.DragManager;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.ResourceProgressEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	import com.util.UtilArray;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.net.msg.sceneUserCmd.stActiveUserActRelationCmd;
	import modulecommon.net.msg.sceneUserCmd.stUserActRelationsCmd;
	import modulecommon.net.msg.sceneUserCmd.stViewUserBaseData;
	import modulecommon.scene.benefithall.peoplerank.PeopleRankMgr;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.table.THeroGrowupItem;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.uiinterface.IUIFastSwapEquips;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	import modulecommon.appcontrol.PanelDisposeEx;
	import modulecommon.commonfuntion.HintMgr;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.commonfuntion.delayloader.DelayLoaderBase;
	import modulecommon.net.msg.sceneHeroCmd.ActiveHero;
	import modulecommon.net.msg.sceneHeroCmd.stHeroDataCmd;
	import modulecommon.net.msg.sceneHeroCmd.stHeroMainDataCmd;
	import modulecommon.net.msg.sceneHeroCmd.stRefreshHeroNumCmd;
	import modulecommon.net.msg.sceneHeroCmd.stRemoveHeroCmd;
	import modulecommon.net.msg.sceneHeroCmd.stReqHeroListCmd;
	import modulecommon.net.msg.sceneHeroCmd.stReqMatrixInfoCmd;
	import modulecommon.net.msg.sceneHeroCmd.stRetHeroListCmd;
	import modulecommon.net.msg.sceneHeroCmd.stRetHeroTrainingInfoCmd;
	import modulecommon.net.msg.sceneHeroCmd.stRetRebirthSuccessCmd;
	import modulecommon.net.msg.sceneHeroCmd.stSetHeroXiaYeCmd;
	import modulecommon.net.msg.sceneHeroCmd.t_HeroData;
	import modulecommon.net.msg.sceneUserCmd.stMainUserData;
	import modulecommon.net.msg.sceneUserCmd.stUserDataUserCmd;
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	import modulecommon.scene.beings.Player;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TDataItem;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.table.TWuPropertyItem;
	//import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	import modulecommon.uiinterface.IUIWuXiaye;
	import modulecommon.uiinterface.IUIXingMai;
	
	import org.ffilmation.engine.helpers.fUtil;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class WuMgr
	{
		private var m_dicPropertyName:Dictionary
		private var m_dicWu:Dictionary;
		private var m_dicWuByTableID:Dictionary; //用武将的tableID为键值的Dictionary。其Value是个Vector数组，包含所有同TableID的武将
		private var m_wuListFight:Array;	//出战武将列表
		private var m_wuListNotFight:Array;	//未出战武将列表
		private var m_wuListXiaye:Array;	//在野武将列表
		
		private var m_gkContext:GkContext;
		private var m_bLoaded:Boolean = false; //true - 服务器已经发过武将数据了
		private var m_wuMouseOverPanel:PanelDisposeEx;
		
		//武将培养
		private var m_bHasTrainDatas:Boolean;
		private var m_trainAttrList:Array; //培养属性
		private var m_yuanqidanList:Array; //元气丹
		private var m_oldJinnangList:Array; //锦囊库中锦囊: 用于对比锦囊等级是否提升
		public var bQueryFastTrain:Boolean; //快速培养是否显示提示
		public var bQueryHighTrain:Boolean; //高级培养是否显示提示
		
		//"我的三国关系"(主角)
		private var m_dicMainWuRelations:Dictionary;
		private var m_dicUserActRelations:Dictionary;	//已激活关系数据
		
		protected var m_pathlist:Vector.<String>;
		
		public function WuMgr(gk:GkContext)
		{
			m_dicWu = new Dictionary();
			m_dicPropertyName = new Dictionary();
			
			m_gkContext = gk;
			m_dicPropertyName[WuProperty.PROPTYPE_FORCE] = WuProperty.PROPTYPE_NAME_FORCE;
			m_dicPropertyName[WuProperty.PROPTYPE_IQ] = WuProperty.PROPTYPE_NAME_IQ;
			m_dicPropertyName[WuProperty.PROPTYPE_CHIEF] = WuProperty.PROPTYPE_NAME_CHIEF;
			m_dicPropertyName[WuProperty.PROPTYPE_HPLIMIT] = WuProperty.PROPTYPE_NAME_HPLIMIT;
			m_dicPropertyName[WuProperty.PROPTYPE_LEVEL] = WuProperty.PROPTYPE_NAME_LEVEL;
			m_dicPropertyName[WuProperty.PROPTYPE_EXP] = WuProperty.PROPTYPE_NAME_EXP;
			m_dicPropertyName[WuProperty.PROPTYPE_NEXTEXP] = WuProperty.PROPTYPE_NAME_NEXTEXP;
			m_dicPropertyName[WuProperty.PROPTYPE_PHYDAM] = WuProperty.PROPTYPE_NAME_PHYDAM;
			m_dicPropertyName[WuProperty.PROPTYPE_PHYDEF] = WuProperty.PROPTYPE_NAME_PHYDEF;
			m_dicPropertyName[WuProperty.PROPTYPE_STRATEGYDAM] = WuProperty.PROPTYPE_NAME_STRATEGYDAM;
			m_dicPropertyName[WuProperty.PROPTYPE_STRATEGYDEF] = WuProperty.PROPTYPE_NAME_STRATEGYDEF;
			m_dicPropertyName[WuProperty.PROPTYPE_ZFDAM] = WuProperty.PROPTYPE_NAME_ZFDAM;
			m_dicPropertyName[WuProperty.PROPTYPE_ZFDEF] = WuProperty.PROPTYPE_NAME_ZFDEF;
			m_dicPropertyName[WuProperty.PROPTYPE_BAOJI] = WuProperty.PROPTYPE_NAME_BAOJI;
			m_dicPropertyName[WuProperty.PROPTYPE_BJDEF] = WuProperty.PROPTYPE_NAME_BJDEF;
			m_dicPropertyName[WuProperty.PROPTYPE_LUCK] = WuProperty.PROPTYPE_NAME_LUCK;
			m_dicPropertyName[WuProperty.PROPTYPE_POJI] = WuProperty.PROPTYPE_NAME_POJI;
			m_dicPropertyName[WuProperty.PROPTYPE_FANJI] = WuProperty.PROPTYPE_NAME_FANJI;
			m_dicPropertyName[WuProperty.PROPTYPE_ATTACKSPEED] = WuProperty.PROPTYPE_NAME_ATTACKSPEED;
			m_dicPropertyName[WuProperty.PROPTYPE_SHIQI] = WuProperty.PROPTYPE_NAME_SHIQI;
			m_dicPropertyName[WuProperty.PROPTYPE_ZHANLI] = WuProperty.PROPTYPE_NAME_ZHANLI;
			m_dicPropertyName[WuProperty.PROPTYPE_ZONGZHANLI] = WuProperty.PROPTYPE_NAME_ZONGZHANLI;
			
			m_dicWuByTableID = new Dictionary();
			m_wuListFight = new Array();
			m_wuListNotFight = new Array();
			m_wuListXiaye = new Array();
			//m_dicOnUpdate[WuProperty.PROPTYPE_LEVEL] = onLeveUp;
			
			m_trainAttrList = new Array();
			m_yuanqidanList = new Array();
			m_pathlist = new Vector.<String>();
			m_dicUserActRelations = new Dictionary();
		}
		
		public function getMainWu():WuMainProperty
		{
			return m_dicWu[WuProperty.MAINHERO_ID] as WuMainProperty;
		}
		
		public function getWuByHeroID(id:uint):WuProperty
		{
			return m_dicWu[id] as WuProperty;
		}
		
		public function addWuProperty(wu:WuProperty):void
		{
			m_dicWu[wu.m_uHeroID] = wu;
		}
		
		public function get wujiangNum():uint
		{
			var ret:uint = 0;
			for each (var item:*in m_dicWu)
			{
				ret++;
			}
			return ret - 1;
		}
		
		public function getAllWu():Array
		{
			var ret:Array = new Array();
			for each (var item:*in m_dicWu)
			{
				ret.push(item);
			}
			return ret;
		}
		
		public function addMainProperty(main:stMainUserData):void
		{
			var wu:WuMainProperty;
			wu = getWuByHeroID(WuProperty.MAINHERO_ID) as WuMainProperty;
			
			if (wu == null)
			{
				wu = new WuMainProperty(m_gkContext);
				wu.m_uHeroID = WuProperty.MAINHERO_ID;
				addWuProperty(wu);
			}
			
			wu.setByMainUserDataUserCmd(main);
			
			if (this.m_gkContext.m_UIs.hero)
			{
				this.m_gkContext.m_UIs.hero.updateAlldata();
			}
		}
		public function addMainPropertyWatch(main:stViewUserBaseData):void
		{
			var wu:WuMainProperty;
			wu = getWuByHeroID(WuProperty.MAINHERO_ID) as WuMainProperty;
			
			if (wu == null)
			{
				wu = new WuMainProperty(m_gkContext);
				wu.m_uHeroID = WuProperty.MAINHERO_ID;
				addWuProperty(wu);
			}
			
			wu.setByMainUserDataUserCmdWatch(main);
			
			if (this.m_gkContext.m_UIs.hero)
			{
				this.m_gkContext.m_UIs.hero.updateAlldata();
			}
		}
		
		public function updateHeroProperty(msg:ByteArray):void
		{
			//服务器端用hero表示武将
			var rev:stHeroDataCmd = new stHeroDataCmd();
			rev.deserialize(msg);
			var i:uint = 0;
			var data:t_ItemData;
			var wu:WuHeroProperty;
			wu = getWuByHeroID(rev.heroid) as WuHeroProperty;
			if (wu == null)
			{
				return;
			}
			
			updateProperty(wu, rev.datas);
			
			if (m_gkContext.m_UIs.backPack != null)
			{
				m_gkContext.m_UIs.backPack.updateHero(rev.heroid);
			}
			
			var form:IUIFastSwapEquips = m_gkContext.m_UIMgr.getForm(UIFormID.UIFastSwapEquips) as IUIFastSwapEquips;
			if (form)
			{
				form.updateWuData(rev.heroid);
			}
		}
		
		//刷新武将数量
		public function processRefreshHeroNumCmd(msg:ByteArray):void
		{
			var rev:stRefreshHeroNumCmd = new stRefreshHeroNumCmd();
			rev.deserialize(msg);
			
			var wu:WuHeroProperty;
			wu = getWuByHeroID(rev.heroid) as WuHeroProperty;
			if (wu == null)
			{
				return;
			}
			var bAdd:Boolean = false;
			if (rev.num > wu.m_num)
			{
				bAdd = true;
			}
			
			wu.m_num = rev.num;
			if (m_gkContext.m_UIs.backPack != null)
			{
				m_gkContext.m_UIs.backPack.onWuNumChange(rev.heroid);
			}
			
			if (m_gkContext.m_UIs.zhenfa != null)
			{
				m_gkContext.m_UIs.zhenfa.updateXiayeWuNum(wu);
			}
			
			handleAddheroHint(wu, HintMgr.ADDHERO_REFRESHNUM);
			
			if (bAdd && wu.xiaye)
			{
				m_gkContext.m_systemPrompt.prompt(wu.fullName + "进入在野武将列表，可手动调出");
			}
			var uiwuxiaye:IUIWuXiaye = m_gkContext.m_UIMgr.getForm(UIFormID.UIWuXiaye) as IUIWuXiaye;
			if (uiwuxiaye)
			{
				uiwuxiaye.updateWuNum(wu);
			}
		}
		
		//删除武将
		public function processRemoveHeroCmd(msg:ByteArray):void
		{
			var rev:stRemoveHeroCmd = new stRemoveHeroCmd();
			rev.deserialize(msg);
			
			var wu:WuHeroProperty = m_dicWu[rev.heroid];
			if (null == wu)
			{
				DebugBox.sendToDataBase("WuMgr::processRemoveHeroCmd wu==null");
				return;
			}
			m_gkContext.m_zhenfaMgr.takeDownHero(rev.heroid, true);
			
			
			
			if ((WuProperty.COLOR_PURPLE == wu.color || WuProperty.COLOR_BLUE == wu.color) && null == m_oldJinnangList)
			{
				m_oldJinnangList = getJinnangList();
			}
			
			delete m_dicWu[rev.heroid];
			updateActiveStates();
			deleteWuFromTableIDDictionary(wu);
			
			var list:Array;
			if (wu.chuzhan)
			{
				list = m_wuListFight;
			}
			else if (wu.xiaye)
			{
				list = m_wuListXiaye;
			}
			else
			{
				list = m_wuListNotFight;
			}
			UtilArray.removeFromArray(list, wu);

			m_gkContext.m_objMgr.delWuPakage(rev.heroid);
			
			if (m_gkContext.m_UIs.backPack != null)
			{
				if (wu.xiaye == false)
				{
					m_gkContext.m_UIs.backPack.removeWu(rev.heroid);
				}
				else
				{
					m_gkContext.m_UIs.backPack.removeXiayeWu(wu);
				}
			}
			
			if (m_gkContext.m_UIs.equipSys != null)
			{
				if (wu.xiaye == false)
				{
					m_gkContext.m_UIs.equipSys.removeWu(wu);
				}
			}
			
			if (m_gkContext.m_UIs.zhenfa)
			{
				m_gkContext.m_UIs.zhenfa.updateJinnangGrid();
				m_gkContext.m_UIs.zhenfa.buildList();
				if (wu.xiaye)
				{
					m_gkContext.m_UIs.zhenfa.removeXiayeWu(wu);
				}
			}
			
			var uiwuxiaye:IUIWuXiaye = m_gkContext.m_UIMgr.getForm(UIFormID.UIWuXiaye) as IUIWuXiaye;
			if (uiwuxiaye)
			{
				uiwuxiaye.removeWu(wu);
			}
			
			if (WuProperty.COLOR_PURPLE == wu.color)
			{
				m_gkContext.m_jiuguanMgr.sortPurpleWuList();
			}
		}
		
		//转生成功
		public function processReBirthSuccessCmd(msg:ByteArray):void
		{
			var rev:stRetRebirthSuccessCmd = new stRetRebirthSuccessCmd();
			rev.deserialize(msg);
			
			if (m_gkContext.m_UIs.backPack != null && (m_gkContext.m_UIs.backPack as Form).isVisible())
			{
				m_gkContext.m_UIs.backPack.hideNextRelationWuListByHeroID(rev.heroid - 1);//转生前武将HeroID
				m_gkContext.m_UIs.backPack.switchToHero(rev.heroid);
			}
			var formXM:IUIXingMai = m_gkContext.m_UIMgr.getForm(UIFormID.UIXingMai) as IUIXingMai;
			if (formXM && (formXM as Form).isVisible())
			{
				formXM.hideNextRelationWuListByHeroID(rev.heroid - 1);
			}
			m_gkContext.m_contentBuffer.addContent("wujiangzhuanshengani_info", rev.heroid);
			if (!m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIWuJiangZhuanShengAni))
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIWuJiangZhuanShengAni);
			}
		}
		
		public function setWuChuzhan(wu:WuProperty):void
		{
			if (wu.chuzhan)
			{
				return;
			}
			if (wu.antiChuzhan)
			{
				UtilArray.removeFromArray(m_wuListNotFight, wu);
			}
			else if (wu.xiaye)
			{
				UtilArray.removeFromArray(m_wuListXiaye, wu);
			}
			UtilArray.insertWidthSort(m_wuListFight, wu, compare);
			wu.setChuzhan();
			
			// 更新主角身上的特效
			//updateMainEffByWu();
		}
		
		public function setWuAntiChuzhan(wu:WuProperty):void
		{
			if (wu.antiChuzhan)
			{
				return;
			}
			if (wu.chuzhan)
			{
				UtilArray.removeFromArray(m_wuListFight, wu);
			}
			else if (wu.xiaye)
			{
				UtilArray.removeFromArray(m_wuListXiaye, wu);
			}
			UtilArray.insertWidthSort(m_wuListNotFight, wu, compare);
			wu.setAntiChuzhan();
		}
		public function setWuXiaye(wu:WuProperty):void
		{
			if (wu.xiaye)
			{
				return;
			}
			if (wu.chuzhan)
			{
				UtilArray.removeFromArray(m_wuListFight, wu);
			}
			else if (wu.antiChuzhan)
			{
				UtilArray.removeFromArray(m_wuListNotFight, wu);
			}
			UtilArray.insertWidthSort(m_wuListXiaye, wu, compare);
			wu.setXiaye();
		}
		public function updateMainPropery(msg:ByteArray):void
		{
			var rev:stUserDataUserCmd = new stUserDataUserCmd();
			rev.deserialize(msg);
			var wu:WuMainProperty;
			wu = getWuByHeroID(WuProperty.MAINHERO_ID) as WuMainProperty;
			if (wu == null)
			{
				return;
			}
			
			var oldLevel:uint = wu.m_uLevel;
			var oldZongZhanli:uint = wu.m_uZongZhanli;
			updateProperty(wu, rev.datas);
			
			if (wu.m_uLevel > oldLevel)
			{
				onMainPlayerLevelup(wu, oldLevel);
			}
			
			if (rev.datas[WuProperty.PROPTYPE_ZONGZHANLI] != undefined)
			{
				if (this.m_gkContext.m_UIs.hero)
				{
					this.m_gkContext.m_UIs.hero.upZongZhanli();
				}
				
				if (this.m_gkContext.m_UIs.zhenfa)
				{
					this.m_gkContext.m_UIs.zhenfa.updateAllWuZhanli();
				}
				
				if (oldZongZhanli > 0 && m_gkContext.m_localMgr.isSet(LocalDataMgr.LOCAL_InBatchMoveObj)==false)
				{
					if (wu.m_uZongZhanli > oldZongZhanli)
					{
						var type:int = 0;
						if (rev.datas[WuProperty.PROPTYPE_LEVEL])
						{
							type = 1;
						}
						onZongzhanliUp(wu.m_uZongZhanli - oldZongZhanli, type);
					}
				}
			}
			
			if (m_gkContext.m_UIs.backPack != null)
			{
				m_gkContext.m_UIs.backPack.updateHero(wu.m_uHeroID);
			}
			
			if (rev.datas[WuProperty.PROPTYPE_EXP] != undefined)
			{
				if (m_gkContext.m_UIs.sysBtn)
				{
					m_gkContext.m_UIs.sysBtn.updateExpCount();
				}
			}
			
			var form:IUIFastSwapEquips = m_gkContext.m_UIMgr.getForm(UIFormID.UIFastSwapEquips) as IUIFastSwapEquips;
			if (form)
			{
				form.updateWuData(wu.m_uHeroID);
			}
		}
		
		public function onZongzhanliUp(num:int, type:int):void
		{
			var zhanliParam:Object = new Object();
			zhanliParam["funtype"] = "zhanli";
			zhanliParam["type"] = type;
			zhanliParam["num"] = num;
			m_gkContext.m_hintMgr.addToUIZhanliAddAni(zhanliParam);
			m_gkContext.m_peopleRankMgr.onValueUp(PeopleRankMgr.RANKTYPE_Zhanli);
		}
		
		public function updateProperty(wu:WuProperty, datas:Dictionary):void
		{
			var i:uint = 0;
			//var wu:WuProperty;
			var keyName:String;
			
			var key:String;
			var value:uint;
			for (key in datas)
			{
				value = datas[key];
				keyName = m_dicPropertyName[key];
				if (wu.hasOwnProperty(keyName))
				{
					wu[keyName] = value;
				}
			}
		}
		
		/*public function requestAllWu():void
		{
			var req:stReqHeroListCmd = new stReqHeroListCmd();
			m_gkContext.sendMsg(req);
			
			var req2:stReqMatrixInfoCmd = new stReqMatrixInfoCmd();
			m_gkContext.sendMsg(req2);
		}*/
		
		public function loadAllWuPropery(msg:ByteArray):void
		{
			var rev:stRetHeroListCmd = new stRetHeroListCmd();
			rev.deserialize(msg);
			var i:uint = 0;
			var wu:WuHeroProperty;
			var fData:t_HeroData;
			var list:Dictionary;
			while (i < rev.datas.length)
			{
				fData = rev.datas[i].fData;
				list = rev.datas[i].list;
				wu = getWuByHeroID(fData.id) as WuHeroProperty;
				if (wu != null)
				{
					i++;
					continue;					
				}
				if (wu == null)
				{
					wu = new WuHeroProperty(m_gkContext);
					wu.setByHeroData(fData);
					wu.npcBase = m_gkContext.m_dataTable.getItem(DataTable.TABLE_NPCBATTLE, fData.tableID) as TNpcBattleItem;
					if (wu.m_npcBase != null && wu.m_wuPropertyBase != null)
					{
						this.addWuProperty(wu);
						m_gkContext.m_objMgr.addWuPakage(wu.m_uHeroID);
					}
					addWuToTableIDDictionary(wu);
					
				}
				updateProperty(wu, list);
				
				if (wu.chuzhan)
				{
					m_wuListFight.push(wu);
				}
				else if (wu.antiChuzhan)
				{
					m_wuListNotFight.push(wu);
				}
				else if (wu.xiaye)
				{
					m_wuListXiaye.push(wu);
				}
				i++;				
			}
			m_wuListFight.sort(compare);
			m_wuListNotFight.sort(compare);
			m_wuListXiaye.sort(compare);			
			updateActiveStates();
			
			loaded = true;
						
			
			if (m_gkContext.m_UIs.teamFBZX != null)
			{
				m_gkContext.m_UIs.teamFBZX.onLoadAllWuPropty();
			}
			
			loadConfig();	//武将培养配置数据
			loadConfigUAR();//"我的三国关系"配置数据
			
			// 加载武将的待机资源
			//loadResNUnload();
			//lazyLoadRes();
		}
		
		protected function addWuToTableIDDictionary(wu:WuHeroProperty):void
		{
			var list:Vector.<WuHeroProperty>;
			if (m_dicWuByTableID[wu.tableID] == undefined)
			{
				list = new Vector.<WuHeroProperty>();
				m_dicWuByTableID[wu.tableID] = list;
			}
			else
			{
				list = m_dicWuByTableID[wu.tableID];
			}
			list.push(wu);
		}
		
		protected function deleteWuFromTableIDDictionary(wu:WuHeroProperty):void
		{
			var list:Vector.<WuHeroProperty> = m_dicWuByTableID[wu.tableID];
			if (list)
			{
				var i:int = list.indexOf(wu);
				if (i != -1)
				{
					list.splice(i, 1);
					if (list.length == 0)
					{
						delete m_dicWuByTableID[wu.tableID]
					}
					
				}
				
			}
		}
		
		public function addWu(msg:ByteArray):void
		{
			var rev:stHeroMainDataCmd = new stHeroMainDataCmd();
			rev.deserialize(msg);
			var wu:WuHeroProperty = getWuByHeroID(rev.data.id) as WuHeroProperty;
			if (wu != null)
			{
				return;
			}
			wu = new WuHeroProperty(m_gkContext);
			wu.setByHeroData(rev.data);
			wu.npcBase = m_gkContext.m_dataTable.getItem(DataTable.TABLE_NPCBATTLE, rev.data.tableID) as TNpcBattleItem;
			
			if ((WuProperty.COLOR_PURPLE == wu.color || WuProperty.COLOR_BLUE == wu.color) && null == m_oldJinnangList)
			{
				m_oldJinnangList = getJinnangList();
			}
			
			updateProperty(wu, rev.list);
			addWuProperty(wu);
			addWuToTableIDDictionary(wu);
			m_gkContext.m_objMgr.addWuPakage(wu.m_uHeroID);
			updateActiveStates();
			
			var list:Array;
			if (wu.chuzhan)
			{
				list = m_wuListFight;
			}
			else if (wu.xiaye)
			{
				list = m_wuListXiaye;
			}
			else
			{
				list = m_wuListNotFight;
			}
			UtilArray.insertWidthSort(list, wu, compare);
			
			var uiwuxiaye:IUIWuXiaye = m_gkContext.m_UIMgr.getForm(UIFormID.UIWuXiaye) as IUIWuXiaye;
			if (wu.xiaye == false)
			{
				if (m_gkContext.m_UIs.backPack != null)
				{
					m_gkContext.m_UIs.backPack.addWu(wu.m_uHeroID);
				}
				if (m_gkContext.m_UIs.zhenfa != null)
				{
					m_gkContext.m_UIs.zhenfa.addWu(wu.m_uHeroID);
				}
				
				if (uiwuxiaye)
				{
					uiwuxiaye.toNotXiaye(wu.m_uHeroID);
				}
				if (m_gkContext.m_UIs.equipSys != null)
				{
					m_gkContext.m_UIs.equipSys.addWu(wu);
				}
			}
			else
			{
				if (m_gkContext.m_UIs.backPack != null)
				{
					m_gkContext.m_UIs.backPack.updateWu();
					m_gkContext.m_UIs.backPack.addXiayeWu(wu);
				}
				/*var formXM:IUIXingMai = m_gkContext.m_UIMgr.getForm(UIFormID.UIXingMai) as IUIXingMai;
				if (formXM&&formXM.isVisible())
				{
					formXM.updateWu();
				}*/
				if (m_gkContext.m_UIs.zhenfa != null)
				{
					m_gkContext.m_UIs.zhenfa.addXiayeWu(wu);
				}
				
				if (uiwuxiaye)
				{
					uiwuxiaye.toXiaye(wu.m_uHeroID);
				}
				
				m_gkContext.m_systemPrompt.prompt(wu.fullName + "进入在野武将列表，可手动调出");
			}
			
			if (m_gkContext.m_UIs.jiuguan != null)
			{
				m_gkContext.m_UIs.jiuguan.updateCurTabWus();
			}
			
			var uixingmai:IUIXingMai = m_gkContext.m_UIMgr.getForm(UIFormID.UIXingMai) as IUIXingMai;
			if (uixingmai)
			{
				uixingmai.updateActWuState(wu.m_uHeroID);
			}
			
			if (WuProperty.COLOR_PURPLE == wu.color)
			{
				m_gkContext.m_jiuguanMgr.sortPurpleWuList();
			}
			
			handleAddheroHint(wu);
			
			if (isLevelUpJinnang(wu.m_wuPropertyBase.m_uJinnang1))
			{
				handleJinnangLevelupHint(wu);
			}
			
			if (WuProperty.COLOR_PURPLE == wu.color || WuProperty.COLOR_BLUE == wu.color)
			{
				m_oldJinnangList = getJinnangList();
				
				if (m_gkContext.m_UIs.zhenfa)
				{
					m_gkContext.m_UIs.zhenfa.updateJinnangGrid();
				}
			}
		}
		
		//改变武将颜色
		/*public function changeWuColor(msg:ByteArray):void
		   {
		   var rev:stHeroColorChangeCmd = new stHeroColorChangeCmd();
		   rev.deserialize(msg);
		   var wu:WuHeroProperty = getWuByHeroID(rev.heroid) as WuHeroProperty;
		   if (wu != null)
		   {
		   wu.m_wuPropertyBase = this.m_gkContext.m_dataTable.getItem(DataTable.TABLE_WUPROPERTY, rev.heroid * 10 + rev.color) as TWuPropertyItem;
		   wu.color = rev.color;
		   updateActiveStates();
		   }
		
		   if (m_gkContext.m_UIs.jiuguan != null)
		   {
		   m_gkContext.m_UIs.jiuguan.onAddWu();
		   }
		 }*/
		
		/*
		 * bFight - true:返回出战武将列表；false:返回未出战武将列表
		 * bIncludeMain - true, 包含主角
		 */
		public function getFightWuList(bFight:Boolean, bIncludeMain:Boolean = true):Array
		{
			var ret:Array;
			if (bFight)
			{
				
				if (bIncludeMain)
				{
					ret = new Array();
					ret = ret.concat(this.getMainWu(), m_wuListFight);
				}
				else
				{
					ret = m_wuListFight;
				}
				
			}
			else
			{
				ret = m_wuListNotFight;
			}
			return ret;		
		}
		
		/*
		   获取下野武将列表
		 */
		public function getXiayeWuList():Array
		{			
			return m_wuListXiaye;
		}
		
		/*
		   获取非下野武将列表（包括主角）
		 */
		public function getNotXiayeWuList():Array
		{
			var wu:WuProperty;
			var ret:Array = new Array();
			ret = ret.concat(this.getMainWu(), m_wuListFight, m_wuListNotFight);			
			return ret;
		}
		
		/*
		 * 获得携带武将列表，不含主角
		 */
		public function getCarryHighAddWuDic():Dictionary
		{
			var ret:Dictionary = new Dictionary();
			var wulist:Array = new Array();
			wulist = wulist.concat(m_wuListFight, m_wuListNotFight);
			
			var wu:WuHeroProperty;
			var list:Vector.<WuHeroProperty>;
			
			for each(wu in wulist)
			{
				if (undefined == ret[wu.tableID])
				{
					list = new Vector.<WuHeroProperty>();
					ret[wu.tableID] = list;
				}
				else
				{
					list = ret[wu.tableID];
				}
				
				list.push(wu);
			}
			
			return ret;
		}
		/*根据锦囊ID返回JinnangItem对象
		 * 计算锦囊等级的规则:
		   1. 根据武将名称, 将携带武将（不含下野武将）分组。即每组的武将的名字是相同的
		   2. 对每组武将，通过比较加数，得到该组加数最高的武将。
		   3. 这样得到每组最高加数武将的列表。然后从列表中去掉锦囊ID不是idInit的武将，得到新的武将列表
		   4. 按照规则（没有加数武将，锦囊等级是1；鬼武将，锦囊等级是2，... ），将列表中的所有武将对应的锦囊等级相加，其和是锦囊等级
		 */
		public function jinangIDLevel(idInit:uint):JinnangItem
		{
			var wu:WuHeroProperty;
			var num:uint = 0;
			var nJinnang:int;
			var i:int;
			var list:Vector.<WuHeroProperty>;
			var carrywudic:Dictionary = getCarryHighAddWuDic();
			for each (list in carrywudic)
			{
				wu = list[0];
				if (wu.m_wuPropertyBase.m_uJinnang1 == idInit)
				{
					for (i = 1; i < list.length; i++)
					{
						if (wu.add < list[i].add)
						{
							wu = list[i];
						}
					}
					nJinnang = 1 + wu.add;
					num += nJinnang;
				}
			}
			
			if (num == 0)
			{
				return null;
			}
			else
			{
				var ret:JinnangItem = new JinnangItem();
				ret.idInit = idInit;
				ret.num = num;
				
				return ret;
			}
		}
		
		//获得当前锦囊库中锦囊列表
		public function getJinnangList():Array
		{
			var wu:WuHeroProperty;
			var dic:Dictionary = new Dictionary();
			var ret:Array = new Array();
			var item:JinnangItem;
			
			var wuTableIDDic:Dictionary = new Dictionary();
			
			var base:TWuPropertyItem;
			var list:Vector.<WuHeroProperty>;
			var i:int;
			var nJinnang:int;
			var carrywudic:Dictionary = getCarryHighAddWuDic();
			for each (list in carrywudic)
			{
				wu = list[0];
				for (i = 1; i < list.length; i++)
				{
					if (wu.add < list[i].add)
					{
						wu = list[i];
					}
				}
				nJinnang = 1 + wu.add;
				base = wu.m_wuPropertyBase;
				if (base.m_uJinnang1 == 0)
				{
					continue;
				}
				if (dic[base.m_uJinnang1] == undefined)
				{
					item = new JinnangItem();
					dic[base.m_uJinnang1] = item;
					item.idInit = base.m_uJinnang1;
					item.num = nJinnang;
				}
				else
				{
					item = dic[base.m_uJinnang1];
					item.num += nJinnang;
				}
				
			}
			
			for each (var itemJin:*in dic)
			{
				item = (itemJin as JinnangItem);
				ret.push(item);
			}
			dic = null;
			ret.sort(compareJinnang);
			return ret;
		}
		
		//锦囊等级是否增加
		public function isLevelUpJinnang(idInit:uint):Boolean
		{
			if (0 == idInit)
			{
				return false;
			}
			
			var item:JinnangItem;
			var jinnang:JinnangItem = jinangIDLevel(idInit);
			for each (item in m_oldJinnangList)
			{
				if (jinnang && (item.idInit == jinnang.idInit) && (item.idLevel < jinnang.idLevel))
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function get loaded():Boolean
		{
			return m_bLoaded;
		}
		
		public function set loaded(bFlag:Boolean):void
		{
			m_bLoaded = bFlag;
		}
		
		public function onMainPlayerLevelup(wu:WuProperty, oldLevel:uint):void
		{
			if (this.m_gkContext.m_UIs.hero)
			{
				this.m_gkContext.m_UIs.hero.updateLevel();
			}
			if (this.m_gkContext.m_UIs.zhenfa)
			{
				this.m_gkContext.m_UIs.zhenfa.onLevelup();
			}
			
			var hero:Player = (m_gkContext.m_playerManager.hero as Player);
			hero.addLinkEffect("e3_e4010", 12, false);
			hero.addLinkEffect("e3_e401", 12, false);
			
			if (m_gkContext.m_UIs.backPack)
			{
				m_gkContext.m_UIs.backPack.updateAllObjects();
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_taskpromptMgr.updateDatas();
				m_gkContext.m_UIs.taskPrompt.updatePrompt();
				
				//藏宝库剩余探宝次数更新
				m_gkContext.m_cangbaokuMgr.updateTanbaoTimes();
			}
			
			m_gkContext.m_zhanxingMgr.updateGridLockStateInEquip();
			
			m_gkContext.m_peopleRankMgr.onValueUp(PeopleRankMgr.RANKTYPE_Level);
			
			m_gkContext.m_yizhelibaoMgr.levelUpdate();
			
			m_gkContext.m_preLoadInIdleTimeProcess.changeLevel();
			
			if (false == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIRadar) && wu.m_uLevel >= 4)
			{
				m_gkContext.m_UIMgr.showForm(UIFormID.UIRadar);
			}
			
			// 播放音效
			m_gkContext.m_commonProc.playMsc(9);
		}
		
		//查找最低级的武将对象
		public function getLowestWuByTableID(id:uint):WuHeroProperty
		{
			var initID:int = id * 10;
			var iAdd:int;
			for (iAdd = 0; iAdd < 3; iAdd++)
			{
				if (m_dicWu[initID + iAdd] != undefined)
				{
					return m_dicWu[initID + iAdd];
				}
			}
			return null;
		}
		
		//查找低于指定加数(add)的武将对象
		public function getRelativeHighestWuByTableID(id:uint, add:int):WuHeroProperty
		{
			var initID:int = id * 10;
			var iAdd:int;
			for (iAdd = add - 1; iAdd >= 0; iAdd--)
			{
				if (m_dicWu[initID + iAdd] != undefined)
				{
					return m_dicWu[initID + iAdd];
				}
			}
			return null;
		}
		
		public function updateActiveStates():void
		{
			var wu:WuProperty;
			var wuHero:WuHeroProperty;
			var wuRelation:WuHeroProperty;
			var i:uint;
			var hero:ActiveHero;
			var bActive:Boolean;
			for each (wu in this.m_dicWu)
			{
				wuHero = wu as WuHeroProperty;
				if (wuHero != null && wuHero.m_vecActiveHeros != null)
				{
					bActive = true;
					for (i = 0; i < wuHero.m_vecActiveHeros.length; i++)
					{
						hero = wuHero.m_vecActiveHeros[i];
						wuRelation = getWuByHeroID(hero.id) as WuHeroProperty;
						if (wuRelation && wuRelation.xiaye == false)
						{
							hero.bOwned = true;
						}
						else
						{
							hero.bOwned = false;
							bActive = false;
						}
					}
					wuHero.m_bActive = bActive;
				}
			}
		}
		
		//分别对每个武将（不包括主角)，执行函数fun。函数声明为：fun(wu:WuHeroProperty, param:Object):void
		public function exeFunForEachHero(fun:Function, param:Object):void
		{
			var wu:WuProperty;
			var wuHero:WuHeroProperty;
			
			for each (wu in this.m_dicWu)
			{
				if (wu is WuHeroProperty)
				{
					fun(wu as WuHeroProperty, param);
				}
			}
		}
		
		public static function compareJinnang(a:JinnangItem, b:JinnangItem):int
		{
			if (a.num > b.num)
			{
				return -1;
			}
			else if (a.num < b.num)
			{
				return 1;
			}
			if (a.idInit < b.idInit)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		
		}
		
		public static function compare(aWu:WuProperty, bWu:WuProperty):int
		{
			if (aWu.isMain)
			{
				return -1;
			}
			if (bWu.isMain)
			{
				return 1;
			}
			var a:WuHeroProperty = aWu as WuHeroProperty;
			var b:WuHeroProperty = bWu as WuHeroProperty;
			if (a.add > b.add)
			{
				return -1;
			}
			else if (a.add < b.add)
			{
				return 1;
			}
			if (a.color > b.color)
			{
				return -1;
			}
			else if (a.color < b.color)
			{
				return 1;
			}
			
			/*if (a.m_uLevel > b.m_uLevel)
			   {
			   return -1;
			   }
			   else if (a.m_uLevel < b.m_uLevel)
			   {
			   return 1;
			   }
			   if (a.m_uExp > b.m_uExp)
			   {
			   return -1;
			   }
			   else if (a.m_uExp < b.m_uExp)
			   {
			   return 1;
			 }*/
			return 0;
		}
		
		public function handleAddheroHint(wu:WuHeroProperty, itype:int = 0):void
		{
			var hintParam:Object = new Object();
			hintParam[HintMgr.HINTTYPE] = HintMgr.HINTTYPE_AddWu;
			hintParam[HintMgr.ADDHEROACTION] = itype;
			hintParam["wuhero"] = wu;
			m_gkContext.m_hintMgr.hint(hintParam);
			DebugBox.addLog("武将（" + wu.fullName + "）加入，右下角显示提示中......");
		}
		
		//锦囊等级提升，右下角显示提示框
		public function handleJinnangLevelupHint(wuhero:WuHeroProperty):void
		{
			if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_JINNANG))
			{
				var hintParam:Object = new Object();
				hintParam[HintMgr.HINTTYPE] = HintMgr.HINTTYPE_JnLevelUp;
				hintParam["wuhero"] = wuhero;
				m_gkContext.m_hintMgr.hint(hintParam);
			}
		}
		
		//id为武将(非玩家)合成ID
		public function getWuState(heroid:uint):int
		{
			var wu:WuHeroProperty = getWuByHeroID(heroid) as WuHeroProperty;
			if (wu)
			{
				if (wu.xiaye)
				{
					return WuProperty.HERO_STATE_XIAYE; //下野
				}
				else if (wu.chuzhan)
				{
					return WuProperty.HERO_STATE_FIGHT; //出战
				}
				else // if (wu.antiChuzhan)
				{
					return WuProperty.HERO_STATE_NONE; //未出战
				}
			}
			else
			{
				if (m_gkContext.m_jiuguanMgr.hasWu(heroid / 10))
				{
					return WuProperty.HERO_STATE_NORECRUIT; //未招募
				}
				else
				{
					return WuProperty.HERO_STATE_NOT; //未获得
				}
			}
		}
		
		//获得某一武将(wuID)的关联武将(即该武将的关系武将中包含武将wuID)
		public function getWuRelationList(wuID:uint):Vector.<uint>
		{
			var wuList:Vector.<uint> = new Vector.<uint>();
			var wubaseList:Vector.<TDataItem> = m_gkContext.m_dataTable.getTable(DataTable.TABLE_WUPROPERTY);
			var i:int;
			var j:int;
			var item:TWuPropertyItem;
			var ativewu:Vector.<uint>;
			for (i = 0; i < wubaseList.length; i++)
			{
				item = wubaseList[i] as TWuPropertyItem;
				ativewu = item.getVecAtiveWu();
				for (j = 0; j < ativewu.length; j++)
				{
					if (wuID == ativewu[j])
					{
						wuList.push(item.m_uID);
						break;
					}
				}
			}
			
			return wuList;
		}
		
		//获得拥有同一锦囊的武将列表
		public function getWuListOfHaveSameJinnang(jinnangID:uint):Array
		{
			if (0 == jinnangID)
			{
				return null;
			}
			var wuList:Array = new Array();
			var wubaseList:Vector.<TDataItem> = m_gkContext.m_dataTable.getTable(DataTable.TABLE_WUPROPERTY);
			var i:int;
			var j:int;
			var item:TWuPropertyItem;
			for (i = 0; i < wubaseList.length; i++)
			{
				item = wubaseList[i] as TWuPropertyItem;
				if (item && (item.m_uJinnang1 == jinnangID))
				{
					wuList.push(item.m_uID);
				}
			}
			
			return wuList;
		}
		
		public function showWuMouseOverPanel(p:DisplayObjectContainer):void
		{
			if (m_wuMouseOverPanel == null)
			{
				m_wuMouseOverPanel = new PanelDisposeEx();
				m_wuMouseOverPanel.setPanelImageSkin("commoncontrol/panel/wumouseover.png");
				m_wuMouseOverPanel.setPos(-4, -4);
				m_wuMouseOverPanel.mouseChildren = false;
				m_wuMouseOverPanel.mouseEnabled = false;
			}
			m_wuMouseOverPanel.show(p);
		
		}
		
		public function hideWuMouseOverPanel(p:DisplayObjectContainer):void
		{
			if (m_wuMouseOverPanel == null)
			{
				return;
			}
			m_wuMouseOverPanel.hide(p);
		}
		
		//获得出战武将总数 bIncludeMain : true 包括玩家自己 false 不包括玩家自己
		public function getNumsFightWu(bIncludeMain:Boolean = true):uint
		{
			var ret:uint = 0;
			var wuList:Array = getFightWuList(true, bIncludeMain);
			if (wuList)
			{
				ret = wuList.length;
			}
			
			return ret;
		}
		
		public function processSetHeroXiaYeCmd(msg:ByteArray):void
		{
			var rev:stSetHeroXiaYeCmd = new stSetHeroXiaYeCmd();
			rev.deserialize(msg);
			var wu:WuHeroProperty = this.getWuByHeroID(rev.heroid) as WuHeroProperty;
			DragManager.drop();
			if (wu == null)
			{
				return;
			}
			if (wu.xiaye == rev.toXiaye)
			{
				return;
			}			
			
			if (wu.xiaye)
			{
				this.setWuAntiChuzhan(wu);				
			}
			else
			{				
				if (wu.chuzhan)
				{
					m_gkContext.m_zhenfaMgr.takeDownHero(wu.m_uHeroID, true);
				}
				this.setWuXiaye(wu);				
			}
			
			updateActiveStates();
			
			var wuListActived:Array = computeWuListActivedByWu(wu);
			var strActivePrompt:String;
			if (wu.xiaye == false)
			{		
				
				if (m_gkContext.m_UIs.backPack != null)
				{
					m_gkContext.m_UIs.backPack.addWu(wu.m_uHeroID);
					m_gkContext.m_UIs.backPack.removeXiayeWu(wu);
				}
				if (m_gkContext.m_UIs.zhenfa != null)
				{
					m_gkContext.m_UIs.zhenfa.addWu(wu.m_uHeroID);
					m_gkContext.m_UIs.zhenfa.removeXiayeWu(wu);
				}
				if (m_gkContext.m_UIs.equipSys)
				{
					m_gkContext.m_UIs.equipSys.addWu(wu);
				}
				m_gkContext.m_systemPromptMulti.addMsg(wu.fullName + " 成为携带武将");
				strActivePrompt = "关系激活+1"
			}
			else
			{				
				if (m_gkContext.m_UIs.backPack != null)
				{
					m_gkContext.m_UIs.backPack.removeWu(rev.heroid);
					m_gkContext.m_UIs.backPack.addXiayeWu(wu);
				}
				
				if (m_gkContext.m_UIs.zhenfa != null)
				{
					m_gkContext.m_UIs.zhenfa.addXiayeWu(wu);
					m_gkContext.m_UIs.zhenfa.buildList();
				}
				
				if (m_gkContext.m_UIs.equipSys)
				{
					m_gkContext.m_UIs.equipSys.removeWu(wu);
				}
				
				m_gkContext.m_systemPromptMulti.addMsg(wu.fullName + "成为在野武将");
				strActivePrompt = "关系激活-1"
			}
			var wuActived:WuHeroProperty;
			for each (wuActived in wuListActived)
			{
				m_gkContext.m_systemPromptMulti.addMsg(wuActived.fullName + strActivePrompt);
				
				if (m_gkContext.m_UIs.backPack)
				{
					m_gkContext.m_UIs.backPack.updateHero(wuActived.m_uHeroID);
				}
			}
			
			var iForm:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIWuXiaye);
			if (iForm)
			{
				iForm.updateData(wu);
			}
			
			if (m_gkContext.m_UIs.zhenfa)
			{
				m_gkContext.m_UIs.zhenfa.updateJinnangGrid();
			}
		}
		
		/*
		 * 返回装备此装备的武将
		 */
		public function getWuWhichHasEquip(zo:ZObject):WuProperty
		{
			var retWu:WuProperty;
			if (zo)
			{
				if (zo.m_object.m_loation.isEquipedObject)
				{
					retWu = getWuByHeroID(zo.m_object.m_loation.heroid);
				}
			}
			return retWu;
		}
		
		public function computeWuListActivedByWu(activeWu:WuHeroProperty):Array
		{
			var wu:WuHeroProperty;
			var ret:Array = new Array();
			var actHero:ActiveHero;
			for each (var item:*in m_dicWu)
			{
				if (item is WuHeroProperty)
				{
					wu = item as WuHeroProperty;
					if (!wu.xiaye)
					{
						for each (actHero in wu.m_vecActiveHeros)
						{
							if (actHero.id == activeWu.m_uHeroID)
							{
								ret.push(wu);
								break;
							}
						}
					}
				}
			}
			return ret;
		}
		
		public function getWuAddIconName(add:int):String
		{
			var ret:String = "";
			switch (add)
			{
				case WuHeroProperty.Add_Gui: 
					ret = "icon.gui";
					break;
				case WuHeroProperty.Add_Xian: 
					ret = "icon.xian";
					break;
				case WuHeroProperty.Add_Shen: 
					ret = "icon.shen";
					break;
			}
			return ret;
		}
		
		/***Begin 武将培养****************************************************/
		public function loadConfig():void
		{
			if (m_bHasTrainDatas == true)
			{
				return;
			}
			
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Herotrain);
			parseXml(xml);
		}
		
		private function parseXml(xml:XML):void
		{
			var item:TrainAttr;
			var xmlItem:XML;
			var xmlList:XMLList = (xml.child("herotrain")[0] as XML).child("level");
			for each (xmlItem in xmlList)
			{
				item = new TrainAttr();
				item.paresXml(xmlItem);
				m_trainAttrList.push(item);
			}
			
			xmlList = null;
			xmlList = xml.child("yuanqidan");
			var yuanqidan:YuanqiDan;
			for each (xmlItem in xmlList)
			{
				yuanqidan = new YuanqiDan();
				yuanqidan.parseXml(xmlItem);
				m_yuanqidanList.push(yuanqidan);
			}
			
			if (m_trainAttrList.length && m_yuanqidanList.length)
			{
				m_bHasTrainDatas = true;
			}
		}
		
		public function processRetHeroTrainingInfoUserCmd(msg:ByteArray):void
		{
			var rev:stRetHeroTrainingInfoCmd = new stRetHeroTrainingInfoCmd();
			rev.deserialize(msg);
			
			var wu:WuProperty = getWuByHeroID(rev.m_heroid);
			wu.m_trainLevel = rev.m_trainLevel;
			wu.m_trainPower = rev.m_curPower;
			
			if (rev.m_baoji)
			{
				m_gkContext.m_systemPrompt.prompt("出现暴击 经验增加翻倍");
			}
			
			if (m_gkContext.m_UIs.backPack)
			{
				m_gkContext.m_UIs.backPack.updateHeroTrain(rev.m_heroid);
			}
		}
		
		//获得当前等级所需元气丹  level:培养等级
		public function getNeedYuanqidan(level:uint):YuanqiDan
		{
			var ret:YuanqiDan;
			var dan:YuanqiDan;
			for (var i:int = 0; i < m_yuanqidanList.length; i++)
			{
				dan = m_yuanqidanList[i];
				if (level <= dan.m_levellimit)
				{
					if ((level + 20) >= dan.m_levellimit)
					{
						ret = dan;
					}
					
					if (m_gkContext.m_objMgr.computeObjNumInCommonPackage(dan.m_id))
					{
						return dan;
					}
				}
			}
			
			return ret;
		}
		
		//获得培养等级属性  level:培养等级
		public function getTrainAttrByLevel(level:uint):TrainAttr
		{
			var item:TrainAttr;
			var i:int;
			level = (level > 0 ? level : 1);
			for (i = 0; i < m_trainAttrList.length; i++)
			{
				item = m_trainAttrList[i];
				if (item.m_id == level)
				{
					return item;
					break;
				}
			}
			
			return null;
		}
		
		//获得当前培养等级下，已增加属性值  level:培养等级
		public function getAllHavedAttrs(level:uint):Dictionary
		{
			var ret:Dictionary = new Dictionary();
			var i:int;
			var item:TrainAttr;
			for (i = 0; i < m_trainAttrList.length; i++)
			{
				item = m_trainAttrList[i];
				if (item.m_id < level)
				{
					if (ret[item.m_proptype] == undefined)
					{
						ret[item.m_proptype] = item.m_propvalue;
					}
					else
					{
						ret[item.m_proptype] += item.m_propvalue;
					}
				}
			}
			
			return ret;
		}
		
		//获得某一武将当前加数的基础属性值
		public function getWuBaseAttr(heroid:uint):THeroGrowupItem
		{
			var ret:THeroGrowupItem = new THeroGrowupItem();
			var add:int = heroid % 10;
			var item:THeroGrowupItem;
			var wu:TNpcBattleItem = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(heroid / 10);
			var wuBase:TWuPropertyItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_WUPROPERTY, wu.m_uID * 10 + wu.m_uColor) as TWuPropertyItem;
			var id:uint;
			
			if (add > 0)
			{
				id = add * 100 + wu.m_uColor * 10 + wu.m_iZhenwei;
				item = m_gkContext.m_dataTable.getItem(DataTable.TABLE_HEROGROWUP, id) as THeroGrowupItem
				
				ret.m_uForce += item.m_uForce;
				ret.m_uIQ += item.m_uIQ;
				ret.m_uChief += item.m_uChief;
				ret.m_uHPLimit += item.m_uHPLimit;
				ret.m_uSpeed += item.m_uSpeed;
			}
			
			ret.m_uForce += wuBase.m_uForce;
			ret.m_uIQ += wuBase.m_uIQ;
			ret.m_uChief += wuBase.m_uChief;
			ret.m_uHPLimit += wuBase.m_uHPLimit;
			
			return ret;
		}
		
		//获得某一武将当前加数的每级成长值
		public function getWuGrowupValue(heroid:uint):THeroGrowupItem
		{
			var ret:THeroGrowupItem;
			var wu:TNpcBattleItem = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(heroid / 10);
			var id:uint = wu.job * 1000 + (heroid % 10) * 100 + wu.m_uColor * 10 + wu.m_iZhenwei;
			
			ret = m_gkContext.m_dataTable.getItem(DataTable.TABLE_HEROGROWUP, id) as THeroGrowupItem
			
			return ret;
		}
		/***End 武将培养****************************************************/
		
		/***Begin "我的三国关系"(主角)****************************************************/
		
		//读取“我的三国关系”数据
		public function loadConfigUAR():void
		{
			if (m_dicMainWuRelations)
			{
				return;
			}
			
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Useractrelations);
			if (xml)
			{
				parseXmlUAR(xml);
			}
			
		}
		
		private function parseXmlUAR(xml:XML):void
		{
			var groupList:XMLList;
			var item:XML;
			var actherosgroup:ActHerosGroup;
			
			m_dicMainWuRelations = new Dictionary();
			
			groupList = xml.child("group");
			
			for each(item in groupList)
			{
				actherosgroup = new ActHerosGroup();
				actherosgroup.parseXml(item);
				
				m_dicMainWuRelations[actherosgroup.m_groupID] = actherosgroup;
			}
		}
		
		public function get vecActHerosGroup():Array
		{
			var ret:Array = new Array();
			
			for each (var item:ActHerosGroup in m_dicMainWuRelations)
			{
				ret.push(item);
			}
			
			return ret;
		}
		
		public function getActHerosGroup(id:uint):ActHerosGroup
		{
			return m_dicMainWuRelations[id];
		}
		
		//上线发送关系激活数据
		public function processUserActRelationsUserCmd(msg:ByteArray):void
		{
			var rev:stUserActRelationsCmd = new stUserActRelationsCmd();
			rev.deserialize(msg);
			
			var item:uint;
			var groupid:uint;
			for each(item in rev.m_uarList)
			{
				groupid = item / 10;
				m_dicUserActRelations[groupid] = item;
			}
		}
		
		//"我的三国关系"激活成功返回消息
		public function processActiveUserActRelationUserCmd(msg:ByteArray):void
		{
			var rev:stActiveUserActRelationCmd = new stActiveUserActRelationCmd();
			rev.deserialize(msg);
			
			var groupid:uint = rev.m_group / 10;
			m_dicUserActRelations[groupid] = rev.m_group;
			
			if (m_gkContext.m_UIs.backPack)
			{
				m_gkContext.m_UIs.backPack.actSuccessUAR(groupid);
			}
		}
		
		//return:(groupID * 10 + itemID) (合成数据 useractrelations.xml配置表)
		public function getUARData(groupid:uint):uint
		{
			return m_dicUserActRelations[groupid] as uint;
		}
		/***End "我的三国关系"(主角)****************************************************/
		
		// 加载所有武将的待机动作
		public function loadResNUnload():void
		{
			m_pathlist.length = 0;
			
			var idx:int = 0;
			
			var path:String = "";
			var modelstr:String;
			var actlist:Vector.<uint> = new Vector.<uint>(); // 动作列表
			var dirlist:Vector.<uint> = new Vector.<uint>(); // 方向列表
			
			var model:String;
			var act:uint;
			var dir:uint;
			
			// 第一次创建角色
			actlist.push(0);
			dirlist.push(1);
			
			for each (var wu:WuProperty in m_dicWu)
			{
				if (wu.isMain)
				{
					model = (m_gkContext.m_playerManager.hero as PlayerMain).modelName();
				}
				else
				{
					model = (wu as WuHeroProperty).m_npcBase.npcBattleModel.m_strModel;
				}
				
				// model = "c2_c121"
				modelstr = fUtil.insStrFromModelStr(model);
				
				for each (act in actlist)
				{
					for each (dir in dirlist)
					{
						// 加载图片资源
						path = modelstr + "_" + act + "_" + dir + ".swf";
						path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHBEINGTEX);
						//if (!m_gkContext.m_context.m_resMgrNoProg.getResource(path, SWFResource)) // 如果资源没有加载
						if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
						{
							//m_gkContext.progLoadingaddResName(path);
							//m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
							
							idx = m_pathlist.indexOf(path);
							if (idx == -1)
							{
								m_pathlist.push(path);
								//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
								//m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
								
								m_gkContext.progLoadingaddResName(path);
								m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
							}
						}
					}
				}
				
				// 加载配置文件
				path = "x" + modelstr + ".swf";
				path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLCINS);
				//if (!m_gkContext.m_context.m_resMgrNoProg.getResource(path, SWFResource)) // 如果资源没有加载
				if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
				{
					//m_gkContext.progLoadingaddResName(path);
					//m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
					
					idx = m_pathlist.indexOf(path);
					if (idx == -1)
					{
						m_pathlist.push(path);
						//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
						//m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
						
						m_gkContext.progLoadingaddResName(path);
						m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
					}
				}
			}
		
			//if(m_pathlist.length == 0)
			//{
			//	m_gkContext.progResLoaded("wubeingLoadend");
			//}
		}
		
		// 资源加载完成,通过资源直接回调
		public function onloadedSWF(event:ResourceEvent):void
		{
			Logger.info(null, null, "Loaded " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
			event.resourceObject.removeEventListener(ResourceProgressEvent.PROGRESS_EVENT, onProgressSWF);
			event.resourceObject.removeEventListener(ResourceEvent.STARTED_EVENT, onStartedSWF);
			
			// 加载进度条
			m_gkContext.m_context.progLoading.progResLoaded(event.resourceObject.filename);
			
			// 加载进度条
			var idx:int = m_pathlist.indexOf(event.resourceObject.filename);
			if (idx >= 0)
			{
				m_pathlist.splice(idx, 1);
				if (m_pathlist.length == 0)
				{
					m_gkContext.progResLoaded("wubeingLoadend");
				}
			}
		}
		
		// 资源加载失败，通过资源直接回调
		private function onFailedSWF(event:ResourceEvent):void
		{
			Logger.error(null, null, "failed " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
			event.resourceObject.removeEventListener(ResourceProgressEvent.PROGRESS_EVENT, onProgressSWF);
			event.resourceObject.removeEventListener(ResourceEvent.STARTED_EVENT, onStartedSWF);
			
			// 加载进度条
			m_gkContext.m_context.progLoading.progResFailed(event.resourceObject.filename);
			
			// 加载进度条
			var idx:int = m_pathlist.indexOf(event.resourceObject.filename);
			if (idx >= 0)
			{
				m_pathlist.splice(idx, 1);
				if (m_pathlist.length == 0)
				{
					m_gkContext.progResLoaded("wubeingLoadend");
				}
			}
		}
		
		private function onProgressSWF(event:ResourceProgressEvent):void
		{
			m_gkContext.progResProgress(event.resourceObject.filename, event._percentLoaded);
		}
		
		private function onStartedSWF(event:ResourceEvent):void
		{
			m_gkContext.progResStarted(event.resourceObject.filename);
		}
		
		// 资源加载完成,通过资源直接回调
		public function onloadedNoProgSWF(event:ResourceEvent):void
		{
			Logger.info(null, null, "Loaded " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
			
			// 加载进度条
			var idx:int = m_pathlist.indexOf(event.resourceObject.filename);
			if (idx >= 0)
			{
				m_pathlist.splice(idx, 1);
				if (m_pathlist.length == 0)
				{
					m_gkContext.progResLoaded("wubeingLoadend");
				}
			}
		}
		
		// 资源加载失败，通过资源直接回调
		private function onFailedNoProgSWF(event:ResourceEvent):void
		{
			Logger.error(null, null, "failed " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
			
			//m_gkContext.m_context.m_resMgrNoProg.load(event.resourceObject.filename, SWFResource);
			m_gkContext.m_context.m_resMgr.load(event.resourceObject.filename, SWFResource);
			
			// 加载进度条
			var idx:int = m_pathlist.indexOf(event.resourceObject.filename);
			if (idx >= 0)
			{
				m_pathlist.splice(idx, 1);
				if (m_pathlist.length == 0)
				{
					m_gkContext.progResLoaded("wubeingLoadend");
				}
			}
		}
		
		// 延迟加载武将资源
		public function lazyLoadRes():void
		{
			var idx:int = 0;
			
			var path:String = "";
			var modelstr:String;
			var actlist:Vector.<uint> = new Vector.<uint>(); // 动作列表
			var dirlist:Vector.<uint> = new Vector.<uint>(); // 方向列表
			
			var model:String;
			var act:uint;
			var dir:uint;
			
			var item:DelayLoaderBase;
			
			// 第一次创建角色
			actlist.push(0);
			actlist.push(2);
			actlist.push(7);
			actlist.push(8);
			
			dirlist.push(1);
			
			for each (var wu:WuProperty in m_dicWu)
			{
				if (wu.isMain)
				{
					model = (m_gkContext.m_playerManager.hero as PlayerMain).modelName();
				}
				else
				{
					model = (wu as WuHeroProperty).m_npcBase.npcBattleModel.m_strModel;
				}
				
				// model = "c2_c121"
				modelstr = fUtil.insStrFromModelStr(model);
				
				for each (act in actlist)
				{
					for each (dir in dirlist)
					{
						// 加载图片资源
						path = modelstr + "_" + act + "_" + dir + ".swf";
						if (!fUtil.isEmptyRes(path))
						{
							path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHBEINGTEX);

							if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
							{	
								idx = m_pathlist.indexOf(path);
								if (idx == -1)
								{
									m_pathlist.push(path);
									
									m_gkContext.progLoadingaddResName(path);
									m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
								}
							}
						}
					}
				}
				
				// 加载配置文件
				path = "x" + modelstr + ".swf";
				path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLCINS);

				if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
				{	
					idx = m_pathlist.indexOf(path);
					if (idx == -1)
					{
						m_pathlist.push(path);
						
						m_gkContext.progLoadingaddResName(path);
						m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
					}
				}
			}
			
			if (m_pathlist.length == 0)
			{
				m_gkContext.progResLoaded("wubeingLoadend");
			}
		}
		
		// 获取武将的数量
		public function getWuNumByCond(add:uint, color:uint, chuzhan:Boolean = true):uint
		{
			var item:WuHeroProperty;
			var num:uint;
			var key:String;
			for (key in m_dicWu)
			{
				if(!(m_dicWu[key] is WuMainProperty))		// 如果不是主角自己
				{
					item = m_dicWu[key] as WuHeroProperty;
					if (item.add >= add && item.color >= color && item.chuzhan == chuzhan)
					{
						++num;
					}
				}
			}
			
			return num;
		}
		
		// 更新主角身上绕身光效
		public function updateMainEffByWu():void
		{
			var mainplayer:PlayerMain = m_gkContext.m_playerManager.hero;
			var num:uint;
			var wuefftype:uint = EntityCValue.MWETNone;
			// 当玩家出阵武将4个都是神紫将以上
			num = getWuNumByCond(WuHeroProperty.Add_Shen, WuProperty.COLOR_PURPLE);
			if (num >= 4)
			{
				wuefftype = EntityCValue.MWETF;
			}
			else
			{
				//当玩家出阵武将4个都是仙紫将以上
				num = getWuNumByCond(WuHeroProperty.Add_Xian, WuProperty.COLOR_PURPLE);
				if (num >= 4)
				{
					wuefftype = EntityCValue.MWETH;
				}
				else
				{
					// 当玩家出阵武将4个都是鬼紫将以上
					num = getWuNumByCond(WuHeroProperty.Add_Gui, WuProperty.COLOR_PURPLE);
					if (num >= 4)
					{
						wuefftype = EntityCValue.MWETT;
					}
					else
					{					
						// 当玩家出阵武将4个都是紫将以上
						num = getWuNumByCond(WuHeroProperty.Add_Zero, WuProperty.COLOR_PURPLE);
						if (num >= 4)
						{
							wuefftype = EntityCValue.MWETO;
						}
					}
				}
			}

			mainplayer.wuEffType = wuefftype;
		}
	}
}