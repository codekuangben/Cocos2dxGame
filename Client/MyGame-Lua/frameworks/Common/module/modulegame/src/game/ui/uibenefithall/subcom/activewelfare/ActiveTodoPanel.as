package game.ui.uibenefithall.subcom.activewelfare 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import game.ui.uibenefithall.DataBenefitHall;
	import modulecommon.GkContext;
	import modulecommon.scene.benefithall.dailyactivities.DailyactivitiesMgr;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	/**
	 * ...
	 * @author ...
	 * 活跃任务列表
	 */
	public class ActiveTodoPanel extends Component
	{
		private var m_gkContext:GkContext;
		private var m_dataBenefitHall:DataBenefitHall;
		private var m_list:ControlListVHeight;
		private var m_param:Object;
		private var m_itemOverPanel:Panel;
		
		public function ActiveTodoPanel(databenefithall:DataBenefitHall, parent:DisplayObjectContainer, xpos:Number, ypos:Number) 
		{
			super(parent, xpos, ypos);
			m_dataBenefitHall = databenefithall;
			m_gkContext = m_dataBenefitHall.m_gkContext;
			
			m_list = new ControlListVHeight(this, 0, 0);
			m_param = new Object();
			m_param["gk"] = m_gkContext;
			m_param["actTodoPanel"] = this;
			
			initData();
		}
		
		public function initData():void
		{
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			param.m_class = ItemActiveTodo;
			param.m_lineSize = 35;
			param.m_marginBottom = 1;
			param.m_marginLeft = 5;
			param.m_marginRight = 5;
			param.m_marginTop = 1;
			param.m_intervalV = 2;
			param.m_heightList = param.m_marginTop + 33 + (33 + param.m_intervalV) * 9 + param.m_marginBottom;
			param.m_width = 625;
			param.m_bCreateScrollBar = true;
			m_list.setParam(param);
		}
		
		public function setDatas(list:Array):void
		{
			if (list)
			{
				m_list.setDatas(list, m_param);
			}
		}
		
		//id 活跃任务编号
		public function onClickItem(id:int):void
		{
			var funcid:int = DailyactivitiesMgr.getFuncID(id);
			
			if (!m_gkContext.m_corpsMgr.hasCorps && (DailyactivitiesMgr.TODOS_ITEM22 == id || DailyactivitiesMgr.TODOS_ITEM23 == id))
			{
				m_gkContext.m_systemPrompt.prompt("你还没有加入军团");
			}
			else if (DailyactivitiesMgr.TODOS_ITEM21 == id)
			{
				m_gkContext.m_systemPrompt.prompt("暂未开放");
			}
			else if (DailyactivitiesMgr.TODOS_ITEM18 == id)
			{
				if (!m_gkContext.m_corpsMgr.hasCorps)
				{
					m_gkContext.m_systemPrompt.prompt("等级达到20级，加入军团后，可携团友一起攻城御敌");
				}
				else if (m_gkContext.m_UIs.screenBtn && m_gkContext.m_UIs.screenBtn.isVisibleBtn(ScreenBtnMgr.Btn_CorpsCitySys))
				{
					m_gkContext.m_screenbtnMgr.moveToNpcOfCorpsCitySys();
					m_dataBenefitHall.m_mainForm.exit();
				}
				else
				{
					m_gkContext.m_systemPrompt.prompt("活动时间未到");
				}
			}
			else
			{
				if (m_gkContext.m_sysnewfeatures.openOneFuncForm(funcid))
				{
					m_dataBenefitHall.m_mainForm.exit();
				}
			}
			
		}
		
		public function showItemOverPanel(parent:Component):void
		{
			if (null == m_itemOverPanel)
			{
				m_itemOverPanel = new Panel(null, 0, -10);
				m_itemOverPanel.setSize(625, 33);
				m_itemOverPanel.autoSizeByImage = false;
				m_itemOverPanel.setPanelImageSkin("commoncontrol/panel/itemrollover.png");
			}
			
			parent.addChild(m_itemOverPanel);
		}
		
		public function hideItemOverPanel():void
		{
			if (m_itemOverPanel && m_itemOverPanel.parent)
			{
				m_itemOverPanel.parent.removeChild(m_itemOverPanel);
			}
		}
		
		override public function dispose():void
		{
			if (m_itemOverPanel && (null == m_itemOverPanel.parent))
			{
				m_itemOverPanel.dispose();
				m_itemOverPanel = null;
			}
			super.dispose();
		}
	}

}