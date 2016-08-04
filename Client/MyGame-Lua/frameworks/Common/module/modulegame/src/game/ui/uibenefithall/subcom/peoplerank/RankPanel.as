package game.ui.uibenefithall.subcom.peoplerank 
{
	import com.bit101.components.PanelPageParent;
	import flash.display.DisplayObjectContainer;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.subcom.peoplerank.pagestyle1.RankPageStyle1;
	import game.ui.uibenefithall.subcom.peoplerank.pagestyle2.RankPageStyle2;
	
	/**
	 * ...
	 * @author 
	 */
	public class RankPanel extends PanelPageParent 
	{
		protected var m_dataBenefitHall:DataBenefitHall;
		public function RankPanel(data:DataBenefitHall, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_dataBenefitHall = data;
		}
		
		public function showPage(day:int):void
		{
			var pageBase:RankPagebase=m_dicPage[day];
			if (pageBase == null)
			{
				pageBase = createPage(day);
				m_dicPage[day] = pageBase;
			}
			if (pageBase)
			{
				pageBase.show();
			}
		}
		
		public function removePage(day:int):void
		{
			var pageBase:RankPagebase = m_dicPage[day];
			if (pageBase)
			{
				delete m_dicPage[day];
				pageBase.dispose();
				if (pageBase.parent)
				{
					pageBase.parent.removeChild(pageBase);
				}
			}
		}
		public function updateOnServerData(day:int):void
		{
			var page:RankPagebase = m_dicPage[day];
			if (page)
			{
				page.updateOnServerData();
			}
		}
		
		public function onLingqu(day:int):void
		{
			var page:RankPageStyle1 = m_dicPage[day];
			if (page)
			{
				page.onLingqu();
			}
		}
		public function onNextDay():void
		{
			var page:RankPagebase;
			for each(page in m_dicPage)
			{
				if (page is RankPageStyle1)
				{
					(page as RankPageStyle1).onNextDay();
				}
			}
		}
		private function createPage(day:int):RankPagebase
		{
			if (day == 3 || day == 6 || day == 7)
			{
				var pageBase:RankPagebase = new RankPageStyle2(day, m_dataBenefitHall, this);
			}
			else
			{
				pageBase= new RankPageStyle1(day, m_dataBenefitHall, this);
			}
			return pageBase;
		}
	}

}