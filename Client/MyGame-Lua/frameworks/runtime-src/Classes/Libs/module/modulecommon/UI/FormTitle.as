package modulecommon.ui 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.util.UtilFont;
	import flash.events.Event;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class FormTitle extends Form 
	{
		protected var _title:String;	
		protected var _titleLabel:Label;
		public function FormTitle() 
		{
			super();
		}
		
		override protected function addChildren():void
		{
			super.addChildren();		
			this.addEventListener(Event.RESIZE, onResize);
			_titleLabel = new Label(this);	

			//_titleLabel.setBold(true);
			_titleLabel.setFontSize(24);
			_titleLabel.setFontName(UtilFont.NAME_HuawenXinwei);
			_titleLabel.setLetterSpacing(6);			
			_titleLabel.setSize(120, 25);	
			_titleLabel.autoSize = false;
			_titleLabel.align = Component.CENTER;
			
		}		
		
		protected function onResize(event:Event):void
        {
			_titleLabel.x = (this.width - _titleLabel.width) / 2;
        }
		/**
		 * Gets / sets the title shown in the title bar.
		 */		
		public function setTitleY(yPos:int):void
		{
			_titleLabel.y = yPos
		}
		public function set title(t:String):void
		{
			if (t.length > 4)
			{
				_titleLabel.setLetterSpacing(4);
			}
			_title = t;
			
			_titleLabel.text = _title;
		}
		public function get title():String
		{
			return _title;
		}
		
	}

}