package modulecommon.scene.ingotbefall 
{
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.ingotbefall.stCaiShenOnlinePropertyUserCmd;
	import modulecommon.net.msg.ingotbefall.stRetZhaoCaiResultPropertyUserCmd;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	import modulecommon.scene.vip.VipPrivilegeMgr;
	//import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	/**
	 * ...
	 * @author ...
	 */
	public class IngotBefallMgr 
	{
		public static const INGOTBEFALL_MAXPOWER:int = 100;	//招财能量上限值
		public static const INGOTBEFALL_FREETIMES:uint = 1;	//每日免费次数
		
		private var m_gkContext:GkContext;
		private var m_bnoQuery:Boolean = false;	//点击“招财”按钮，是否出现提示
		public var m_leftTimes:uint;		//每日招财剩余次数
		public var m_baoji:uint;	//是否暴击 0:否  1:暴击
		public var m_power:uint;	//招财能量 最大值100
		public var m_payMoney:uint;	//招财所需元宝
		public var m_isReset7Clock:Boolean;
		
		
		public function IngotBefallMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_isReset7Clock = false;
		}
		
		public function processZhaocaiResultPropertyUserCmd(msg:ByteArray):void
		{
			var rev:stRetZhaoCaiResultPropertyUserCmd = new stRetZhaoCaiResultPropertyUserCmd();
			rev.deserialize(msg);
			
			m_baoji = rev.baoji;
			m_power = rev.power;
			m_payMoney = rev.money;
			m_leftTimes = rev.lefttimes;
			
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIIngotBefall) as IForm
			if (form)
			{
				form.updateData();
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_IngotBefall, -1, leftFrees);
			}
			
			if (m_gkContext.m_UIs.screenBtn)
			{
				m_gkContext.m_UIs.screenBtn.updateLblCnt(leftFrees, ScreenBtnMgr.Btn_IngotBefall);
			}
		}
		
		public function processCaiShenOnlinePropertyUserCmd(msg:ByteArray):void
		{
			var rev:stCaiShenOnlinePropertyUserCmd = new stCaiShenOnlinePropertyUserCmd();
			rev.deserialize(msg);
			
			m_leftTimes = rev.lefttimes;
			m_power = rev.power;
			m_payMoney = rev.needmoney;
		}
		
		// 7 点重置
		public function process7ClockUserCmd():void
		{
			m_isReset7Clock = true;
			
			m_leftTimes = MaxCounts;
			m_payMoney = 0;
			
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIIngotBefall) as IForm
			if (form)
			{
				form.updateData();
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_IngotBefall, -1, leftFrees);
			}
			
			if (m_gkContext.m_UIs.screenBtn)
			{
				m_gkContext.m_UIs.screenBtn.updateLblCnt(leftFrees, ScreenBtnMgr.Btn_IngotBefall);
			}
			
			m_isReset7Clock = false;
		}
		
		//获得银币公式=40000+人物等级*500
		public function get rewardMoney():uint
		{
			return (m_gkContext.playerMain.level * 500 + 40000);
		}
		
		public function get bNoQuery():Boolean
		{
			return m_bnoQuery;
		}
		
		public function set bNoQuery(bool:Boolean):void
		{
			m_bnoQuery = bool;
		}
		
		//每日招财最大次数
		public function get MaxCounts():uint
		{
			return m_gkContext.m_vipPrivilegeMgr.getPrivilegeValue(VipPrivilegeMgr.Vip_IngotBefall);
		}
		
		//剩余免费次数
		public function get leftFrees():uint
		{
			return ((m_leftTimes + INGOTBEFALL_FREETIMES) > MaxCounts)? (m_leftTimes + INGOTBEFALL_FREETIMES - MaxCounts): 0;
		}
	}

}