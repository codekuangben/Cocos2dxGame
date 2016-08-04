package com.bit101.components.pageturn 
{	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import com.bit101.components.PushButton;
	/**
	 * ...
	 * @author 
	 * 这是翻页按钮控件, 2个按钮(向前翻页按钮盒向后)之间没有显示页数。
	 */
	public class PageTurn2 extends PageTurnBase 
	{
		
		public function PageTurn2(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
		}
		//
		public function setBtnPos(xPre:Number, yPre:Number, xNext:Number, yNext:Number):void
		{
			m_preBtn.setPos(xPre, yPre);
			m_nextBtn.setPos(xNext, yNext);			
		}
		
		override public function onPageBtnClick(e:MouseEvent):void
		{
			var tag:int = (e.currentTarget as PushButton).tag;			
			m_funOnPageBtnClick(tag == 0 ? true : false);
		}
		public function setTurnState(canPrePage:Boolean, canNextPage:Boolean):void
		{
			if (canPrePage)
			{
				m_preBtn.enabled = true;
			}
			else
			{
				m_preBtn.enabled = false;
			}
			
			if (canNextPage)
			{
				m_nextBtn.enabled = true;
			}
			else
			{
				m_nextBtn.enabled = false;
			}
			
		}
	}

}