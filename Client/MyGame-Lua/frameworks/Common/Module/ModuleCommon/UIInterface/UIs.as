package modulecommon.uiinterface 
{
	import modulecommon.ui.Form;
	import modulecommon.ui.uiprog.UICircleLoading;
	

	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UIs 
	{
		public var backPack:IUIBackPack;
		public var zhenfa:IUIZhenfa;
		public var task:IUITask;		
		public var taskTrace:IUITaskTrace;
		public var xuanshangrenwu:IUIXuanShangRenWu;
		public var hero:IUIHero;
		public var sysBtn:IUiSysBtn;
		public var radar:IUIRadar;
		public var newhandPro:IUINewhandPrompt;
		public var jiuguan:IUIJiuGuan;
		public var worldmap:IUIWorldMap;
		public var screenBtn:IUIScreenBtn;
		public var equipSys:IUIEquipSys;	
		public var npcTalk:IUINpcTalk;
		public var taskPrompt:IUITaskPrompt;
		public var gmInfoShow:Form;
		//public var progLoading:UIProgLoading;		// 程序启动进度条
		public var circleLoading:UICircleLoading;	// 环形程序启动进度条
		public var chatSystem:IUIChatSystem;
		public var teamFBZX:IUITeamFBZX;	// 组队副本
		public var benefitHall:IUIBenefitHall;
		public var heroRally:IUIHeroRally;
		public var rechatge:IUIRechatge;
		public var dtRechatge:IUIRechatge;
		public var collectProgress:Form;
	}
}