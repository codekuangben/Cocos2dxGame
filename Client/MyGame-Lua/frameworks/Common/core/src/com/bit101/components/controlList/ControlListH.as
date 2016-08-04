package com.bit101.components.controlList
{
	//import com.bit101.components.Panel;
	//import com.bit101.components.PanelContainer;
	//import com.bit101.components.VScrollBar;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Quadratic;
	
	import flash.display.DisplayObjectContainer;
	//import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 * 目标:
	   1. 只有1行子控件
	   2. 可以有任意列数的子控件
	   3. 不同的子控件，其宽度相同，其高度可不同
	 */
	public class ControlListH extends ControlListBase
	{		
		private var m_aligParam:ControlHAlignmentParam;		
		private var m_dataWidth:int;		
		
		
		private var m_gtWeen:GTween;
		private var m_terminalPoint:Number;
		private var m_speed:Number = 100;
		
		private var m_gtMoveWeen:GTween;
		private var m_moveDistance:Number;
		private var m_moveList:Vector.<CtrolHComponent>;
		
		public function ControlListH(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
						
			m_gtWeen = new GTween(this);
			m_gtWeen.repeatCount = 1;
			m_gtWeen.ease = Quadratic.easeOut;
			m_gtWeen.paused = true;
			
			m_terminalPoint = 0;
		}
		
		public function setDatas(datas:Array, param:Object = null):void
		{
			//releaseAllCtrols();
			if (param == null)
			{
				param = m_aligParam.m_dataParam;
			}
			
			var numDatas:int = datas.length;			
			var ctrol:CtrolHComponent;
			var i:int;
			var oldNumCtrol:int = m_controls.length;
			var left:int = m_aligParam.m_marginLeft;
			
			for (i = 0; i < numDatas; i++)
			{
				if (i < oldNumCtrol)
				{
					ctrol = m_controls[i]as CtrolHComponent;
				}
				else
				{
					ctrol = new m_aligParam.m_class(param);
					ctrol.height = m_aligParam.m_height;
					ctrol.y = m_aligParam.m_marginTop;
					ctrol.addEventListener(MouseEvent.CLICK, onItemClik);
					m_container.addChild(ctrol);
					m_controls.push(ctrol);
				}
				ctrol.x = left;
				ctrol.setData(datas[i]);
				
				if (i == numDatas - 1)
				{
					left += m_controls[i].width;
				}
				else  
				{
					left += (m_controls[i].width + m_aligParam.m_intervalH);
				}
			}
			
			m_dataWidth = left + m_aligParam.m_marginRight;
			
			if (oldNumCtrol > numDatas)
			{				
				var item:CtrolHComponent;
				i = oldNumCtrol - 1;
				while (i >= numDatas)
				{
					item = m_controls.pop() as CtrolHComponent;
					item.removeEventListener(MouseEvent.CLICK, onItemClik);
					item.dispose();
					this.m_container.removeChild(item);
					i--;
				}	
			}			
			m_iSelectedIndex = -1;
			updatePos();
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
			var ctrol:CtrolHComponent = new m_aligParam.m_class(param);
			ctrol.setData(data);
			ctrol.height = m_aligParam.m_height;
			ctrol.y = m_aligParam.m_marginTop;
			ctrol.addEventListener(MouseEvent.CLICK, onItemClik);
			m_container.addChild(ctrol);					
			m_controls.splice(index, 0, ctrol);
			
			adjustAllPos();
		}
		override public function deleteData(index:int):void
		{
			if (index >= m_controls.length)
			{
				return;
			}
			
			var i:int = 0;
			var delCtrol:CtrolHComponent = m_controls[index] as CtrolHComponent;
			if (index < m_controls.length - 1)
			{
				m_moveDistance = m_controls[index + 1].x - delCtrol.x;
				if (m_moveList == null)
				{
					m_moveList = new Vector.<CtrolHComponent>();
				}
				m_moveList.length = 0;
				for (i = index + 1; i < m_controls.length; i++)
				{
					m_moveList.push(m_controls[i]);
					(m_controls[i] as CtrolHComponent).m_relativeX = m_controls[i].x - m_moveDistance;
				}
				
				if (m_gtMoveWeen == null)
				{
					m_gtMoveWeen = new GTween(this);					
				}
				m_gtMoveWeen.duration = m_moveDistance / m_speed;
				m_gtMoveWeen.setValue("moveDistance", 0);
				m_gtMoveWeen.paused = false;
			}
			m_controls.splice(index, 1);
			m_dataWidth = computeDataWidth();
			this.m_container.removeChild(delCtrol);
			if (m_scrollPos > maxScrollPos)
			{
				scrollPos = maxScrollPos;
			}
		}
		
		override protected function adjustAllPos():void
		{
			var i:int = 0;
			var count:int = m_controls.length;
			var left:int = m_aligParam.m_marginLeft;
			if ( m_controls.length > 0)
			{
				m_controls[0].x = left;
				left += m_controls[0].width;
			}
			for (i = 1; i < count; i++)
			{
				left += m_aligParam.m_intervalH;
				m_controls[i].x = left;
				left += m_controls[i].width;
			}
			
			m_dataWidth = left + m_aligParam.m_marginRight;
			if (m_scrollPos > maxScrollPos)
			{
				scrollPos = maxScrollPos; 
			}
		}
		protected function computeDataWidth():int
		{
			var i:int = 0;
			var ret:int = m_aligParam.m_marginLeft;
			if ( m_controls.length > 0)
			{
				ret += m_controls[0].width;
			}
			for (i = 1; i < m_controls.length; i++)
			{
				ret += m_controls[i].width + m_aligParam.m_intervalH;
			}
			ret += m_aligParam.m_marginRight;
			return ret;
		}
		
		public function set moveDistance(v:Number):void
		{
			m_moveDistance = v;
			if (m_moveList == null)
			{
				return;
			}
			var ctrol:CtrolHComponent;
			for each(ctrol in m_moveList)
			{
				ctrol.x = ctrol.m_relativeX + m_moveDistance;
			}
		}
		
		public function get moveDistance():Number
		{
			return m_moveDistance;
		}		
		public function setParam(param:ControlHAlignmentParam):void
		{
			if (m_aligParam == null)
			{
				m_aligParam = new ControlHAlignmentParam();
			}
			param.copy(m_aligParam);			
			var midValue:uint = 0;
			
			this.width = m_aligParam.m_widthList;
			
			midValue = m_aligParam.m_marginTop + m_aligParam.m_height + m_aligParam.m_marginBottom;
			//midValue += 18;			
			this.height = midValue;
			//addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			var rect:Rectangle = new Rectangle(0, 0, this.width, this.height);
			this.scrollRect = rect;
		}
		
		public function isPauseMove():Boolean
		{
			return m_gtWeen.paused;
		}
		
		public function get terminaPoint():Number
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
			if (m_aligParam.m_onscrollTobothEndFun!=null&&(m_scrollPos == 0 || m_scrollPos == __max))
			{
				m_aligParam.m_onscrollTobothEndFun();
			}
		}
		override protected function updatePos():void
		{			
			m_container.x = - m_scrollPos;
		}
		
		//若被选择的项没有显示出来，则调整m_scrollPos
		public function updatePosForShowSelectedItem():void
		{
			if (m_iSelectedIndex >= 0 && m_iSelectedIndex < m_controls.length)
			{
				var item:CtrolComponentBase = m_controls[m_iSelectedIndex];
				var leftPos:Number;
				var rightPos:Number;
				if (m_iSelectedIndex == 0)
				{
					leftPos = m_aligParam.m_marginLeft;
				}
				else
				{
					leftPos = m_aligParam.m_intervalH;
				}
				leftPos = item.x - leftPos;
				if (m_iSelectedIndex == m_controls.length-1)
				{
					rightPos = m_aligParam.m_marginRight;
				}
				else
				{
					rightPos = m_aligParam.m_intervalH;
				}
				
				rightPos = item.x + item.width + rightPos;
				
				if (leftPos - m_scrollPos >= 0 && rightPos - m_scrollPos < m_aligParam.m_widthList)
				{
					return;
				}
				var newPos:int;
				if (leftPos - m_scrollPos < 0)
				{
					newPos = leftPos;
				}
				else
				{
					newPos = rightPos - m_aligParam.m_widthList;
				}
				toNewPos(newPos);
			}
		}
		override public function canToPriLine():Boolean
		{
			return m_terminalPoint > 0;
		}
		
		public function canToNextLine():Boolean
		{
			return m_terminalPoint < maxScrollPos;
		}
		
		public function get pageSize():int
		{
			return this.width;
		}
		
		public function get dataWidth():int
		{
			return this.m_dataWidth;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			m_gtWeen.paused = true;
			m_gtWeen.target = null;
			m_gtWeen.onComplete = null;	
			if (m_aligParam.m_onscrollTobothEndFun != null)
			{
				m_aligParam.m_onscrollTobothEndFun = null;
			}
			
			if (m_gtMoveWeen != null)
			{
				m_gtMoveWeen.paused = true;
				m_gtMoveWeen.target = null;
			}
		}
		public function set speed(s:Number):void
		{
			m_speed = s;
		}
		
		public function get maxScrollPos():Number
		{
			var ret:Number;
			if (m_dataWidth <= m_aligParam.m_widthList)
			{
				ret = 0;
			}
			else
			{
				ret = m_dataWidth - m_aligParam.m_widthList;
			}
			return ret;
		}		
	}
}