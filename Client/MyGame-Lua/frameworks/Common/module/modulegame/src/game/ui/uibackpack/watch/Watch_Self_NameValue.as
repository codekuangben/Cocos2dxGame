package game.ui.uibackpack.watch 
{
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class Watch_Self_NameValue extends Watch_NameValue 
	{
		private var m_mark:Panel;
		public function Watch_Self_NameValue(parent:DisplayObjectContainer = null) 
		{
			super(parent);
			m_mark = new Panel(this,0,2);
			m_mark.recycleSkins = true;
		}
		override public function set(name:String, value:uint, compareValue:uint=uint.MAX_VALUE):void
		{
			super.set(name, value);
			if (compareValue == uint.MAX_VALUE || compareValue == value)
			{
				m_mark.visible = false;
			}
			else
			{
				m_mark.visible = true;
				var str:String;
				if (compareValue < value)
				{
					str = "commoncontrol/panel/compare_up.png";
				}
				else
				{
					str = "commoncontrol/panel/compare_down.png";
				}
				m_mark.setPanelImageSkin(str);
				m_mark.x = m_value.x + m_value.width + 10;
			}
		}
	}

}