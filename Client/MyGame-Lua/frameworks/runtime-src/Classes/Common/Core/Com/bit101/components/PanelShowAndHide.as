package com.bit101.components 
{
	/**
	 * ...
	 * @author 
	 * 可以自我控制显示与隐藏
	 */
	import flash.display.DisplayObjectContainer;
	public class PanelShowAndHide extends PanelContainer 
	{
		protected var m_parent:DisplayObjectContainer;
		public function PanelShowAndHide(parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number =  0) 
		{
			m_parent = parent;
			setPos(xpos, ypos);
		}
		public function show():void
		{
			if (this.parent != m_parent)
			{
				m_parent.addChild(this);
				onShow();
			}
		}
		
		public function onShow():void
		{
			
		}
		public function onHide():void
		{
			
		}
		
		override public function isVisible():Boolean 
		{
			return this.parent != null;
		}
		public function hide():void
		{
			if (this.parent)
			{
				onHide();
				this.parent.removeChild(this);				
			}
		}
		/*desc: 当对象没有父亲节点时，调用dispose。
		 */ 
		public function disposeWhenParentEqualNull():void
		{
			if (this.parent == null)
			{
				this.dispose();
			}
		}
	}

}