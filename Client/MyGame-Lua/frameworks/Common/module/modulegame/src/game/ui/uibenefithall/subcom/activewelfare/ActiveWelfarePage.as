package game.ui.uibenefithall.subcom.activewelfare 
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.progressBar.BarInProgress2;
	import flash.display.DisplayObjectContainer;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.subcom.PageBase;
	import modulecommon.scene.benefithall.dailyactivities.Rewards;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author ...
	 * 活跃福利
	 */
	public class ActiveWelfarePage extends PageBase
	{
		private var m_dataBenefitHall:DataBenefitHall;
		private var m_activeTodoPanel:ActiveTodoPanel;	//活跃任务列表
		private var m_actValueLabel:Label;
		private var m_actValue:uint;					//今日活跃度值
		private var m_activeValueBar:BarInProgress2;	//活跃值进度条
		private var m_rewardsList:Array;	//活跃奖励列表
		private var m_vecRewardBox:Vector.<RewardBox>;	//奖励宝箱列表
		
		public function ActiveWelfarePage(data:DataBenefitHall, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0)
		{
			super(data, parent, xpos, ypos);
			m_dataBenefitHall = data;
			
			initData();
		}
		
		private function initData():void
		{
			m_dataBenefitHall.m_gkContext.m_dailyActMgr.loadConfig();
			
			this.setPanelImageSkin("module/benefithall/huoyuefulibg.png");
			
			m_actValueLabel = new Label(this, 24, 81, "", UtilColor.GOLD, 14);
			m_actValueLabel.setBold(true);
			
			m_rewardsList = m_dataBenefitHall.m_gkContext.m_dailyActMgr.getCurActReward();
			m_vecRewardBox = new Vector.<RewardBox>(4);
			
			var arr:Array = ["blue", "green", "purple", "orange"];
			var rewardbox:RewardBox;
			var i:int;
			
			if (m_rewardsList)
			{
				for (i = 0; i < m_rewardsList.length && i < 4; i++)
				{
					rewardbox = new RewardBox(m_dataBenefitHall.m_gkContext, this, 185 + (i * 120), 10);
					rewardbox.setDatas(arr[i], m_rewardsList[i]);
					m_vecRewardBox[i] = rewardbox;
				}
			}
			
			m_activeValueBar = new BarInProgress2(this, 177, 83);
			m_activeValueBar.setSize(398, 11);
			m_activeValueBar.autoSizeByImage = false;
			m_activeValueBar.setPanelImageSkin("commoncontrol/panel/barblue.png");
			m_activeValueBar.maximum = 1;
			m_activeValueBar.initValue = 0;
			
			var panel:Panel;
			var barbg:Panel = new Panel(this, 155, 80);
			barbg.setSize(442, 17);
			barbg.setHorizontalImageSkin("commoncontrol/horstretch/progressBg2_mirror.png");
			
			for (i = 0; i < 9; i++)
			{
				panel = new Panel(barbg, 60 + i * 40, 1);
				panel.setPanelImageSkin("commoncontrol/panel/lattice.png");
			}
			
			m_activeTodoPanel = new ActiveTodoPanel(m_dataBenefitHall, this, 12, 154);
		}
		
		override public function onShow():void
		{
			super.onShow();
			
			m_dataBenefitHall.m_gkContext.m_dailyActMgr.reqOpenPerDayToDo();
		}
		
		override public function updateData(param:Object = null):void
		{
			super.updateData(param);
			
			m_actValue = m_dataBenefitHall.m_gkContext.m_dailyActMgr.m_actValue;
			
			m_actValueLabel.text = "活跃值：" + m_actValue.toString();
			
			var v:Number = 1;
			var valueMax:uint = m_dataBenefitHall.m_gkContext.m_dailyActMgr.actValueMax;
			valueMax = (valueMax > 100)? 100: valueMax;
			
			if (m_actValue < valueMax)
			{
				v = m_actValue / valueMax;
			}
			m_activeValueBar.value = v;
			
			updateRewardBoxState();
			
			m_activeTodoPanel.setDatas(m_dataBenefitHall.m_gkContext.m_dailyActMgr.getCurToDoList());
		}
		
		//更新活跃度奖励宝箱状态
		public function updateRewardBoxState():void
		{
			m_rewardsList = m_dataBenefitHall.m_gkContext.m_dailyActMgr.getCurActReward();
			var rewards:Rewards;
			var rewardbox:RewardBox;
			for each(rewards in m_rewardsList)
			{
				for each(rewardbox in m_vecRewardBox)
				{
					if (rewardbox && (rewardbox.actValue == rewards.m_value))
					{
						rewardbox.updateBoxState(rewards.m_bReceive);
						break;
					}
				}
			}
		}
		
	}

}