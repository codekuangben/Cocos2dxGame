package game.ui.uibenefithall.subcom.jihuoma 
{
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.msg.reqSendActiveCodeCmd;
	import game.ui.uibenefithall.subcom.PageBase;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 * 激活码
	 */
	public class JihuomaPage extends PageBase 
	{
		private var m_funBtn:PushButton;
		private var m_input:InputText;
		public function JihuomaPage(data:DataBenefitHall, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(data, parent, xpos, ypos);
			
			this.setPanelImageSkin("module/benefithall/jihuomabg.png");
			
			m_input = new InputText(this, 120, 341);
			m_input.setSize(426, 30);
			m_input.setTextFormat(UtilColor.WHITE, 14, true);
			m_input.drawRectBG();
			
			m_funBtn = new PushButton(this, 259, 395, onFunClick);
			m_funBtn.setSkinButton1Image("module/benefithall/lingqulibaobtn.png");
		}
		
		private function onFunClick(e:MouseEvent):void
		{
			
			var str:String = m_input.text;
			if (str == null || str.length == 0)
			{
				m_dataBenefitHall.m_gkContext.m_systemPrompt.promptOnTopOfMousePos("请输入激活码！", UtilColor.RED);
				return;
			}
			var send:reqSendActiveCodeCmd = new reqSendActiveCodeCmd();
			send.code = str;
			m_dataBenefitHall.m_gkContext.sendMsg(send);
		}
		
	}

}