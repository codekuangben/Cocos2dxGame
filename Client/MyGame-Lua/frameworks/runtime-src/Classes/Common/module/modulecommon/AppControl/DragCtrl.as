package modulecommon.appcontrol 
{
	//import com.bit101.components.Component;
	import com.dnd.DraggingImage;

	import modulecommon.GkContext;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class DragCtrl extends ImageDrawCtrl implements DraggingImage 
	{		
		protected var m_bDrag:Boolean;		
		public function DragCtrl(gk:GkContext) 
		{
			super(gk);			
			
		}		
		public function onDrag():void
		{
			m_bDrag = true;
			this.invalidate();
		}
		public function onDrop():void
		{
			m_bDrag = false;
			this.invalidate();
		}
		public function getDisplay():DisplayObject
		{
			return null;
		}
		/**
		 * Paints the image for accept state of dragging.(means drop allowed)
		 */
		public function switchToAcceptImage():void
		{
		}
		
		/**
		 * Paints the image for reject state of dragging.(means drop not allowed)
		 */
		public function switchToRejectImage():void
		{
		}
	}

}