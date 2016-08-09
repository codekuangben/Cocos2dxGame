package modulecommon.scene.zhanxing
{
	/**
	 * ...
	 * @author ...
	 */
	//import adobe.utils.CustomActions;
	import com.dnd.DragManager;
	import com.util.UtilXML;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.zhanXingCmd.stAddShenBingCmd;
	import modulecommon.net.msg.zhanXingCmd.stAllShenBingInfoCmd;
	import modulecommon.net.msg.zhanXingCmd.stLightHeroCmd;
	import modulecommon.net.msg.zhanXingCmd.stLocation;
	import modulecommon.net.msg.zhanXingCmd.stRefreshMingLiCmd;
	import modulecommon.net.msg.zhanXingCmd.stRefreshOpenedGeZiNumCmd;
	import modulecommon.net.msg.zhanXingCmd.stRefreshSilverVisitTimesWuXueCmd;
	import modulecommon.net.msg.zhanXingCmd.stRefreshZXScoreCmd;
	import modulecommon.net.msg.zhanXingCmd.stRemoveShenBingCmd;
	import modulecommon.net.msg.zhanXingCmd.stSwapShenBingCmd;
	import modulecommon.net.msg.zhanXingCmd.stViewOtherUserEquipedWuXueCmd;
	import modulecommon.net.msg.zhanXingCmd.stZhanXingInfoCmd;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.ui.Form;
	import modulecommon.uiinterface.IUIWuxueExchange;
	import modulecommon.uiinterface.IUIZhanxing;
	import modulecommon.scene.sysbtn.SysbtnMgr;
	import modulecommon.ui.UIFormID;
	
	public class ZhanxingMgr
	{
		public static const PACKAGE:String = "package";
		public static const ZSTAR:String = "obj";
		
		public static const EQUIP_GRID_NUM:int = 8;
		
		public static const EQUIP_Front:int = 0;
		public static const EQUIP_Mid:int = 1;
		public static const EQUIP_Back:int = 2;
		
		private var m_gkContext:GkContext;
		private var m_dicAttr:Dictionary;
		private var m_dicWuhu:Dictionary;
		private var m_dicPackage:Dictionary;
		private var m_dicWuxue:Dictionary; //(EQUIP_Front，命力)
		private var m_dicGridNoToLevel:Dictionary; //格子编号(zero-based)到开放等级的映射
		private var m_wuxueDataList:Array;
		
		private var m_lightHero:int; //当前点亮的五虎将
		private var m_score:uint;
		public var m_ui:IUIZhanxing;
		private var m_autoTFState:Boolean;//自动探访
		private var m_bhechengFlag:Boolean;//自动合成
		private var m_lastNeedHecheng:uint;//最后一个武学到位后开始合成
		public var m_vecStarOtherPlayer:Vector.<T_Star>;	// 其他玩家已装备的武学（观察界面中显示）
		private var m_configLoaded:Boolean;
		/**
		 * 剩余银币探访次数
		 */
		public var m_silvervisittimes:uint;
		
		public function ZhanxingMgr(gk:GkContext)
		{
			m_gkContext = gk;
			m_dicPackage = new Dictionary();
			m_dicPackage[stLocation.SBCELLTYPE_MIANPACK] = new PackageStar(stLocation.SBCELLTYPE_MIANPACK, 5, 4);
			m_dicPackage[stLocation.SBCELLTYPE_LOCKPACK] = new PackageStar(stLocation.SBCELLTYPE_MIANPACK, 5, 1);
			m_dicPackage[stLocation.SBCELLTYPE_FRONT] = new PackageStar(stLocation.SBCELLTYPE_MIANPACK, EQUIP_GRID_NUM, 1);
			m_dicPackage[stLocation.SBCELLTYPE_CENTER] = new PackageStar(stLocation.SBCELLTYPE_CENTER, EQUIP_GRID_NUM, 1);
			m_dicPackage[stLocation.SBCELLTYPE_BACK] = new PackageStar(stLocation.SBCELLTYPE_BACK, EQUIP_GRID_NUM, 1);
			
			m_dicWuxue = new Dictionary();
			autoTFState = false;
			hechengFlag = false;
		}
		
		public function getPackage(location:int):PackageStar
		{
			return m_dicPackage[location];
		}
		
		public function setOpenedSizeForPackage(nMIANPACK:int, nLOCKPACK:int):void
		{
			//var pc:PackageStar = getPackage(stLocation.SBCELLTYPE_MIANPACK);
			//pc.openedSize = nMIANPACK + 15;
			
			//pc = getPackage(stLocation.SBCELLTYPE_LOCKPACK);
			//pc.openedSize = nLOCKPACK + 1;
		}
		
		public function getPackageAndStarByThisID(thisID:uint):Object
		{
			var ret:Object;
			var obj:ZStar;
			for each (var item:*in m_dicPackage)
			{
				obj = (item as PackageStar).getStarByThisID(thisID);
				if (obj != null)
				{
					ret = new Object();
					ret[PACKAGE] = (item as PackageStar);
					ret[ZSTAR] = obj;
					return ret;
				}
			}
			return null;
		}
		
		//上线收到此消息
		public function process_stZhanXingInfoCmd(msg:ByteArray, param:uint):void
		{
			var rev:stZhanXingInfoCmd = new stZhanXingInfoCmd();
			rev.deserialize(msg);
			m_score = rev.score;
			m_lightHero = rev.lighthero;
			m_silvervisittimes = rev.silvervisittimes;
			m_dicWuxue[EQUIP_Front] = rev.frontMingli;
			m_dicWuxue[EQUIP_Mid] = rev.midMingli;
			m_dicWuxue[EQUIP_Back] = rev.backMingli;
			
			//setOpenedSizeForPackage(rev.sbpnum, rev.lpnum);
			loadConfig();
		}
		
		//上线收到此消息
		public function process_stAllShenBingInfoCmd(msg:ByteArray, param:uint):void
		{
			var rev:stAllShenBingInfoCmd = new stAllShenBingInfoCmd();
			rev.deserialize(msg);
			
			var tStar:T_Star;
			var star:ZStar;
			var pc:PackageStar
			for each (tStar in rev.m_list)
			{
				star = new ZStar();
				star.setStar(tStar);
				pc = getPackage(tStar.m_location.location);
				pc.addStar(star);
			}
		}
		
		public function process_stRefreshSilverVisitTimesWuXueCmd(msg:ByteArray, param:uint):void
		{
			var rev:stRefreshSilverVisitTimesWuXueCmd = new stRefreshSilverVisitTimesWuXueCmd();
			rev.deserialize(msg);
			m_silvervisittimes = rev.m_silvervisittimes;
			if (m_ui)
			{
				m_ui.refreshSilverTimes();
			}
		}
		
		public function process_stRefreshZXScoreCmd(msg:ByteArray, param:uint):void
		{
			var rev:stRefreshZXScoreCmd = new stRefreshZXScoreCmd();
			rev.deserialize(msg);
			m_score = rev.m_score;
			if (m_ui)
			{
				m_ui.refreshScore();
			}
			var form:IUIWuxueExchange = m_gkContext.m_UIMgr.getForm(UIFormID.UIWuxueExchange) as IUIWuxueExchange;
			if (form)
			{
				form.refreshScore();
			}
		}
		
		public function process_stLightHeroCmd(msg:ByteArray, param:uint):void
		{
			var rev:stLightHeroCmd = new stLightHeroCmd();
			rev.deserialize(msg);
			
			m_lightHero = rev.m_no;
			if (m_ui)
			{
				m_ui.updateLightWuhu();
			}
		}
		
		//得到新的,或对其更新
		public function process_stAddShenBingCmd(msg:ByteArray, param:uint):void
		{
			var rev:stAddShenBingCmd = new stAddShenBingCmd();
			rev.deserialize(msg);
			var star:ZStar;
			var pc:PackageStar;
			if (rev.m_action == stAddShenBingCmd.SBACTION_OPTAIN)
			{
				star = new ZStar();
				star.setStar(rev.m_star);
				pc = getPackage(rev.m_star.m_location.location);
				pc.addStar(star);				
				if (m_ui)
				{
					if (rev.heronum >= 1 && rev.heronum <= 5)
					{
						m_ui.addStarFromTanfang(star, rev.heronum);
					}
					else
					{
						m_ui.addStar(star);
					}
				}
			}
			else if (rev.m_action == stAddShenBingCmd.SBACTION_REFRESH)
			{
				var retObj:Object = getPackageAndStarByThisID(rev.m_star.thisid);
				if (retObj == null)
				{
					return;
				}
				
				var bPosChange:Boolean;
				star = retObj[ZSTAR];
				var oldLocation:stLocation = star.m_tStar.m_location;
				
				if (oldLocation.location != rev.m_star.m_location.location || oldLocation.x != rev.m_star.m_location.x || oldLocation.y != rev.m_star.m_location.y)
				{
					bPosChange = true;
					var packSor:PackageStar = retObj[PACKAGE];
					packSor.removeStar(star);
					if (m_ui)
					{
						m_ui.removeStar(star);
					}
					
					
				}
				
				star.m_tStar = rev.m_star;
				if (bPosChange)
				{
					var packDest:PackageStar = getPackage(rev.m_star.m_location.location);
					packDest.addStar(star);
					if (m_ui)
					{
						m_ui.addStar(star);
					}
				}
				else
				{
					if (m_ui)
					{
						m_ui.updateStar(star);
					}
				}
			}
			if (autoTFState)
			{
				if ((m_dicPackage[stLocation.SBCELLTYPE_MIANPACK] as PackageStar).numOfFreeGrids == 0)
				{
					m_lastNeedHecheng = rev.m_star.thisid;
					autoTFState = false;
					if (m_ui.checkState)
					{
						hechengFlag = true;
					}
				}
				else
				{
					if (m_ui && m_ui.isVisible())
					{
						m_ui.autoTangfang();
					}
				}
			}
		}
		
		//删除1个
		public function process_stRemoveShenBingCmd(msg:ByteArray, param:uint):void
		{
			var rev:stRemoveShenBingCmd = new stRemoveShenBingCmd();
			rev.deserialize(msg);
			dropWuXue(rev.thisid);
			var retObj:Object = getPackageAndStarByThisID(rev.thisid);
			if (retObj == null)
			{
				return;
			}
			
			var pack:PackageStar = retObj[PACKAGE];
			var star:ZStar = retObj[ZSTAR];
			//dropZOjbect(zobj.thisID);
			pack.removeStar(star);
			if (m_ui)
			{
				m_ui.removeStar(star);
			}			
		}
		
		public function process_stSwapShenBingCmd(msg:ByteArray, param:uint):void
		{
			var rev:stSwapShenBingCmd = new stSwapShenBingCmd();
			rev.deserialize(msg);
			DragManager.drop();
			var sor:Object = getPackageAndStarByThisID(rev.thisid);
			if (sor == null)
			{
				return;
			}
			var packSor:PackageStar = sor[PACKAGE];
			var zStarSor:ZStar = sor[ZSTAR];
			
			//dropZOjbect(zobjSor.thisID);
			var packDest:PackageStar = m_dicPackage[rev.m_location.location];
			if (packDest == null)
			{
				return;
			}
			
			var zStarDest:ZStar = packDest.getStar(rev.m_location.x, rev.m_location.y);
			if (zStarDest != null)
			{
				packDest.removeStar(zStarDest);
				if (m_ui)
				{
					m_ui.removeStar(zStarDest);
				}
			}
			
			packSor.removeStar(zStarSor);
			
			if (m_ui)
			{
				m_ui.removeStar(zStarSor);
			}
			
			//------------
			if (zStarDest != null)
			{
				zStarDest.m_tStar.m_location = zStarSor.m_tStar.m_location;
			}
			zStarSor.m_tStar.m_location = rev.m_location;
			packDest.addStar(zStarSor);
			if (m_ui)
			{
				m_ui.addStar(zStarSor);
			}
			if (zStarDest != null)
			{
				packSor.addStar(zStarDest);
				if (m_ui)
				{
					m_ui.addStar(zStarDest);
				}
			}
			var ui:IUIZhanxing = m_gkContext.m_UIMgr.getForm(UIFormID.UIZhanxing) as IUIZhanxing;
			if (ui)
			{
				ui.updataLbsysText();
			}
			if (getAllFree()!=0)
			{
				m_gkContext.m_UIs.sysBtn.showEffectAni(SysbtnMgr.SYSBTN_ZhanXing);
			}
			else
			{
				m_gkContext.m_UIs.sysBtn.hideEffectAni(SysbtnMgr.SYSBTN_ZhanXing);
			}
		}
		public function dropWuXue(thisID:uint):void
		{
			var panel:WuXueIcon = DragManager.getDragInitiator() as WuXueIcon;
			if (panel != null)
			{
				if (panel.zStar&& panel.zStar.m_tStar.thisid == thisID)
				{
					DragManager.drop();
				}
			}
		}
		public function process_stRefreshOpenedGeZiNumCmd(msg:ByteArray, param:uint):void
		{
			var rev:stRefreshOpenedGeZiNumCmd = new stRefreshOpenedGeZiNumCmd();
			rev.deserialize(msg);
			var oldNumOfmainPack:int = getPackage(stLocation.SBCELLTYPE_MIANPACK).openedSize;
			//var oldNumOfLockPack:int = getPackage(stLocation.SBCELLTYPE_LOCKPACK).openedSize;
			//setOpenedSizeForPackage(rev.m_numGridInCommon, rev.m_numGridInReserve);
			var newNumOfmainPack:int = getPackage(stLocation.SBCELLTYPE_MIANPACK).openedSize;
			//var newNumOfLockPack:int = getPackage(stLocation.SBCELLTYPE_LOCKPACK).openedSize;
			
			if (newNumOfmainPack > oldNumOfmainPack)
			{
				if (m_ui)
				{
					m_ui.updateLocState(stLocation.SBCELLTYPE_MIANPACK, oldNumOfmainPack, newNumOfmainPack);
				}
			}
			/*if (newNumOfLockPack > oldNumOfLockPack)
			{
				if (m_ui)
				{
					m_ui.updateLocState(stLocation.SBCELLTYPE_LOCKPACK, oldNumOfLockPack, newNumOfLockPack);
				}
			}*/
		}
		
		public function process_stRefreshMingLiCmd(msg:ByteArray, param:uint):void
		{
			var rev:stRefreshMingLiCmd = new stRefreshMingLiCmd();
			rev.deserialize(msg);
			m_dicWuxue[rev.type] = rev.m_mingli;
			if (m_ui)
			{
				m_ui.updateWuxue(rev.type);
			}
			
		}
		
		//观察他人装备的武学
		public function process_stViewOtherUserEquipedWuxueCmd(msg:ByteArray, param:uint):void
		{
			var rev:stViewOtherUserEquipedWuXueCmd = new stViewOtherUserEquipedWuXueCmd();
			rev.deserialize(msg);
			
			m_vecStarOtherPlayer = rev.m_list;
		}
		
		private function loadConfig():void
		{
			if (m_configLoaded)
			{
				return;
			}
			m_configLoaded = true;
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Zhanxing);
			m_dicAttr = new Dictionary();
			m_dicWuhu = new Dictionary();
			m_dicGridNoToLevel = new Dictionary();
			
			var itemXML:XML;
			var id:int;
			var str:String;
			var list:XMLList;
			var wuhuXml:XML;
			var wuhuItem:WuhuItem;
			var data:int;
			var wuxuedata:WuxueData;
			list = xml.child("wuhujiang");
			for each (itemXML in list)
			{
				wuhuItem = new WuhuItem();
				wuhuItem.m_id = UtilXML.attributeIntValue(itemXML, "id");
				wuhuItem.cost = UtilXML.attributeIntValue(itemXML, "cost");
				wuhuItem.m_ybcost = UtilXML.attributeIntValue(itemXML, "ybcost");
				wuhuItem.m_name = UtilXML.attributeValue(itemXML, "name");
				m_dicWuhu[wuhuItem.m_id] = wuhuItem;
			}
			var attrXml:XML = UtilXML.getSubXml(xml, "attrconfig");
			list = attrXml.child("attr");
			for each (itemXML in list)
			{
				id = UtilXML.attributeIntValue(itemXML, "type");
				str = UtilXML.attributeValue(itemXML, "name");
				m_dicAttr[id] = str;
			}
			
			list = xml.child("equipgrid");
			for each (itemXML in list)
			{
				id = UtilXML.attributeIntValue(itemXML, "id");
				data = UtilXML.attributeIntValue(itemXML, "openlevel");
				m_dicGridNoToLevel[id] = data;
			}
			
			list = xml.child("wuxueexchange").elements("*");
			m_wuxueDataList = new Array();
			for each (itemXML in list)
			{
				wuxuedata = new WuxueData();
				wuxuedata.parse(itemXML);
				m_wuxueDataList.push(wuxuedata);
			}
			updateGridLockStateInEquip();
		}
		
		public function updateGridLockStateInEquip():void
		{
			var i:int;
			var playerLevel:int = m_gkContext.playerMain.level;
			var level:int;
			var num:int;
			if (m_dicGridNoToLevel == null)
			{
				return;
			}
			for (i = EQUIP_GRID_NUM - 1; i >= 0; i--)
			{
				level = m_dicGridNoToLevel[i];
				if (playerLevel >= level)
				{
					num = i + 1;
					break;
				}
			}
			getPackage(stLocation.SBCELLTYPE_FRONT).openedSize = num;
			getPackage(stLocation.SBCELLTYPE_CENTER).openedSize = num;
			getPackage(stLocation.SBCELLTYPE_BACK).openedSize = num;
			if (m_ui)
			{
				m_ui.updateEquipLocState();
			}
			
		}
		
		public function getWuhuItem(id:int):WuhuItem
		{
			if (m_dicWuhu == null)
			{
				loadConfig();
			}
			return m_dicWuhu[id];
		}
		
		public function get lightHero():int
		{
			return m_lightHero;
		}
		
		public function getAttrName(id:int):String
		{
			if (m_dicWuhu == null)
			{
				loadConfig();
			}
			return m_dicAttr[id];
		}
		
		public function isLocationLock(location:stLocation):Boolean
		{
			var pac:PackageStar = getPackage(location.location);
			return pac.isLock(location.x, location.y);
		}
		
		public function getOpenLevelOfGrid(id:int):int
		{
			return m_dicGridNoToLevel[id];
		}
		
		public function getWuxue(type:int):uint
		{
			return m_dicWuxue[type];
		}
		
		public function getAllFree():int
		{
			var allFree:int;
			allFree = getPackage(stLocation.SBCELLTYPE_FRONT).numOfFreeGrids + getPackage(stLocation.SBCELLTYPE_CENTER).numOfFreeGrids + getPackage(stLocation.SBCELLTYPE_BACK).numOfFreeGrids;
			return allFree;
			
		}
		
		public function set autoTFState(state:Boolean):void
		{
			m_autoTFState = state;
			/*if (state)
			{
				if (m_ui)
				{
					m_ui.hechengBtnEnable(false);
				}
			}
			else
			{
				if (m_ui)
				{
					m_ui.hechengBtnEnable(true);
				}
			}*/
		}
		public function get autoTFState():Boolean
		{
			return m_autoTFState;
		}
		public function get score():uint
		{
			return m_score;
		}
		
		//已佩戴武学列表
		public function get vecStarWearing():Vector.<T_Star>
		{
			var ret:Vector.<T_Star> = new Vector.<T_Star>();
			
			getVecStarWearing(stLocation.SBCELLTYPE_FRONT, ret);
			getVecStarWearing(stLocation.SBCELLTYPE_CENTER, ret);
			getVecStarWearing(stLocation.SBCELLTYPE_BACK, ret);
			
			return ret;
		}
		
		private function getVecStarWearing(location:int, data:Vector.<T_Star>):void
		{
			var packageStar:PackageStar = getPackage(location);
			var star:ZStar;
			
			if (null == data || null == packageStar)
			{
				return;
			}
			
			for each(star in packageStar.datas)
			{
				if (star)
				{
					data.push(star.m_tStar);
				}
			}
		}
		public function get WuxueList():Array
		{
			return m_wuxueDataList;
		}
		public function get hechengFlag():Boolean
		{
			return m_bhechengFlag;
		}
		public function set hechengFlag(flag:Boolean):void
		{
			m_bhechengFlag = flag;
		}
		public function get hechengThisId():uint
		{
			return m_lastNeedHecheng;
		}
	}

}