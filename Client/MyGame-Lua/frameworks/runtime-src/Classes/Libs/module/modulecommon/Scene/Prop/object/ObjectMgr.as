package modulecommon.scene.prop.object
{
	import com.dnd.DragManager;
	import com.util.DebugBox;
	import flash.display.DisplayObjectContainer;
	import modulecommon.appcontrol.PanelDisposeEx;
	import modulecommon.commonfuntion.HintMgr;
	import modulecommon.commonfuntion.LocalDataMgr;
	import net.ContentBuffer;
	import modulecommon.net.msg.sceneHeroCmd.stHeroRebirthCacheHeroEquipCmd;
	import modulecommon.net.msg.sceneHeroCmd.stPutCacheEquipToRebirthHeroCmd;
	import modulecommon.net.msg.sceneUserCmd.stRefreshOpenMainPackGeZiNumUserCmd;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TObjectBaseItem;
	import com.util.UtilTools;
	import org.ffilmation.engine.helpers.fUtil;
	//import modulecommon.ui.Form;
	import modulecommon.uiinterface.IForm;
	import modulecommon.uiinterface.IUICorpsLottery;
	import modulecommon.uiinterface.IUIEquipSys;
	import modulecommon.uiinterface.IUIGamble;
	import modulecommon.uiinterface.IUIJiuGuan;
	import modulecommon.uiinterface.IUIRecruitCard;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.propertyUserCmd.*;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIAnimationGet;
	import modulecommon.uiinterface.IUIBackPack;
	
	import org.ffilmation.engine.datatypes.IntPoint;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIMountsSys;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ObjectMgr
	{
		//包裹类型定义
		public static const PACKAGE:String = "package";
		public static const ZOBJECT:String = "obj";
		
		public static const PACKAGE_MAIN_WIDTH:int = 5;
		public static const PACKAGE_MAIN_HEIGHT:int = 6;
		private var m_dicPackage:Dictionary;
		private var m_commonPackageList:Vector.<Package>; //为了方便获得3个主包裹，也用这个数组来引用3个包裹
		private var m_totalTimeForOpenGrid:Number = 0;
		private var m_leftTimeForOpenGrid:Number = 0;
		private var m_initTimeForOpenGrid:Number = 0;
		private var m_gkContext:GkContext;
		private var m_param:Object;
		private var m_ObjectMouseOverPanel:PanelDisposeEx;
		/**
		 * 战斗结束后播放物品飞包裹动画中的物品列表
		 */
		private var m_objPlayList:Array;
		private var m_dicWuEquipBuffer:Dictionary; //转生时，用于武将装备的缓存区。[heroid, list:Vector.<ZObject>]
		
		public function ObjectMgr(gk:GkContext)
		{
			m_param = new Object();
			m_gkContext = gk;
			m_dicPackage = new Dictionary();
			m_objPlayList = new Array();
			m_dicPackage[toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON1)] = new Package(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON1, PACKAGE_MAIN_WIDTH, PACKAGE_MAIN_HEIGHT);
			m_dicPackage[toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON2)] = new Package(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON2, PACKAGE_MAIN_WIDTH, PACKAGE_MAIN_HEIGHT);
			m_dicPackage[toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON3)] = new Package(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON3, PACKAGE_MAIN_WIDTH, PACKAGE_MAIN_HEIGHT);
			m_dicPackage[toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_BAOWU)] = new Package(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_BAOWU, PACKAGE_MAIN_WIDTH, PACKAGE_MAIN_HEIGHT);
			m_dicPackage[toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_UEQUIP)] = new Package(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_UEQUIP, 1, ZObjectDef.EQUIP_MAX);
			m_commonPackageList = new Vector.<Package>(3);
			m_commonPackageList[0] = m_dicPackage[toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON1)];
			m_commonPackageList[1] = m_dicPackage[toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON2)];
			m_commonPackageList[2] = m_dicPackage[toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON3)];
			
			m_dicWuEquipBuffer = new Dictionary();
		}
		
		public function addWuPakage(heroID:uint):void
		{
			var key:uint = toPackageKey(heroID, stObjLocation.OBJECTCELLTYPE_HEQUIP);
			if (m_dicPackage[key] == undefined)
			{
				m_dicPackage[key] = new Package(heroID, stObjLocation.OBJECTCELLTYPE_HEQUIP, 1, ZObjectDef.EQUIP_MAX);
			}
		}
		
		//删除一个武将的装备背包
		public function delWuPakage(heroID:uint):void
		{
			var key:uint = toPackageKey(heroID, stObjLocation.OBJECTCELLTYPE_HEQUIP);
			if (m_dicPackage[key] != undefined)
			{
				delete m_dicPackage[key];
			}
		}
		
		public function getAllObject():Array
		{
			var ret:Array = new Array();
			for each (var item:*in m_dicPackage)
			{
				ret = ret.concat((item as Package).datas);
			}
			
			return ret;
		}
		
		// 
		public function getObjectByF(fun:Function):Array
		{
			var ret:Array = new Array();
			
			var idlist:Vector.<uint> = new Vector.<uint>(3, true);
			
			idlist[0] = toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON1);
			idlist[1] = toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON2);
			idlist[2] = toPackageKey(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON3);
			
			for each (var id:uint in idlist)
			{
				ret = ret.concat((m_dicPackage[id] as Package).datasByF(fun));
			}
			
			return ret;
		}
		
		// 计算所有物品的数量
		public function calcObjNum(objlst:Array):uint
		{
			var num:uint = 0;
			for each (var obj:ZObject in objlst)
			{
				num += obj.m_object.num;
			}
			
			return num;
		}
		
		public function setOpenedSizeForCommonPackage(n1:int, n2:int, n3:int):void
		{
			var pc:Package = this.getPakage(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON1);
			pc.openedSize = n1 + 20;
			pc = this.getPakage(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON2);
			pc.openedSize = n2;
			pc = this.getPakage(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_COMMON3);
			pc.openedSize = n3;
		}
		
		//计算3个包裹中未锁住的格子的数量
		public function getSizeOfOpenedGrid():int
		{
			var ret:int = 0;
			var pc:Package;
			for each (pc in m_commonPackageList)
			{
				ret += pc.openedSize;
			}
			return ret;
		}
		
		public function processRefreshOpenMainPackGeZiNumUserCmd(msg:ByteArray):void
		{
			var rev:stRefreshOpenMainPackGeZiNumUserCmd = new stRefreshOpenMainPackGeZiNumUserCmd();
			rev.deserialize(msg);
			
			var oldOpenedSize:int = getSizeOfOpenedGrid();
			setOpenedSizeForCommonPackage(rev.packageOpendSize1, rev.packageOpendSize2, rev.packageOpendSize3);
			var nowOpenedSize:int = getSizeOfOpenedGrid();
			if (this.backPack)
			{
				backPack.updateLocState(oldOpenedSize, nowOpenedSize);
			}
		}
		
		public function processAddUserObjListProperty(msg:ByteArray):void
		{
			var rev:stAddUserObjListPropertyUserCmd = new stAddUserObjListPropertyUserCmd();
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
				if (backPack)
				{
					backPack.addObject(obj);
				}
			}
		}
		
		public function processAddObjectProperty(msg:ByteArray):void
		{
			var rev:stAddObjectPropertyUserCmd = new stAddObjectPropertyUserCmd();
			rev.deserialize(msg);
			var obj:ZObject;
			if (rev.actionType == stAddObjectPropertyUserCmd.OBJACTION_OPTAIN)
			{
				obj = new ZObject();
				if (false == obj.setObject(rev.tobject))
				{
					return;
				}
				var pkage:Package = m_dicPackage[obj.toPackageKey()] as Package;
				if (pkage == null)
				{
					return;
				}
				pkage.addObject(obj);
				if (backPack)
				{
					backPack.addObject(obj);
				}
				
				var str:String = "得到道具：" + fUtil.keyValueToString("名称", obj.name, "id", obj.ObjID, "thisID", obj.thisID, "颜色", obj.iconColor, "x", obj.m_object.m_loation.x, "y", obj.m_object.m_loation.y);
				DebugBox.addLog(str);
				
				OnObjectNumChange(obj, true);
				//当前在新手地图(即玩家第一次登陆时，进入的地图)，不需要播放获取道具动画
				if (m_gkContext.m_mapInfo.clientMapID == 1000)
				{
					return;
				}
				
				//如果军团抽奖界面打开，则道具获得飞行特效延时播放
				var ui:IUICorpsLottery = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsLottery) as IUICorpsLottery;
				if (ui)
				{
					ui.addFlyObj(obj);
					return;
				}
				
				if (!m_gkContext.m_localMgr.isSet(LocalDataMgr.LOCAL_HIDE_TurnCardState))
				{
					//playAniForGetObject(obj, obj.m_object.num);
					if (m_gkContext.m_giftPackMgr.giftAniData.m_cbkState) // 藏宝库宝箱领取物品的时候不需要播放动画
					{
						// 保存数据
						addCBKFlyObj(obj, obj.m_object.num);
					}
					else if (!m_gkContext.m_giftPackMgr.giftAniData.m_giftState)
					{
						if (!m_gkContext.m_localMgr.isSet(LocalDataMgr.LOCAL_InNotPlayAniForGetObject))
						{
							if (rev.isani == ZObjectDef.OBJANITYPE_AFTERBATTLE)
							{
								var item:ObjAfterBattle = new ObjAfterBattle();
								item.m_obj = obj;
								item.m_num = obj.m_object.num;
								m_objPlayList.push(item);
							}
							else
							{
								playAniForGetObject(obj, obj.m_object.num);
							}
						}
						
					}
					
					if (obj.isEquip)
					{
						hintOnGetEquip(obj);
					}
				}
				if (obj.isEquip)
				{
					if (m_gkContext.m_UIs.equipSys)
					{
						m_gkContext.m_UIs.equipSys.addEquip(obj);
					}
				}
				
			}
			else if (rev.actionType == stAddObjectPropertyUserCmd.OBJACTION_REFRESH)
			{
				refreshObject(rev);
				
			}
		
		}
		
		public function processstAutoOpenMPGZLeftTimeCmd(msg:ByteArray):void
		{
			var rev:stAutoOpenMPGZLeftTimeCmd = new stAutoOpenMPGZLeftTimeCmd();
			rev.deserialize(msg);
			m_leftTimeForOpenGrid = rev.lefttime * 60000;
			m_totalTimeForOpenGrid = rev.totaltime * 60000;
			m_initTimeForOpenGrid = m_gkContext.m_context.m_processManager.platformTime;
			
			if (backPack)
			{
				backPack.updateNextOpenedGrid();
			}
		}
		
		private function refreshObject(cmd:stAddObjectPropertyUserCmd):void
		{
			var retObj:Object = getPackageAndObjectByThisID(cmd.tobject.thisID);
			if (retObj == null)
			{
				return;
			}
			var obj:ZObject = retObj[ZOBJECT];
			var oldColor:uint = obj.m_object.m_equipData.color;
			obj.m_object = cmd.tobject;
			
			if (backPack)
			{
				//颜色变化时,需要更新Icon的颜色 装备强化等级满时
				if ((oldColor != obj.m_object.m_equipData.color) || (obj.isEquip && (obj.curEnhanceLevel == obj.maxEnhanceLevel)))
				{
					backPack.updateObject(obj);
				}
			}
			
			if (equipSys)
			{
				equipSys.freshObject(obj);
			}
		}
		
		public function getPackageAndObjectByThisID(thisID:uint):Object
		{
			var ret:Object;
			var obj:ZObject;
			for each (var item:*in m_dicPackage)
			{
				obj = (item as Package).getObjectByThisID(thisID);
				if (obj != null)
				{
					ret = new Object();
					ret[PACKAGE] = (item as Package);
					ret[ZOBJECT] = obj;
					return ret;
				}
			}
			return null;
		}
		
		public function getObjectInCommonByThisID(thisID:uint):ZObject
		{
			var pge:Package;
			var obj:ZObject;
			var i:int = stObjLocation.OBJECTCELLTYPE_COMMON1;
			for (; i <= stObjLocation.OBJECTCELLTYPE_COMMON3; i++)
			{
				pge = getPakage(WuProperty.MAINHERO_ID, i);
				obj = pge.getObjectByThisID(thisID);
				if (obj)
				{
					return obj;
				}
			}
			
			return null;
		}
		
		public function getEquipByType(heroID:uint, type:int):ZObject
		{
			var pac:Package = getEquipPakage(heroID);
			if (pac)
			{
				return pac.getEquipInEquipPakageByPos(ZObjectDef.typeToEquipPos(type));
			}
			return null;
		}
		
		public function processRemoveObjectProperty(msg:ByteArray):void
		{
			var rev:stRemoveObjectPropertyUserCmd = new stRemoveObjectPropertyUserCmd();
			rev.deserialize(msg);
			var retObj:Object = getPackageAndObjectByThisID(rev.thisID);
			if (retObj == null)
			{
				return;
			}
			
			var pack:Package = retObj[PACKAGE];
			var zobj:ZObject = retObj[ZOBJECT];
			dropZOjbect(zobj.thisID);
			pack.removeObject(zobj);
			if (backPack)
			{
				backPack.removeObject(zobj);
			}
			
			OnObjectNumChange(zobj, false);
		
		}
		
		//道具位置的变换
		public function processSwapObjectProperty(msg:ByteArray):void
		{
			var rev:stSwapObjectPropertyUserCmd = new stSwapObjectPropertyUserCmd();
			rev.deserialize(msg);
			
			var strLog:String = "将" + rev.thisID + "移动";
			m_gkContext.addLog(strLog);
			
			var sor:Object = getPackageAndObjectByThisID(rev.thisID);
			if (sor == null)
			{
				return;
			}
			var packSor:Package = sor[PACKAGE];
			var zobjSor:ZObject = sor[ZOBJECT];
			
			dropZOjbect(zobjSor.thisID);
			var packDest:Package = m_dicPackage[rev.dst.toPackageKey()];
			if (packDest == null)
			{
				return;
			}
			
			var zobjDest:ZObject = packDest.getObject(rev.dst.x, rev.dst.y);
			if (zobjDest != null)
			{
				packDest.removeObject(zobjDest);
				if (backPack)
				{
					backPack.removeObject(zobjDest);
				}
			}
			
			packSor.removeObject(zobjSor);
			
			if (backPack)
			{
				backPack.removeObject(zobjSor);
			}
			
			//------------
			if (zobjDest != null)
			{
				zobjDest.m_object.m_loation = zobjSor.m_object.m_loation;
			}
			zobjSor.m_object.m_loation = rev.dst;
			packDest.addObject(zobjSor);
			if (zobjDest != null)
			{
				packSor.addObject(zobjDest);
			}
			
			//--------------
			if (backPack)
			{
				backPack.addObject(zobjSor);
				if (zobjDest != null)
				{
					backPack.addObject(zobjDest);
				}
			}
			
			//--------------
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIFastSwapEquips) as IForm;
			if (form)
			{
				form.updateData(zobjSor);
				if (zobjDest != null)
				{
					form.updateData(zobjDest);
				}
			}
			
			if (zobjDest)
			{
				if (zobjDest.isEquip && zobjDest.isInCommonPackage)
				{
					var hintThisID:uint = m_gkContext.m_contentBuffer.getContent("uiHintMgr.subform_ChangeEquip", true) as uint;
					if (zobjDest.m_object.thisID == hintThisID)
					{
						var hintParam:Object = new Object();
						hintParam["obj"] = zobjDest;
						hintParam["srcType"] = 1;
						m_gkContext.m_hintMgr.hint(hintParam);
					}
				}
			}
		}
		
		public function processSplitObjProperty(msg:ByteArray):void
		{
			var rev:stSplitObjPropertyUserCmd = new stSplitObjPropertyUserCmd();
			rev.deserialize(msg);
			
			var sor:Object = getPackageAndObjectByThisID(rev.srcthisid);
			if (sor == null)
			{
				return;
			}
			var packSor:Package = sor[PACKAGE];
			var zobjSor:ZObject = sor[ZOBJECT];
			dropZOjbect(zobjSor.thisID);
			
			var packDest:Package = m_dicPackage[rev.pos.toPackageKey()];
			if (packDest == null)
			{
				return;
			}
			var zObjDest:ZObject = packDest.getObject(rev.pos.x, rev.pos.y);
			if (zObjDest)
			{
				if (zObjDest.thisID != rev.dstthisid)
				{
					return;
				}
			}
			
			if (zObjDest == null)
			{
				zObjDest = new ZObject();
				var objServer:T_Object = zobjSor.m_object.clone();
				objServer.num = rev.num;
				objServer.thisID = rev.dstthisid;
				objServer.m_loation = rev.pos;
				zObjDest.setObject(objServer);
				
				packDest.addObject(zObjDest);
				if (backPack)
				{
					backPack.addObject(zObjDest);
				}
			}
			else
			{
				zObjDest.m_object.num += rev.num;
				if (backPack)
				{
					backPack.updateObject(zObjDest);
				}
			}
			
			if (zobjSor.m_object.num <= rev.num)
			{
				packSor.removeObject(zobjSor);
				if (backPack)
				{
					backPack.removeObject(zobjSor);
				}
			}
			else
			{
				zobjSor.m_object.num -= rev.num;
				if (backPack)
				{
					backPack.updateObject(zobjSor);
				}
			}
			m_gkContext.m_contentBuffer.delContent(ContentBuffer.OBJECT_Chaifen);
		
		}
		
		public function processRefreshObjNum(msg:ByteArray):void
		{
			var rev:stRefreshObjNumPropertyUserCmd = new stRefreshObjNumPropertyUserCmd();
			rev.deserialize(msg);
			var retObj:Object = getPackageAndObjectByThisID(rev.thisid);
			
			if (retObj == null)
			{
				return;
			}
			
			var bAdd:Boolean = false;
			
			var obj:ZObject = retObj[ZOBJECT];
			var addNum:int;
			if (obj.m_object.num < rev.num)
			{
				bAdd = true;
				addNum = rev.num - obj.m_object.num;
			}
			obj.m_object.num = rev.num;
			if (backPack)
			{
				backPack.updateObject(obj);
			}
			
			OnObjectNumChange(obj, bAdd);
			
			//如果军团抽奖界面打开，则道具获得飞行特效延时播放
			var ui:IUICorpsLottery = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsLottery) as IUICorpsLottery;
			if (ui)
			{
				ui.addFlyObj(obj);
				return;
			}
			
			if (bAdd && !m_gkContext.m_localMgr.isSet(LocalDataMgr.LOCAL_HIDE_TurnCardState))
			{
				if (m_gkContext.m_giftPackMgr.giftAniData.m_cbkState) // 藏宝库宝箱领取物品的时候不需要播放动画
				{
					// 保存数据
					addCBKFlyObj(obj, addNum);
				}
				else if (!m_gkContext.m_giftPackMgr.giftAniData.m_giftState)
				{
					if (!m_gkContext.m_localMgr.isSet(LocalDataMgr.LOCAL_InNotPlayAniForGetObject))
					{
						if (rev.isani == ZObjectDef.OBJANITYPE_AFTERBATTLE)
						{
							var item:ObjAfterBattle = new ObjAfterBattle();
							item.m_obj = obj;
							item.m_num = addNum;
							m_objPlayList.push(item);
						}
						else
						{
							playAniForGetObject(obj, addNum);
						}
					}
				}
			}
		}
		
		public function processretSortMainPackageUserCmd(msg:ByteArray):void
		{
			var rev:retSortMainPackageUserCmd = new retSortMainPackageUserCmd();
			rev.deserialize(msg);
			if (rev.type == 0)
			{
				zhengliForCommonPackage(rev.list);
			}
			else
			{
				zhengliForBaowuPackage(rev.list);
			}
		}
		
		//武将转生缓存装备
		public function process_stHeroRebirthCacheHeroEquipCmd(msg:ByteArray):void
		{
			var rev:stHeroRebirthCacheHeroEquipCmd = new stHeroRebirthCacheHeroEquipCmd();
			rev.deserialize(msg);
			var pac:Package = this.getEquipPakage(rev.heroid);
			m_dicWuEquipBuffer[rev.heroid] = pac.copyObjectsToList();
		}
		
		//武将转生给转生武将穿上缓存装备
		public function process_stPutCacheEquipToRebirthHeroCmd(msg:ByteArray):void
		{
			var rev:stPutCacheEquipToRebirthHeroCmd = new stPutCacheEquipToRebirthHeroCmd();
			rev.deserialize(msg);
			var pac:Package = this.getEquipPakage(rev.dstheroid);
			var list:Vector.<ZObject> = m_dicWuEquipBuffer[rev.srcheroid];
			if (list == null)
			{
				DebugBox.info("没有缓存过武将" + rev.srcheroid + "的装备");
				return;
			}
			
			pac.copyObjectsFromList(list);
			
			if (backPack)
			{
				var zobj:ZObject;
				for each (zobj in list)
				{
					if (zobj)
					{
						backPack.addObject(zobj);
					}
				}
			}
			delete m_dicWuEquipBuffer[rev.srcheroid];
		
		}
		
		private function zhengliForCommonPackage(sortlist:Vector.<SortItem>):void
		{
			var list:Vector.<ZObject> = new Vector.<ZObject>();
			var sortItem:SortItem;
			var obj:ZObject;
			for each (sortItem in sortlist)
			{
				obj = getObjectInCommonByThisID(sortItem.thisID);
				if (obj == null)
				{
					DebugBox.info("包裹整理消息处理出现问题");
					continue;
				}
				obj.m_object.m_loation.location = sortItem.location;
				obj.m_object.num = sortItem.num;
				obj.m_object.m_loation.x = sortItem.x;
				obj.m_object.m_loation.y = sortItem.y;
				list.push(obj);
			}
			m_commonPackageList[0].clear();
			m_commonPackageList[1].clear();
			m_commonPackageList[2].clear();
			
			var pkage:Package;
			for each (obj in list)
			{
				pkage = m_dicPackage[obj.toPackageKey()] as Package;
				pkage.addObject(obj);
			}
			
			if (backPack)
			{
				backPack.reloadCommonObjects();
			}
		}
		
		private function zhengliForBaowuPackage(sortlist:Vector.<SortItem>):void
		{
			var list:Vector.<ZObject> = new Vector.<ZObject>();
			var sortItem:SortItem;
			var obj:ZObject;
			
			var pacBaowu:Package = getPakage(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_BAOWU);
			for each (sortItem in sortlist)
			{
				obj = pacBaowu.getObjectByThisID(sortItem.thisID);
				if (obj == null)
				{
					DebugBox.info("包裹整理消息处理出现问题");
					continue;
				}
				obj.m_object.m_loation.location = sortItem.location;
				obj.m_object.num = sortItem.num;
				obj.m_object.m_loation.x = sortItem.x;
				obj.m_object.m_loation.y = sortItem.y;
				list.push(obj);
			}
			pacBaowu.clear();
			
			for each (obj in list)
			{
				pacBaowu.addObject(obj);
			}
			
			if (backPack)
			{
				backPack.reloadBaowuPackage();
			}
		}
		
		protected function get backPack():IUIBackPack
		{
			return m_gkContext.m_UIs.backPack;
		}
		
		protected function get jiuguan():IUIJiuGuan
		{
			return m_gkContext.m_UIs.jiuguan;
		}
		
		public static function toPackageKey(heroID:uint, location:uint):uint
		{
			var key:uint = ((heroID << 8) + location);
			return key;
		}
		
		public function dropZOjbect(thisID:uint):void
		{
			var panel:ObjectPanel = DragManager.getDragInitiator() as ObjectPanel;
			if (panel != null)
			{
				if (panel.thisID == thisID)
				{
					DragManager.drop();
				}
			}
		}
		
		public function findFirstEmptyGridInBackPack():stObjLocation
		{
			var pkage:Package;
			var pos:IntPoint;
			var ret:stObjLocation;
			var k:uint = stObjLocation.OBJECTCELLTYPE_COMMON1;
			while (k <= stObjLocation.OBJECTCELLTYPE_COMMON3)
			{
				pkage = (m_dicPackage[toPackageKey(WuProperty.MAINHERO_ID, k)]) as Package;
				pos = pkage.findFirstEmptyGrid();
				if (pos != null)
				{
					ret = new stObjLocation();
					ret.heroid = WuProperty.MAINHERO_ID;
					ret.location = k;
					ret.x = pos.x;
					ret.y = pos.y;
					return ret;
				}
				k++;
			}
			
			return null;
		}
		
		public function get dicPackage():Dictionary
		{
			return m_dicPackage;
		}
		
		//获得指定武将（主角或主角的武将）的包裹
		public function getEquipPakage(heroID:uint):Package
		{
			var loaction:int;
			if (heroID == WuProperty.MAINHERO_ID)
			{
				loaction = stObjLocation.OBJECTCELLTYPE_UEQUIP;
			}
			else
			{
				loaction = stObjLocation.OBJECTCELLTYPE_HEQUIP;
			}
			return m_dicPackage[toPackageKey(heroID, loaction)];
		}
		
		public function getPakage(heroID:uint, location:uint):Package
		{
			return m_dicPackage[toPackageKey(heroID, location)];
		}
		
		public function getCommonPackage(location:uint):Package
		{
			return m_dicPackage[toPackageKey(WuProperty.MAINHERO_ID, location)];
		}
		
		public function exeFunInCommonPackages(fun:Function, param:Object):void
		{
			var pge:Package;
			var i:int = stObjLocation.OBJECTCELLTYPE_COMMON1;
			for (; i <= stObjLocation.OBJECTCELLTYPE_COMMON3; i++)
			{
				pge = getPakage(WuProperty.MAINHERO_ID, i);
				pge.execFun(fun, param);
			}
		}
		
		public function isFullOnPutObject(objID:uint):Boolean
		{
			var pge:Package;
			var i:int = stObjLocation.OBJECTCELLTYPE_COMMON1;
			for (; i <= stObjLocation.OBJECTCELLTYPE_COMMON3; i++)
			{
				pge = getPakage(WuProperty.MAINHERO_ID, i);
				if (false == pge.isFullOnPutObject(objID))
				{
					return false;
				}
			}
			return true;
		}
		
		public function get equipSys():IUIEquipSys
		{
			return m_gkContext.m_UIs.equipSys;
		}
		
		public function getObjectNameByTableID(id:uint):String
		{
			var item:TObjectBaseItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_OBJECT, id) as TObjectBaseItem;
			if (item)
			{
				return item.m_name;
			}
			else
			{
				return null;
			}
		}
		
		public function getObjectBaseByTableID(id:uint):TObjectBaseItem
		{
			var item:TObjectBaseItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_OBJECT, id) as TObjectBaseItem;
			return item;
		}
		
		public function computeObjNumInCommonPackage(id:uint):uint
		{
			m_param[ComputeObjNum_ID] = id;
			m_param[ComputeObjNum_NUM] = 0;
			exeFunInCommonPackages(computeObjNum, m_param);
			return m_param[ComputeObjNum_NUM];
		}
		
		//计算包裹中空格子的数量
		public function computeNumOfFreeGridsInCommonPackage():int
		{
			var ret:int = 0;
			var pge:Package;
			var i:int = stObjLocation.OBJECTCELLTYPE_COMMON1;
			for (; i <= stObjLocation.OBJECTCELLTYPE_COMMON3; i++)
			{
				pge = getPakage(WuProperty.MAINHERO_ID, i);
				ret += pge.numOfFreeGrids;
			}
			return ret;
		}
		
		public static const ComputeObjNum_ID:String = "id";
		public static const ComputeObjNum_NUM:String = "num";
		
		public static function computeObjNum(obj:ZObject, param:Object):void
		{
			if (obj.m_object.objID == param[ComputeObjNum_ID])
			{
				param[ComputeObjNum_NUM] += obj.m_object.num;
			}
		}
		
		//计算当前已拥有宝物(id)的数量
		public function computeNumOfBaowu(id:uint):uint
		{
			var param:Object = new Object();
			param["id"] = id;
			param["num"] = 0;
			getPakage(WuProperty.MAINHERO_ID, stObjLocation.OBJECTCELLTYPE_BAOWU).execFun(s_computeNumOfBaowu, param);
			
			return param["num"];
		}
		
		private function s_computeNumOfBaowu(obj:ZObject, param:Object):void
		{
			if (obj.ObjID == param["id"])
			{
				param["num"] += obj.m_object.num;
			}
		}
		
		//播放得到道具动画（道具Icon飞入武将(按钮))
		public function playAniForGetObject(obj:ZObject, num:int):void
		{
			var i:int;
			var aniGetForm:IUIAnimationGet = m_gkContext.m_UIMgr.getForm(UIFormID.UIAnimationGet) as IUIAnimationGet;
			if (aniGetForm != null)
			{
				for (i = 0; i < num; i++)
				{
					aniGetForm.addObj(obj);
				}
				
			}
			else
			{
				var add:Boolean = false;
				var ar:Array = m_gkContext.m_contentBuffer.getContent("uiAnimationGet_content", false) as Array;
				if (ar == null)
				{
					ar = new Array();
					add = true;
				}
				
				for (i = 0; i < num; i++)
				{
					ar.push(obj);
				}
				
				if (add)
				{
					m_gkContext.m_contentBuffer.addContent("uiAnimationGet_content", ar);
					m_gkContext.m_UIMgr.loadForm(UIFormID.UIAnimationGet);
				}
			}
		}
		
		public function hintOnGetEquip(obj:ZObject):void
		{
			if (m_gkContext.playerMain.level > 24)
			{
				return;
			}
			var hintParam:Object = new Object();
			hintParam[HintMgr.HINTTYPE] = HintMgr.HINTTYPE_AddObject;
			hintParam["obj"] = obj;
			this.m_gkContext.m_hintMgr.hint(hintParam);
		}
		
		public function showObjectMouseOverPanel(p:DisplayObjectContainer, posX:Number, posY:Number):void
		{
			if (m_ObjectMouseOverPanel == null)
			{
				m_ObjectMouseOverPanel = new PanelDisposeEx();
				m_ObjectMouseOverPanel.setPanelImageSkin("commoncontrol/panel/objectmouseover.png");
				m_ObjectMouseOverPanel.mouseChildren = false;
				m_ObjectMouseOverPanel.mouseEnabled = false;
			}
			
			m_ObjectMouseOverPanel.scaleX = p.scaleX;
			m_ObjectMouseOverPanel.scaleY = p.scaleY;
			
			var pp:DisplayObjectContainer = p.parent;
			if (pp)
			{
				m_ObjectMouseOverPanel.setPos(posX + p.x, posY + p.y);
				m_ObjectMouseOverPanel.show(pp);
			}
		
		}
		
		public function hideObjectMouseOverPanel(p:DisplayObjectContainer):void
		{
			if (m_ObjectMouseOverPanel == null)
			{
				return;
			}
			var pp:DisplayObjectContainer = p.parent;
			if (pp)
			{
				m_ObjectMouseOverPanel.hide(pp);
			}
		}
		
		// 增加藏宝库飞行的物品,只显示一个物品图标,但是显示
		public function addCBKFlyObj(obj:ZObject, num:int):void
		{
			// 需要单独创建一个物品,因为需要显示增加的物品数量
			var createobj:ZObject;
			createobj = ZObject.createClientObject(obj.m_ObjectBase.m_uID, num);
			// 如果没有列表,就生成一个列表
			if (!m_gkContext.m_giftPackMgr.giftAniData.m_dicObj[UIFormID.UICangbaoku])
			{
				m_gkContext.m_giftPackMgr.giftAniData.m_dicObj[UIFormID.UICangbaoku] = new Vector.<ZObject>();
			}
			
			m_gkContext.m_giftPackMgr.giftAniData.m_dicObj[UIFormID.UICangbaoku].push(createobj);
		}
		
		//判断指定武将的身上有无装备
		public function hasEquipForWus(heroID:uint):Boolean
		{
			var pak:Package = getEquipPakage(heroID);
			if (pak && pak.hasObject())
			{
				return true;
			}
			return false;
		}
		
		//判断包裹中能否放下所有武将的装备
		public function hasEnoughGridForWus(list:Array):Boolean
		{
			var pak:Package;
			var i:int;
			var numEquips:int = 0;
			for (i = 0; i < list.length; i++)
			{
				pak = getEquipPakage(list[i]);
				if (pak)
				{
					numEquips += pak.numOfObjects;
				}
			}
			
			var numFreeGrids:int = computeNumOfFreeGridsInCommonPackage();
			return numEquips <= numFreeGrids;
		}
		
		public static function s_funCollectAllthisID(obj:ZObject, param:Object):void
		{
			var list:Vector.<uint> = param as Vector.<uint>;
			list.push(obj.thisID);
		}
		
		//将指定武将的所有装备放入包裹中
		public function moveWuEquipsToCommonPackage(heroIDlist:Array):void
		{
			var list:Vector.<uint> = new Vector.<uint>();
			var pak:Package;
			var i:int;
			for (i = 0; i < heroIDlist.length; i++)
			{
				pak = getEquipPakage(heroIDlist[i]);
				if (pak)
				{
					pak.execFun(s_funCollectAllthisID, list);
				}
			}
			if (list.length == 0)
			{
				return;
			}
			
			var freeGridsList:Vector.<stObjLocation> = new Vector.<stObjLocation>();
			var param:Object = new Object();
			param["num"] = list.length;
			param["list"] = freeGridsList;
			for each (pak in m_commonPackageList)
			{
				pak.findFreeGrids(param);
			}
			if (list.length != freeGridsList.length)
			{
				return;
			}
			
			var send:stReqBatchMoveObjPropertyUserCmd = new stReqBatchMoveObjPropertyUserCmd();
			for (i = 0; i < list.length; i++)
			{
				send.push(list[i], freeGridsList[i]);
			}
			
			m_gkContext.sendMsg(send);
		}
		
		/*
		 * 当道具obj的数量发生变化时，调用此函数
		 */
		protected function OnObjectNumChange(obj:ZObject, bAdd:Boolean):void
		{
			
			if (equipSys)
			{
				equipSys.updateOnObjectNumChange(obj);
				
				if (obj.type == ZObjectDef.ItemType_EmbedGem)
				{
					equipSys.updateGemInPackage();
				}
			}
			
			if (obj.type == ZObjectDef.ItemType_Baowu)
			{
				if (jiuguan)
				{
					jiuguan.updateBaoWuNum();
				}
				var form:IUIRecruitCard = m_gkContext.m_UIMgr.getForm(UIFormID.UIRecruitCard) as IUIRecruitCard;
				if (form)
				{
					form.updateBaoWuNum(obj.ObjID);
				}
			}
			
			if ((obj.type == ZObjectDef.ItemType_YuanQiDan) && backPack)
			{
				backPack.updateHeroTrain();
			}
			
			if (obj.ObjID == ZObjectDef.OBJID_rongyu)
			{
				if (m_gkContext.m_marketMgr.isUIMarketVisible())
				{
					m_gkContext.m_marketMgr.m_uiMarketForm.updateRongyu();
				}
			}
			
			var uigamble:IUIGamble = m_gkContext.m_UIMgr.getForm(UIFormID.UIGamble) as IUIGamble;
			if (uigamble && m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIGamble))
			{
				uigamble.updateXingYunBi();
			}
			
			// 坐骑更新兽灵石
			var uiMountsSys:IUIMountsSys = m_gkContext.m_UIMgr.getForm(UIFormID.UIMountsSys) as IUIMountsSys;
			if (uiMountsSys)
			{
				uiMountsSys.onObjNumChange();
			}
		}
		
		//通过道具id获得所有ThisId
		public function getObjThisIdListByID(id:uint):Array
		{
			var param:Object = new Object();
			param["id"] = id;
			param["thisidlist"] = new Array();
			exeFunInCommonPackages(computeObjThisID, param);
			return param["thisidlist"];
		}
		
		private function computeObjThisID(obj:ZObject, param:Object):void
		{
			if (obj.m_object.objID == param["id"])
			{
				if (param["thisidlist"] as Array)
				{
					(param["thisidlist"] as Array).push(obj.m_object.thisID);
				}
			}
		}
		
		//两个武将互换装备   id_a,id_b未武将heroid(非主角)
		public function swapEquipsOfTwoHero(id_a:uint, id_b:uint):void
		{
			var vecThisId:Vector.<uint> = new Vector.<uint>();
			var vecLocation:Vector.<stObjLocation> = new Vector.<stObjLocation>();
			
			var pak_a:Package;
			var vecThisId_a:Vector.<uint> = new Vector.<uint>(ZObjectDef.EQUIP_MAX);
			var vecObjLoc_a:Vector.<stObjLocation> = new Vector.<stObjLocation>(ZObjectDef.EQUIP_MAX);
			var pak_b:Package;
			var vecThisId_b:Vector.<uint> = new Vector.<uint>(ZObjectDef.EQUIP_MAX);
			var vecObjLoc_b:Vector.<stObjLocation> = new Vector.<stObjLocation>(ZObjectDef.EQUIP_MAX);
			
			pak_a = getEquipPakage(id_a);
			pak_b = getEquipPakage(id_b);
			
			if (null == pak_a || null == pak_b)
			{
				return;
			}
			
			var i:int;
			var obj:ZObject;
			var stobjlocation:stObjLocation;
			
			for (i = 0; i < ZObjectDef.EQUIP_MAX; i++)
			{
				obj = pak_a.getObject(0, i);
				if (obj)
				{
					stobjlocation = obj.m_object.m_loation;
				}
				else
				{
					stobjlocation = new stObjLocation();
					stobjlocation.heroid = id_a;
					stobjlocation.location = stObjLocation.OBJECTCELLTYPE_HEQUIP;
					stobjlocation.y = i;
					
				}
				
				vecObjLoc_a[i] = stobjlocation;
			}
			pak_a.execFun(swapEquips_AllthisID, vecThisId_a);
			
			for (i = 0; i < ZObjectDef.EQUIP_MAX; i++)
			{
				obj = pak_b.getObject(0, i);
				if (obj)
				{
					stobjlocation = obj.m_object.m_loation;
				}
				else
				{
					stobjlocation = new stObjLocation();
					stobjlocation.heroid = id_b;
					stobjlocation.location = stObjLocation.OBJECTCELLTYPE_HEQUIP;
					stobjlocation.y = i;
					
				}
				
				vecObjLoc_b[i] = stobjlocation;
			}
			pak_b.execFun(swapEquips_AllthisID, vecThisId_b);
			
			for (i = 0; i < ZObjectDef.EQUIP_MAX; i++)
			{
				if (vecThisId_a[i])
				{
					vecThisId.push(vecThisId_a[i]);
					vecLocation.push(vecObjLoc_b[i]);
				}
				
				if ((0 == vecThisId_a[i]) && vecThisId_b[i])
				{
					vecThisId.push(vecThisId_b[i]);
					vecLocation.push(vecObjLoc_a[i]);
				}
			}
			
			var cmd:stReqBatchMoveObjPropertyUserCmd = new stReqBatchMoveObjPropertyUserCmd();
			for (i = 0; i < vecThisId.length; i++)
			{
				cmd.push(vecThisId[i], vecLocation[i]);
			}
			m_gkContext.sendMsg(cmd);
		}
		
		private function swapEquips_AllthisID(obj:ZObject, param:Object):void
		{
			var vec:Vector.<uint> = param as Vector.<uint>;
			if (vec)
			{
				vec[obj.m_object.m_loation.y] = obj.thisID;
			}
		}
		
		private function swapEquips_AllstObjLocation(obj:ZObject, param:Object):void
		{
			var vec:Vector.<stObjLocation> = param as Vector.<stObjLocation>;
			if (vec)
			{
				vec[obj.m_object.m_loation.y] = obj.m_object.m_loation;
			}
		}
		
		public function get leftTimeForOpenGrid():Number
		{
			return m_leftTimeForOpenGrid;
		}
		
		public function get initTimeForOpenGrid():Number
		{
			return m_initTimeForOpenGrid;
		}
		
		public function get totalTimeForOpenGrid():Number
		{
			return m_totalTimeForOpenGrid;
		}
		/**
		 * 每次战斗后调用 每次调用若m_objPlayList中有东西 就一次性全放出动画
		 */
		public function playAfterBattle():void
		{
			while (m_objPlayList.length != 0)
			{
				var item:ObjAfterBattle = m_objPlayList.splice(0, 1)[0];
				playAniForGetObject(item.m_obj, item.m_num);
			}
		}
	}
}