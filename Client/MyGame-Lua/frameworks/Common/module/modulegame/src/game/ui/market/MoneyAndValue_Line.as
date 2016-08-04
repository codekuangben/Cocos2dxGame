package game.ui.market 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import modulecommon.appcontrol.MonkeyAndValue;
	import modulecommon.GkContext;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MoneyAndValue_Line extends MonkeyAndValue 
	{
		public var m_line:Shape;		
		public function MoneyAndValue_Line(gk:GkContext, parent:DisplayObjectContainer, type:int, xPos:Number,yPos:Number) 
		{
			super(gk, parent, type, xPos, yPos);
			m_line = new Shape();			
			this.addChild(m_line);
		}
		override public function set value(v:int):void
		{
			m_value.text = v.toString();
			m_value.flush();
			m_line.graphics.beginFill(0xcccccc);
			m_line.graphics.drawRect( 0, 9, m_value.x + m_value.width, 1);
			m_line.graphics.endFill();
		}
		
	}

}