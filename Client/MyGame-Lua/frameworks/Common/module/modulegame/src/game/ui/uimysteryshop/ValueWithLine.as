package game.ui.uimysteryshop
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import flash.display.DisplayObjectContainer;
	import modulecommon.appcontrol.MoneyPanel;
	import modulecommon.GkContext;
	import modulecommon.appcontrol.MoneyPanel;
	import flash.display.Shape;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ValueWithLine extends Component 
	{
		public var m_value:Label;
		public var m_moneyPanel:MoneyPanel;
		public var m_tittle:Label;		
		public var m_line:Shape;	
		
		public function ValueWithLine(gk:GkContext,parent:DisplayObjectContainer,type:int, xpos:Number, ypos:Number,line:Boolean=false,str:String=null) 
		{
			super(parent, xpos, ypos);
			
			if (str != null)
			{
				m_tittle = new Label(this, -32);	
				m_tittle.text = str;
			}
			m_value = new Label(this, 22);	
			if (line)
			{		
				m_line = new Shape();	
				m_line.graphics.beginFill(0xff0000);
				m_line.graphics.drawRect( -32, 8, m_value.x + m_value.width+65, 2);
				m_line.graphics.endFill();
			}
			m_moneyPanel = new MoneyPanel(gk, this);
			m_moneyPanel.type = type;			
		}
		
		public function set value(v:int):void
		{
			m_value.text = v.toString();
			if (m_line != null)
			{
				this.addChild(m_line);
			}
		}
		
		public function set color(col:int):void
		{
			if (m_tittle != null)
			{
				m_tittle.setFontColor(col);
			}
			m_value.setFontColor(col);			
		}
		
		public function updateMoneyPanel(type:int):void
		{
			m_moneyPanel.type = type;
		}
	}
}