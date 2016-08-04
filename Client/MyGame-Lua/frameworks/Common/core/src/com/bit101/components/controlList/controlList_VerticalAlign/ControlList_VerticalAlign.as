package com.bit101.components.controlList.controlList_VerticalAlign 
{
	import com.bit101.components.controlList.ControlListBase;
	import com.bit101.components.controlList.CtrolComponentBase;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Quadratic;
	import flash.geom.Rectangle;
	import org.ffilmation.engine.helpers.fUtil;
	/**
	 * ...
	 * @author 
	 * 目标：
	 * 1. 这是包含子控件，并对子控件进行排版的类
	 * 2. 排版方式，先在竖向排版，然后横向排版
	 * 3. 每个子控件的高度相同，宽度相同
	 * 4. 不会出现滚动条；点击翻页按钮触发翻页。
	 * 5. 此控件的最显著特点是，翻页是以动画形式进行的
	 * 6. ControlList_VerticalAlign_Param的2个成员变量m_marginLeft和m_marginRight是不需要设置的
	 */
	public class ControlList_VerticalAlign extends ControlListBase 
	{
		private var m_aligParam:ControlList_VerticalAlign_Param;
		private var m_DataTotalWidth:int;
		
		private var m_gtWeen:GTween;
		private var m_terminalPoint:Number;
		private var m_speed:Number = 100;
		public function ControlList_VerticalAlign(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			
			m_gtWeen = new GTween(this);
			m_gtWeen.repeatCount = 1;
			m_gtWeen.ease = Quadratic.easeOut;
			m_gtWeen.paused = true;
			m_terminalPoint = 0;
		}
		public function setDatas(datas:Array):void
		{			
			var numDatas:int = datas.length;			
			var ctrol:CtrolComponentBase;
			var i:int;
			var oldNumCtrol:int = m_controls.length;	
						
			for (i = 0; i < numDatas; i++)
			{
				
				if ( i < m_controls.length)
				{
					ctrol = m_controls[i];
					ctrol.onNotSelected();
				}
				else
				{
					ctrol = new m_aligParam.m_class(m_aligParam.m_dataParam);
					m_container.addChild(ctrol);
					m_controls.push(ctrol);
					ctrol.addEventListener(MouseEvent.CLICK, onItemClik);
				}
				ctrol.index = i;
				ctrol.setData(datas[i]);
			}
			
			if (m_controls.length > numDatas)
			{
				for (i = numDatas; i < m_controls.length; i++)
				{
					ctrol = m_controls[i];
					ctrol.dispose();
					m_container.removeChild(ctrol);
				}
				m_controls.splice(numDatas, m_controls.length - numDatas);
			}	
			
			adjustAllPos();
			m_iSelectedIndex = -1;
		}
		//如果index == -1表示插入最后
		public function insertData(index:int, data:Object):void
		{
			if (index == -1 || index > m_controls.length)
			{
				index = m_controls.length;
			}			
			
			var ctrol:CtrolComponentBase = new m_aligParam.m_class(m_aligParam.m_dataParam);
			ctrol.setData(data);
			ctrol.setSize(m_aligParam.m_width, m_aligParam.m_height);
			ctrol.addEventListener(MouseEvent.CLICK, onItemClik);
			
			m_container.addChild(ctrol);
			m_controls.splice(index, 0, ctrol);
			
			adjustAllPos();
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
				if (d == m_aligParam.m_numRow)
				{			
					top = m_aligParam.m_marginTop;
					left += (m_aligParam.m_width + m_aligParam.m_intervalH);
					d = 0;
				}					
				ctrol = m_controls[i];
				ctrol.index = i;			
				ctrol.setPos(left, top);				
				d++;
				if (d != m_aligParam.m_numRow)
				{
					top += (m_aligParam.m_height + m_aligParam.m_intervalV);
				}						
			}
			
			if (d > 0)
			{
				left += m_aligParam.m_width;
			}			
			m_DataTotalWidth = left + m_aligParam.m_marginRight;		
			if (m_scrollPos > maxScrollPos)
			{
				m_scrollPos = maxScrollPos;
			}
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
		public function toNextLine():void
		{
			var newPos:Number = m_scrollPos + m_aligParam.m_lineSize;
			if (newPos > maxScrollPos)
			{
				newPos = maxScrollPos;
			}
			toNewPos(newPos);
		}
		//返回总的页数
		public function get pageCount():int
		{
			return (m_DataTotalWidth + pageSize - 1) / pageSize;
		}
		public function get pageSize():int
		{
			return this.width;
		}
		public function get terminalPoint():Number
		{
			return m_terminalPoint;
		}
		public function toNewPos(pos:Number):void
		{
			if (pos == m_scrollPos)
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
			
			m_terminalPoint = pos;
		}
		public function set scrollPos(pos:Number):void
		{
			m_scrollPos = pos;
			var __max:Number = maxScrollPos;
			if (m_scrollPos < 0)
			{
				m_scrollPos = 0;
			}
			else if (m_scrollPos > __max)
			{
				m_scrollPos = __max;
			}

			updatePos();			
		}
		
		override public function canToPriLine():Boolean
		{
			var pos:Number;
			if (m_gtWeen.paused)
			{
				pos = m_scrollPos;
			}
			else
			{
				pos = m_terminalPoint;
			}
			return pos > 0;
		}
		
		public function canToNextLine():Boolean
		{
			var pos:Number;
			if (m_gtWeen.paused)
			{
				pos = m_scrollPos;
			}
			else
			{
				pos = m_terminalPoint;
			}
			return pos < maxScrollPos;
		}
		
		public function isAni():Boolean
		{
			return m_gtWeen.paused == false;
		}
		override protected function updatePos():void
		{			
			m_container.x = - m_scrollPos;
		}
		public function get maxScrollPos():Number
		{
			var ret:Number;
			if (m_DataTotalWidth <= this.width)
			{
				ret = 0;
			}
			else
			{
				ret = m_DataTotalWidth - this.width;
			}
			return ret;
		}
		public function setParam(param:ControlList_VerticalAlign_Param):void
		{
			m_aligParam = new ControlList_VerticalAlign_Param();
			param.copy(m_aligParam);
			fUtil.assert(m_aligParam.m_intervalH % 2==0, "m_intervalV必须是偶数");
			m_aligParam.m_marginLeft = m_aligParam.m_intervalH / 2;
			m_aligParam.m_marginRight = m_aligParam.m_marginLeft;
			
			var midValue:uint = 0;
			
			if (m_aligParam.m_numColum >= 2)
			{
				midValue = (m_aligParam.m_numColum - 1) * m_aligParam.m_intervalH;
			}
			else
			{
				midValue = 0;
			}
			midValue = midValue + m_aligParam.m_width * m_aligParam.m_numColum + m_aligParam.m_marginLeft + m_aligParam.m_marginRight;
			
			this.width = midValue;
			m_aligParam.m_lineSize = midValue;
			if (m_aligParam.m_numRow >= 2)
			{
				midValue = (m_aligParam.m_numRow - 1) * m_aligParam.m_intervalV;
			}
			else
			{
				midValue = 0;
			}
			midValue = midValue + m_aligParam.m_height * m_aligParam.m_numRow + m_aligParam.m_marginTop + m_aligParam.m_marginBottom;
			
			this.height = midValue;
			
			var rect:Rectangle = new Rectangle(0, 0, this.width, this.height);
			this.scrollRect = rect;
		}
		override public function dispose():void 
		{
			m_gtWeen.target = null;
			m_gtWeen.paused = true;
			m_gtWeen.onComplete = null;	
			super.dispose();
		}
		
		public function set speed(s:Number):void
		{
			m_speed = s;
		}
	}

}