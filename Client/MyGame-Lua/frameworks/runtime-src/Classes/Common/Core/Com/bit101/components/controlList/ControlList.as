package com.bit101.components.controlList
{
	//import com.bit101.components.Panel;
	//import com.bit101.components.PanelContainer;
	import com.bit101.components.VScrollBar;
	import org.ffilmation.engine.helpers.fUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...要求每个子控件的宽相等,高相等
	 * @author zouzhiqiang
	 */
	public class ControlList extends ControlListBase
	{		
		private var m_aligParam:ControlAlignmentParam;		
		private var m_scrollbar:VScrollBar;
		
		private var m_DataTotalHeight:int;	
		private var m_bItemSelectable:Boolean;
		
		public function ControlList(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);		
		}
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

			var item:CtrolComponentBase;
			for each(item in m_controls)
			{
				item.removeEventListener(MouseEvent.CLICK, onItemClik);
			}
			m_aligParam.m_class = null;
			super.dispose();
		}
		
		public function setDatas(datas:Array, param:Object = null):void
		{			
			m_datas = datas;
			if (param == null)
			{
				param = m_aligParam.m_dataParam;
			}
			var ctrol:CtrolComponentBase;
			var i:int;
			var d:int = 0;
			var left:int = m_aligParam.m_marginLeft;
			var top:int = m_aligParam.m_marginTop;
			var dataCount:int = datas.length;
			for (i = 0; i < dataCount; i++)
			{
				if (d == m_aligParam.m_numColumn)
				{
					left = m_aligParam.m_marginLeft;
					top += (m_aligParam.m_height + m_aligParam.m_intervalV);
					d = 0;
				}
								
				if ( i < m_controls.length)
				{
					ctrol = m_controls[i];
					ctrol.onNotSelected();
				}
				else
				{
					ctrol = new m_aligParam.m_class(param);
					m_container.addChild(ctrol);
					m_controls.push(ctrol);
					ctrol.addEventListener(MouseEvent.CLICK, onItemClik);
				}
				ctrol.index = i;
				ctrol.setData(datas[i]);
				ctrol.setPos(left, top);				
				d++;
				if (d != m_aligParam.m_numColumn)
				{
					left += (m_aligParam.m_width + m_aligParam.m_intervalH);
				}						
			}
			
			if (d > 0)
			{
				top += m_aligParam.m_height;
			}
			
			if (m_controls.length > dataCount)
			{
				for (i = dataCount; i < m_controls.length; i++)
				{
					ctrol = m_controls[i];
					ctrol.dispose();
					m_container.removeChild(ctrol);
				}
				m_controls.splice(dataCount, m_controls.length - dataCount);
			}
			
			m_DataTotalHeight = top + m_aligParam.m_marginBottom;
			
			adjustAllPos();
			if (m_scrollPos > maxScrollPos)
			{
				scrollPos = maxScrollPos;
			}
			m_iSelectedIndex = -1;
			if (m_bInitSubCtrlOnShow)
			{
				processCtrlFirstShow();
			}
		}		
		
		override protected function adjustAllPos():void
		{
			var ctrol:CtrolComponentBase;			
			var left:int = m_aligParam.m_marginLeft;
			var top:int = m_aligParam.m_marginTop;
			var i:int;
			var d:int = 0;
			var n:int = m_controls.length;
			for (i = 0; i < n; i++)
			{
				if (d == m_aligParam.m_numColumn)
				{
					left = m_aligParam.m_marginLeft;
					top += (m_aligParam.m_height + m_aligParam.m_intervalV);
					d = 0;
				}						
				ctrol = m_controls[i];
				ctrol.index = i;			
				ctrol.setPos(left, top);				
				d++;
				if (d != m_aligParam.m_numColumn)
				{
					left += (m_aligParam.m_width + m_aligParam.m_intervalH);
				}						
			}
			
			if (d > 0)
			{
				top += m_aligParam.m_height;
			}			
			m_DataTotalHeight = top + m_aligParam.m_marginBottom;
			if (m_aligParam.m_bAutoHeight)
			{
				this.height = m_DataTotalHeight;
				var rect:Rectangle = new Rectangle(0, 0, this.width, this.height);
				this.scrollRect = rect;
			}
			
			
			if (m_scrollPos > maxScrollPos)
			{
				scrollPos = maxScrollPos; 
			}
			if (m_scrollbar != null)
			{
				m_scrollbar.numTotalData = m_DataTotalHeight;				
				m_scrollbar.value = scrollPos;
			}
		}		

		//如果index == -1表示插入最后
		public function insertData(index:int, data:Object,  param:Object = null):void
		{
			if (index == -1 || index > m_controls.length)
			{
				index = m_controls.length;
			}
			if (param == null)
			{
				param = m_aligParam.m_dataParam;
			}
			
			var ctrol:CtrolComponent = new m_aligParam.m_class(param);
			ctrol.setData(data);
			ctrol.width = m_aligParam.m_width;
			ctrol.height = m_aligParam.m_height;			
			
			m_container.addChild(ctrol);
			m_controls.splice(index, 0, ctrol);
			if (m_bInitSubCtrlOnShow)
			{
				ctrol.onFirstShow();
			}
			adjustAllPos();
			
		}
		protected function onScroll(event:Event):void
		{
			updateOnScrollChange();		
		}
		
		protected function onMouseWheel(event:MouseEvent):void
		{
			m_scrollbar.value -= event.delta*10;	
			updateOnScrollChange();
		}
		
		protected function updateOnScrollChange():void
		{
			scrollPos = m_scrollbar.value;
		}
		
		public function toPreLine():void
		{
			var newPos:Number = m_scrollPos - m_aligParam.m_lineSize;
			if (newPos < 0)
			{
				newPos = 0;
			}
			toNewPos(newPos);
		}
		
		public function toNewPos(pos:Number):void
		{
			/*if (pos == m_scrollPos)
			{
				return;
			}
			if (m_gtWeen.paused == false)
			{
				return;
			}
			m_gtWeen.setValue("scrollPos", pos);
			m_gtWeen.init();
			m_gtWeen.duration = Math.abs(pos - m_scrollPos) / m_speed;
			m_gtWeen.paused = false;
			
			m_terminalPoint = pos;*/
			scrollPos = pos;
		}
		
		public function toNextLine():void
		{
			var newPos:Number = m_scrollPos + m_aligParam.m_lineSize;
			if (newPos > maxScrollPos)
			{
				newPos = maxScrollPos;
			}
			toNewPos(newPos);
		}
		
		//直接显示第line行。zero-based
		public function toLine(line:int):void
		{
			var newPos:Number = m_aligParam.m_lineSize * line;
			toNewPos(newPos);
		}
		
		public function get maxScrollPos():Number
		{
			var ret:Number;
			if (m_DataTotalHeight <= m_aligParam.m_parentHeight)
			{
				ret = 0;
			}
			else
			{
				if(ControlAlignmentParamBase.ScrollType_LastPageFull == m_aligParam.m_scrollType)
				{
					ret = m_DataTotalHeight - m_aligParam.m_parentHeight;
				}
				else if(ControlAlignmentParamBase.ScrollType_Normal == m_aligParam.m_scrollType)
				{
					if (m_DataTotalHeight == 0)
					{
						ret = 0;
					}
					else
					{
						ret = Math.floor((m_DataTotalHeight -1) / m_aligParam.m_parentHeight)*m_aligParam.m_parentHeight;
					}
				}
			}
			return ret;
		}

		public function set scrollPos(pos:Number):void
		{
			m_scrollPos = pos;
			
			if (m_scrollPos < 0)
			{
				m_scrollPos = 0;
			}
			else if (m_scrollPos > maxScrollPos)
			{
				m_scrollPos = maxScrollPos;
			}
			updatePos();
		}
		
		//返回当前是第几页。第一页返回0；依次类推。当以翻页方式滚动时，这个函数才有意义
		public function get curPage():int
		{
			return m_scrollPos / pageSize;
		}
		
		public function get pageSize():int
		{
			return this.height;
		}
		
		//返回总的页数
		public function get pageCount():int
		{
			return (m_DataTotalHeight + pageSize - 1) / pageSize;
		}
		
		public function canToNextLine():Boolean
		{
			return m_scrollPos < maxScrollPos;
		}
				
		public function setParamForPageMode(param:ControlAlignmentParam_ForPageMode):void
		{
			if (m_aligParam == null)
			{
				m_aligParam = new ControlAlignmentParam();
			}
			fUtil.assert(param.m_intervalV % 2==0, "m_intervalV必须是偶数");
			m_aligParam.m_class = param.m_class;
			m_aligParam.m_width = param.m_width;
			m_aligParam.m_height = param.m_height;
			m_aligParam.m_intervalH = param.m_intervalH;
			m_aligParam.m_intervalV = param.m_intervalV;
			m_aligParam.m_marginBottom = param.m_intervalV / 2;
			m_aligParam.m_marginLeft = param.m_marginLeft;
			m_aligParam.m_marginRight = param.m_marginRight;
			m_aligParam.m_marginTop = m_aligParam.m_marginBottom;
			m_aligParam.m_numColumn = param.m_numColumn;			
			m_aligParam.m_lineSize = m_aligParam.m_marginBottom + m_aligParam.m_marginTop + (param.m_numRow - 1) * m_aligParam.m_intervalV + param.m_numRow * m_aligParam.m_height;
			m_aligParam.m_parentHeight = m_aligParam.m_lineSize;
			m_aligParam.m_needScroll = false;
			m_aligParam.m_scrollType = 1;
			m_aligParam.m_dataParam = param.m_dataParam;
			m_aligParam.m_bAutoHeight = false;
			
			setParamEx();
		}
		public function setParam(param:ControlAlignmentParam):void
		{
			if (m_aligParam == null)
			{
				m_aligParam = new ControlAlignmentParam();
			}
			
			m_aligParam.m_class = param.m_class;
			m_aligParam.m_width = param.m_width;
			m_aligParam.m_height = param.m_height;
			m_aligParam.m_intervalH = param.m_intervalH;
			m_aligParam.m_intervalV = param.m_intervalV;
			m_aligParam.m_marginBottom = param.m_marginBottom;
			m_aligParam.m_marginLeft = param.m_marginLeft;
			m_aligParam.m_marginRight = param.m_marginRight;
			m_aligParam.m_marginTop = param.m_marginTop;
			m_aligParam.m_numColumn = param.m_numColumn;			
			m_aligParam.m_lineSize = param.m_lineSize;
			m_aligParam.m_parentHeight = param.m_parentHeight;
			m_aligParam.m_needScroll = param.m_needScroll;
			m_aligParam.m_scrollType = param.m_scrollType;
			m_aligParam.m_dataParam = param.m_dataParam;
			m_aligParam.m_bAutoHeight = param.m_bAutoHeight;			
			
			setParamEx();
		}
		
		private function setParamEx():void
		{
			var midValue:uint = 0;			
			this.height = m_aligParam.m_parentHeight;
			
			if (m_aligParam.m_numColumn >= 2)
			{
				midValue = (m_aligParam.m_numColumn - 1) * m_aligParam.m_intervalH;
			}
			else
			{
				midValue = 0;
			}
			midValue = midValue + m_aligParam.m_width * m_aligParam.m_numColumn + m_aligParam.m_marginLeft + m_aligParam.m_marginRight;
			
			this.width = midValue;
			if (m_aligParam.m_needScroll)
			{ 
				midValue += 18;
				this.width = midValue;
				m_scrollbar = new VScrollBar(this, 0, 0, onScroll);
				m_scrollbar.setPos(this.width - m_scrollbar.width, 0);
				m_scrollbar.height = this.height;
				m_scrollbar.pageSize = this.pageSize;
				m_scrollbar.lineSize = m_aligParam.m_lineSize;
				addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
			var rect:Rectangle = new Rectangle(0, 0, this.width, this.height);
			this.scrollRect = rect;
		}

		public function set itemSelectable(bFlag:Boolean):void
		{
			m_bItemSelectable = bFlag;
		}
		
		override protected function processCtrlFirstShow():void
		{
			var ctrl:CtrolComponentBase;
			for each(ctrl in m_controls)
			{
				if (ctrl.bHasShow)
				{
					continue;
				}
				
				if (ctrl.y - m_scrollPos<this._height && ctrl.y+_height-m_scrollPos>0)				
				{
					ctrl.onFirstShow();
				}
				
			}			
			
		}
	}
}