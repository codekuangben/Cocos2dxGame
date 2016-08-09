package modulecommon.appcontrol 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;	
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class Icon_ValueCtrol extends Component 
	{
		public var m_icon:Component;
		public var m_value:Label;
		public function Icon_ValueCtrol(parent:DisplayObjectContainer = null, bCreatePanel:Boolean = true ) 
		{
			super(parent);
			if (bCreatePanel)
			{
				m_icon = new Panel(this);
			}
			m_value = new Label(this);
		}
		
	}

}