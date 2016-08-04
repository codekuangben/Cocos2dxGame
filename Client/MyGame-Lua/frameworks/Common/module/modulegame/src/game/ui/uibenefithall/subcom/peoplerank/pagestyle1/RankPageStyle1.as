package game.ui.uibenefithall.subcom.peoplerank.pagestyle1 
{
	import flash.display.DisplayObjectContainer;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.subcom.peoplerank.RankPagebase;
	import modulecommon.scene.benefithall.peoplerank.Ranks_Style1;
	
	/**
	 * ...
	 * @author 
	 */
	public class RankPageStyle1 extends RankPagebase 
	{
		private var m_fixAwadPart:FixAwardPart;
		private var m_rankAwardPart:RankAwardPart1;
		public function RankPageStyle1(day:int, data:DataBenefitHall, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(day, data, parent, xpos, ypos);
			this.setPanelImageSkin("module/benefithall/peoplerank/bg1.png");
			m_fixAwadPart = new FixAwardPart(m_ranks as Ranks_Style1, data, this, 0, 210);
			m_rankAwardPart = new RankAwardPart1(m_ranks as Ranks_Style1, data, this, 0, 325);
		}
		
		override public function updateOnServerData():void
		{
			m_rankAwardPart.updateOnServerData();
		}
		public function onLingqu():void
		{
			m_fixAwadPart.onLingqu();
		}
		
		public function onNextDay():void
		{
			m_fixAwadPart.onNextDay();
		}
	}

}