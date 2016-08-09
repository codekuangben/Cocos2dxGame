package game
{
	//import com.pblabs.engine.debug.Logger;
	//import com.pblabs.engine.resource.SWFResource;
	//import common.Context;
	import com.pblabs.engine.entity.EntityCValue;
	import common.Context;
	import flash.display.Sprite;
	import flash.events.UncaughtErrorEvent;
	import game.logic.VipTY;
	import modulecommon.commonfuntion.SysOptions;
	import modulecommon.scene.prop.relation.stUBaseInfo;
	
	import flash.utils.ByteArray;
	
	import game.logic.GiftPackMgr;
	import game.logic.TeamFBSys;
	import game.netcb.GameNetHandle;
	import game.scene.GameSceneLogic;
	import game.ui.mgr.UIMgrForGame;
	
	import modulecommon.GkContext;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIArenaStarter;
	import modulecommon.uiinterface.IUICopiesAwards;
	import modulecommon.uiinterface.IUITurnCard;
	import game.logic.CorpsCitySys;
	import game.logic.RankSys;
	import game.logic.MountsSysLogic;
	import game.scene.GameSceneUILogic;
	import modulecommon.scene.zhanxing.ZStar;
	import modulecommon.scene.beings.NpcPlayerFake;
	import modulecommon.scene.beings.NpcVisit;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.beings.PlayerManager;
	import modulecommon.scene.beings.PlayerOther;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.TableManager;
	import modulecommon.scene.prop.object.GemDrawTool;
	import modulecommon.scene.prop.object.ObjectTool;
	import modulecommon.scene.MapInfo;
	import modulecommon.scene.SceneViewer;
	import modulecommon.scene.beings.BeingEntityClientMgr;
	import modulecommon.scene.beings.FObjectManager;
	import modulecommon.scene.beings.FallObjectEntity;
	import modulecommon.scene.beings.NpcManager;

	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.scene.beings.MountsShareData;
	import modulecommon.commonfuntion.delayloader.DelayLoaderMgr;
	import modulecommon.ui.UIManager;
	import modulecommon.ui.uiprog.UICircleLoading;
	import modulecommon.scene.fight.BattleMgr;
	import modulecommon.scene.beings.PlayerArena;
	import modulefight.ModuleFightRoot;
	import modulecommon.login.NetISP;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleGameRoot 
	{
		RegisterClass_Game;
		public var m_gkcontext:GkContext;
		public var m_context:Context;
		//public var m_rootSp:Sprite;
		
		public var m_sceneLogic:GameSceneLogic;		// 游戏模块不卸载了，这些变量也都不卸载了吧   
		
		
		public function ModuleGameRoot() 
		{
			
		}
		
		public function init(sp:Sprite):void		
		{
			m_gkcontext = new GkContext(m_context);
			
			m_context.gkcontext = m_gkcontext;
			ZStar.m_gkContext = m_gkcontext;
			stUBaseInfo.s_gkContext = m_gkcontext;
			m_gkcontext.m_contentBuffer = m_context.m_contentBuffer;
			
			sp.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, m_context.onUncaughtErrorHappened);
			m_context.m_typeReg.addClass(EntityCValue.TVistNpc, NpcVisit);
			//m_context.m_typeReg.addClass(EntityCValue.TBattleNpc, NpcBattle);
			m_context.m_typeReg.addClass(EntityCValue.TPlayer, PlayerOther);
			m_context.m_typeReg.addClass(EntityCValue.TPlayerMain, PlayerMain);
			m_context.m_typeReg.addClass(EntityCValue.TPlayerArena, PlayerArena);
			m_context.m_typeReg.addClass(EntityCValue.TFallObject, FallObjectEntity);
			m_context.m_typeReg.addClass(EntityCValue.TNpcPlayerFake, NpcPlayerFake);
			
			m_gkcontext.m_playerManager = new PlayerManager(m_gkcontext);
			m_gkcontext.m_beingEntityClientMgr = new BeingEntityClientMgr(m_gkcontext);
			//m_context.m_thingManager = new ThingManager(m_context);
			m_gkcontext.m_npcManager = new NpcManager(m_context);
			m_gkcontext.m_fobjManager = new FObjectManager(m_context);
			
			m_gkcontext.m_UIMgr = new UIManager(m_gkcontext)			
			m_context.getLay(Context.TLayUI).addChildAt(m_gkcontext.m_UIMgr as Sprite, 0);
			
			
			m_gkcontext.m_beingProp = new BeingProp();
			//m_context.m_tblMgr = new TableManager(m_context);
			m_gkcontext.m_tblMgr = new TableManager(m_gkcontext);
			m_gkcontext.m_battleMgr = new BattleMgr(m_gkcontext, new ModuleFightRoot(m_gkcontext));
			m_gkcontext.m_delayLoader = new DelayLoaderMgr(m_gkcontext);
			m_gkcontext.m_mapInfo = new MapInfo(m_gkcontext);
			m_context.m_sceneView = new SceneViewer(m_context.m_layList[Context.TLayScene], m_gkcontext);			
			
			
			m_gkcontext.m_netISP = new NetISP(m_gkcontext);
			m_gkcontext.m_UIs.circleLoading = new UICircleLoading();
			m_gkcontext.m_UIMgr.addForm(m_gkcontext.m_UIs.circleLoading);
			
			//m_gkcontext.m_removeLogo = removeLogo;
			m_gkcontext.m_mountsShareData = new MountsShareData(m_gkcontext);
			
			
			m_context.m_gameHandleMsg = new GameNetHandle(m_gkcontext);
			m_gkcontext.m_UIMgr.m_uiGgrForGame = new UIMgrForGame();
			
			//m_gkcontext.m_context.m_sceneView = new SceneViewer(m_gkcontext.m_context.m_layList[Context.TLayScene], m_gkcontext);	
			if (m_gkcontext.m_context.m_config.m_single)
			{
				//m_gkcontext.m_localData[GameEn.ENPath] = "asset/scene/xml/example1.xml";
				m_gkcontext.m_mapInfo.m_mapPath = "asset/scene/xml/example1.xml";
				m_gkcontext.m_context.m_sceneView.gotoScene("asset/scene/xml/example1.xml", 1000);
			}
			
			//m_gkcontext.m_UIMgr.loadForm(UIFormID.UINpcTalk);
			//m_gkcontext.m_UIMgr.loadForm(UIFormID.UIChat);
			
			// KBEN: 初始化全局变量 
			m_sceneLogic = new GameSceneLogic(m_gkcontext);			
			m_sceneLogic.init();
			m_gkcontext.m_sceneLogic = m_sceneLogic;
			
			this.m_gkcontext.m_quitFight = quitFightScene;
			
			// test: 加载声音
			//this.m_gkcontext.m_context.m_soundMgr.play("tst.mp3");
			
			// 礼包数据初化
			m_gkcontext.m_giftPackMgr = new GiftPackMgr(m_gkcontext);
			m_gkcontext.m_teamFBSys = new TeamFBSys(m_gkcontext);
			m_gkcontext.m_corpsCitySys = new CorpsCitySys(m_gkcontext);
			m_gkcontext.m_rankSys = new RankSys(m_gkcontext);
			m_gkcontext.m_mountsSysLogic = new MountsSysLogic(m_gkcontext);
			m_gkcontext.m_sceneUILogic = new GameSceneUILogic(m_gkcontext);
			m_gkcontext.m_vipTY = new VipTY(m_gkcontext);
		}		
		
		// 退出战斗场景调用这个函数         
		public function quitFightScene():void
		{
			// 停止战斗音乐
			var fightmapname:uint = 0;
			if(m_gkcontext.m_mapInfo.m_bInArean)
			{
				fightmapname = 9052;		// 如果从竞技场进入战斗地图,统一进入 9052 这个地图
				
				// 退出战斗,如果在竞技场,需要检查是否是最后一次战斗,需要请求邮件信息,显示奖励
				var form:IUIArenaStarter = this.m_gkcontext.m_UIMgr.getForm(UIFormID.UIArenaStarter) as IUIArenaStarter;
				if(0 == form.count)
				{
					m_gkcontext.m_radarMgr.reqMail();
				}
			}
			else
			{
				fightmapname = this.m_gkcontext.m_mapInfo.fightMapName;
			}
			
			// 停止主场景音乐
			var bgmusicname:String;
			if(!m_gkcontext.m_sysOptions.isSet(SysOptions.COMMONSET_CLIENT_LDSSound))
			{
				bgmusicname = m_gkcontext.m_battleMgr.getBattleMapMusic(fightmapname);
				if(bgmusicname.length)
				{
					this.m_gkcontext.m_context.m_soundMgr.stop(bgmusicname);
				}
				else
				{
					this.m_gkcontext.m_context.m_soundMgr.stop(EntityCValue.DFMusic);
				}
			}
			
			// 切换游戏场景，显示场景切换
			m_gkcontext.m_context.m_sceneView.leaveSceneFight();
			m_gkcontext.m_battleMgr.moduleFight.leave();
		
			// 恢复游戏模块场景逻辑  
			m_sceneLogic.m_gkcontext = m_gkcontext;
			m_sceneLogic.init();
			m_gkcontext.m_sceneLogic = m_sceneLogic;			
			
			m_gkcontext.m_UIMgr.resetGameUIEvent();
			
			// 播放主场景音乐
			if(!m_gkcontext.m_sysOptions.isSet(SysOptions.COMMONSET_CLIENT_LDSSound))
			{
				if(m_gkcontext.m_mapInfo.m_sceneMusic.length)
				{
					this.m_gkcontext.m_context.m_soundMgr.play(m_gkcontext.m_mapInfo.m_sceneMusic, EntityCValue.FXDft, 0.0, int.MAX_VALUE);
				}
			}
			
			// 处理退出战斗进入副本需要处理的内容
			// 副本通关奖励
			if(m_gkcontext.m_contentBuffer.getContent("uiCopiesAwards_end", false))
			{
				var uiawards:IUICopiesAwards = m_gkcontext.m_UIMgr.getForm(UIFormID.UICopiesAwards) as IUICopiesAwards;
				if(uiawards)
				{
					uiawards.parseCopyClearance(m_gkcontext.m_contentBuffer.getContent("uiCopiesAwards_end", true) as ByteArray);
				}
				else
				{
					m_gkcontext.m_UIMgr.loadForm(UIFormID.UICopiesAwards);
				}
			}
			// 转卡片.在竞技场中的翻拍奖励需要在战斗场景中显示这个奖励
			if(m_gkcontext.m_contentBuffer.getContent("uiCopyTurnCard_reward", false))
			{
				var ui:IUITurnCard = m_gkcontext.m_UIMgr.getForm(UIFormID.UITurnCard) as IUITurnCard;
				if(ui)
				{
					ui.parseCopyReward(m_gkcontext.m_contentBuffer.getContent("uiCopyTurnCard_reward", true) as ByteArray);
				}
				else
				{
					m_gkcontext.m_UIMgr.loadForm(UIFormID.UITurnCard);
				}
			}
		}	
	}
}