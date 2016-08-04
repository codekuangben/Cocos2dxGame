package game.ui.uichat 
{
	import com.bit101.components.Component;
	import com.bit101.components.VScrollBar;
	import com.riaidea.text.RichTextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class RichTextFieldScroll extends Component 
	{
		private var _scrollbar:VScrollBar;
		private var _rtf:RichTextField;
		
		public function RichTextFieldScroll()
		{
			super();
		}
		override protected function addChildren():void
		{			
			_scrollbar = new VScrollBar(this, 0, 0, onScroll);
			
			_rtf = new RichTextField();			
			_rtf.html = true;
			_rtf.type = RichTextField.DYNAMIC;
			_rtf.autoScroll = true;
			addChild(_rtf);
			
			_rtf.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			_scrollbar.height = h;
			_scrollbar.pageSize = Math.ceil(this.height / 20);
			
			_rtf.x = _scrollbar.width;
			_rtf.setSize(w - _scrollbar.width,h);
		}
		public function clear():void
		{
			_rtf.clear();
		}
		
		public function append(newText:String, newSprites:Array = null):void
		{
			_rtf.append(newText, newSprites);
			_scrollbar.numTotalData = _rtf.textfield.numLines;
		}
		
		public function toBottom():void
		{
			_scrollbar.value = _scrollbar.maximum;
			_rtf.scrollV = _scrollbar.value + 1;
		}
		protected function onMouseWheel(event:MouseEvent):void
		{
			_scrollbar.value -= event.delta;
            _rtf.scrollV = _scrollbar.value + 1;
		}

		protected function onScroll(event:Event):void
		{
            _rtf.scrollV = _scrollbar.value + 1;
		}
	}

}