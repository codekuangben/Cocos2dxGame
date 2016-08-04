package modulefight.digitani
{
	import com.bit101.components.Panel;
	import common.Context;
	import flash.display.DisplayObjectContainer;
	import modulecommon.appcontrol.DigitComponentWidthSign;
	import common.event.UIEvent;
	import modulefight.FightEn;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class DigitNormalDisplay extends Panel
	{
		private var m_typePanel:Panel;
		public var m_digit:DigitComponentWidthSign;
	
		
		public function DigitNormalDisplay(con:Context, parent:DisplayObjectContainer = null)
		{
			super(parent);
			this.addEventListener(UIEvent.IMAGELOADED, onChildImageLoaded);
			m_typePanel = new Panel(this);
			m_typePanel.recycleSkins = true;
			m_typePanel.visible = false;
			
			m_digit = new DigitComponentWidthSign(con, this);
			m_digit.setParam("commoncontrol/digit/normaldigit", 22, 35, "commoncontrol/digit/normaldigit/subtract.png", 10, 22);
			//m_digit.y = 20;
			m_digit.addEventListener(UIEvent.IMAGELOADED, onDigitCreatorDraw);
		}
		
		public function setDigit(n:int, type:int):void
		{			
			
			
			if (type == FightEn.DAM_None)
			{
				m_typePanel.visible = false;
			}
			else
			{
				if (type == FightEn.DAM_Physical)
				{
					m_typePanel.setPanelImageSkin("commoncontrol/panel/word_wu.png");
				}
				else if (type == FightEn.DAM_Strategy)
				{
					m_typePanel.setPanelImageSkin("commoncontrol/panel/word_ce.png");
				}				
				m_typePanel.visible = true;
				
			}
			m_digit.digit = n;
		}
		
		private function onChildImageLoaded(e:UIEvent):void
		{
			if (e.target != this)
			{
				e.stopPropagation();
			}
		}
		
		private function onDigitCreatorDraw(e:UIEvent):void
		{
			if (e.target != m_digit)
			{
				return;
			}
			if (m_typePanel.visible)
			{
				m_typePanel.x = m_digit.width;
				this.width = m_typePanel.x + 34;
				
			}
			else
			{
				this.width = m_digit.width;
			}
			//trace("位置"+m_dight.toString()+","+m_typePanel.x+","+m_digit.width+","+m_typePanel.visible.toString());
			
			this.height = 112;
			this.dispatchEvent(new UIEvent(UIEvent.IMAGELOADED, true));
		}
	}

}