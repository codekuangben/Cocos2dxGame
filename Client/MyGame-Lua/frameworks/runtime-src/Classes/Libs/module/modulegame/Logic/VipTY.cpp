package game.logic
{
	import flash.utils.ByteArray;
	import game.netmsg.sceneUserCmd.practiceVipTimeUserCmd;
	import modulecommon.GkContext;
	import modulecommon.logicinterface.IVipTY;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.time.Daojishi;
	import com.util.UtilTools;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIScreenBtn;
	import modulecommon.uiinterface.IUIVipTiYan;
	/**
	 * ...
	 * @author ...
	 */
	public class VipTY implements IVipTY
	{
		protected var m_gkcontext:GkContext;
		private var m_daojishi:Daojishi;
		private var m_LastTime:uint;	// 礼包倒计时
		private var m_binit:Boolean;	// 倒计时礼包按钮是否创建
		
		public function VipTY(value:GkContext)
		{
			m_gkcontext = value;
			m_LastTime = 3600 * 2 + 1;			// 默认是 3600 * 2 + 1 ，就是还没有体验过，不是 0
		}
		
		private function beginDaojishi():void
		{
			if (!m_daojishi)
			{
				m_daojishi = new Daojishi(m_gkcontext.m_context);
			}
			
			m_daojishi.funCallBack = updateDaojishi;
			
			m_daojishi.initLastTime = 1000*m_LastTime;
			if(m_LastTime > 0)
			{
				m_daojishi.begin();
			}
			
			// 显示 UI
			if (m_gkcontext.m_UIs.screenBtn)
			{
				if(!m_binit)
				{
					//m_gkcontext.m_UIs.screenBtn.addBtnByID(ScreenBtnMgr.Btn_VipTiYan);
					m_binit = true;
				}
				m_gkcontext.m_UIs.screenBtn.updateVipTY(m_daojishi.timeSecond);
			}
		}
		
		private function updateDaojishi(d:Daojishi):void
		{
			// 如果没有停止 bug ：如果开始的时候倒计时就是  0，那么
			var time:String = UtilTools.formatTimeToString(m_daojishi.timeSecond);
			var ui:IUIScreenBtn = m_gkcontext.m_UIs.screenBtn;
			if (ui != null)
			{
				if (!m_binit)
				{
					//ui.addBtnByID(ScreenBtnMgr.Btn_VipTiYan);
					m_binit = true;
				}
				ui.updateVipTY(m_daojishi.timeSecond);
			}
			
			// 记录时间
			m_LastTime = m_daojishi.timeSecond;

			if (m_daojishi.isStop())
			{
				m_daojishi.end();
			}
		}
		
		public function pspracticeVipTimeUserCmd(msg:ByteArray):void
		{
			var cmd:practiceVipTimeUserCmd = new practiceVipTimeUserCmd();
			cmd.deserialize(msg);
			
			m_LastTime = cmd.time;
			if (m_LastTime != 3600 * 2 + 1)	// 表示玩家还没有体验vip
			{
				beginDaojishi();
			}
			
			var vipty:IUIVipTiYan = m_gkcontext.m_UIMgr.getForm(UIFormID.UIVipTiYan) as IUIVipTiYan;
			if (vipty)
			{
				vipty.updateBtnEnbale(canEnableTY());
			}
		}
		
		public function set binit(value:Boolean):void
		{
			m_binit = value;
		}
		
		public function canEnableTY():Boolean
		{
			if (m_LastTime != 3600 * 2 + 1)	// 表示玩家还没有体验vip
			{
				return false;
			}
			
			return true;
		}
		
		public function clearDJS():void
		{
			if (m_daojishi)
			{
				m_daojishi.end();
			}
			
			m_binit = false;
		}
		
		public function clearActiveIcon():void
		{
			if (m_gkcontext.m_UIs.screenBtn)
			{
				m_gkcontext.m_UIs.screenBtn.removeBtn(ScreenBtnMgr.Btn_VipTiYan);
			}
		}
		
		public function isDJSEnd():Boolean
		{
			return (m_LastTime == 0);
		}
	}
}