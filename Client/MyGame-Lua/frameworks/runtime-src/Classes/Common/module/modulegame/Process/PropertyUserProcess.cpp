package game.process
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import game.netmsg.propertyUserCmd.stPlayGainObjAniUserCmd;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.ui.Form;
	//import com.util.DebugBox;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import game.netmsg.mapobject.stAddLostMapObjPropertyUserCmd;
	import game.netmsg.mapobject.stAddMapObjPropertyUserCmd;
	import game.netmsg.mapobject.stmsg.t_MapObjData;
	import game.netmsg.mapobject.stRmLostMapObjPropertyUserCmd;
	import game.netmsg.mapobject.stRmMapObjPropertyUserCmd;
	import game.netmsg.propertyUserCmd.stRetPickUpObjPropertyUserCmd;
	
	import modulecommon.GkContext;
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.*;
	import modulecommon.scene.beings.FallObjectEntity;
	//import modulecommon.scene.beings.Player;
	//import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.object.ObjectMgr;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TFObjectItem;
	//import com.util.UtilColor;
	//import com.util.UtilHtml;
	import com.util.UtilTools;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	//import org.ffilmation.engine.core.fScene;
	
	public class PropertyUserProcess
	{
		private var m_gkcontext:GkContext;
		private var m_objMgr:ObjectMgr;
		private var dicFun:Dictionary;
		
		private var m_zongzhanliBatchMoveObjActionUserCmd:int;
		
		public function PropertyUserProcess(gk:GkContext)
		{
			m_gkcontext = gk;
			m_objMgr = gk.m_objMgr;
			dicFun = new Dictionary();
			dicFun[stPropertyUserCmd.ADDUSEROBJ_PROPERTY_USRECMD] = m_objMgr.processAddObjectProperty;
			dicFun[stPropertyUserCmd.REMOVEUSEROBJ_PROPERTY_USRECMD] = m_objMgr.processRemoveObjectProperty;
			dicFun[stPropertyUserCmd.SWAPUSEROBJ_PROPERTY_USRECMD] = m_objMgr.processSwapObjectProperty;
			dicFun[stPropertyUserCmd.SPLITOBJ_PROPERTY_USRECMD] = m_objMgr.processSplitObjProperty;
			dicFun[stPropertyUserCmd.ADDUSEROBJECT_LIST_PROPERTY_USERCMD] = m_objMgr.processAddUserObjListProperty;
			dicFun[stPropertyUserCmd.RET_SORT_MAIN_PACKAGE_USERCMD] = m_objMgr.processretSortMainPackageUserCmd;
			dicFun[stPropertyUserCmd.PARA_AUTO_OPEN_MPGZ_LEFTTIME_PROPERTY_USERCMD] = m_objMgr.processstAutoOpenMPGZLeftTimeCmd;
			dicFun[stPropertyUserCmd.RET_PICKUPOBJ_PROPERTY_USRECMD] = pickUpObjAni;
			dicFun[stPropertyUserCmd.REFRESH_OBJ_NUM_PROPERTY_USRECMD] = m_objMgr.processRefreshObjNum;
			dicFun[stPropertyUserCmd.REFRESH_OPEN_MAINPACK_GEZI_NUM_USERCMD] = m_objMgr.processRefreshOpenMainPackGeZiNumUserCmd;
			dicFun[stPropertyUserCmd.VIEWED_USER_EQUIP_LIST_PROPERTY_USERCMD] = m_gkcontext.m_watchMgr.processAddUserObjListProperty;
			dicFun[stPropertyUserCmd.GM_ADDUSEROBJECT_LIST_PROPERTY_USERCMD] = m_gkcontext.m_gmWatchMgr.processstGmAddUserObjListPropertyUserCmd;
			dicFun[stPropertyUserCmd.PARA_RET_ZHAOCAI_RESULT_PROPERTY_USERCMD] = m_gkcontext.m_ingotbefallMgr.processZhaocaiResultPropertyUserCmd;
			dicFun[stPropertyUserCmd.PARA_CAISHEN_ONLINE_PROPERTY_USERCMD] = m_gkcontext.m_ingotbefallMgr.processCaiShenOnlinePropertyUserCmd;
			
			dicFun[stPropertyUserCmd.PARA_DAZUO_ONLINE_PROPERTY_USERCMD] = m_gkcontext.m_dazuoMgr.processDazuoOnlinePropertyUserCmd;
			dicFun[stPropertyUserCmd.PARA_RET_DAZUO_DATA_PROPERTY_USERCMD] = m_gkcontext.m_dazuoMgr.processRetDazuoDataPropertyUserCmd;
			dicFun[stPropertyUserCmd.PARA_DZDATA_CHANGE_PROPERTY_USERCMD] = m_gkcontext.m_dazuoMgr.processDZDataChangePropertyUserCmd;
			dicFun[stPropertyUserCmd.PARA_FUYOUTIME_CHANGE_PROPERTY_USERCMD] = m_gkcontext.m_dazuoMgr.processFuyouTimeChangePropertyUserCmd;
			dicFun[stPropertyUserCmd.PARA_INCOME_CHANGE_PROPERTY_USERCMD] = m_gkcontext.m_dazuoMgr.processIncomeChangePropertyUserCmd;
			dicFun[stPropertyUserCmd.PARA_BUYTIMES_CHANGE_PROPERTY_USERCMD] = m_gkcontext.m_dazuoMgr.processBuyTimesChangePropertyUserCmd;
			dicFun[stPropertyUserCmd.PARA_RET_OTHER_FUYOUTIME_PROPERTY_USERCMD] = m_gkcontext.m_dazuoMgr.processRetOtherFuyouTimeProperytUserCmd;
			dicFun[stPropertyUserCmd.PARA_RET_FREE_LINGPAI_INFO_USERCMD] = processRetFreeLingpaiInfoUserCmd;
			dicFun[stPropertyUserCmd.PARA_BATCH_MOVE_OBJ_ACTION_USERCMD] = process_stBatchMoveObjActionUserCmd;
			dicFun[stPropertyUserCmd.PARA_PLAY_GAIN_OBJ_ANI_USERCMD] = process_stPlayGainObjAniUserCmd;
		}
		
		public function process(msg:ByteArray, param:uint):void
		{
			var cmd:stPropertyUserCmd;
			var fobjData:t_MapObjData;
			var pt:Point;
			var fobj:FallObjectEntity;
			var tFObjItem:TFObjectItem;
			var other:FallObjectEntity;
			
			if (dicFun[param] != undefined)
			{
				dicFun[param](msg);
			}
			else if (stPropertyUserCmd.ADD_MAPOBJECT_PROPERTY_USERCMD == param)
			{
				cmd = new stAddMapObjPropertyUserCmd();
				cmd.deserialize(msg);
				
				fobjData = (cmd as stAddMapObjPropertyUserCmd).data;
				fobj = m_gkcontext.m_fobjManager.getFOjectByTmpID(fobjData.thisid) as FallObjectEntity;
				pt = m_gkcontext.m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(fobjData.x, fobjData.y));
				
				if (fobj == null)
				{
					tFObjItem = (this.m_gkcontext.m_dataTable.getItem(DataTable.TABLE_FObj, fobjData.objid)) as TFObjectItem;
					if (tFObjItem == null)
					{
						Logger.info(null, "process", "stAddMapObjPropertyUserCmd" + "TFObjectItem中没有编号" + fobjData.objid);
					}
					
					other = this.m_gkcontext.m_context.m_sceneView.scene().createFObject(EntityCValue.TFallObject, tFObjItem.m_strModel, pt.x, pt.y, 0, UtilTools.convS2CDir(0)) as FallObjectEntity;
					if (other != null)
					{
						fobj = other;
						fobj.fobjBase = tFObjItem;
						fobj.tempid = fobjData.thisid;
						fobj.name = fobjData.objname;
						if (fobj.isAutoPick)
						{
							fobj.registerAutoPick();
						}
						m_gkcontext.m_fobjManager.addFObjectByTmpID(fobj.tempid, fobj);
					}
				}
			}
			else if (stPropertyUserCmd.RM_MAPOBJECT_PROPERTY_USERCMD == param)
			{
				cmd = new stRmMapObjPropertyUserCmd();
				cmd.deserialize(msg);
				
				m_gkcontext.m_fobjManager.destroyFOjectByTmpID((cmd as stRmMapObjPropertyUserCmd).thisid);
			}
			else if (stPropertyUserCmd.ADD_LOST_MAPOBJECT_PROPERTY_USERCMD == param)
			{
				cmd = new stAddLostMapObjPropertyUserCmd();
				cmd.deserialize(msg);
				
				var lostmsg:stAddLostMapObjPropertyUserCmd = cmd as stAddLostMapObjPropertyUserCmd;
				fobj = m_gkcontext.m_fobjManager.getFOjectByTmpID(lostmsg.thisid) as FallObjectEntity;
				pt = m_gkcontext.m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(lostmsg.x, lostmsg.y));
				
				if (fobj == null)
				{
					tFObjItem = (this.m_gkcontext.m_dataTable.getItem(DataTable.TABLE_FObj, lostmsg.id)) as TFObjectItem;
					if (tFObjItem == null)
					{
						Logger.info(null, "process", "stAddLostMapObjPropertyUserCmd" + "TFObjectItem中没有编号" + lostmsg.id);
					}
					
					other = this.m_gkcontext.m_context.m_sceneView.scene().createFObject(EntityCValue.TFallObject, tFObjItem.m_strModel, pt.x, pt.y, 0, UtilTools.convS2CDir(0)) as FallObjectEntity;
					if (other != null)
					{
						fobj = other;
						//fobj.serverX = lostmsg.x;
						//fobj.serverY = lostmsg.y;
						fobj.thisid = lostmsg.thisid;
						fobj.fobjBase = tFObjItem;
						fobj.tempid = lostmsg.thisid;
						fobj.name = lostmsg.name;
						fobj.m_moneyType = lostmsg.type;
						fobj.m_moneyNum = lostmsg.num;
						if (fobj.isAutoPick)
						{
							fobj.registerAutoPick();
						}
						m_gkcontext.m_fobjManager.addFObjectByTmpID(fobj.tempid, fobj);
					}
				}
			}
			else if (stPropertyUserCmd.RM_LOST_MAPOBJECT_PROPERTY_USERCMD == param)
			{
				// 删除一个掉落物
				cmd = new stRmLostMapObjPropertyUserCmd();
				cmd.deserialize(msg);				
				m_gkcontext.m_fobjManager.destroyFOjectByTmpID((cmd as stRmLostMapObjPropertyUserCmd).thisid);
				
			}
		}
		
		public function pickUpObjAni(msg:ByteArray):void
		{
			var rev:stRetPickUpObjPropertyUserCmd = new stRetPickUpObjPropertyUserCmd();
			rev.deserialize(msg);
			
			var fobj:FallObjectEntity;
			fobj = m_gkcontext.m_fobjManager.getFOjectByTmpID(rev.thisid) as FallObjectEntity;
			if (fobj && fobj.m_moneyType)
			{
				var bitmap:Bitmap = fobj.curBitmap;
				if (bitmap && bitmap.bitmapData)
				{
					var paramAni:Object = new Object();
					var pos:Point = bitmap.localToGlobal(new Point());
					pos = m_gkcontext.m_context.golbalToScreen(pos);
					paramAni["x"] = pos.x;
					paramAni["y"] = pos.y;
					paramAni["bitmapData"] = bitmap.bitmapData.clone();
					paramAni["type"] = fobj.m_moneyType;
					paramAni["num"] = fobj.m_moneyNum;
					var form:IForm = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFallObjectPicupAni);
					if (form)
					{
						form.updateData(paramAni);
					}
					else
					{
						m_gkcontext.m_contentBuffer.addContent("uiFallObjectPicupAni_data", paramAni);
						m_gkcontext.m_UIMgr.loadForm(UIFormID.UIFallObjectPicupAni);
					}
				}
				
				// 播放音效
				m_gkcontext.m_commonProc.playMsc(1);
			}
			
		}
		
		//返回令牌购买、领取信息
		public function processRetFreeLingpaiInfoUserCmd(msg:ByteArray):void
		{
			var rev:stRetFreeLingPaiInfoCmd = new stRetFreeLingPaiInfoCmd();
			rev.deserialize(msg);
			
			var info:Object = new Object();
			info["buylptimes"] = rev.buylptimes;
			info["freelp"] = rev.freelp;
			
			m_gkcontext.m_contentBuffer.addContent("uiBuyLingpai_info", info);
			var form:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIBuyLingpai);
			if (form)
			{
				form.updateData(info);
			}
			else
			{
				m_gkcontext.m_UIMgr.loadForm(UIFormID.UIBuyLingpai);
			}
			
			// 播放音效
			m_gkcontext.m_commonProc.playMsc(1);
		}
		
		public function process_stBatchMoveObjActionUserCmd(msg:ByteArray):void
		{
			var rev:stBatchMoveObjActionUserCmd = new stBatchMoveObjActionUserCmd();
			rev.deserialize(msg);
			if(rev.m_action == 0)
			{
				m_gkcontext.m_localMgr.set(LocalDataMgr.LOCAL_InBatchMoveObj);
				m_zongzhanliBatchMoveObjActionUserCmd = m_gkcontext.playerMain.wuProperty.m_uZongZhanli;
			}
			else if (rev.m_action == 1)
			{
				m_gkcontext.m_localMgr.clear(LocalDataMgr.LOCAL_InBatchMoveObj);
				var newZhanli:int = m_gkcontext.playerMain.wuProperty.m_uZongZhanli;
				if (newZhanli > m_zongzhanliBatchMoveObjActionUserCmd)
				{
					m_gkcontext.m_wuMgr.onZongzhanliUp(newZhanli - m_zongzhanliBatchMoveObjActionUserCmd, 0);
				}
				
			}
			
			
		}
		
		public function process_stPlayGainObjAniUserCmd(msg:ByteArray):void
		{
			var rev:stPlayGainObjAniUserCmd = new stPlayGainObjAniUserCmd();
			rev.deserialize(msg);
			if (rev.m_bPlay)
			{
				m_gkcontext.m_localMgr.clear(LocalDataMgr.LOCAL_InNotPlayAniForGetObject);
			}
			else
			{
				m_gkcontext.m_localMgr.set(LocalDataMgr.LOCAL_InNotPlayAniForGetObject);
			}
		}
	}
}