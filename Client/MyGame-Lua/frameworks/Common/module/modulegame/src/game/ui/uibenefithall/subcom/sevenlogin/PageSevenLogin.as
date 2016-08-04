package game.ui.uibenefithall.subcom.sevenlogin
{
	import flash.display.DisplayObjectContainer;
	
	import flash.utils.Dictionary;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.subcom.PageBase;
	import com.bit101.components.PushButton;
	/**
	 * @brief 7 日登陆页面
	 */
	public class PageSevenLogin extends PageBase
	{
		private var m_topPart:QiriTopPart;
		private var m_bottomPart:QiriBottomPart;
		
		public function PageSevenLogin(data:DataBenefitHall, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(data, parent, xpos, ypos);
			this.setPanelImageSkin("module/benefithall/qiridenglu/qiridenglubg.png");
			
			m_bottomPart = new QiriBottomPart(m_dataBenefitHall, this);
			m_topPart = new QiriTopPart(m_dataBenefitHall, m_bottomPart, this);
		}
		
		override public function updateData(param:Object = null):void
		{
			m_topPart.updateDay(param as int);
			m_bottomPart.updateDay(param as int);
		}	
	}
}