package game.ui.uibenefithall.subcom.welfarepackage 
{
	import com.bit101.components.Panel;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.GkContext;
	import modulecommon.net.msg.activityCmd.getBackWelfareDataCmd;
	import com.bit101.components.Component;
	
	/**
	 * ...
	 * @author 
	 */
	public class WelfareReceiveState extends Panel 
	{
		private var m_gkcontext:GkContext;
		private var m_remainday:Label;
		private var m_receiveBtn:PushButton;
		private var m_type:uint;
		public function WelfareReceiveState(type:uint, path:String, gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkcontext = gk;
			m_type = type;
			setPanelImageSkin(path);
			m_receiveBtn = new PushButton(this, 60, 182, receiveClick);
			m_remainday = new Label(this, 123, 141);
			m_remainday.setFontSize(14);
			m_remainday.align = Component.CENTER;
			nextDay();
			
		}
		private function receiveClick(e:MouseEvent):void
		{
			var send:getBackWelfareDataCmd = new getBackWelfareDataCmd();
			send.m_type = m_type;
			m_gkcontext.sendMsg(send);
		}
		public function harvest():void
		{
			m_receiveBtn.setSkinButton1Image("module/benefithall/rebate/btnreceived.png");
			m_receiveBtn.enabled = false;
			updataLabel();
		}
		public function nextDay():void
		{
			var state:Object = m_gkcontext.m_welfarePackageMgr.packageState(m_type);
			if (state.m_leftTime > 0 && state.m_buyback == 0) //剩余次数大于0且未领取过
			{
				m_receiveBtn.setSkinButton1Image("module/benefithall/lingqulibaobtn.png");
				m_receiveBtn.enabled = true;
			}
			else
			{
				m_receiveBtn.setSkinButton1Image("module/benefithall/rebate/btnreceived.png");
				m_receiveBtn.enabled = false;
			}
			updataLabel();
		}
		/*override public function onShow():void 
		{
			super.onShow();
			updataLabel();
		}*/
		private function updataLabel():void
		{
			m_remainday.text = "剩余 " + m_gkcontext.m_welfarePackageMgr.packageState(m_type).m_leftTime + "天";
		}
	}

}