package com.bit101.components.controlList
{
	//import com.bit101.components.Panel;
	//import com.bit101.components.PanelContainer;
	import com.bit101.components.VScrollBar;
	import com.util.DebugBox;
	import org.ffilmation.engine.helpers.fUtil;
	//import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import com.gskinner.motion.GTween;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 * 目标:
	   1. 只有1列子控件
	   2. 可以有任意数量行数的子控件
	   3. 不同行的子控件，其宽度相同，其高度可不同
	 */
	public class ControlListVHeight extends ControlListBase
	{
		protected var m_aligParam:ControlVHeightAlignmentParam;
		protected var m_dataHeight:int;
		
		private var m_scrollbar:VScrollBar;
		
		private var m_speed:Number = 100;
		
		private var m_gtMoveWeen:GTween;
		private var m_moveDistance:Number;
		private var m_moveList:Vector.<CtrolComponentBase>;
		
		public function ControlListVHeight(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}
		
		public function setDatas(datas:Array, param:Object = null):void
		{
			if (param == null)
			{
				param = m_aligParam.m_dataParam;
			}
			
			m_datas = datas;
			var ctrol:CtrolVHeightComponent;
			var i:int;
			var oldNumCtrol:int = m_controls.length;
			var dataCount:int = datas.length;
			var top:int = m_aligParam.m_marginTop;
			
			for (i = 0; i < dataCount; i++)
			{
				if (i < oldNumCtrol)
				{
					ctrol = m_controls[i] as CtrolVHeightComponent;
					ctrol.onNotSelected();
				}
				else
				{
					ctrol = new m_aligParam.m_class(param);
					ctrol.list = this;
					ctrol.width = m_aligParam.m_width;
					if (m_aligParam.m_height)
					{
						ctrol.height = m_aligParam.m_height;
					}
					ctrol.addEventListener(MouseEvent.CLICK, onItemClik);
					ctrol.x = m_aligParam.m_marginLeft;
					m_controls.push(ctrol);
					m_container.addChild(ctrol);
				}
				ctrol.y = top;
				ctrol.setData(m_datas[i]);
				top += ctrol.height;
				if (i < dataCount - 1)
				{
					top += m_aligParam.m_intervalV;
				}
				
			}
			
			if (m_controls.length > dataCount)
			{
				for (i = dataCount; i < m_controls.length; i++)
				{
					ctrol = m_controls[i] as CtrolVHeightComponent;
					ctrol.dispose();
					ctrol.removeEventListener(MouseEvent.CLICK, onItemClik);
					m_container.removeChild(ctrol);
				}
				m_controls.splice(dataCount, m_controls.length - dataCount);
			}
			updateOrder();
			dataHeight = top + m_aligParam.m_marginBottom;
			m_iSelectedIndex = -1;
			
			if (m_bInitSubCtrlOnShow)
			{
				processCtrlFirstShow();
			}
		}
		
		public function clear():void
		{
			var ctrol:CtrolVHeightComponent;
			for each (ctrol in m_controls)
			{
				ctrol.dispose();
				ctrol.removeEventListener(MouseEvent.CLICK, onItemClik);
				m_container.removeChild(ctrol);
			}
			m_controls.length = 0;
			dataHeight = m_aligParam.m_marginBottom + m_aligParam.m_marginTop;
			
			scrollPos = 0;
		}
		
		//如果index == -1表示插入最后
		public function insertData(index:int, data:Object, param:Object = null):void
		{
			stopMove();
			if (index == -1 || index > m_controls.length)
			{
				index = m_controls.length;
			}
			if (param == null)
			{
				param = m_aligParam.m_dataParam;
			}
			
			var ctrol:CtrolVHeightComponent = new m_aligParam.m_class(param);
			ctrol.setData(data);
			ctrol.width = m_aligParam.m_width;
			ctrol.x = m_aligParam.m_marginLeft;
			ctrol.addEventListener(MouseEvent.CLICK, onItemClik);
			m_container.addChild(ctrol);
			m_controls.splice(index, 0, ctrol);
			if (m_bInitSubCtrlOnShow)
			{
				ctrol.onFirstShow();
			}
			
			adjustAllPos();
			updateOrder();
		}
		
		//根据数据删除一项
		public function deleteDataByData(data:Object):void
		{
			var i:int = 0;
			var count:int = m_controls.length;
			for (i = 0; i < count; i++)
			{
				if (m_controls[i].data == data)
				{
					deleteData(i);
					break;
				}
			}
		}
		
		public function deleteCtrl(ctrl:CtrolComponentBase):void
		{
			var i:int = m_controls.indexOf(ctrl);
			if (i != -1)
			{
				deleteData(i);
			}
		}
		
		//根据索引删除一项
		override public function deleteData(index:int):void
		{
			if (index >= m_controls.length)
			{
				return;
			}
			stopMove();
			var i:int = 0;
			var delCtrol:CtrolComponentBase = m_controls[index];
			if (index < m_controls.length - 1)
			{
				m_moveDistance = m_controls[index + 1].y - delCtrol.y;
				if (m_moveList == null)
				{
					m_moveList = new Vector.<CtrolComponentBase>();
				}
				m_moveList.length = 0;
				for (i = index + 1; i < m_controls.length; i++)
				{
					m_moveList.push(m_controls[i]);
					(m_controls[i] as CtrolVHeightComponent).m_relativeY = m_controls[i].y - m_moveDistance;
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
			dataHeight = computeDataHeight();
			if (delCtrol.parent == m_container)
			{
				this.m_container.removeChild(delCtrol);
			}
			else
			{
				DebugBox.sendToDataBase("ControlListVHeight::deleteData delCtrol.parent"+delCtrol.parent);
			}
			delCtrol.dispose();
			if (m_scrollPos > maxScrollPos)
			{
				scrollPos = maxScrollPos;
			}
			updateOrder();
			if (m_bInitSubCtrlOnShow)
			{
				processCtrlFirstShow();
			}
		}
		
		public function deleteDataWithoutAni(index:int):void
		{
			if (index >= m_controls.length)
			{
				return;
			}
			
			var i:int = 0;
			var delCtrol:CtrolComponentBase = m_controls[index];
			m_controls.splice(index, 1);
			dataHeight = computeDataHeight();
			this.m_container.removeChild(delCtrol);
			delCtrol.dispose();
			if (m_scrollPos > maxScrollPos)
			{
				scrollPos = maxScrollPos;
			}
			updateOrder();
		}
		
		public function adjustAllPos():void
		{
			var i:int = 0;
			var count:int = m_controls.length;
			var top:int = m_aligParam.m_marginTop;
			if (m_controls.length > 0)
			{
				m_controls[0].y = top;
				top += m_controls[0].height;
			}
			for (i = 1; i < count; i++)
			{
				top += m_aligParam.m_intervalV;
				m_controls[i].y = top;
				top += m_controls[i].height;
			}
			
			this.dataHeight = top + m_aligParam.m_marginBottom;
		
		}
		
		protected function computeDataHeight():int
		{
			var i:int = 0;
			var ret:int = m_aligParam.m_marginTop;
			if (m_controls.length > 0)
			{
				ret += m_controls[0].height;
			}
			for (i = 1; i < m_controls.length; i++)
			{
				ret += m_controls[i].height + m_aligParam.m_intervalV;
			}
			ret += m_aligParam.m_marginBottom;
			return ret;
		}
		
		public function sortList(funSort:Function):void
		{
			m_controls.sort(funSort);
			adjustAllPos();
		}
		
		public function sortListByDataList(dataList:Array):void
		{
			var ctrlListCopy:Vector.<CtrolComponentBase> = new Vector.<CtrolComponentBase>(m_controls.length);
			var ctrl:CtrolComponentBase;
			var i:int;
			var count:int = m_controls.length;
			for each(ctrl in m_controls)
			{
				i = dataList.indexOf(ctrl.data);
				ctrlListCopy[i] = ctrl;
			}
			for (i = 0; i < count; i++)
			{
				m_controls[i] = ctrlListCopy[i];
			}
			adjustAllPos();
		}
		
		public function set moveDistance(v:Number):void
		{
			m_moveDistance = v;
			if (m_moveList == null)
			{
				return;
			}
			var ctrol:CtrolVHeightComponent;
			for each (ctrol in m_moveList)
			{
				ctrol.y = ctrol.m_relativeY + m_moveDistance;
			}
		}
		
		protected function stopMove():void
		{
			if (m_gtMoveWeen && m_gtMoveWeen.paused == false)
			{
				m_gtMoveWeen.paused = true;
				adjustAllPos();
			}
		}
		
		public function get moveDistance():Number
		{
			return m_moveDistance;
		}
		
		public function setParamForPageMode(param:ControlVHeightAlignmentParam_ForPageMode):void
		{
			if (m_aligParam == null)
			{
				m_aligParam = new ControlVHeightAlignmentParam();
			}
			fUtil.assert(param.m_intervalV % 2 == 0, "m_intervalV必须是偶数");
			m_aligParam.m_class = param.m_class;
			m_aligParam.m_bCreateScrollBar = false;
			m_aligParam.m_width = param.m_width;
			m_aligParam.m_height = param.m_height;
			
			m_aligParam.m_intervalV = param.m_intervalV;
			m_aligParam.m_marginBottom = param.m_intervalV / 2;
			m_aligParam.m_marginLeft = param.m_marginLeft;
			m_aligParam.m_marginRight = param.m_marginRight;
			m_aligParam.m_marginTop = m_aligParam.m_marginBottom;
			
			m_aligParam.m_lineSize = m_aligParam.m_marginBottom + m_aligParam.m_marginTop + (param.m_numRow - 1) * m_aligParam.m_intervalV + param.m_numRow * param.m_height;
			m_aligParam.m_heightList = m_aligParam.m_lineSize;
			m_aligParam.m_scrollType = 1;
			m_aligParam.m_dataParam = param.m_dataParam;
			setParamEx();
		}
		
		public function setParam(param:ControlVHeightAlignmentParam):void
		{
			if (m_aligParam == null)
			{
				m_aligParam = new ControlVHeightAlignmentParam();
			}
			
			m_aligParam.m_class = param.m_class;
			m_aligParam.m_bCreateScrollBar = param.m_bCreateScrollBar;
			m_aligParam.m_width = param.m_width;
			m_aligParam.m_height = param.m_height;
			m_aligParam.m_intervalV = param.m_intervalV;
			m_aligParam.m_marginBottom = param.m_marginBottom;
			m_aligParam.m_marginLeft = param.m_marginLeft;
			m_aligParam.m_marginRight = param.m_marginRight;
			m_aligParam.m_marginTop = param.m_marginTop;
			m_aligParam.m_heightList = param.m_heightList;
			m_aligParam.m_lineSize = param.m_lineSize;
			m_aligParam.m_scrollType = param.m_scrollType;
			m_aligParam.m_dataParam = param.m_dataParam;
			
			setParamEx();
		}
		
		private function setParamEx():void
		{
			var midValue:uint = 0;
			midValue = m_aligParam.m_marginLeft + m_aligParam.m_width + m_aligParam.m_marginRight;
			midValue += 18;
			this.width = midValue;
			this.height = m_aligParam.m_heightList;
			if (m_aligParam.m_bCreateScrollBar == true)
			{
				m_scrollbar = new VScrollBar(this, 0, 0, onScroll);
				m_scrollbar.setPos(this.width - m_scrollbar.width, 0);
				m_scrollbar.height = this.height;
				m_scrollbar.pageSize = this.pageSize;
				m_scrollbar.lineSize = m_aligParam.m_lineSize;
				addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				m_scrollbar.visible = false;
			}
			var rect:Rectangle = new Rectangle(0, 0, this.width, this.height);
			this.scrollRect = rect;
		}
		
		protected function onScroll(event:Event):void
		{
			scrollPos = m_scrollbar.value;
		}
		
		protected function onMouseWheel(event:MouseEvent):void
		{
			m_scrollbar.value -= event.delta * 10;
			scrollPos = m_scrollbar.value;
		}
		
		//返回总的页数
		public function get pageCount():int
		{
			return (dataHeight + pageSize - 1) / pageSize;
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
		
		public function get dataHeight():int
		{
			return this.m_dataHeight;
		}
		
		//返回
		public function get ctrlCount():int
		{
			return m_controls.length;
		}
		
		public function set dataHeight(h:int):void
		{
			m_dataHeight = h;
			if (m_scrollbar != null)
			{
				m_scrollbar.numTotalData = m_dataHeight;
			}
			
			if (m_aligParam.m_scrollType == ControlAlignmentParamBase.ScrollType_AutoHeight)
			{
				this.height = m_dataHeight;
				var rect:Rectangle = new Rectangle(0, 0, this.width, this.height);
				this.scrollRect = rect;
			}
			else
			{
				if (m_scrollPos > maxScrollPos)
				{
					scrollPos = maxScrollPos;
					if (m_scrollbar)
					{
						m_scrollbar.value = scrollPos;
					}
				}
			}
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
			if (m_scrollbar)
			{
				m_scrollbar.value = m_scrollPos;
			}
			updatePos();
		}
		
		public function get maxScrollPos():Number
		{
			var ret:Number;
			if (m_dataHeight <= m_aligParam.m_heightList)
			{
				ret = 0;
			}
			else
			{
				if (ControlAlignmentParamBase.ScrollType_LastPageFull == m_aligParam.m_scrollType)
				{
					ret = m_dataHeight - m_aligParam.m_heightList;
				}
				else if (ControlAlignmentParamBase.ScrollType_Normal == m_aligParam.m_scrollType)
				{
					ret = Math.floor((m_dataHeight - 1) / m_aligParam.m_heightList) * m_aligParam.m_heightList;
						//ret = m_dataHeight - m_dataHeight%m_aligParam.m_heightList;
				}
			}
			return ret;
		}
		
		public function getCurPageScrollPosByItem(item:CtrolComponentBase):Number
		{
			var ret:Number;
			
			ret = Math.floor((item.y - 1) / m_aligParam.m_heightList) * m_aligParam.m_heightList;
			
			return ret;
		}
		
		public function canToNextLine():Boolean
		{
			return m_scrollPos < maxScrollPos;
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
		
		public function set speed(s:Number):void
		{
			m_speed = s;
		}
		
		public function isCtrlVisibleForScroll(ctrl:CtrolVHeightComponent):Boolean
		{
			var curY:Number = ctrl.y - m_scrollPos;
			if (curY < this.height && curY + ctrl.height > 0)
			{
				return true;
			}
			return false;
		}
		
		public function updateOrder():void
		{
			var i:int;
			var count:int = m_controls.length;
			var ctrl:CtrolComponentBase;
			var bFirst:Boolean;
			var bLast:Boolean;
			for (i = 0; i < count; i++)
			{
				ctrl = m_controls[i];
				if (i == 0)
				{
					bFirst = true;
				}
				if (i == count - 1)
				{
					bLast = true;
				}
				ctrl.setFirstAndLastFlag(bFirst, bLast, i);
			}
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
		
		//这个函数用于调试
		public function getPropertys(list:Array):Dictionary
		{
			var ret:Dictionary = new Dictionary();
			var str:String;
			for each (str in list)
			{
				if (this[str] != undefined)
				{
					ret[str] = this[str];
				}
			}
			return ret;
		}
		
		// 停止播放动画,如果删除一项,然后立即插入一项,但是插入的这一项正好在移动动画中,就会出现位置错误
		public function stopTWeen():void
		{
			if (m_gtMoveWeen)
			{
				m_gtMoveWeen.paused = true;
			}
		}
	}

}