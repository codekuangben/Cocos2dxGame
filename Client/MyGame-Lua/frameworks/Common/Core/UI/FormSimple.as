package ui
{
	import com.bit101.components.Window;
	import common.Context;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author
	 */
	public class FormSimple extends Window
	{
		protected var m_context:Context;
		
		public function FormSimple(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		
		}
		
		public function setContext(con:Context):void
		{
			m_context = con;
		}
		public function onStageReSize():void
		{
			adjustPosWithAlign();
		}
		protected function computeAdjustPosWithAlign():Point
		{
			var ret:Point = new Point();
			var widthStage:int = m_context.m_config.m_curWidth;
			var heightStage:int = m_context.m_config.m_curHeight;
			if (alignVertial == CENTER)
			{
				ret.y = (heightStage - this.height) / 2;
			}
			else if (alignVertial == TOP)
			{
				ret.y = this._marginTop;
			}
			else
			{
				ret.y = heightStage - this.height - this._marginBottom;
			}
			
			if (alignHorizontal == CENTER)
			{
				ret.x = (widthStage - this.width) / 2;
			}
			else if (alignHorizontal == LEFT)
			{
				ret.x = _marginLeft;
			}
			else
			{
				ret.x = widthStage - this.width - _marginRight;
			}
			return ret;
		}
		
		public function adjustPosWithAlign():void
		{
			var pos:Point = computeAdjustPosWithAlign();
			this.x = pos.x;
			this.y = pos.y;			
		}
		public function show():void
		{			
			this.m_context.m_uiManagerSimple.showForm(this.id);			
		}
		public function onShow():void
		{
			
		}
		public function hide():void
		{
			this.m_context.m_uiManagerSimple.hideForm(this.id);		
		}
		public function onHide():void
		{
			
		}
		public function exit():void
		{
			if (_exitMode == EXITMODE_DESTORY)
			{
				this.m_context.m_uiManagerSimple.destroyForm(this.id);
			}
			else
			{
				this.m_context.m_uiManagerSimple.hideForm(this.id);
			}
		}
	
	}

}