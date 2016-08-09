package modulecommon.commonfuntion 
{
	import com.util.DebugBox;
	import com.util.UtilCommon;
	import modulecommon.scene.jiuguan.JiuguanMgr;
	import modulecommon.scene.market.stMarket;
	import modulecommon.ui.Form;
	import modulecommon.uiinterface.IUIBackPack;
	import modulecommon.uiinterface.IUIMountsSys;
	//import flash.geom.Point;
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.questUserCmd.stReqOpenXuanShangQuestUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stYetOpenNewFunctionUserCmd;
	import modulecommon.net.msg.sceneHeroCmd.stReqRicherAndEnemyListCmd;
	import modulecommon.net.msg.trialTowerCmd.stReqTrialTowerUIInfo;
	//import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.equipsys.EquipSysMgr;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author 
	 */
	public class SysNewFeatures 
	{
		/*
		//新功能开启
		enum eNewFunctionType 
		{
			NFT_NONE = 0,
			NFT_XINGMAI = 1,    //血魂珠(星脉)
			NFT_ZHENFA  = 2,    //阵法
			NFT_JIUGUAN = 3,    //酒馆
			NFT_DAZAO   = 4,    //打造
			NFT_JINGJICHANG = 5,    //竞技场
			NFT_CANBAOKU = 6,   //藏宝窟
			NFT_ZHANYITIAOZHAN = 7, //战役挑战
			NFT_TRIALTOWER = 8, //试练塔(过关斩将)
			NFT_XUANSHANG = 9,  //悬赏
			NFT_QIANYAN = 10,   //钱眼
			NFT_WUJIANGJIHUO = 11,  //武将激活
			NFT_JINNANG = 12,   //锦囊
			NFT_HEROREBIRTH = 13,	//武将转生
			NFT_GEMEMBED    = 14,   //宝石镶嵌
			NFT_EQUIPXILIAN = 15,   //装备洗炼
			NFT_EQUIPDECOMPOSE = 16,    //装备分解
			NFT_EQUIPCOMPOSE  = 17,     //装备合成
			NFT_CAISHENDAO = 18,	//财神降临
			NFT_DAZUO = 19, //打坐
			NFT_FHLIMIT4 = 20,  //阵法中上阵人数四人
			NFT_FHLIMIT5 = 21,  //阵法中上阵人数五人
			NFT_HEROXIAYE = 22, //武将下野
			NFT_FRIENDSYS = 23, //好友系统
			NFT_HEROTRAIN = 24, //武将培养
			NFT_TEAMCOPY = 25,  		//组队副本
			NFT_EQUIPADVANCE = 26,  	//装备进阶
			NFT_JUNTUAN = 27,   		//军团
			NFT_MEIRIBIZUO = 28,    	//每日必做
			NFT_SANGUOZHANCHANG = 29,   //三国战场
			NFT_ZHANXING = 30,			//占星
			NFT_FIRSTCHARGEGIFTBOX = 31,//首充礼包
			NFT_TENPERCENTGIFTBOX = 32，//一折大礼包
			NFT_BAOWUROB = 33,			//宝物抢夺
			NFT_WORLDBOSS = 34,			//世界boss
			NFT_CITYBATTLE = 35,    	//王城争霸战
			NFT_TONGQUETAI = 36,    	//铜雀台
			NFT_MOUNT = 37, 			//坐骑
			NFT_EQUIPLEVELUP = 38,  	//装备升级
			NFT_GODLYWEAPON = 39,		//神兵系统
			NFT_TREASUREHUNTING = 40,   //寻宝
			NFT_WELFAREHALL = 41,		//福利大厅
			NFT_RANK:int = 42;			// 排行榜
			NFT_GETGUANZHI = 43,    //领取官职
			NFT_COLLECTGIFT = 44,   //收藏大礼
			NFT_SGQUNYINGHUI = 45,  //三国群英会
			NFT_SECRETSTORE = 46,   //神秘商店
			NFT_PAOSHANG = 47,  //  跑商
			NFT_USERACTRELAIONS = 48,   //主角激活关系
			NFT_CHARGEREBACK = 49,  //充值返利	(最初定义错误，该类型客户端去掉，不在使用，但保留，以确保后加类型不会出错)
			NFT_VIPPRACTICE = 50,   //vip体验
			NFT_CORPSTREASURE = 51, //军团夺宝
			NFT_MAX,
		};
		*/
		public static const NFT_NONE:int = 0;
		public static const NFT_XINGMAI:int = 1;
		public static const NFT_ZHENFA:int = 2;
		public static const NFT_JIUGUAN:int = 3;
		public static const NFT_DAZAO:int = 4;
		public static const NFT_JINGJICHANG:int = 5;
		public static const NFT_CANBAOKU:int = 6;
		public static const NFT_ZHANYITIAOZHAN:int = 7;
		public static const NFT_TRIALTOWER:int = 8;
		public static const NFT_XUANSHANG:int = 9;
		public static const NFT_QIANYAN:int = 10;
		public static const NFT_WUJIANGJIHUO:int = 11;
		public static const NFT_JINNANG:int = 12;
		public static const NFT_HEROREBIRTH:int = 13;
		public static const NFT_GEMEMBED:int = 14;
		public static const NFT_EQUIPXILIAN:int = 15;
		public static const NFT_EQUIPDECOMPOSE:int = 16;
		public static const NFT_EQUIPCOMPOSE:int = 17;
		public static const NFT_CAISHENDAO:int = 18;
		public static const NFT_DAZUO:int = 19;
		public static const NFT_FHLIMIT4:int = 20;
		public static const NFT_FHLIMIT5:int = 21;
		public static const NFT_HEROXIAYE:int = 22;
		public static const NFT_FRIENDSYS:int = 23;
		public static const NFT_HEROTRAIN:int = 24;
		public static const NFT_TEAMCOPY:int = 25;
		public static const NFT_EQUIPADVANCE:int = 26;
		public static const NFT_JUNTUAN:int = 27;
		public static const NFT_MEIRIBIZUO:int = 28;
		public static const NFT_SANGUOZHANCHANG:int = 29;
		public static const NFT_ZHANXING:int = 30;
		public static const NFT_FIRSTCHARGEGIFTBOX:int = 31;
		public static const NFT_TENPERCENTGIFTBOX:int = 32;
		public static const NFT_BAOWUROB:int = 33;
		public static const NFT_WORLDBOSS:int = 34;
		public static const NFT_CITYBATTLE:int = 35;
		public static const NFT_TONGQUETAI:int = 36;
		public static const NFT_MOUNT:int = 37;
		public static const NFT_EQUIPLEVELUP:int = 38;
		public static const NFT_GODLYWEAPON:int = 39;
		public static const NFT_TREASUREHUNTING:int = 40;
		public static const NFT_WELFAREHALL:int = 41;
		public static const NFT_RANK:int = 42;
		public static const NFT_GETGUANZHI:int = 43;
		public static const NFT_COLLECTGIFT:int = 44;
		public static const NFT_SGQUNYINGHUI:int = 45;
		public static const NFT_SECRETSTORE:int = 46;
		public static const NFT_PAOSHANG:int = 47;
		public static const NFT_USERACTRELAIONS:int = 48;
		public static const NFT_CHARGEREBACK:int = 49;
		public static const NFT_VIPPRACTICE:int = 50;
		public static const NFT_CORPSTREASURE:int = 51;
		public static const NFT_MAX:int = 52;
		
		//通过任务追踪打开某一功能界面(非通过开启新功能开启功能)
		
		//酒馆相关功能
		public static const FUNC_GAMBLE:int = 103;			//赌博界面
		public static const FUNC_JIUGUANPURPLE:int = 203;	//紫武将显示界面
		public static const FUNC_RecruitWu:int = 1003;		//招募武将
		
		//好友相关功能
		public static const FUNC_AddFriend:int = 1002;		//添加加好友(好友界面、添加好友界面)
		
		//军团相关功能
		public static const FUNC_CorpsLottery:int = 1027;	//军团抽奖
		public static const FUNC_CorpsMarket:int = 2027;	//军团商城
		
		//神兵相关功能
		public static const FUNC_GWSkillTrain:int = 1039;	//号令天下
		
		//与“开启新功能”无关的功能界面 >10000
		//商城相关
		public static const FUNC_MarketRemai:int = 10001;	//商城-热卖
		public static const FUNC_MarketRongyu:int = 10002;	//商城-荣誉商城
		
		//人物界面相关
		public static const FUNC_UIBackPack:int = 20001;		//人物界面
		
		public var m_nft:int = NFT_NONE; //表示当前引导是哪个功能的引导
		private var m_gkContext:GkContext;
		private var m_sysNewFeatures:Vector.<uint>;
		
		public function SysNewFeatures(gk:GkContext) 
		{
			m_gkContext = gk;
			var size:int = int((NFT_MAX + UtilCommon.UNITSIZE - 1) / UtilCommon.UNITSIZE);
			m_sysNewFeatures = new Vector.<uint>(size);
		}
		
		public function init(msg:ByteArray):void
		{
			DebugBox.addLog("收到新功能开启状态列表");			
			var rev:stYetOpenNewFunctionUserCmd = new stYetOpenNewFunctionUserCmd();
			rev.deserialize(msg);
			
			for (var i:int = 0; i < m_sysNewFeatures.length; i++)
			{
				m_sysNewFeatures[i] = msg.readUnsignedInt();
			}
			/*
			m_gkContext.m_UIMgr.loadForm(UIFormID.UiSysBtn);
			m_gkContext.m_UIMgr.loadForm(UIFormID.UIScreenBtn);
			
			if (m_gkContext.m_taskpromptMgr.isShowUITaskPrompt())
			{
				if (false == m_gkContext.m_taskpromptMgr.m_bLoadConfig)
				{
					m_gkContext.m_taskpromptMgr.initData();
				}
				m_gkContext.m_UIMgr.loadForm(UIFormID.UITaskPrompt);
			}*/
		}
		
		public function setType(id:int):void
		{
			UtilCommon.setState(m_sysNewFeatures, id);
		}
		
		public function isSet(id:int):Boolean
		{
			if (id > 100)
			{
				id = id % 100;
			}
			return UtilCommon.isSet(m_sysNewFeatures, id);
		}
		
		//打开某一功能界面,进入某一功能场景 return: true-需打开界面已打开 false-相关功能未开启或没有
		public function openOneFuncForm(funcid:int):Boolean
		{
			if (NFT_EQUIPCOMPOSE == funcid && isSet(NFT_GEMEMBED))
			{
				//装备合成功能，同装备洗炼功能一起开放
			}
			else if ((funcid < 10000) && !isSet(funcid))
			{
				m_gkContext.m_systemPrompt.prompt("该功能还未开启");
				return false;
			}
			
			if (m_gkContext.m_mapInfo.m_isInFuben
				&& (NFT_CANBAOKU == funcid || NFT_TRIALTOWER == funcid || NFT_SANGUOZHANCHANG == funcid || NFT_TEAMCOPY == funcid))
			{
				//副本中，不可再进其他副本:藏宝库、过关斩将、三国战场、组队副本
				m_gkContext.m_mapInfo.promptInFubenDesc();
				return false;
			}
			
			var formID:uint = 0;
			var ret:Boolean = false;
			var form:Form = null;
			
			switch (funcid)
			{
				case NFT_GEMEMBED: 
				case NFT_EQUIPXILIAN: 
				case NFT_EQUIPDECOMPOSE: 
				case NFT_EQUIPCOMPOSE: 
				case NFT_EQUIPADVANCE:
				case NFT_EQUIPLEVELUP:
				case NFT_DAZAO: 
				{					
					m_gkContext.m_equipSysMgr.setOpenPage(EquipSysMgr.getPageIdByFuncID(funcid));
					formID = UIFormID.UIEquipSys;
					break;
				}
				case NFT_XINGMAI:
					if (false == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIXingMai))
					{
						m_gkContext.m_UIMgr.showFormWidthProgress(UIFormID.UIXingMai);
					}
					ret = true;
					break;
				case NFT_ZHENFA:
					if (false == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIZhenfa))
					{
						m_gkContext.m_UIMgr.showFormWidthProgress(UIFormID.UIZhenfa);
					}
					ret = true;
					break;
				case NFT_JIUGUAN:
				case FUNC_JIUGUANPURPLE:
				{
					if (FUNC_JIUGUANPURPLE == funcid)
					{
						m_gkContext.m_jiuguanMgr.setOpenPage(JiuguanMgr.WU_PURPLE);//3 紫将界面
					}
					formID = UIFormID.UIJiuGuan;
					break;
				}
				case FUNC_GAMBLE:
					formID = UIFormID.UIGamble;
					break;
				case NFT_CANBAOKU: 
					m_gkContext.m_cangbaokuMgr.reqEnterCangbaoku();
					ret = true;
					break;
				case NFT_ZHANYITIAOZHAN: 
					m_gkContext.m_elitebarrierMgr.reqEnterJBoss();
					ret = true;
					break;
				case NFT_XUANSHANG: 
				{
					if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIXuanShangRenWu) == false)
					{
						var send2:stReqOpenXuanShangQuestUserCmd = new stReqOpenXuanShangQuestUserCmd();
						m_gkContext.sendMsg(send2);
					}
					ret = true;
					break;
				}
				case NFT_JINGJICHANG: 
				{
					if (m_gkContext.m_cangbaokuMgr.inCangbaoku)
					{
						m_gkContext.m_systemPrompt.prompt("该地图无法进入竞技场");
					}
					else
					{
						m_gkContext.m_arenaMgr.enterArena();
						ret = true;
					}
					break;
				}
				case NFT_TRIALTOWER: 
				{
					if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIGuoguanzhanjiang) == false)
					{
						var send3:stReqTrialTowerUIInfo = new stReqTrialTowerUIInfo();
						m_gkContext.sendMsg(send3);
					}
					ret = true;
					break;
				}
				case NFT_BAOWUROB:
				{
					if (null == m_gkContext.m_wuMgr.getWuByHeroID(1440))
					{
						var cmd:stReqRicherAndEnemyListCmd = new stReqRicherAndEnemyListCmd();
						cmd.m_baowuId = m_gkContext.m_jiuguanMgr.getBaowuByWuid(144);	//默认抢夺“刘备”相关宝物
						m_gkContext.sendMsg(cmd);
					}
					
					m_gkContext.m_jiuguanMgr.setOpenPage(JiuguanMgr.WU_PURPLE);//3紫将界面
					formID = UIFormID.UIJiuGuan;
					break;
				}
				case NFT_CAISHENDAO:
					formID = UIFormID.UIIngotBefall;
					break;
				case NFT_FHLIMIT4:
				case NFT_FHLIMIT5:
					if (false == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIZhenfa))
					{				
						m_gkContext.m_UIMgr.showFormWidthProgress(UIFormID.UIZhenfa);
					}
					ret = true;
					break;
				case NFT_JUNTUAN:
				{
					if (m_gkContext.m_corpsMgr.hasCorps)
					{
						m_gkContext.m_corpsMgr.openPage();
					}
					else
					{
						if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UICorpsLst) == true)
						{
							m_gkContext.m_UIMgr.exitForm(UIFormID.UICorpsLst);
						}
						else
						{
							m_gkContext.m_UIMgr.showFormEx(UIFormID.UICorpsLst);							
						}
					}
					ret = true;
					break;
				}
				case FUNC_CorpsLottery:
					if (m_gkContext.m_corpsMgr.hasCorps)
					{
						m_gkContext.m_corpsMgr.openPage();
						formID = UIFormID.UICorpsLottery;
					}
					else
					{
						m_gkContext.m_systemPrompt.prompt("请先加入军团");
					}
					break;
				case FUNC_CorpsMarket:
					if (m_gkContext.m_corpsMgr.hasCorps)
					{
						m_gkContext.m_corpsMgr.openPage();
						m_gkContext.m_marketMgr.openUICorpsMarket();
						ret = true;
					}
					else
					{
						m_gkContext.m_systemPrompt.prompt("请先加入军团");
					}
					break;
				case FUNC_AddFriend:
				{
					if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIFndLst) == false)
					{
						m_gkContext.m_UIMgr.loadForm(UIFormID.UIFndLst);
					}
					formID = UIFormID.UIFndAdd;
					break;
				}
				case NFT_TEAMCOPY:
					if (false == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UITeamFBSys))
					{
						m_gkContext.m_teamFBSys.clkBtn = true;
						m_gkContext.m_UIMgr.createFormInGame(UIFormID.UITeamFBSys);
					}
					ret = true;
					break;
				case NFT_MEIRIBIZUO:
					//
					break;
				case NFT_SANGUOZHANCHANG:
					if (false == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UISanguoZhangchangEnter))
					{
						form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UISanguoZhangchangEnter);
						form.show();
					}
					ret = true;
					break;
				case NFT_ZHANXING:
					formID = UIFormID.UIZhanxing;
					break;
				case NFT_FIRSTCHARGEGIFTBOX:
					formID = UIFormID.UIFirstRecharge;
					break;
				case NFT_TENPERCENTGIFTBOX:
					formID = UIFormID.UIYizhelibao;
					break;
				case NFT_WORLDBOSS:
					m_gkContext.m_worldBossMgr.reqEnterWorldBoss();
					ret = true;
					break;
				case NFT_CITYBATTLE:
					m_gkContext.m_systemPrompt.prompt("client 王城争霸战");
					break;
				case FUNC_MarketRemai:
					m_gkContext.m_marketMgr.openUIMarket();
					ret = true;
					break;
				case FUNC_MarketRongyu:
					m_gkContext.m_marketMgr.openUIMarket(stMarket.TYPE_Rongyu)
					ret = true;
					break;
				case NFT_TONGQUETAI:
					if (false == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UITongQueWuHui))
					{
						form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UITongQueWuHui);
						form.show();
					}
					ret = true;
					break;
				case NFT_MOUNT:
				{
					var mountssys:IUIMountsSys = m_gkContext.m_UIMgr.getForm(UIFormID.UIMountsSys) as IUIMountsSys;
					var uimounts:Form;
					var uishouhun:Form;
					if (!mountssys)
					{
						m_gkContext.m_mountsSysLogic.btnClkLoadModuleMode = true;
						m_gkContext.m_UIMgr.loadForm(UIFormID.UIMountsSys);
					}
					else if(mountssys && mountssys.isResReady())
					{
						uimounts = m_gkContext.m_UIMgr.getForm(UIFormID.UIMounts);
						uishouhun = m_gkContext.m_UIMgr.getForm(UIFormID.UIShouHun);
						if (!uimounts && !uishouhun)
						{
							mountssys.showCCSUI(UIFormID.UIMounts);
						}
					}
					ret = true;
					break;
				}
				case NFT_GODLYWEAPON:
				case FUNC_GWSkillTrain:
					if (FUNC_GWSkillTrain == funcid && (true == m_gkContext.m_godlyWeaponMgr.bOpenGWSkilltrain))
					{
						m_gkContext.m_godlyWeaponMgr.m_bShowUIGWSkill = true;
					}
					formID = UIFormID.UIGodlyWeapon;
					break;
				case NFT_TREASUREHUNTING:
					if (false == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UITreasureHunt))
					{
						form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UITreasureHunt);
						form.show();
					}
					ret = true;
					break;
				case NFT_WELFAREHALL:
					if (false == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIBenefitHall))
					{
						form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIBenefitHall);
						form.show();
					}
					ret = true;
					break;
				case NFT_SGQUNYINGHUI:
					m_gkContext.m_systemPrompt.prompt("三国群英会");//亲，不用了请删除我，谢谢
					break;
				case NFT_SECRETSTORE:
					if (false == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIMysteryShop))
					{
						form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIMysteryShop);
						form.show();
					}
					ret = true;
					break;
				case NFT_PAOSHANG:
					m_gkContext.m_systemPrompt.prompt("跑商");//亲，不用了请删除我，谢谢
					break;
				case NFT_WUJIANGJIHUO:
				case NFT_HEROREBIRTH:
				case NFT_USERACTRELAIONS:
				case NFT_HEROTRAIN:
				case FUNC_UIBackPack:
					var iuibackpack:IUIBackPack = m_gkContext.m_UIMgr.getForm(UIFormID.UIBackPack) as IUIBackPack;
					if (iuibackpack && iuibackpack.isVisible())
					{						
						if (m_gkContext.m_sysbtnMgr.m_bShowPackage)
						{
							m_gkContext.m_sysbtnMgr.m_bShowPackage = false;
							iuibackpack.onShowRelationWuPanel();
							iuibackpack.onShowPackage();
						}
					}
					else
					{
						if (iuibackpack)
						{
							iuibackpack.show();
						}
						else
						{
							m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIBackPack);
						}
					}
					ret = true;
					break;
				case NFT_HEROXIAYE:
					formID = UIFormID.UIWuXiaye;
					break;
				case NFT_FRIENDSYS:
					formID = UIFormID.UIFndLst;
					break;
				case NFT_VIPPRACTICE:
					m_gkContext.m_systemPrompt.prompt("vip体验");//亲，不用了请删除我，谢谢
					break;
				case NFT_CORPSTREASURE:
					m_gkContext.m_systemPrompt.prompt("军团夺宝");//亲，不用了请删除我，谢谢
					break;
				default:
					formID = 0;
			}
			
			if (formID)
			{
				if (m_gkContext.m_UIMgr.isFormVisible(formID) == false)
				{
					m_gkContext.m_UIMgr.showFormEx(formID);
				}
				
				return true;
			}
			
			if (ret)
			{
				return true;
			}
			
			return false;
		}
		
	}

}