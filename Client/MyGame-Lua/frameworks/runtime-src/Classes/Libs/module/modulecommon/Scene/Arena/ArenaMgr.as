package modulecommon.scene.arena 
{
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EffectEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.entity.TerrainEntity;
	import modulecommon.commonfuntion.SysOptions;
	import modulecommon.net.msg.guanZhiJingJiCmd.stNotifyClearGuanZhiNameCmd;
	import modulecommon.net.msg.guanZhiJingJiCmd.stNotifyGuanZhiNameCmd;
	import modulecommon.net.msg.guanZhiJingJiCmd.stNotifyNineGuanZhiNameCmd;
	import modulecommon.net.msg.guanZhiJingJiCmd.stReq30RankListCmd;
	import modulecommon.net.msg.guanZhiJingJiCmd.stReqGetGuanzhiCmd;
	import modulecommon.scene.beings.PlayerArena;
	import modulecommon.scene.dazuo.DaZuoMgr;
	import modulecommon.scene.hero.AttrBufferMgr;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import modulecommon.GkContext;
	//import modulecommon.net.msg.guanZhiJingJiCmd.CharItem;
	import modulecommon.net.msg.guanZhiJingJiCmd.notifyThreeFixedCharIDUserCmd;
	import modulecommon.net.msg.guanZhiJingJiCmd.stReqOpenGuanZhiJingJiUserCmd;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	import modulecommon.time.Daojishi;
	import com.util.UtilTools;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	import modulecommon.uiinterface.IUIArenaStarter;
	import modulecommon.uiinterface.IUIGZJJChallenge;
	import modulecommon.uiinterface.IUIRadar;
	
	import org.ffilmation.engine.core.fScene;
	
	/**
	 * ...
	 * @author 
	 */
	public class ArenaMgr
	{
		public static const InArean_NotIn:int = 0;	//没有在竞技场
		public static const InArean_StartUpIn:int = 1;		//已启动进入，但地图还未加载完
		public static const InArean_In:int = 2;	//已经进入，且地图已加载完
		public static const InArean_StartUpOut:int = 3;	//已启动进入，但场景地图还未加载完毕
		
		public static const REWARDDAY:uint = 0;		//日奖励
		public static const REWARDWEEK:uint = 1;	//周奖励
		public static const PKMAXCOUNT:uint = 10;	//每日挑战总次数
		
		//俸禄领取状态
		public static const SALARYSTATE_NONE:int = -1;			//无俸禄
		public static const SALARYSTATE_RECEIVED:int = 0;		//已领取
		public static const SALARYSTATE_NORECEIVED:int = 1;		//未领取
		
		private var m_gkContext:GkContext;
		private var m_playerMainPosInGame:Point;	//记录主角在游戏场景中的位置
		private var m_playerMainAngleInGame:Number;   //记录主角在游戏场景中的位置
		private var m_daojishi:Daojishi;
		private var m_leftTimes:uint;		// 距离下次挑战的冷却时间
		private var m_arenaSalaryInfo:Object;		//官职信息：官职名、银币、将魂
		
		public var m_pkCount:int;			// 今日已挑战次数(官职竞技)
		public var m_effList:Vector.<EffectEntity>;	// 现在创建一个随机玩家,就是这个特效
		public var m_playerList:Vector.<BeingEntity>;	// 玩家列表
		private var m_mainPlayer:PlayerArena;	//	主角
		public var m_ptList:Vector.<Point>;		// 位置信息
		public var m_dayTipDataList:Vector.<TipData>;	//日奖箱子Tips数据
		public var m_weekTipDataList:Vector.<TipData>;	//周奖箱子Tips数据
		public var m_bHavedDatas:Boolean;		//是否已经读取数据
		public var m_mainPlayerRank:uint;		//主角排名
		
		protected var m_bInMap:int;	// 是否进入竞技场地图	
		
		public function ArenaMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_effList = new Vector.<EffectEntity>();
			m_playerList = new Vector.<BeingEntity>();
			m_dayTipDataList = new Vector.<TipData>();
			m_weekTipDataList = new Vector.<TipData>();
			m_bHavedDatas = false;
			
			m_ptList = new Vector.<Point>(4, true);
			m_ptList[0] = new Point(947, 572);	// 玩家 1
			m_ptList[1] = new Point(855, 493);	// 玩家 2
			m_ptList[2] = new Point(1057,657);	// 玩家 3
			m_ptList[3] = new Point(1143, 513);	// 这个是特效的位置
		}
		
		public function dayRefresh():void
		{
			m_pkCount = 0;
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_Arena, -1, leftPkCounts);
			}
			
			if (m_gkContext.m_UIs.screenBtn)
			{
				m_gkContext.m_UIs.screenBtn.updateLblCnt(leftPkCounts, ScreenBtnMgr.Btn_Arena);
			}
			
			//清除官职名称
			if (m_gkContext.playerMain)
			{
				m_gkContext.playerMain.guanzhiName = "";				
			}
			
			m_arenaSalaryInfo = null;
			m_gkContext.m_sysOptions.clear(SysOptions.COMMONSET_GET_GUANZHI);//该状态在早7:00，仅客户端重置，重新登录，服务器会更新
			
			var form:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaSalary);
			if (form)
			{
				form.updateData(m_arenaSalaryInfo);
			}
		}
		public function setPKCount(count:int):void
		{
			m_pkCount = count;
			//if(m_gkContext.m_mapInfo.m_bInArean)
			//{
			//	createRival();
			//}
			
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaStarter) as IForm;
			if (form)
			{
				form.updateData();
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_Arena, -1, leftPkCounts);
			}
			
			if (m_gkContext.m_UIs.screenBtn)
			{
				m_gkContext.m_UIs.screenBtn.updateLblCnt(leftPkCounts, ScreenBtnMgr.Btn_Arena);
			}
		}
		
		//pk次数
		public function get pkCount():int
		{
			return m_pkCount;
		}
		
		//今日pk剩余次数
		public function get leftPkCounts():int
		{
			return PKMAXCOUNT - m_pkCount;
		}
		
		//在官职竞技场中，我的对手是几个人, 1或3
		public function get numOfRivalsInArena():int
		{
			if (m_pkCount < (PKMAXCOUNT + 1))
			{
				return 1;
			}
			else
			{
				return 3;
			}
		}
		
		//进入竞技场，且竞技场地图加载完毕后，调用此函数
		public function gotoArena():void
		{
			// 尽量先把相机位置放到正确的位置，然后再创建各种资源
			// 摄像机放在指定位置就行了
			m_gkContext.m_context.m_sceneView.curCamera(EntityCValue.SCUI).gotoPos(960, 510, 0);
			
			if (m_playerMainPosInGame == null)
			{
				m_playerMainPosInGame = new Point();
			}
			
			
			//创建对手模型(特效)
			createRandom();
			m_bInMap = InArean_In;			
			
			// 如果这个消息在进入地图之前发送过来,就在这处理
			var msg:ByteArray = m_gkContext.m_contentBuffer.getContent("arean_notifyThreeFixedCharIDUserCmd", true) as ByteArray;
			if(msg)
			{
				parseMsg(msg);
			}
		}
		
		/*
		public function createRival():void
		{
			var cnt:int = numOfRivalsInArena;
			// 创建特效
			var terEnt:TerrainEntity;
			var idx:int;
			terEnt = m_gkContext.m_context.m_terrainManager.terrainEntityByScene(m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCUI));
			var ptList:Vector.<Point> = new Vector.<Point>(3, true);
			ptList[0] = new Point(1110, 440);
			ptList[1] = new Point(980, 360);
			ptList[2] = new Point(1240, 520);
			
			idx = m_effList.length;
			if(m_effList.length <= cnt)	// 添加
			{
				while(idx < cnt)
				{
					m_effList.push(terEnt.addGroundEffectByID("e4_e11290", ptList[idx].x, ptList[idx].y));
					m_effList[idx].bFlip = EntityCValue.FLPX;
					++idx;
				}
			}
			else		// 删除
			{
				
				while(idx > cnt)
				{
					// 删除地形特效
					terEnt.disposeGroundEff(m_effList[idx - 1]);
					m_effList.splice(idx - 1, 1);
					--idx;
				}
			}
		}
		*/
		
		// 创建随机
		public function createRandom():void
		{
			// 创建特效
			var terEnt:TerrainEntity;
			var idx:int;
			terEnt = m_gkContext.m_context.m_terrainManager.terrainEntityByScene(m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCUI));

			if(m_effList.length == 0)	// 添加
			{
				m_effList.push(terEnt.addGroundEffectByID("e4_e11290", m_ptList[3].x, m_ptList[3].y));
				m_effList[idx].bFlip = EntityCValue.FLPX;
			}
		
			//创建主角模型
			if (m_mainPlayer==null)
			{
				var playerid:String = m_gkContext.m_context.m_playerResMgr.modelName(m_gkContext.playerMain.job, m_gkContext.playerMain.gender);
				m_mainPlayer = m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCUI).createCharacter(EntityCValue.TPlayerArena, playerid, 630, 580, 0, UtilTools.convS2CDir(7)) as PlayerArena;
				m_mainPlayer.name = m_gkContext.playerMain.name;
				m_mainPlayer.m_rank = mainPlayerRank;
				//m_mainPlayer.m_corpsName = m_gkContext.m_corpsMgr.m_corpsName;
				m_mainPlayer.updateNameDesc();
				m_gkContext.m_beingEntityClientMgr.addBeing(m_mainPlayer);
			}
			
			// 更新界面内容
			var uigzjj:IUIGZJJChallenge = m_gkContext.m_UIMgr.getForm(UIFormID.UIGZJJChallenge) as IUIGZJJChallenge;
			if(uigzjj)
			{
				uigzjj.updateUIBtn();
			}
		}
		
		//离开竞技场，在卸载竞技场地图前，调用此函数
		public function leaveArea():void
		{			
			if (m_mainPlayer)
			{
				m_gkContext.m_beingEntityClientMgr.destroyBeing(m_mainPlayer);				
				m_mainPlayer = null;
			}
			//移除对手模型
			m_effList.length = 0;
			
			// 删除玩家模型
			var player:PlayerArena;
			for each(player in m_playerList)
			{
				m_gkContext.m_beingEntityClientMgr.destroyBeing(player);				
			}
			
			
			m_playerList.length = 0;
			m_bInMap = InArean_StartUpOut;
			//m_ptList.length = 0;
		}
		//离开竞技场地图，并加载完新地图后，调用次含数
		public function onLeaveAreaAndAfterNewMapLoaded():void
		{
			m_gkContext.m_context.m_sceneView.followHero(m_gkContext.playerMain);
			m_bInMap = InArean_NotIn;
		}
		//首次进入竞技场，即通过点击屏幕上方竞技场按钮(或其他地方)进入竞技场界面
		public function enterArena():void
		{
			// 只有状态准备好了，才可以跳地图
			if(!m_gkContext.m_context.m_sceneView.isLoading)
			{
				// 进入场景，这个场景用完了就卸载了
				var nameFileName:String;
				
				m_gkContext.playerMain.stopMoving();
				m_gkContext.m_mapInfo.m_bInArean = true;
				nameFileName = m_gkContext.m_context.m_path.getPathByName("x" + m_gkContext.m_mapInfo.m_areanmapfilename + ".swf", EntityCValue.PHXMLTINS);
				m_gkContext.m_mapInfo.m_mapPathArean = nameFileName;
				m_gkContext.m_context.m_sceneView.gotoSceneUI(nameFileName, m_gkContext.m_mapInfo.m_areanSceneID);
				
				// 更新雷达信息
				var form:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIRadar);
				(form as IUIRadar).updateBtnRadar();
				
				//获取boxTips数据
				loadConfigOfBoxTipsDatas();
				
				var send:stReqOpenGuanZhiJingJiUserCmd = new stReqOpenGuanZhiJingJiUserCmd();
				m_gkContext.sendMsg(send);	
				
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIArenaWeekReward);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIArenaInfomation);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIArenaLadder);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIArenaStarter);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIGZJJChallenge);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIArenaSalary);
			}
			
			m_gkContext.m_screenbtnMgr.hideUIScreenBtn();
			m_gkContext.m_taskMgr.hideUITaskTrace();
			m_gkContext.m_UIMgr.hideForm(UIFormID.UITaskPrompt);
			
			//竞技场中，属性加成药水无效
			if (m_gkContext.m_UIs.hero)
			{
				m_gkContext.m_UIs.hero.updateBufferEnabled(AttrBufferMgr.TYPE_YAOSHUI, false);
			}
			
			//竞技场中，不能进行打坐修炼，取消打坐状态
			m_gkContext.m_dazuoMgr.setStateOfDaZuo(DaZuoMgr.STATE_NODAZUO);
		}
		
		public function updateColdTimeDaojishi(time:uint):void
		{
			m_leftTimes = time;
			if (0 == time)
			{
				if (m_daojishi)
				{
					m_daojishi.end();
				}
				
				uiUpdateLeftTimes();
			}
			else
			{
				if (m_daojishi == null)
				{
					m_daojishi = new Daojishi(m_gkContext.m_context);
				}
				m_daojishi.initLastTime = time * 1000;
				m_daojishi.funCallBack = updateDaoJiShi;
				m_daojishi.begin();
			}
		}
		
		private function updateDaoJiShi(d:Daojishi):void
		{
			if (m_daojishi.isStop())
			{
				m_leftTimes = 0;
				m_daojishi.end();
			}
			
			uiUpdateLeftTimes();
		}
		
		//更新官职晋级中开始按钮上的冷却时间
		private function uiUpdateLeftTimes():void
		{
			var form1:IUIArenaStarter = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaStarter) as IUIArenaStarter;
			if (form1)
			{
				form1.updateLeftTimes(leftTimes);
			}
			
			var form2:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaWeekReward) as IForm;
			if (form2)
			{
				form2.updateData();
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_Arena, leftTimes, -1);
			}
		}
		
		//获得开始挑战冷却时间
		public function get leftTimes():uint
		{
			if (0 == m_leftTimes)
			{
				return 0;
			}
			else
			{
				return m_daojishi.timeSecond;
			}
		}
		
		// 发送假玩家
		public function parseNotifyThreeFixedCharID(msg:ByteArray, param:uint):void
		{
			// error
			m_gkContext.addLog("收到 parseNotifyThreeFixedCharID 消息");
			
			if(!m_bInMap)
			{
				m_gkContext.m_contentBuffer.addContent("arean_notifyThreeFixedCharIDUserCmd", msg);
			}
			else
			{
				parseMsg(msg);
			}
		}
		
		//官职竞技中获得称号
		public function processNotifyGuanzhiNameUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:stNotifyGuanZhiNameCmd = new stNotifyGuanZhiNameCmd();
			rev.deserialize(msg);
			
			if (null == m_arenaSalaryInfo)
			{
				m_arenaSalaryInfo = new Object();
			}
			m_arenaSalaryInfo["guanzhi"] = rev.guanzhi;
			m_arenaSalaryInfo["yinbi"] = rev.yinbi;
			m_arenaSalaryInfo["jianghun"] = rev.jianghun;
			
			showGuanzhiName();
		}
		
		//清除官职竞技称号
		public function processNotifyClearGuanzhiNameUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:stNotifyClearGuanZhiNameCmd = new stNotifyClearGuanZhiNameCmd();
			rev.deserialize(msg);
			
			if (m_gkContext.playerMain)
			{
				m_gkContext.playerMain.guanzhiName = "";
			}
		}
		
		//发送官职名（领取附件后，上线时，若有官职发送)
		public function processNotifyNineGuanzhiNameUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:stNotifyNineGuanZhiNameCmd = new stNotifyNineGuanZhiNameCmd();
			rev.deserialize(msg);
			
			var player:PlayerArena = m_gkContext.m_playerManager.getBeingByTmpID(rev.m_tempid) as PlayerArena;
			if (player)
			{
				player.guanzhiName = rev.m_guanzhi;
			}
		}
		
		// 解析消息
		protected function parseMsg(msg:ByteArray):void
		{
			// 删除之前的模型
			var player:PlayerArena;
			var uigzjj:IUIGZJJChallenge = m_gkContext.m_UIMgr.getForm(UIFormID.UIGZJJChallenge) as IUIGZJJChallenge; 
			for each(player in m_playerList)
			{
				m_gkContext.m_beingEntityClientMgr.destroyBeing(player);		
				
				if (uigzjj)
				{
					uigzjj.removeBtn(player.tempid);
				}
			}
			m_playerList.length = 0;
			
			var rev:notifyThreeFixedCharIDUserCmd = new notifyThreeFixedCharIDUserCmd();
			rev.deserialize(msg);
			
			var idx:uint = 0;
			var playerid:String;
			
			var sc:fScene = m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCUI);
			var pt:Point;
			if (sc == null)
			{
				return;
			}
			while(idx < 3)
			{	
				playerid = m_gkContext.m_context.m_playerResMgr.modelName(rev.text[idx].job, rev.text[idx].sex);
				
				// error 
				if(!playerid)
				{
					m_gkContext.addLog("parseMsg消息 playerid 为 null");
				}
				
				player = sc.createCharacter(EntityCValue.TPlayerArena, playerid, m_ptList[idx].x, m_ptList[idx].y, 0, UtilTools.convS2CDir(3)) as PlayerArena;
				//player.charID = rev.text[idx].charid;
				player.m_rank = rev.text[idx].rank;
				player.name = rev.text[idx].name;
				player.tempid = rev.text[idx].tempid;
				player.gender = rev.text[idx].sex;		
				player.updateNameDesc();
				m_playerList.push(player);
				m_gkContext.m_beingEntityClientMgr.addBeing(player);
				
				++idx;
			}
			
			if(uigzjj)
			{
				uigzjj.updateUIBtn();
			}
		}
		
		//退出竞技场，关闭相关form，并显示屏幕中的部分ui界面 true:已退出arena  false:未退出
		public function exitArena():Boolean
		{
			// 只有场景加载完成，才能推出，否则太麻烦了，需要各种判断
			if (!m_gkContext.m_context.m_sceneView.isLoading)
			{
				m_gkContext.m_mapInfo.m_bInArean = false;
				
				// 关闭界面
				var form:Form;
				form = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaWeekReward);
				if (form)
				{
					form.exit();
				}
				form = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaInfomation);
				if (form)
				{
					form.exit();
				}
				form = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaLadder);
				if (form)
				{
					form.exit();
				}
				form = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaStarter);
				if (form)
				{
					form.exit();
				}
				form = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaBetialRank);
				if (form)
				{
					form.exit();
				}
				form = m_gkContext.m_UIMgr.getForm(UIFormID.UIGZJJChallenge);
				if (form)
				{
					form.exit();
				}
				form = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaSalary);
				if (form)
				{
					form.exit();
				}
				
				leaveArea();
				m_gkContext.m_context.m_sceneView.leaveSceneUI();
				
				m_gkContext.m_screenbtnMgr.showUIScreenBtn();		
				m_gkContext.m_taskMgr.showUITaskTrace();
				m_gkContext.m_UIMgr.showForm(UIFormID.UITaskPrompt);
				
				if (m_gkContext.m_UIs.hero)
				{
					m_gkContext.m_UIs.hero.updateBufferEnabled(AttrBufferMgr.TYPE_YAOSHUI, true);
				}
				
				return true;
			}
			
			return false;
		}
		
		//从guanzhijingji.xml配置文件中，读取相关数据:竞技场中箱子Tips显示内容
		public function loadConfigOfBoxTipsDatas():void
		{
			if (m_bHavedDatas)
			{
				return;
			}
			
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Guanzhijingji);
			parseXml(xml);
		}
		
		public function parseXml(xml:XML):void
		{
			var tipdata:TipData;
			var itemList:XMLList;
			var item:XML;
			
			itemList = (xml.child("weekreward")[0]).child("item");
			for each(item in itemList)
			{
				tipdata = new TipData();
				tipdata.tipsDataParseXml(item, REWARDWEEK);
				m_weekTipDataList.push(tipdata);
			}
			m_weekTipDataList.sort(compare);
			
			itemList = (xml.child("dayreward")[0]).child("item");
			for each(item in itemList)
			{
				tipdata = new TipData();
				tipdata.tipsDataParseXml(item, REWARDDAY);
				m_dayTipDataList.push(tipdata);
			}
			m_dayTipDataList.sort(compare);
			
			if (m_weekTipDataList.length && m_dayTipDataList.length)
			{
				m_bHavedDatas = true;
			}
		}
		
		//按照编号，从小到大 123...
		private function compare(a:TipData, b:TipData):int
		{
			if (a.id <= b.id)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		//获得箱子tips数据 type 0:日奖 1:周奖   rank:排名(1.2.3.4..) score:积分
		public function getTipData(type:int, rank:int, score:int):TipData
		{
			if (!m_bHavedDatas)
			{
				return null;
			}
			
			var ret:TipData = null;
			var item:TipData;
			var count:int;
			var i:int;
			if (REWARDWEEK == type)
			{
				if (rank <= 30)
				{
					ret = m_weekTipDataList[rank - 1];
				}
				else
				{
					count = m_weekTipDataList.length;
					for (i = 31; i < count; i++)
					{
						item = m_weekTipDataList[i];
						if (item.scoreVec[0] <= score && score <= item.scoreVec[1])
						{
							ret = item;
							break;
						}
					}
				}
			}
			else if (REWARDDAY == type)
			{
				for each(item in m_dayTipDataList)
				{
					if (item.scoreVec[0] <= score && score <= item.scoreVec[1])
					{
						ret = item;
					}
				}
			}
			
			return ret;
		}
		
		//通过"官职名"，获得该官职对应俸禄信息
		public function getTipDataByGuanzhi(guanzhi:String):TipData
		{
			if (!m_bHavedDatas)
			{
				return null;
			}
			
			var ret:TipData = null;
			var item:TipData;
			var i:int;
			
			for (i = 0; i < m_weekTipDataList.length; i++)
			{
				item = m_weekTipDataList[i];
				if (item.title == guanzhi)
				{
					ret = item;
					break;
				}
			}
			
			if (i == m_weekTipDataList.length)
			{
				ret = m_weekTipDataList[i - 1];
			}
			
			return ret;
		}
		
		public function get innMap():int
		{
			return m_bInMap;
		}
		
		//获得下一区间奖励数据
		public function getNextTipData(type:int, rank:int, score:int):TipData
		{
			if (!m_bHavedDatas)
			{
				return null;
			}
			
			var ret:TipData = null;
			var item:TipData;
			var count:int;
			var i:int;
			if ((REWARDWEEK == type) && (rank > 1))
			{
				if (rank <= 30)
				{
					ret = m_weekTipDataList[rank - 2];
				}
				else
				{
					count = m_weekTipDataList.length;
					for (i = 31; i < count; i++)
					{
						item = m_weekTipDataList[i];
						if (item.scoreVec[0] <= score && score <= item.scoreVec[1])
						{
							ret = m_weekTipDataList[i - 1];
							break;
						}
					}
				}
			}
			else if (REWARDDAY == type)
			{
				count = m_dayTipDataList.length;
				for (i = 0; i < count; i++)
				{
					item = m_dayTipDataList[i];
					if (item.scoreVec[0] <= score && score <= item.scoreVec[1])
					{
						if ((i + 1) < count)
						{
							ret = m_dayTipDataList[i + 1];
							break;
						}
					}
				}
			}
			
			return ret;
		}
		
		public function get weekTipDataList():Array
		{
			var ret:Array = new Array();
			
			for (var i:int = 0; i < m_weekTipDataList.length; i++)
			{
				ret.push(m_weekTipDataList[i]);
			}
			
			return ret;
		}
		
		//获得主角
		public function get mainPlayerRank():uint
		{
			return m_mainPlayerRank;
		}
		
		public function set mainPlayerRank(rank:uint):void
		{
			m_mainPlayerRank = rank;
			if (m_mainPlayer)
			{
				m_mainPlayer.m_rank = m_mainPlayerRank;
				m_mainPlayer.updateNameDesc();
			}
		}
		
		//显示官职名称
		public function showGuanzhiName():void
		{
			var guanzhi:String;
			if (m_arenaSalaryInfo && undefined != m_arenaSalaryInfo["guanzhi"])
			{
				guanzhi = m_arenaSalaryInfo["guanzhi"];
			}
			
			if (m_gkContext.m_sysOptions.isSet(SysOptions.COMMONSET_GET_GUANZHI) && guanzhi && m_gkContext.playerMain)
			{
				m_gkContext.playerMain.guanzhiName = guanzhi;
			}
			
			var form:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaSalary);
			if (form)
			{
				form.updateData(m_arenaSalaryInfo);
			}
			
			if (m_gkContext.m_UIs.screenBtn)
			{
				var bshow:Boolean = (SALARYSTATE_NORECEIVED == receiveSalaryState)? true: false;
				m_gkContext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_Arena, bshow);
			}
		}
		
		//官职名称、银币、将魂信息
		public function get arenaSalaryInfo():Object
		{
			return m_arenaSalaryInfo;
		}
		
		public function get isInArenea():Boolean
		{
			return m_bInMap == InArean_StartUpIn || m_bInMap == InArean_In;
		}
		
		//请求领取俸禄
		public function reqGetGuanzhi():void
		{
			var cmd:stReqGetGuanzhiCmd = new stReqGetGuanzhiCmd();
			m_gkContext.sendMsg(cmd);
		}
		
		//请求竞技场前30名信息
		public function req30RankList():void
		{
			var cmd:stReq30RankListCmd = new stReq30RankListCmd();
			m_gkContext.sendMsg(cmd);
			
			loadConfigOfBoxTipsDatas();
		}
		
		//俸禄领取状态：return = -1无俸禄/0已领取/1未领取
		public function get receiveSalaryState():int
		{
			var ret:int = SALARYSTATE_NONE;
			var guanzhi:String = null;
			
			if (m_arenaSalaryInfo && undefined != m_arenaSalaryInfo["guanzhi"])
			{
				guanzhi = m_arenaSalaryInfo["guanzhi"];
			}
			
			if (guanzhi && ("" != guanzhi))
			{
				if (m_gkContext.m_sysOptions.isSet(SysOptions.COMMONSET_GET_GUANZHI))
				{
					ret = SALARYSTATE_RECEIVED;
				}
				else
				{
					ret = SALARYSTATE_NORECEIVED;
				}
			}
			
			return ret;
		}
	}
}