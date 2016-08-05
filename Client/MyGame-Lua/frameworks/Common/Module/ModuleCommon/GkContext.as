package modulecommon
{	
	import com.dncompute.canvas.BrowserCanvas;
	import com.pblabs.engine.debug.Logger;
	import com.util.DebugBox;
	import com.util.IDAllocator;
	import com.util.UtilCommon;
	import flash.events.ErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import modulecommon.commonfuntion.PreLoadInIdleTimeProcess;
	import modulecommon.login.INetISP;
	import modulecommon.scene.corpsduobao.CorpsDuobaoMgr;
	import net.http.HttpCmdBase;
	import modulecommon.net.msg.sgQunYingCmd.stNotifyCrossServerIsReadyCmd;
	import modulecommon.net.msg.sgQunYingCmd.stReqCrossServerDataCmd;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	import modulecommon.scene.benefithall.jlzhaohui.JLZhaoHuiMgr;
	import modulecommon.scene.benefithall.LimitBigSendAct.LimitBagSendMgr;
	import modulecommon.scene.benefithall.peoplerank.PeopleRankMgr;
	import modulecommon.scene.benefithall.qiridenglu.QiridengluMgr;
	import modulecommon.scene.benefithall.rebate.RechargeRebateMgr;
	import modulecommon.scene.dtrebate.DTRechargeRebateMgr;
	import modulecommon.scene.herorally.HeroRallyMgr;
	import modulecommon.scene.qasys.QasysMgr;
	import modulecommon.scene.watch.GmWatchMgr;
	import modulecommon.time.DingshiqiMgr;
	import modulecommon.ui.Form;
	import org.ffilmation.engine.helpers.fOffList;
	import org.ffilmation.engine.helpers.fUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import common.Context;
	import common.IGKContext;
	import common.net.msg.basemsg.stNullUserCmd;
	import common.net.msg.basemsg.t_NullCmd;
	
	import modulecommon.appcontrol.UIFocus;
	import modulecommon.appcontrol.UIMapSwitchEffect;
	import modulecommon.appcontrol.UIMenu;
	import modulecommon.appcontrol.UIPlayAni;
	import modulecommon.appcontrol.menu.UIMenuEx;
	import modulecommon.commonfuntion.ConfirmDialogMgr;
	import modulecommon.commonfuntion.HintMgr;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.commonfuntion.NewHandMgr;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.commonfuntion.SysOptions;
	import modulecommon.commonfuntion.systemprompt.SystemPrompt;
	import modulecommon.commonfuntion.TipDefault;
	import modulecommon.commonfuntion.delayloader.DelayLoaderMgr;
	import modulecommon.commonfuntion.imloader.ModuleResLoader;
	import modulecommon.commonfuntion.systemprompt.SystemPromptMulti;
	import modulecommon.commonfuntion.systempromt_bottom.SystemPrompt_Bottom;
	import modulecommon.fun.NewhandFun;
	import modulecommon.logicinterface.ICBUIEvent;
	import modulecommon.logicinterface.ICorpsCitySys;
	
	import modulecommon.logicinterface.IGiftPackMgr;
	import modulecommon.logicinterface.ISceneLogic;
	import modulecommon.logicinterface.ITeamFBSys;
	
	import net.ContentBuffer;
	import modulecommon.net.msg.MsgInfo;
	
	import modulecommon.scene.CommonProcess;
	import modulecommon.scene.MapInfo;
	import modulecommon.scene.antiaddiction.AntiAddictionMgr;
	import modulecommon.scene.arena.ArenaMgr;
	import modulecommon.scene.beings.BeingEntityClientMgr;
	import modulecommon.scene.beings.FObjectManager;
	import modulecommon.scene.beings.IMountsShareData;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.beings.NpcManager;
	import modulecommon.scene.beings.PlayerFakeMgr;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.beings.PlayerManager;
	import modulecommon.scene.cangbaoku.CangbaokuMgr;
	import modulecommon.scene.benefithall.dailyactivities.DailyactivitiesMgr;
	import modulecommon.scene.dazuo.DaZuoMgr;
	import modulecommon.scene.elitebarrier.EliteBarrierMgr;
	import modulecommon.scene.equipsys.EquipSysMgr;
	import modulecommon.scene.equipsys.xilianconfig.XilianshiConfig;
	import modulecommon.scene.fight.BattleMgr;
	import modulecommon.scene.fight.ZhenfaMgr;
	import modulecommon.scene.gamble.GambleMgr;
	import modulecommon.scene.gm.GMMgr;
	import modulecommon.scene.godlyweapon.GodlyWeaponMgr;
	import modulecommon.scene.guanguanzhanjiang.GgzjMgr;
	import modulecommon.scene.hero.AttrBufferMgr;
	import modulecommon.scene.ingotbefall.IngotBefallMgr;
	import modulecommon.scene.jiuguan.JiuguanMgr;
	import modulecommon.scene.market.MarketMgr;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.CommonData;
	import modulecommon.scene.prop.ITableManager;
	import modulecommon.scene.prop.MainPro;
	import modulecommon.scene.prop.dataXMl.commonXMl;
	import modulecommon.scene.prop.job.Soldier;
	import modulecommon.scene.prop.object.GemDrawTool;
	import modulecommon.scene.prop.object.ObjectMgr;
	import modulecommon.scene.prop.object.ObjectTool;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.relation.RelArmy;
	import modulecommon.scene.prop.skill.SkillDrawTool;
	import modulecommon.scene.prop.skill.SkillMgr;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TEffectItem;
	import modulecommon.scene.prop.table.TModelEffItem;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.scene.radar.RadarMgr;
	import modulecommon.scene.saodang.SaodangMgr;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.scene.sensitiveword.SensitiveWordMgr;
	import modulecommon.scene.sysbtn.SysbtnMgr;
	import modulecommon.scene.task.TaskManager;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	import modulecommon.scene.tongquetai.TongQueTaiMgr;
	import modulecommon.scene.treasurehunt.TreasureHuntMgr;
	import modulecommon.scene.vip.VipPrivilegeMgr;
	import modulecommon.scene.watch.WatchMgr;
	import modulecommon.scene.worldboss.WorldBossMgr;
	import modulecommon.scene.wu.WuMgr;
	import modulecommon.scene.xingmai.XingmaiMgr;
	import modulecommon.scene.xmlloader.XmlLoaderMgr;
	import modulecommon.scene.yizhelibao.YizhelibaoMgr;
	import modulecommon.scene.yugaogongneng.YugaoGongnengMgr;
	import modulecommon.scene.zhanchang.SanguoZhanChangMgr;
	import modulecommon.scene.zhanliupgrade.ZhanliUpgradeMgr;
	import modulecommon.scene.zhanxing.ZhanxingMgr;
	import modulecommon.scene.benefithall.welfarepackage.WelfarePackageMgr;
	
	import modulecommon.ui.UIFormID;
	import modulecommon.ui.UIManager;
	import modulecommon.ui.UIPathFunc;
	import modulecommon.uiinterface.IUIChat;
	import modulecommon.uiinterface.IUITip;
	import modulecommon.uiinterface.UIs;
	
	import network.IWorldHandler;
	import org.ffilmation.engine.helpers.fActDirOff;
	import modulecommon.logicinterface.IRankSys;
	import modulecommon.logicinterface.IMountsSysLogic;
	import modulecommon.logicinterface.ISceneUILogic;
	import modulecommon.logicinterface.IVipTY;
	import modulecommon.commonfuntion.MsgRoute;
	
	/**
	 * ...
	 * @author
	 * @brief 上层逻辑全局变量，仅仅是上层逻辑需要用到的
	 */
	public class GkContext implements IGKContext
	{
		public var m_context:Context;
		public var m_battleLight:Number;
		public var m_UIMgr:UIManager;
		public var m_cbUIEvent:ICBUIEvent;
		
		//登陆方面的数据
		

		
		//主动重置大小
		public var m_canvas:BrowserCanvas;
		private var m_bCrossserverDataReady:Boolean;	//跨服
		// 各个模块之间通信的函数	
		public var m_sceneSocket:IWorldHandler;	// 这个是客户端和服务器通信的主要 socket 
		
		
		//public var m_terrainManager:ITerrainManager;
		//public var m_sceneState:int = EntityCValue.SSIniting;
		//public var m_count:Number = 0;
		
		public var m_sceneLogic:ISceneLogic; // 场景逻辑处理  	 		
		public var m_beingProp:BeingProp; // 所有 hero 属性 
		public var m_wuMgr:WuMgr;
		public var m_zhenfaMgr:ZhenfaMgr;
		public var m_tblMgr:ITableManager; // 表管理器，表基本都存放在这里
		public var m_dataTable:DataTable; //tbl表
		public var m_dataXml:DataXml; //xml数据
		public var m_taskMgr:TaskManager;
		public var m_skillMgr:SkillMgr;
		public var m_playerManager:PlayerManager;
		public var m_beingEntityClientMgr:BeingEntityClientMgr;
		public var m_playerFakeMgr:PlayerFakeMgr;
		public var m_npcBattleBaseMgr:NpcBattleBaseMgr;
		public var m_fobjManager:FObjectManager;
		public var m_objMgr:ObjectMgr;		 
		public var m_contentBuffer:ContentBuffer; //用于缓存一些东西, 其key必须保证与其它模块不同，
		public var m_objectTool:ObjectTool;
		public var m_skillDrawTool:SkillDrawTool; //画技能Icon的工具
		public var m_gemDrawTool:GemDrawTool;	
		
		
		public var m_unloadModuleF:Function; // 卸载模块函数 
		
		public var m_mapInfo:MapInfo;
		public var m_uiChat:IUIChat;
		public var m_uiTip:IUITip; //tips
		public var m_uiMenu:UIMenu; //菜单
		public var m_uiMenuEx:UIMenuEx; //菜单
		private var m_uiPlayAni:UIPlayAni;
		public var m_uiMapSwitchEffect:UIMapSwitchEffect;
		public var m_UIs:UIs;
		public var m_newhandFun:NewhandFun;
		public var m_mainPro:MainPro;
		public var m_commonData:CommonData;
		public var m_Solder:Soldier;
		public var m_xingmaiMgr:XingmaiMgr;
		public var m_jiuguanMgr:JiuguanMgr;
		public var m_cangbaokuMgr:CangbaokuMgr;
		public var m_arenaMgr:ArenaMgr;
		public var m_systemPrompt:SystemPrompt;
		public var m_systemPromptMulti:SystemPromptMulti;
		public var m_systemPromptBottom:SystemPrompt_Bottom;
		
		public var m_sysOptions:SysOptions;
		public var m_confirmDlgMgr:ConfirmDialogMgr;
		
		public var m_UIPath:UIPathFunc;
		public var m_elitebarrierMgr:EliteBarrierMgr;
		public var m_hintMgr:HintMgr;
		public var m_newHandMgr:NewHandMgr;
		public var m_uiFocus:UIFocus;
		public var m_localMgr:LocalDataMgr;
		public var m_xilianConfig:XilianshiConfig;
		public var m_xmlLoader:XmlLoaderMgr;
		public var m_npcManager:NpcManager;
		
		public var m_ggzjMgr:GgzjMgr;
		public var m_sysnewfeatures:SysNewFeatures;
		public var m_saodangMgr:SaodangMgr;
		public var m_screenbtnMgr:ScreenBtnMgr;
		public var m_zhanliupgradeMgr:ZhanliUpgradeMgr;
		public var m_sysbtnMgr:SysbtnMgr;
			
		public var m_quitFight:Function; // 退出战斗调用的消息  
		public var m_bTestScript:Boolean = false;
		
		protected var m_stageMouseChildrenCount:int;	//记录stage被锁的次数
		public var m_delayLoader:DelayLoaderMgr;
		
		//public var m_cbSceneLoad:ICBSceneLoad;	// 场景加载的各种回调
		
		public var m_strNpcTalkBuffer:String;	//记录日志内容
		public var m_battleMgr:BattleMgr;
		public var m_equipSysMgr:EquipSysMgr;
		public var m_watchMgr:WatchMgr;
		public var m_gmWatchMgr:GmWatchMgr;
		public var m_commonXML:commonXMl;
		public var m_taskpromptMgr:TaskPromptMgr;
		public var m_ingotbefallMgr:IngotBefallMgr;
		public var m_gambleMgr:GambleMgr;
		public var m_dazuoMgr:DaZuoMgr;
		public var m_dailyActMgr:DailyactivitiesMgr;
		public var m_marketMgr:MarketMgr;
		public var m_antiAddictionMgr:AntiAddictionMgr;	//防沉迷提示
		public var m_vipPrivilegeMgr:VipPrivilegeMgr;	//vip特权		
		public var m_sanguozhanchangMgr:SanguoZhanChangMgr;
		public var m_jlZhaoHuiMgr:JLZhaoHuiMgr;
		
		public var m_corpsMgr:RelArmy;	//军团管理器
		public var m_commonProc:CommonProcess;	//军团管理器
		public var m_SWMgr:SensitiveWordMgr;
		public var m_yugaoGongnengMgr:YugaoGongnengMgr;
		
		public var m_giftPackMgr:IGiftPackMgr;		// 礼包树立存放的地方
		public var m_dynamicFormIDAllocator:IDAllocator;
		
		public var m_teamFBSys:ITeamFBSys;			// 组队副本系统
		public var m_gmMgr:GMMgr;
		
		public var m_zhanxingMgr:ZhanxingMgr;
		public var m_attrBufferMgr:AttrBufferMgr;
		public var m_worldBossMgr:WorldBossMgr;
		public var m_radarMgr:RadarMgr;
		public var m_godlyWeaponMgr:GodlyWeaponMgr;	//神兵
		public var m_benefitHallMgr:BenefitHallMgr;
		public var m_heroRallyMgr:HeroRallyMgr;
		
		//public var m_removeLogo:Function;
		public var m_yizhelibaoMgr:YizhelibaoMgr;
		public var m_treasurehuntMgr:TreasureHuntMgr;
		public var m_tongquetaiMgr:TongQueTaiMgr;
		public var m_corpsCitySys:ICorpsCitySys;
		public var m_mountsShareData:IMountsShareData;
		
		// test:
		//public var m_fCB:Function;
		
		public var m_resLoader:ModuleResLoader;			// 这个是建立角色的资源
		public var m_LimitBagSendMgr:LimitBagSendMgr;
		public var m_rankSys:IRankSys;	// 排行榜
		public var m_qiridengluMgr:QiridengluMgr;
		public var m_peopleRankMgr:PeopleRankMgr;
		public var m_welfarePackageMgr:WelfarePackageMgr;
		public var m_rechargeRebateMgr:RechargeRebateMgr;
		public var m_dtRechargeRebateMgr:DTRechargeRebateMgr;
		public var m_qasysMgr:QasysMgr;
		public var m_netISP:INetISP;
		public var m_dingshiqiMgr:DingshiqiMgr;
		public var m_preLoadInIdleTimeProcess:PreLoadInIdleTimeProcess;
		
		public var m_mountsSysLogic:IMountsSysLogic;
		public var m_startLoadedCB:Function;
		public var m_startLoadingCB:Function;
		public var m_startFailedCB:Function;
		//public var m_HttpCom:IHttpCom;
		
		public var m_vipTY:IVipTY;
		
		public var m_sceneUILogic:ISceneUILogic; 	// 场景 UI 处理,处理 UI 中的玩家模型
		public var m_msgRoute:MsgRoute;			// 事件分发
		/**
		 * 军团夺宝管理器
		 */
		public var m_CorpsDuobaoMgr:CorpsDuobaoMgr;

		public function GkContext(context:Context)
		{
			m_context = context;
			m_xmlLoader = new XmlLoaderMgr(this);

			
			m_dataTable = new DataTable(this);
			m_dataXml = new DataXml(this);
			ZObject.dataTable = m_dataTable;
			ZObject.m_gkContext = this;
			m_taskMgr = new TaskManager(this);
			m_contentBuffer = new ContentBuffer();			
			m_objMgr = new ObjectMgr(this);
			
			m_playerFakeMgr = new PlayerFakeMgr(this);			
			m_wuMgr = new WuMgr(this);
			m_zhenfaMgr = new ZhenfaMgr(this);
			m_skillMgr = new SkillMgr(this);
			m_npcBattleBaseMgr = new NpcBattleBaseMgr(this);
			m_skillDrawTool = new SkillDrawTool(this);
			m_UIs = new UIs();
			m_newhandFun = new NewhandFun(this);
			m_mainPro = new MainPro();
			m_commonData = new CommonData(this);		
			m_Solder = new Soldier(this);
			m_xingmaiMgr = new XingmaiMgr(this);
			m_jiuguanMgr = new JiuguanMgr(this);
			m_cangbaokuMgr = new CangbaokuMgr(this);
			m_ggzjMgr = new GgzjMgr(this);
			m_arenaMgr = new ArenaMgr(this);
			m_systemPrompt = new SystemPrompt(this);
			m_systemPromptMulti = new SystemPromptMulti(this);
			m_systemPromptBottom = new SystemPrompt_Bottom(this);
			m_sysOptions = new SysOptions(this);
			m_confirmDlgMgr = new ConfirmDialogMgr(this);
			m_dtRechargeRebateMgr = new DTRechargeRebateMgr(this);
			
			m_UIPath = new UIPathFunc();	
			m_uiTip = new TipDefault();
			m_hintMgr = new HintMgr(this);
			m_sysnewfeatures = new SysNewFeatures(this);
			m_newHandMgr = new NewHandMgr(this);
			m_localMgr = new LocalDataMgr();
			m_saodangMgr = new SaodangMgr(this);
			m_xilianConfig = new XilianshiConfig(this);
			m_screenbtnMgr = new ScreenBtnMgr(this);		
			m_zhanliupgradeMgr = new ZhanliUpgradeMgr(this);
			m_sysbtnMgr = new SysbtnMgr();
			m_equipSysMgr = new EquipSysMgr(this);
			m_watchMgr = new WatchMgr(this);
			m_gmWatchMgr = new GmWatchMgr(this);
			m_elitebarrierMgr = new EliteBarrierMgr(this);
			
			m_commonXML = new commonXMl(this);
			m_taskpromptMgr = new TaskPromptMgr(this);
			m_ingotbefallMgr = new IngotBefallMgr(this);
			m_gambleMgr = new GambleMgr(this);
			m_dazuoMgr = new DaZuoMgr(this);
			m_corpsMgr = new RelArmy(this);
			m_commonProc = new CommonProcess(this);
			m_dynamicFormIDAllocator = new IDAllocator();
			m_dynamicFormIDAllocator.beginID = UIFormID.UIDynamicBegin;
			m_dynamicFormIDAllocator.endID = UIFormID.UIDynamicEnd;
			m_dailyActMgr = new DailyactivitiesMgr(this);
			m_marketMgr = new MarketMgr(this);
			
			m_SWMgr = new SensitiveWordMgr();			
			m_vipPrivilegeMgr = new VipPrivilegeMgr(this);
			m_sanguozhanchangMgr = new SanguoZhanChangMgr(this);
			m_yugaoGongnengMgr = new YugaoGongnengMgr(this);
			m_jlZhaoHuiMgr = new JLZhaoHuiMgr(this);
			m_gmMgr = new GMMgr(this);
			m_zhanxingMgr = new ZhanxingMgr(this);
			m_attrBufferMgr = new AttrBufferMgr(this);
			m_yizhelibaoMgr = new YizhelibaoMgr(this); 
			m_treasurehuntMgr = new TreasureHuntMgr(this);
			m_tongquetaiMgr = new TongQueTaiMgr(this);
			m_worldBossMgr = new WorldBossMgr(this);
			m_radarMgr = new RadarMgr(this);
			m_godlyWeaponMgr = new GodlyWeaponMgr(this);
			m_benefitHallMgr = new BenefitHallMgr(this);
			m_LimitBagSendMgr = new LimitBagSendMgr(this);
			m_qiridengluMgr = new QiridengluMgr(this);
			m_heroRallyMgr = new HeroRallyMgr(this);
			m_peopleRankMgr = new PeopleRankMgr(this);
			m_welfarePackageMgr = new WelfarePackageMgr(this);
			m_rechargeRebateMgr = new RechargeRebateMgr(this);
			m_qasysMgr = new QasysMgr(this);
			m_dingshiqiMgr = new DingshiqiMgr(this);
			m_preLoadInIdleTimeProcess = new PreLoadInIdleTimeProcess(this);
			m_msgRoute = new MsgRoute();
			m_CorpsDuobaoMgr = new CorpsDuobaoMgr(this);
		}
		
		public function sendMsg(cmd:t_NullCmd):void
		{		
			m_context.sendMsg(cmd);
		}
		
		public function get playerMain():PlayerMain
		{
			return m_playerManager.hero;
		}
		public function get uiFocus():UIFocus
		{
			if (m_uiFocus == null)
			{
				m_uiFocus = new UIFocus();
				m_UIMgr.addForm(m_uiFocus);
			}
			return m_uiFocus;
		}
		// 这个是从人物表中取连接偏移
		public function linkOff(beingid:uint, effid:uint):Point
		{
			// 有的地方取最大值,导致出现一个框
			// var offpt:Point = this.m_scene.engine.m_context.linkOff(uint.MAX_VALUE, fUtil.modelInsNum(eff.m_insID));
			if(beingid != uint.MAX_VALUE)
			{
				var item:TModelEffItem = m_dataTable.getItem(DataTable.TABLE_MODELEFF, beingid) as TModelEffItem
				if(item)
				{
					if(item.m_EffOffDic[effid])
					{
						return item.m_EffOffDic[effid];
					}
				}
			}
			
			// 从特效表中获取
			var effitem:TEffectItem = m_dataTable.getItem(DataTable.TABLE_EFFECT, effid) as TEffectItem;
			if(effitem)
			{
				return effitem.m_effOff;
			}
			return null;
		}
		
		public function getTagHeight(beingid:uint):int
		{
			var item:TModelEffItem = m_dataTable.getItem(DataTable.TABLE_MODELEFF, beingid) as TModelEffItem
			if(item)
			{
				return item.m_tagHeight;
			}
			
			return 0;
		}
		
		public function getLink1fHeight(beingid:uint):int
		{
			var item:TModelEffItem = m_dataTable.getItem(DataTable.TABLE_MODELEFF, beingid) as TModelEffItem
			if(item)
			{
				return item.m_link1fHeight;
			}
			
			return 0;
		}
		
		public function modelOffAll(beingid:uint):fActDirOff
		{
			var item:TModelEffItem = m_dataTable.getItem(DataTable.TABLE_MODELEFF, beingid) as TModelEffItem
			if(item)
			{
				return item.m_ModelActDirOff;
			}
			
			return null;
		}
		
		public function modelMountserOffAll(beingid:uint):fActDirOff
		{
			var item:TModelEffItem = m_dataTable.getItem(DataTable.TABLE_MODELEFF, beingid) as TModelEffItem
			if(item)
			{
				return item.m_mounterActDirOff;
			}
			
			return null;
		}
		
		public function modelOff(beingid:uint, act:uint, dir:uint):Point
		{
			var ret:Point;
			var item:TModelEffItem = m_dataTable.getItem(DataTable.TABLE_MODELEFF, beingid) as TModelEffItem
			if(item)
			{
				// 现在都取 第 0 个动作，第 0 个方向的偏移，应该这样都行，如果每一个动作的每一个方向都需要单独配置就崩溃了
				//return item.m_ModelOffDic["00"];
				
				var keyOff:String = this.m_context.m_SObjectMgr.m_actDir2Key[act][dir];
				
				if(keyOff && item.m_ModelActDirOff)
				{
					var offList:fOffList = item.m_ModelActDirOff.m_ModelOffDic[keyOff];
					if (offList)
					{
						if (offList.m_offLst.length)
						{
							ret = offList.m_offLst[0];
						}
					}
				}
			}
			
			return ret;
		}
		
		// 获取模型动作帧率
		public function modelFrameRate(beingid:uint):Dictionary
		{
			var item:TModelEffItem = m_dataTable.getItem(DataTable.TABLE_MODELEFF, beingid) as TModelEffItem
			if(item)
			{
				// 现在都取 第 0 个动作，第 0 个方向的偏移，应该这样都行，如果每一个动作的每一个方向都需要单独配置就崩溃了
				return item.m_actFrameRateDic;
			}
			
			return null;
		}
		
		// 从特效基本表中获取可缩放特效的帧数
		public function effFrame(effid:uint):int
		{
			// 从特效表中获取
			var effitem:TEffectItem = m_dataTable.getItem(DataTable.TABLE_EFFECT, effid) as TEffectItem;
			if(effitem)
			{
				return effitem.m_frame;
			}
			return 0;
		}
		
		// 从特效基本表中获取可缩放特效每一帧的缩放数据
		public function effFrame2scale(effid:uint):Dictionary
		{
			// 从特效表中获取
			var effitem:TEffectItem = m_dataTable.getItem(DataTable.TABLE_EFFECT, effid) as TEffectItem;
			if(effitem)
			{
				return effitem.m_frame2scale;
			}
			return null;
		}
		
		public function set stageMouseChildren(bFlag:Boolean):void
		{
			if (bFlag == false)
			{
				if (m_stageMouseChildrenCount == 0)
				{
					m_context.m_mainStage.mouseChildren = false;					
				}
				m_stageMouseChildrenCount++;
			}
			else
			{
				if (m_stageMouseChildrenCount > 0)
				{
					m_stageMouseChildrenCount --;
					if (m_stageMouseChildrenCount == 0)
					{
						m_context.m_mainStage.mouseChildren = true;
					}
				}
			}
		}
		
		// 添加这两个函数主要是为了 context 中可以访问到
		// 替换占位资源的加载,有些资源可能在别的地方才能知道需要加载的资源代的名字，这个时候就需要占位名字，等真正知道了再替换掉
		// 进度条资源加载成功
		public function progResLoaded(path:String):void
		{
			m_context.progLoading.progResLoaded(path);
		}
		
		public function progLoadingaddResName(path:String):void
		{
			m_context.progLoading.addResName(path);
		}
		
		// 进度条资源加载失败
		public function progResFailed(path:String):void
		{
			m_context.progLoading.progResFailed(path);
		}
		
		// 进度条资源加载进度
		public function progResProgress(path:String, percent:Number):void
		{
			m_context.progLoading.progResProgress(path, percent);
		}
		
		// 进度条资源加载开始
		public function progResStarted(path:String):void
		{
			m_context.progLoading.progResStarted(path);
		}
		
		// 添加进度条需要加载的资源
		public function addProgLoadResPath(path:String):void
		{
			//m_UIs.progLoading.addProgLoadResPath(path);
			m_context.progLoading.addResName(path);
		}
		
		// 环形进度条资源加载进度
		public function circleResProgress(path:String, percent:Number):void
		{
			m_UIs.circleLoading.progResProgress(path, percent);
		}
		
		// 进度条资源加载开始
		public function circleResStarted(path:String):void
		{
			m_UIs.circleLoading.progResStarted(path);
		}
		
		// 启动进度条显示
		public function startprogResLoaded(path:String):void
		{
			if (m_startLoadedCB)
			{
				m_startLoadedCB(path);
			}
		}

		public function startprogResProgress(path:String, percent:Number):void
		{
			if (m_startLoadingCB)
			{
				m_startLoadingCB(path, percent);
			}
		}
		
		public function startprogResFailed(path:String):void
		{
			if (m_startFailedCB)
			{
				m_startFailedCB(path);
			}
		}
		
		public function get curMapID():uint
		{
			return m_mapInfo.curMapID;
		}
		
		public function get bInBattleIScene():Boolean
		{
			return m_mapInfo.m_bInBattleIScene;
		}
		
		public function get versonForOut():Boolean
		{
			return m_context.m_config.m_versionForOutNet;
		}
		// 失去焦点
		public function onLoseFocus():void
		{
			var player:PlayerMain = this.playerMain;
			if (player)
			{
				//player.stopMoving();
			}
			
			//m_context.m_processManager.toggleTimer(EntityCValue.TMTimer);
		}
		 
		// 获取焦点
		public function onHasFocus():void
		{
			//m_context.m_processManager.toggleTimer(EntityCValue.TMFrame);
		}
		
		public function hideTipOnMouseOut(event:MouseEvent):void
		{
			m_uiTip.hideTip();
		}
		
		public function addLog(str:String):void
		{      
			m_context.addLog(str);
		}
		
		
		public function getMoreGameInfo(httpCmd:HttpCmdBase):void
		{
			var level:int;
			var mapID:int;
			var bScene:Boolean;
			if (m_mapInfo)
			{
				mapID = m_mapInfo.m_servermapconfigID;
			}
			
			var player:PlayerMain = playerMain;
			if (player)
			{
				httpCmd.m_datadic["charid"] = player.charID;
				httpCmd.m_datadic["name"] = player.name;
				level = player.level;
				if (player.scene)
				{
					bScene = true;
				}
			}
			else
			{
				httpCmd.m_datadic["charid"] = 0;
				httpCmd.m_datadic["name"] = "";
			}	
			
			var errorLog:String = fUtil.keyValueToString("level", level, "mapID", mapID, "bScene", bScene);
			httpCmd.m_datadic["error"] += errorLog;
		}
		public function addInfoInUIChat(str:String):void
		{
			if (m_localMgr.isSet(LocalDataMgr.LOCAL_GM_ShowLogInUIChat) == false)
			{
				return;
			}
			m_uiChat.debugMsg(str);
		}
		
		public function bPrintMsgName(b:Boolean):void
		{
			if (m_context.m_bPrintMsgName != b)
			{
				m_context.m_bPrintMsgName = b;
				MsgInfo.initMsg();
			}
		}
		public function get uiPlayAni():UIPlayAni
		{
			if (m_uiPlayAni == null)
			{
				m_uiPlayAni = new UIPlayAni();
				m_UIMgr.addForm(m_uiPlayAni);
			}
			return m_uiPlayAni;
		}
		
		public function playMsc(mscid:uint, loopCount:int=1):void
		{
			m_commonProc.playMsc(mscid, loopCount);
		}
		
		public function get isCOMMONSET_CLIENT_DebugBoxSet():Boolean
		{
			return m_sysOptions.isSet(SysOptions.COMMONSET_CLIENT_DebugBox);
		}
		
		public function progLoading_isState(state:uint):Boolean
		{
			return m_context.progLoading.isState(state);
		}
		
		
		public function onNetWorkDropped(type:int):void
		{
			if (m_UIMgr.isGameUIInit==false)
			{
				return;
			}
			
			var form:Form = m_UIMgr.getForm(UIFormID.UINetWorkDropped);
				//如果掉线(提示)界面已经出现，则不再更新其内容
				if (form == null)
				{
					form = m_UIMgr.showFormInGame(UIFormID.UINetWorkDropped);
					form.updateData(type);
				}
		}
		public function process_stNotifyCrossServerIsReadyCmd(msg:ByteArray, aaa:uint):void
		{
			if (m_bCrossserverDataReady)
			{
				addLog("再次收到stNotifyCrossServerIsReadyCmd");
				return;
			}
			
			//m_gkContext.addLog("收到stNotifyCrossServerIsReadyCmd: ready="+rev.m_bCrossserverReady);
			var rev:stNotifyCrossServerIsReadyCmd = new stNotifyCrossServerIsReadyCmd();
			rev.deserialize(msg);
			if (rev.m_bCrossserverReady == false)
			{
				return;
			}
			m_bCrossserverDataReady = true;
			var send:stReqCrossServerDataCmd = new stReqCrossServerDataCmd();
			sendMsg(send);		
			
		}	
		
		
		public function isSetLocalFlags(flag:uint):Boolean
		{
			return m_localMgr.isSet(flag);
		}
		
		public function onPreloaded():void
		{
			m_dataXml.setRes(m_context.m_preLoad.m_xmlSWF);
			m_dataTable.loadInitTable(m_context.m_preLoad.m_tableSWF);
			
			m_objectTool = new ObjectTool(this);
			m_objectTool.init();
			m_gemDrawTool = new GemDrawTool(this);
			m_gemDrawTool.init();
			
			m_UIs.circleLoading.loadSwfRes();
			// 加载全局的配置文件
			m_playerManager.loadModelCfgOnlyOne();
			m_playerManager.loadEffCfgOnlyOne();
			
			if (!m_context.m_platformMgr.byLoginplatform)
			{				
				m_UIMgr.loadForm(UIFormID.UILogin);				
			}

		}		
		
		//玩家上线时，看到场景
		public function onIntoScene():void
		{
			this.m_delayLoader.bStarted = true;
		}
	}
}