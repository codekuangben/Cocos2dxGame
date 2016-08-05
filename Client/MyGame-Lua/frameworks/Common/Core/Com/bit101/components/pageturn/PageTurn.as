package com.bit101.components.pageturn
{
	/**
	 * ...
	 * @author
	 * 这是翻页按钮控件, 2个按钮(向前翻页按钮盒向后)之间显示页数。
	 */
	import com.bit101.components.Label;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import com.bit101.components.Component;
	
	public class PageTurn extends PageTurnBase
	{
		protected var m_pageLabel:Label;
		private var m_uPageCount:int;
		private var m_uCurPage:int;
		
		
		public function PageTurn(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);			
			m_pageLabel = new Label(this);
			m_pageLabel.setBold(true);
			m_pageLabel.setLetterSpacing(3);
			m_pageLabel.align = Component.CENTER;		
		}		
		protected function showCtrls():void
		{
			if (m_preBtn.parent == null)
			{
				this.addChild(m_preBtn);
				this.addChild(m_nextBtn);
				this.addChild(m_pageLabel);
			}
		}
		
		protected function hideCtrls():void
		{
			if (m_preBtn && m_preBtn.parent)
			{
				this.removeChild(m_preBtn);
				this.removeChild(m_nextBtn);
				this.removeChild(m_pageLabel);
			}
		}
		
		//wBtn:按钮的宽度，用于计算m_pageLabel.x的值
		public function setBtnPos(xPre:Number, yPre:Number, xNext:Number, yNext:Number, yPage:Number, wBtn:Number):void
		{
			m_preBtn.setPos(xPre, yPre);
			m_nextBtn.setPos(xNext, yNext);
			m_pageLabel.setPos((xNext - xPre+wBtn)/2, yPage);
		}
		
		public function set pageCount(n:int):void
		{
			m_uPageCount = n;
			if (m_uPageCount > 1)
			{
				showCtrls();
			}
			else
			{
				hideCtrls();
			}
			updateLabel();
		}
		
		public function get pageCount():int
		{
			return m_uPageCount;
		}
		
		public function set curPage(n:int):void
		{
			m_uCurPage = n;
			updateLabel();
		}
		
		public function get curPage():int
		{
			return m_uCurPage;
		}
		
		override public function onPageBtnClick(e:MouseEvent):void
		{
			if (m_funNotRespondClick!=null)
			{
				if (m_funNotRespondClick())
				{
					return;
				}
			}
			var tag:int = (e.currentTarget as Component).tag;
			
			if (tag == 0)
			{
				m_uCurPage--;
			}
			else
			{
				m_uCurPage++;
			}
			updateLabel();
			m_funOnPageBtnClick(tag == 0 ? true : false);
		}
		
		public function updateLabel():void
		{
			if (m_preBtn == null)
			{
				return;
			}
			
			if (m_uCurPage == 0)
			{
				m_preBtn.enabled = false;
			}
			else
			{
				m_preBtn.enabled = true;
			}
			
			if (m_uCurPage + 1 >= m_uPageCount)
			{
				m_nextBtn.enabled = false;
			}
			else
			{
				m_nextBtn.enabled = true;
			}
			var str:String;
			str = (m_uCurPage+1).toString() + "/" + m_uPageCount.toString();
			m_pageLabel.text = str;
		}
	
	}

}