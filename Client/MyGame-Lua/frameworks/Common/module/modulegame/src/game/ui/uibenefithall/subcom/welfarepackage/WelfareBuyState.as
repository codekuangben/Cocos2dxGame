package game.ui.uibenefithall.subcom.welfarepackage 
{
	import br.com.stimuli.loading.BulkLoader;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.GkContext;
	import modulecommon.net.msg.activityCmd.buyWelfareDataCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class WelfareBuyState extends Panel 
	{
		private var m_buyBtn:PushButton;
		private var m_gkcontext:GkContext;
		private var m_type:uint;
		public function WelfareBuyState(type:uint,path:String,gk:GkContext,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkcontext = gk;
			m_type = type;
			setPanelImageSkin(path);
			m_buyBtn = new PushButton(this, 60, 182, buyClick);
			m_buyBtn.setSkinButton1Image("module/benefithall/welfarepackage/buy.png");			
		}
		private function buyClick(e:MouseEvent):void
		{
			var send:buyWelfareDataCmd = new buyWelfareDataCmd();
			send.m_type = m_type;
			m_gkcontext.sendMsg(send);
		}
		
	}

}