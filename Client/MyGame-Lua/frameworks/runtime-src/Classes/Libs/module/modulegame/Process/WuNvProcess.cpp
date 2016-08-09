package game.process 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.wunvCmd.stWuNvCmd;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUITongQueWuHui;
	/**
	 * ...
	 * @author ...
	 */
	public class WuNvProcess 
	{
		private var m_gkcontext:GkContext;
		private var m_dicFun:Dictionary;
		public function WuNvProcess(gk:GkContext)
		{
			m_gkcontext = gk;
			m_dicFun = new Dictionary();
			m_dicFun[stWuNvCmd.NOTIFY_WUNV_DATA_USERCMD] = m_gkcontext.m_tongquetaiMgr.process_stNotifyWunvDataUsercmd;
			m_dicFun[stWuNvCmd.RET_BEGIN_WU_NV_DANCING_USERCMD] = m_gkcontext.m_tongquetaiMgr.process_stRetBeginWuNvDancingUserCmd;
			m_dicFun[stWuNvCmd.RET_OPEN_WU_NV_UI_USERCMD] = transmitToUITongQueWuHui;
			m_dicFun[stWuNvCmd.RET_FRIEND_WU_NV_DANCING_USERCMD] = transmitToUITongQueWuHui;
			m_dicFun[stWuNvCmd.RET_GET_WU_NV_OUT_PUT_USERCMD] = m_gkcontext.m_tongquetaiMgr.process_stRetGetWuNvOutPutUserCmd;
			m_dicFun[stWuNvCmd.NOTIFY_ADD_NEW_WUNV_USERCMD] = m_gkcontext.m_tongquetaiMgr.process_stAddNewWuNvUserCmd;
			m_dicFun[stWuNvCmd.NOTIFY_WUNV_REAP_DATA_USERCMD] = m_gkcontext.m_tongquetaiMgr.process_notifyWuNvReapDataUserCmd;
			m_dicFun[stWuNvCmd.NOTIFY_ADD_NEW_MYSTERY_WUNV_USERCMD] = m_gkcontext.m_tongquetaiMgr.process_stAddNewMySteryWuNvUserCmd;
			m_dicFun[stWuNvCmd.NOTIFY_DEL_WUNV_USERCMD] = m_gkcontext.m_tongquetaiMgr.process_stDelWuNvUserCmd;
			m_dicFun[stWuNvCmd.UPDATE_WUNV_STEAL_DATA_USERCMD] = m_gkcontext.m_tongquetaiMgr.process_updateWuNvStealUserCmd;
		}
		public function process(msg:ByteArray, param:uint):void
		{
			if (m_dicFun[param] != undefined)
			{
				m_dicFun[param](msg, param);
			}
		}
		
		public function transmitToUITongQueWuHui(msg:ByteArray, param:uint):void
		{
			var iui:IUITongQueWuHui = m_gkcontext.m_UIMgr.getForm(UIFormID.UITongQueWuHui) as IUITongQueWuHui;
			if (iui)
			{
				iui.processMsg(msg, param);
			}
		}
		/*public function processNotifyWunvDataUsercmd(msg:ByteArray, param:uint):void
		{
			m_gkcontext.m_yizhelibaoMgr.process_stAlreadyPurchaseYZLBObjListCmd(msg);
		}*/
		
	}

}