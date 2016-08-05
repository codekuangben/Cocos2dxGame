package modulecommon.appcontrol.menu 
{
	import com.bit101.components.TextNoScroll;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class MenuItemTextArea extends MenuItemBase 
	{
		protected var m_tf:TextNoScroll;
		public function MenuItemTextArea(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			super(parent, xpos, ypos);
			m_tf = new TextNoScroll();
			m_tf.y = 2;
			m_tf.x = 4;
			this.addChild(m_tf);
			this.mouseEnabled = false;
			m_tf.setCSS("body", { leading: 4, color: "#fbdda2", fontSize: 12, letterSpacing:1} );
			this.width = UIMenuEx.WIDTH_Control;
			m_tf.width = UIMenuEx.WIDTH_Control;
		}
		
		public function set htmlText(str:String):void
		{
			m_tf.htmlText = "<body>"+str+"</body>";
			this.height = m_tf.y+m_tf.height+2;
		}
		
	}

}