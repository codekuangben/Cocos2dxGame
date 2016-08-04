package game.ui.uibenefithall.subcom
{
	import com.bit101.components.PanelPage;
	import flash.display.DisplayObjectContainer;
	import game.ui.uibenefithall.DataBenefitHall;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PageBase extends PanelPage
	{
		protected var m_dataBenefitHall:DataBenefitHall;
		
		public function PageBase(data:DataBenefitHall, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			
			m_dataBenefitHall = data;
		}
		
		public function updateData(param:Object = null):void
		{
			
		}
	}
}