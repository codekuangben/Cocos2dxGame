package modulecommon.scene.scene
{
	import com.gamecursor.GameCursor;
	import com.pblabs.engine.entity.EntityCValue;
	import flash.utils.ByteArray;
	import modulecommon.commonfuntion.HintMgr;
	import modulecommon.commonfuntion.LocalDataMgr;
	import net.ContentBuffer;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.MapInfo;
	import modulecommon.scene.SceneViewer;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUINpcTalk;
	import org.ffilmation.engine.core.fEngine;
	import modulecommon.GkContext;
	//import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.events.fProcessEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FightSceneCtrol extends SceneCtrolBase
	{
		
		public function FightSceneCtrol(gk:GkContext, engine:fEngine, sceneViewer:SceneViewer)
		{
			super(gk, engine, sceneViewer, EntityCValue.SCFIGHT);
		}
		
		public function gotoScene(path:String, sceneid:uint):void
		{
			m_gkContext.m_context.m_gameCursor.setStaticState(GameCursor.STATICSTATE_General);
			
			// 设置场景状态    
			m_sceneState = EntityCValue.SSIniting;
			
			if (m_scene)
			{
				preGotoScene(true);
				if (m_scene.m_path != path)
				{
					desposeScene(m_scene);
					m_scene = null;
				}
			}
			
			switchToScene(path, sceneid);
			
			if (m_sceneState == EntityCValue.SSRead)
			{
				activateScene();
				postGotoScene();
			}
		}
		
		public function leaveScene():void
		{
			m_gkContext.m_context.m_gameCursor.setStaticState(GameCursor.STATICSTATE_General);
			
			if (m_scene == null)
			{
				return;
			}
			
			this.m_engine.hideScene(m_scene, false);
			afterLeaveScene();
		}
		
		override public function loadCompleteHandler(evt:fProcessEvent):void
		{
			super.loadCompleteHandler(evt);
			activateScene();
			postGotoScene();
		}
		
		protected function preGotoScene(bdispose:Boolean):void
		{
			//m_gkContext.m_context.m_terrainManager.preInit(m_scene, true, bdispose);
			//this.m_gkContext.m_uiMapSwitchEffect.leaveMap();
		}
		
		protected function postGotoScene():void
		{
			m_gkContext.m_context.m_processManager.onResize();
			m_gkContext.m_context.m_terrainManager.postInit(m_scene);
			
			// 设置战斗场景中移动的时候不进行深度排序了
			//var fightscene:fScene = this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT);
			//m_scene.m_sortByBeingMove = false;
			
			m_gkContext.m_battleMgr.moduleFight.onBattleMapLoaded();			
			
			
			//this.m_gkContext.m_uiMapSwitchEffect.enterMap();
			if(m_gkContext.m_uiChat)
			{
				m_gkContext.m_uiChat.moveToLayer(UIFormID.BattleLayer);
			}
		}
		
		protected function afterLeaveScene():void
		{
			m_gkContext.m_localMgr.clear(LocalDataMgr.LOCAL_WillIntoBattle);
			m_gkContext.m_mapInfo.inBattleIScene = false;
			var play:PlayerMain = m_gkContext.m_playerManager.hero;
			
			if (null != play)
			{
				play.stopMoveFlag = false;
			}
			
			m_gkContext.m_battleMgr.execMsgInBuffer();
			if (m_gkContext.m_contentBuffer.getContent("uiNpcTalk_content", false))
			{
				var formNpc:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UINpcTalk);
				if (formNpc)
				{
					m_gkContext.m_UIMgr.showForm(UIFormID.UINpcTalk);
					(formNpc as IUINpcTalk).processNpcTalk();
				}
				else
				{
					m_gkContext.m_UIMgr.loadForm(UIFormID.UINpcTalk);
				}
			}
			
			if (m_gkContext.m_contentBuffer.getContent("afterRobShowTips_info", false))
			{
				m_gkContext.m_jiuguanMgr.showTipsOfAfterRob();
			}
			
			var paramForJianghun:Object = m_gkContext.m_contentBuffer.getContent(ContentBuffer.JIANGHUN_GetAni, true);
			if (paramForJianghun)
			{
				m_gkContext.m_hintMgr.addToUIZhanliAddAni(paramForJianghun);
			}
			
			// 显示战斗失败提示窗口
			if (m_gkContext.m_beingProp.m_bShowFailTip)
			{
				m_gkContext.m_beingProp.m_bShowFailTip = false;
				
				var hintParam:Object = new Object();
				hintParam[HintMgr.HINTTYPE] = HintMgr.HINTTYPE_FGFail;
				m_gkContext.m_hintMgr.hint(hintParam);
			}
			
			// 战役挑战中需要给提示
			if (m_gkContext.m_mapInfo.mapType() == MapInfo.MTZhanYi) // 如果在战役挑战中
			{
				if (m_gkContext.m_beingProp.m_fightFail == true)
				{
					m_gkContext.m_systemPrompt.prompt(" 挑战失败，战役次数-0");
					//m_gkContext.m_elitebarrierMgr.showTipsAfterFightFail();
				}
				else
				{
					m_gkContext.m_systemPrompt.prompt("挑战成功，战役次数-1");
				}
				
				m_gkContext.m_beingProp.m_fightFail = false;
			}
			
			if (m_gkContext.m_mapInfo.mapType() == MapInfo.MTTeamFB ||
				MapInfo.MAPID_TeamChuanGuan == m_gkContext.m_mapInfo.m_servermapconfigID) // 如果在组队副本或者组队闯关中
			{
				var formZX:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UITeamFBZX) as Form; // 关闭界面，因为开战后布阵数据可能会变，如果赢了，服务器会保存这次布阵，如果输了，布阵数据全部清理，因此需要关闭打开的时候需要重新请求
				if (formZX)
				{
					formZX.exit();
				}
			}
			
			if(m_gkContext.m_uiChat)
			{
				// 如果在跑商中，不用放回去
				if (!m_gkContext.m_rankSys.bOpenPaoShang)
				{
					m_gkContext.m_uiChat.moveBackFirstLayer();
				}
				else		// 继续移动到第一层
				{
					m_gkContext.m_uiChat.moveToLayer(UIFormID.SecondLayer);
				}
			}
		}
	
	}

}