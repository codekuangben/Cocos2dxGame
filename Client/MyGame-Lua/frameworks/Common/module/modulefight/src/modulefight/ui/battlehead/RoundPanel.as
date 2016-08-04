package modulefight.ui.battlehead 
{
	import com.bit101.components.PanelContainer;
	import common.Context;
	import flash.display.DisplayObjectContainer;
	import modulecommon.appcontrol.DigitComponent;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class RoundPanel extends PanelContainer 
	{
		private var m_digits:DigitComponent;
		
		public function RoundPanel(parent:DisplayObjectContainer, con:Context) 
		{
			super(parent);
			
			m_digits = new DigitComponent(con, this, 94, 32);
			m_digits.setParam("commoncontrol/digit/gedangdigit", 24, 32);
		}
		
		public function setRound(roundIndex:int):void
		{
			if (roundIndex < 9)
			{
				m_digits.x = 96;
			}
			else
			{
				m_digits.x = 88;
			}
			
			if ( -1 == roundIndex)//-1表示还未开始第一回合
			{
				m_digits.digit = 1;
				return;
			}
			
			m_digits.digit = (roundIndex + 1);
		}
		
	}

}