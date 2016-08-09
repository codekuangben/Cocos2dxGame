package com.bit101.components 
{
	import com.ani.AniPosition;
	import com.ani.AniPropertys;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AniShowAndHideAfterMove extends PanelShowAndHide 
	{
		private var m_showX:Number;	//(m_showX, m_showY)：显示状态下的位置
		private var m_showY:Number;		
		private var m_hideX:Number;	//(m_hideX, m_hideY)：显示状态下的位置
		private var m_hideY:Number;
		private var m_ani:AniPropertys;
			
		public function AniShowAndHideAfterMove(parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_ani = new AniPropertys();
			m_ani.sprite = this;	
			m_ani.useFrames = true;
		}
		/*
		 * duration：移动所需要的时间(单位: 帧)
		 */ 
		public function setParam(showX:Number, showY:Number, hideX:Number, hideY:Number, duration:Number):void
		{
			m_showX = showX;
			m_showY = showY;
			m_hideX = hideX;
			m_hideY = hideY;
			m_ani.duration = duration;
		}
		
		public function beginToShow():void
		{
			if (isVisible() == false)
			{
				this.show();
			}
			m_ani.resetValues( { x:m_showX, y:m_showY } );
			m_ani.onEnd = null;
			m_ani.begin();
		}
		
		public function beginToHide():void
		{
			m_ani.resetValues( { x:m_hideX, y:m_hideY } );
			m_ani.onEnd = onHideAniEnd;
			m_ani.begin();
		}
		private function onHideAniEnd():void
		{
			this.hide();
		}
		override public function dispose():void 
		{
			m_ani.dispose();
			super.dispose();
		}
		
		public function immedToShow():void
		{
			if (isVisible() == false)
			{
				this.show();
			}
			setPos(m_showX, m_showY);
		}
		
		public function immedToHide():void
		{
			setPos(m_hideX, m_hideY);
			onHideAniEnd();
		}
		
		
		
	}

}