package game.ui.tasktrace 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.CtrolComponentBase;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.Panel;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import game.ui.tasktrace.rewardtip.TipTaskTrace;
	import modulecommon.appcontrol.PanelDisposeEx;
	
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	import modulecommon.scene.task.TaskItem;
	import modulecommon.scene.task.TaskManager;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class TraceContent extends Component 
	{	
		private var m_updateState:uint;
		public var m_list:TaskList;
		private var m_gkContext:GkContext;	
		private var m_dicTaskInfo:Dictionary;
		private var m_mouseOverPanel:PanelDisposeEx;
		private var m_ui:UITaskTrace;	
		private var m_tip:TipTaskTrace;
		public function TraceContent(ui:UITaskTrace,gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_ui = ui;
			m_list = new TaskList(this);	
			
			m_dicTaskInfo = new Dictionary();	
			
		}
		
		public function initData():void
		{
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkContext;
			dataParam["tc"] = this;
			dataParam["ui"] = m_ui;
			
			param.m_class = TraceItem;
			param.m_heightList = UITaskTrace.HEIGHT_NORMAL - UITaskTrace.HEIGHT_MIN;
			param.m_lineSize = 15;
			param.m_marginBottom = 5;
			param.m_marginLeft = 9+40;
			param.m_marginRight = 10;
			param.m_marginTop = 5;			
			param.m_intervalV = 7
			param.m_width = TraceItem.WIDTH;
			param.m_bCreateScrollBar = true;
			param.m_dataParam = dataParam;
			m_list.setParam(param);
			//var rect:Rectangle = m_list.scrollRect;
			//rect.x = -40;
			//m_list.scrollRect = rect;
			m_list.x = -9 - 40;
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			showbg(0.3);
			setDatas();			
		}
		private function onMouseOver(e:MouseEvent):void
		{
			showbg(0.7);
		}
		private function onMouseLeave(e:MouseEvent):void
		{
			showbg(0.3);
		}
		private function showbg(alpha:Number):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x90301, alpha);
			this.graphics.drawRect(0, 0, TraceItem.WIDTH+10, UITaskTrace.HEIGHT_NORMAL - UITaskTrace.HEIGHT_MIN);
			this.graphics.endFill();
		}
		public function setDatas():void
		{
			var all:Array = m_gkContext.m_taskMgr.getAllTasks();
			all.sort(sort);	
			
			m_list.setDatas(all);
			
		}
		public function addTask(id:uint):void
		{			
			m_dicTaskInfo[id] = getCurState();
			var all:Array = m_gkContext.m_taskMgr.getAllTasks();
			all.sort(sort);
			var taskItem:TaskItem = m_gkContext.m_taskMgr.getTaskItem(id);
			var index:int = all.indexOf(taskItem);
			m_list.insertData(index, taskItem);
			
			var item:TraceItem = getTraceItemByID(id);
			item.showNewIcon(m_ui.m_pnlBk);
		}
		public function updateTask(id:uint):void
		{
			m_dicTaskInfo[id] = getCurState();
			var item:TraceItem = getTraceItemByID(id);
			if (item == null)
			{
				return;
			}
		
			item.updateData();
			var bFinished:Boolean = item.taskitem.finished;
			m_list.adjustAllPos();
						
			
			//判断是否任务的顺序变化了
			var all:Array = m_gkContext.m_taskMgr.getAllTasks();
			all.sort(sort);
			var ctrlList:Vector.<CtrolComponentBase> = m_list.controlList;
			var i:int;
			var n:int = all.length;
			var bSortChange:Boolean;
			for (i = 0; i < n; i++)
			{
				if (all[i] != ctrlList[i].data)
				{
					bSortChange = true;
					break;
				}
			}
			if (bSortChange)
			{
				m_list.setDatas(all);
				if (bFinished)
				{
					m_list.scrollPos = 0;
				}
			}
			
		}
		
		public function deleteTask(id:uint):void
		{
			if (m_dicTaskInfo[id] != undefined)
			{
				delete m_dicTaskInfo[id];
			}
			
			var item:TraceItem = getTraceItemByID(id);
			if (item)
			{
				if (m_gkContext.m_uiFocus && m_gkContext.m_uiFocus.focusCom == item)
				{
					m_gkContext.m_newHandMgr.hide();
				}
				m_list.deleteDataByData(item.taskitem);
			}			
		}
		public function getTaskUpdateState(id:uint):uint
		{
			if (m_dicTaskInfo[id] != undefined)
			{
				return m_dicTaskInfo[id] as uint;
			}
			return 0;
		}
		
		public function getCurState():uint
		{
			m_updateState++;
			return m_updateState;
		}		
		
		public function sort(a:TaskItem, b:TaskItem):int
		{			
			if (a.finished)
			{
				return - 1;
			}
			if (b.finished)
			{
				return 1;
			}
			
			if (a.taskType == TaskManager.TASKTYPE_JuQing)
			{
				return -1;
			}
			if (b.taskType == TaskManager.TASKTYPE_JuQing)
			{
				return 1;
			}
			if (a.taskType == TaskManager.TASKTYPE_XunHuan)
			{
				return -1;
			}
			if (b.taskType == TaskManager.TASKTYPE_XunHuan)
			{
				return 1;
			}
			
			var aState:uint = getTaskUpdateState(a.m_ID);
			var bState:uint = getTaskUpdateState(b.m_ID);
			if (bState == aState)
			{
				if (a.taskType <= b.taskType)
				{
					return -1;
				}
				else
				{
					return 1;
				}
			}
			if (aState > bState)
			{
				return -1;
			}
			return 1;
		}
		public function showOverPanel(traceitem:TraceItem, _x:Number, _y:Number, _width:Number, _height:Number):void
		{
			if (m_mouseOverPanel == null)
			{
				m_mouseOverPanel = new PanelDisposeEx();
				m_mouseOverPanel.setSkinGrid9Image9("commoncontrol/grid9/tasktraceOver.swf");
				
				m_mouseOverPanel.mouseEnabled = false;
			}
			
			m_mouseOverPanel.x = _x;
			m_mouseOverPanel.y = _y;
			m_mouseOverPanel.setSize(_width, _height);
			
			//if (m_list.contains(m_mouseOverPanel) == false)
			//{
			//	m_list.addChild(m_mouseOverPanel);
			//}
			if (m_mouseOverPanel.parent != traceitem)
			{
				traceitem.addChild(m_mouseOverPanel);
			}
		}
		public function hideOverPanel(traceitem:TraceItem):void
		{
			if (m_mouseOverPanel != null)
			{
				//if (m_list.contains(m_mouseOverPanel) == true)
				//{
				//	m_list.removeChild(m_mouseOverPanel);
				//}
				if (traceitem.contains(m_mouseOverPanel))
				{
					traceitem.removeChild(m_mouseOverPanel);
				}
			}
		}
		
		public function onShowNewHand(taskid:uint, desc:String):void
		{
			if (m_list.controlList)
			{
				if (taskid == 0)
				{
					m_gkContext.m_newHandMgr.setFocusFrame( -10, -10, 210, (m_list.controlList[0] as TraceItem).height + 20, 1);
					m_gkContext.m_newHandMgr.prompt(true, -5, (m_list.controlList[0] as TraceItem).height + 5, desc, (m_list.controlList[0] as TraceItem));
					return;
				}
				
				for each(var traceitem:TraceItem in m_list.controlList)
				{
					if (traceitem.taskitem.m_ID == taskid)
					{
						m_gkContext.m_newHandMgr.setFocusFrame( -5, -5, 220, traceitem.height + 10);
						m_gkContext.m_newHandMgr.prompt(true, -5, traceitem.height + 5, desc, traceitem);
					}
				}
			}
		}
		
		public function getTraceItemByID(id:uint):TraceItem
		{
			var i:int;
			var ret:TraceItem;
			var list:Vector.<CtrolComponentBase> = m_list.controlList;
			for (i = 0; i < list.length; i++)
			{
				ret = list[i] as TraceItem;
				if (ret.taskitem.m_ID == id)
				{
					return ret;
				}
			}			
			return null;
		}
		
		public function getTip():TipTaskTrace
		{
			if (m_tip == null)
			{
				m_tip = new TipTaskTrace(m_gkContext);			
			}
			return m_tip;
		}
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			if (m_mouseOverPanel&&null == m_mouseOverPanel.parent)
			{
				m_mouseOverPanel.dispose();
			}
			if (m_tip)
			{
				m_tip.disposeEx();
			}
			super.dispose();
		}
		
		public function updateXunhuanTaskIndex():void
		{
			var ti:TraceItem;
			var list:Array = m_gkContext.m_taskMgr.getTaskListByType(TaskManager.TASKTYPE_XunHuan);
			var taskItem:TaskItem;
			for each(taskItem in list)
			{
				ti = getTraceItemByID(taskItem.m_ID);
				if (ti)
				{
					ti.updateData();
				}
			}		
		}
	}
}