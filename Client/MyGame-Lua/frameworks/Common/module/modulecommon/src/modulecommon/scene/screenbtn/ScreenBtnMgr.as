package modulecommon.scene.screenbtn 
{
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.net.msg.corpscmd.notifyCorpsNpcIDUserCmd;
	import modulecommon.scene.MapInfo;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUITaskTrace;
	/**
	 * ...
	 * @author ...
	 */
	public class ScreenBtnMgr 
	{
		// 7 5 3 1 0 2 4 6
		// 活动按钮定义
		public static const Btn_CANGBAOKU:int = 0;		//藏宝窟
		public static const Btn_EliteBarrier:int = 1;	//精英关卡（战役挑战）
		public static const Btn_Jiuguan:int = 2;		//酒馆
		public static const Btn_Arena:int = 3;			//竞技场.又名武举擂台
		public static const Btn_Guoguanzhanjiang:int = 4;	//过关斩将表
		public static const Btn_Xuanshangrenwu:int = 5;		//悬赏任务
		public static const Btn_SaoDang:int = 6;			//副本扫荡
		public static const Btn_GiftPack:int = 7;			//礼包
		public static const Btn_IngotBefall:int = 8;		//财神降临
		public static const Btn_DailyActivities:int = 9;	//每日必做(签到)
		public static const Btn_CorpsCitySys:int = 10;		//军团城市争夺战(王城争霸战)
		public static const Btn_FirstRecharge:int = 11;		//首充大礼
		public static const Btn_TeamFB:int = 12;			//组队副本
		public static const Btn_Sanguozhanchang:int = 13;	//三国战场
		public static const Btn_Huodonglibao:int = 14;		//活动礼包
		public static const Btn_TenpercentGiftbox:int = 15;	//一折大礼包		
		public static const Btn_WorldBoss:int = 16;			//世界Boss
		public static const Btn_TreasureHunting:int = 17;	//寻宝
		public static const Btn_BenefitHall:int = 18;		//福利大厅
		public static const Btn_SGQunyinghui:int = 19;		//三国群英会
		public static const Btn_Shoucangli:int = 20;	//收藏游戏		
		public static const Btn_Questionnaire:int = 21;	//调查问卷
		public static const Btn_MysteryShop:int = 22;	//神秘商店
		public static const Btn_PaoShang:int = 23;	//跑商
		public static const Btn_RechargeRebate:int = 24;	//充值返利
		public static const Btn_VipTiYan:int = 25;	//VIP体验
		public static const Btn_CorpsTreasure:int = 26;	//军团夺宝
		public static const Btn_DTRechargeRebate:int = 27;	//充值返利
		
		public static const Btn_COUNT_MAX:int = 28;	//屏幕上方功能按钮总数
		
		
		/*功能图标类型，用于 showActivityIconUserCmd 消息中的 type字段
		enum {
			ICON_NONE,
			ICON_CORPSFIGHT,
			ICON_ROB_RESOURCE_COPY,
			ICON_RECHARGE_BACK,
			ICON_VIP_PRACTICE, //vip体验
			ICON_DT_RECHARGE_BACK, //定时版充值返利
			ICON_CORPSTREASURE, //军团夺宝活动
		};*/
		public static const ICON_NONE:uint = 0;
		public static const ICON_CORPSFIGHT:uint = 1;			//王城争霸
		public static const ICON_ROB_RESOURCE_COPY:uint = 2;	//三国战场
		public static const ICON_RECHARGE_BACK:uint = 3;	//充值返利
		public static const ICON_VIP_PRACTICE:uint = 4;		//vip体验  
		public static const ICON_DT_RECHARGE_BACK:uint = 5;	//定时版充值返利
		public static const ICON_CORPSTREASURE:uint = 6;	//军团夺宝
		
		//按钮右上角数字背景类型
		public static const LBLCNTBGTYPE_Red:int = 0;			//红色背景
		public static const LBLCNTBGTYPE_Blue:int = 1;			//蓝色背景
		
		private var m_gkContext:GkContext;
		public var m_showActIconList:Array;
		
		private var m_bShowUIScreenBtn:Boolean;	//true -表示显示UIScreenBtn界面应该显示出来
		
		public function ScreenBtnMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_showActIconList = new Array();
			m_bShowUIScreenBtn = true;
		}
		
		public function hideUIScreenBtn():void
		{
			m_bShowUIScreenBtn = false;
			m_gkContext.m_UIMgr.hideForm(UIFormID.UIScreenBtn);			
		}
		
		public function showUIScreenBtn():void
		{
			m_bShowUIScreenBtn = true;
			if (m_gkContext.m_UIMgr.hasForm(UIFormID.UIScreenBtn))
			{
				m_gkContext.m_UIMgr.showForm(UIFormID.UIScreenBtn);
			}
		}
		
		//推迟到地图加载完毕后，再显示界面
		public function showUIScreenBtnAfterMapLoad():void
		{
			m_bShowUIScreenBtn = true;		
		}
		
		public function get isShowUIScreenBtn():Boolean
		{
			return m_bShowUIScreenBtn;
		}
		
		//根据功能type获得功能按钮id
		public static function getBtnId(type:uint):int
		{
			var id:int = -1;
			switch(type)
			{
				case SysNewFeatures.NFT_CANBAOKU:
					id = Btn_CANGBAOKU;
					break;
				case SysNewFeatures.NFT_ZHANYITIAOZHAN:
					id = Btn_EliteBarrier;
					break;
				case SysNewFeatures.NFT_JIUGUAN:
				case SysNewFeatures.NFT_BAOWUROB:
					id = Btn_Jiuguan;
					break;
				case SysNewFeatures.NFT_JINGJICHANG:
					id = Btn_Arena;
					break;
				case SysNewFeatures.NFT_TRIALTOWER:
					id = Btn_Guoguanzhanjiang;
					break;
				case SysNewFeatures.NFT_XUANSHANG:
					id = Btn_Xuanshangrenwu;
					break;
				case SysNewFeatures.NFT_CAISHENDAO:
					id = Btn_IngotBefall;
					break;
				case SysNewFeatures.NFT_TEAMCOPY:
					id = Btn_TeamFB;
					break;
				case SysNewFeatures.NFT_MEIRIBIZUO:
					id = Btn_DailyActivities;
					break;
				case SysNewFeatures.NFT_SANGUOZHANCHANG:
					id = Btn_Sanguozhanchang;
					break;
				case SysNewFeatures.NFT_FIRSTCHARGEGIFTBOX:
					id = Btn_FirstRecharge;
					break;
				case SysNewFeatures.NFT_TENPERCENTGIFTBOX:
					id = Btn_TenpercentGiftbox;
					break;
				case SysNewFeatures.NFT_WORLDBOSS:
					id = Btn_WorldBoss;
					break;
				case SysNewFeatures.NFT_CITYBATTLE:
					id = Btn_CorpsCitySys;
					break;
				case SysNewFeatures.NFT_TREASUREHUNTING:
					id = Btn_TreasureHunting;
					break;
				case SysNewFeatures.NFT_WELFAREHALL:
					id = Btn_BenefitHall;
					break;
				case SysNewFeatures.NFT_COLLECTGIFT:
					id = Btn_Shoucangli;
					break;
				case SysNewFeatures.NFT_SGQUNYINGHUI:
					id = Btn_SGQunyinghui;
					break;
				case SysNewFeatures.NFT_SECRETSTORE:
					id = Btn_MysteryShop;
					break;
				case SysNewFeatures.NFT_PAOSHANG:
					id = Btn_PaoShang;
					break;
				case SysNewFeatures.NFT_VIPPRACTICE:
					id = Btn_VipTiYan;
					break;
				case SysNewFeatures.NFT_CORPSTREASURE:
					id = Btn_CorpsTreasure;
					break;
				default:
					break;
			}
			
			return id;
		}
		
		public function moveToNpcOfCorpsCitySys():void
		{
			// 走向 Npc
			// 数据一致存在，直到下一次数据清理掉，因为可能访问 npc 中被打断，然后再次继续访问
			var cmd:notifyCorpsNpcIDUserCmd = m_gkContext.m_contentBuffer.getContent("notifyCorpsNpcIDUserCmd", false) as notifyCorpsNpcIDUserCmd;
			var ui:IUITaskTrace = m_gkContext.m_UIs.taskTrace;
			if(cmd && ui)
			{
				ui.gotoFunc(cmd.x, cmd.y, MapInfo.MAPID_CHANGAN, cmd.npcid);
			}
		}
		
	}

}