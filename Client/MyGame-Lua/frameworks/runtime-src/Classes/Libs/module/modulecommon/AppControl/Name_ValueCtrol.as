package modulecommon.appcontrol 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;	
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	
	public class Name_ValueCtrol extends Component 
	{		
		public var m_name:Label;
		public var m_value:Label;
		public function Name_ValueCtrol(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
		{
			super(parent,xpos,ypos);
			m_name = new Label(this);
			m_value = new Label(this);
		}
		
	}

}