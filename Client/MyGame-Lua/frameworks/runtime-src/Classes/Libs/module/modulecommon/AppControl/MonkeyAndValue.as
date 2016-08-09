package modulecommon.appcontrol 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author ...
	 */
	public class MonkeyAndValue extends Component
	{
		public var m_value:Label;
		public var m_moneyPanel:MoneyPanel;
		
		public function MonkeyAndValue(gk:GkContext, parent:DisplayObjectContainer, type:int,xPos:Number, yPos:Number) 
		{
			super(parent, xPos, yPos);
			m_value = new Label(this, 22);			
			m_moneyPanel = new MoneyPanel(gk, this);
			m_moneyPanel.type = type;
		}
		
		public function set value(v:int):void
		{
			m_value.text = v.toString();			
		}
		
		public function updateMoneyPanel(type:int):void
		{
			m_moneyPanel.type = type;
		}
	}

}