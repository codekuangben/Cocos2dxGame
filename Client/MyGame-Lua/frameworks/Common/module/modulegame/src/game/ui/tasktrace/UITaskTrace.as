package game.ui.tasktrace
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.CommonImageManager;
	import com.dgrigg.image.Image;
	import com.pblabs.engine.core.ITickedObject;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.Car1D;
	import modulecommon.scene.task.TaskItem;
	import game.ui.tasktrace.yugaogongneng.YugaoPanel;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import modulecommon.commonfuntion.LocalDataMgr;
	//import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUITaskTrace;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UITaskTrace extends Form implements IUITaskTrace, ITickedObject
	{
		//整个界面的高度分成3部分：1-MARGIN_TOP；2- HEIGHT_MIN；3 - HEIGHT_NORMAL - HEIGHT_MIN；
		public static const WIDTH_NORMAL:int = 230;
		public static const HEIGHT_NORMAL:int = 200;
		public static const WIDTH_MIN:int = 155;
		public static const HEIGHT_MIN:int = 38;
		public static const HEIGHT_Tiao:int = 23;
		public static const MARGIN_TOP:int = 15;
		public static const ANI_TIME:Number = 0.8;
		
		private var m_taskTraceContainer:Panel;
		private var m_leftPanel:PanelContainer;
		private var m_middlePanel:Panel;
		private var m_rightPanel:PanelContainer;
		private var m_indentBtn:PushButton;
		private var m_taskBtn:PushButton;
		private var m_BG:PanelContainer;
		private var m_traceContent:TraceContent;
		
		private var m_Hcar:Car1D;
		private var m_Vcar:Car1D;
		private var m_scrollRect:Rectangle;
		public var m_pnlBk:Panel;		//这个是为了获取 image
		//private var m_pnlBk1:Panel;		//这个是为了获取 image
		private var m_executeTaskGoal:ExecuteTaskGoal;
		
		private var m_yugaoPanel:YugaoPanel;
		public function UITaskTrace()
		{
			
		}		
	
		override public function setImageSWF(imageSWF:SWFResource):void 
		{
			m_taskTraceContainer = new Panel(this);
			this.setSize(WIDTH_NORMAL, 30);
			this.alignHorizontal = Component.RIGHT;
			this.alignVertial = Component.TOP;
			this.marginTop = 130;
			this.adjustPosWithAlign();
			m_gkcontext.m_UIs.taskTrace = this;
			m_BG = new PanelContainer(m_taskTraceContainer, 0, MARGIN_TOP);
			m_BG.setSize(WIDTH_NORMAL, HEIGHT_NORMAL);
			
			m_leftPanel = new PanelContainer(m_BG, 0, -MARGIN_TOP);
			m_leftPanel.setSize(25, 38);
			
			m_middlePanel = new Panel(m_BG, m_leftPanel.width, -MARGIN_TOP);
			m_middlePanel.autoSizeByImage = false;
			m_middlePanel.setSize(WIDTH_NORMAL - WIDTH_MIN, 38);
			
			m_rightPanel = new PanelContainer(m_taskTraceContainer, m_middlePanel.x + m_middlePanel.width, 0);
			m_rightPanel.setSize(130, 38);
			
			if (m_gkcontext.playerMain.level >= 20)
			{
				m_indentBtn = new PushButton(m_leftPanel, 15, 20, onIndentBtn);
				m_indentBtn.setSize(8, 12);			
				m_indentBtn.setPanelImageSkinMirror("commoncontrol/button/leftArrow.swf", Image.MirrorMode_HOR);
				m_indentBtn.recycleSkins = true;
			}
			m_taskBtn = new PushButton(m_rightPanel, 95, 2, onTaskBtn);
			m_taskBtn.setSize(32, 32);
			
			m_traceContent = new TraceContent(this, m_gkcontext, m_BG, 10, HEIGHT_Tiao);
			m_traceContent.initData();
			
			
			this.draggable = false;		
			
			m_pnlBk = new Panel();	// 这个仅仅是获取 image 使用的
			m_executeTaskGoal = new ExecuteTaskGoal(m_gkcontext);
			
			m_taskBtn.setPanelImageSkinBySWF(imageSWF, "tasktrace.taskbtn");
			m_leftPanel.setPanelImageSkinBySWF(imageSWF, "tasktrace.left");
			m_middlePanel.setPanelImageSkinBySWF(imageSWF, "tasktrace.middle");
			m_rightPanel.setPanelImageSkinBySWF(imageSWF, "tasktrace.right");
			m_BG.setPanelImageSkinBySWF(imageSWF, "tasktrace.bg");

			m_pnlBk.setPanelImageSkinBySWF(imageSWF, "tasktrace.newicon");			
			m_bInitiated = true;			
		}
	
		override public function isShouldShow():Boolean 
		{
			return m_gkcontext.m_taskMgr.isShouldShowUITaskTrace();
		}
		
		public function onTick(deltaTime:Number):void
		{
			var intValue:int;
			m_Hcar.onTick(deltaTime);
			m_Vcar.onTick(deltaTime);
			
			intValue = m_Hcar.curPos;
			m_BG.x = intValue;
			m_middlePanel.width = (WIDTH_NORMAL - WIDTH_MIN - intValue);
			m_middlePanel.draw();
			
			m_scrollRect.height = m_Vcar.curPos;
			m_taskTraceContainer.scrollRect = m_scrollRect;			
			
			if (m_Hcar.isStop && m_Vcar.isStop)
			{
				this.m_gkcontext.m_context.m_processManager.removeTickedObject(this);
			}
		}
		
		public function addTask(id:uint):void
		{			
			m_traceContent.addTask(id);			
		}
		
		public function updateTask(id:uint):void
		{		
			m_traceContent.updateTask(id);			
		}
		
		public function deleteTask(id:uint):void
		{		
			m_traceContent.deleteTask(id);
		}
		
		private function onIndentBtn(e:MouseEvent):void
		{
			if (m_Hcar && m_Hcar.isStop == false)
			{
				return;
			}
			if (this.m_BG.x == 0)
			{
				if (m_Hcar == null)
				{
					m_Hcar = new Car1D();
					m_Vcar = new Car1D();
					m_scrollRect = new Rectangle(0, 0, WIDTH_NORMAL, HEIGHT_NORMAL);
					this.m_taskTraceContainer.scrollRect = m_scrollRect;
				}
				
				m_Hcar.sorPos = 0;
				m_Hcar.destPos = WIDTH_NORMAL - WIDTH_MIN;
				m_Hcar.totalTime = ANI_TIME;
				m_Hcar.begin();
				
				m_Vcar.sorPos = HEIGHT_NORMAL;
				m_Vcar.destPos = HEIGHT_MIN;
				m_Vcar.totalTime = ANI_TIME;
				m_Vcar.begin();
				m_indentBtn.setPanelImageSkin("commoncontrol/button/leftArrow.swf");
				
			}
			else
			{
				m_Hcar.sorPos = WIDTH_NORMAL - WIDTH_MIN;
				m_Hcar.destPos = 0;
				m_Hcar.totalTime = ANI_TIME;
				m_Hcar.begin();
				
				m_Vcar.sorPos = HEIGHT_MIN;
				m_Vcar.destPos = HEIGHT_NORMAL;
				m_Vcar.totalTime = ANI_TIME;
				m_Vcar.begin();
				m_indentBtn.setPanelImageSkinMirror("commoncontrol/button/leftArrow.swf", Image.MirrorMode_HOR);				
			}
			this.m_gkcontext.m_context.m_processManager.addTickedObject(this, EntityCValue.PriorityUI);
		}
		
		private function onTaskBtn(e:MouseEvent):void
		{			
			if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UITask) == true)
			{
				m_gkcontext.m_UIMgr.exitForm(UIFormID.UITask);
			}
			else
			{
				m_gkcontext.m_UIMgr.showFormEx(UIFormID.UITask);				
			}
		}
		
		public function getTaskBtnPos():Point
		{
			return m_taskBtn.localToScreen();
		}
		
		override public function onDestroy():void
		{
			m_gkcontext.m_UIs.taskTrace = null;
		}
		
		
		public function execTaskGoal(taskItem:TaskItem):void
		{
			m_executeTaskGoal.exec(taskItem);
		}
		public function gotoFunc(destX:int, destY:int, mapID:int, npcID:int):void
		{
			m_executeTaskGoal.gotoFunc(destX,destY,mapID,npcID);
		}
		//taskid = 0 表示默认指向任务追踪列表中第一个任务
		public function showNewHand(taskid:uint, desc:String = "点击自动寻径。"):void
		{
			if (m_BG.x != 0)
			{
				if (m_gkcontext.m_newHandMgr.isVisible())
				{
					m_gkcontext.m_newHandMgr.hide();
				}
				return;
			}
			
			m_traceContent.onShowNewHand(taskid, desc);
		}
		public function getList():ControlListVHeight
		{
			return m_traceContent.m_list;
		}
		override public function dispose():void 
		{
			super.dispose();
			if (m_yugaoPanel && m_yugaoPanel.parent == null)
			{
				m_yugaoPanel.dispose();
			}
		}
		
		public function updateXunhuanTaskIndex():void
		{		
			m_traceContent.updateXunhuanTaskIndex();			
		}
		
		public function setYugao(id:int, bOpen:Boolean, bShow:Boolean):void
		{
			if (bOpen && null == m_yugaoPanel)
			{
				m_yugaoPanel = new YugaoPanel(m_gkcontext, this, 196, 208);
			}
			
			if (m_yugaoPanel)
			{
				m_yugaoPanel.setYugao(id, bOpen, bShow);
			}
		}
	}

}