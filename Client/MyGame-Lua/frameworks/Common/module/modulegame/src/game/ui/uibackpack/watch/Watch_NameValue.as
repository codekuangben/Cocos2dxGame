package game.ui.uibackpack.watch 
{
	import modulecommon.appcontrol.Name_ValueCtrol;
	import flash.display.DisplayObjectContainer;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author 
	 */
	public class Watch_NameValue extends Name_ValueCtrol 
	{
		
		public function Watch_NameValue(parent:DisplayObjectContainer = null) 
		{
			super(parent);
			m_name.setFontColor(UtilColor.GRAY);
			m_value.setFontColor(UtilColor.GREEN);
		}
		public function set(name:String, value:uint, compareValue:uint=uint.MAX_VALUE):void
		{
			m_name.text = name+":";
			m_value.text = value.toString();
			
			if (name.length == 2)
			{
				m_value.x = 35;
			}
			else if (name.length == 3)
			{
				m_value.x = 50;
			}
			else if (name.length == 4)
			{
				m_value.x = 62; 
			}
			m_value.flush();
		}
	
	}

}