package game.ui.uibenefithall.subcom.sevenlogin 
{
	import com.bit101.components.PanelPageParent;
	import flash.display.DisplayObjectContainer;
	import game.ui.uibenefithall.DataBenefitHall;
	/**
	 * ...
	 * @author 
	 */
	public class QiriBottomPart extends PanelPageParent 
	{
		protected var m_dataBenefitHall:DataBenefitHall;
		protected var m_tip:TipGodlyWeapon;
		public function QiriBottomPart(data:DataBenefitHall, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_dataBenefitHall = data;
			m_dataBenefitHall.m_qiriBottomPart = this;
		}
		
		public function showPage(id:int):void
		{
			var page:QiriDengluAwardPanel = m_dicPage[id];
			if (page == null)
			{
				page = new QiriDengluAwardPanel(m_dataBenefitHall, this, 0, 200);
				m_dicPage[id] = page;
				page.initData(m_dataBenefitHall, id);
			}
			page.show();
		}
		public function updateDay(day:int):void
		{
			var page:QiriDengluAwardPanel = m_dicPage[day];
			if (page != null)
			{
				page.updateBtn();
			}
		}
		override public function dispose():void 
		{
			super.dispose();
			if (m_tip)
			{
				if (m_tip.parent)
				{
					m_tip.parent.removeChild(m_tip);
				}
				m_tip.dispose();
			}
		}
		
		public function getTipGodlyWeapon():TipGodlyWeapon
		{
			if (m_tip == null)
			{
				m_tip = new TipGodlyWeapon(m_dataBenefitHall.m_gkContext);
			}
			return m_tip;
		}
	}

}