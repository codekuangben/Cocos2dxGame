package game.ui.uibenefithall.subcom.peoplerank.pagestyle2 
{
	import flash.display.DisplayObjectContainer;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.subcom.peoplerank.RankPagebase;
	import modulecommon.scene.benefithall.peoplerank.Ranks_Style1;
	
	/**
	 * ...
	 * @author 
	 */
	public class RankPageStyle2 extends RankPagebase 
	{
		private var m_rankAwardPart:RankAwardPart2;
		public function RankPageStyle2(day:int, data:DataBenefitHall, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(day, data, parent, xpos, ypos);
			this.setPanelImageSkin("module/benefithall/peoplerank/bg2.png");
			m_rankAwardPart = new RankAwardPart2(m_ranks as Ranks_Style1, data, this, 0, 208);
		}
		override public function updateOnServerData():void
		{
			m_rankAwardPart.updateOnServerData();
		}
	}

}