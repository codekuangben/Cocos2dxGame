package modulefight 
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import flash.utils.ByteArray;
	import modulecommon.commonfuntion.SysOptions;
	import modulecommon.net.msg.stResRobCmd.reqFinishFightUserCmd;
	import modulecommon.ui.Form;
	
	//import flash.display.Sprite;
	
	//import modulecommon.CommonEn;
	import modulecommon.GkContext;
	import modulecommon.net.msg.questUserCmd.stRequestQuestUserCmd;
	import modulecommon.ui.UIFormID;
	
	import modulefight.netcb.FightNetHandle;
	import modulefight.netmsg.fight.stPKOverUserCmd;
	import modulefight.scene.FightSceneLogic;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.scene.fight.GameFightController;
	import modulefight.uicb.CBUIEvent;
	
	//import org.ffilmation.engine.core.fScene;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.game.IMFight;
	
	/**
	 * ...
	 * @author 
	 */
	public class ModuleFightRoot  implements IMFight
	{		
		public static const STEP_NONE:int = 0;	//没有在执行战斗流程
		public static const STEP_Begin:int = 1;	//阶段：以开始战斗处理为开始，以地图加载完毕为结束
		public static const STEP_mapLoaded:int = 2;	//阶段：以地图加载完毕为开始，以退出战斗为结束
		
		protected var m_step:int;
		public var m_gkcontext:GkContext;
		public var m_fightNetHandle:FightNetHandle;
		public var m_fightControl:GameFightController;
		
		public function ModuleFightRoot(gk:GkContext) 
		{
			m_gkcontext = gk;			
			m_gkcontext.m_context.m_typeReg.addClass(EntityCValue.TBattleNpc, NpcBattle);
		}
		
		public function get isInit():Boolean
		{
			return m_fightNetHandle != null;
		}
		//public function init(sp:Sprite):void
		public function init():void
		{
			// NpcBattle 这个类在这里注册   
						
			m_fightNetHandle = new FightNetHandle(m_gkcontext,this);			
			m_fightControl = new GameFightController(m_gkcontext);
			m_fightControl.m_fightDB.m_ModuleFightRoot = this;
		}
		
		public function handleFightUserCmd(msg:ByteArray, param:uint = 0):void
		{
			if (m_fightNetHandle == null)
			{
				init();
			}
			m_fightNetHandle.handleMsg(msg, param);
		}
		public function resetFight():void
		{
			m_fightControl.resetFight();
		}
		//进入战斗
		public function enter():void
		{
			m_step = STEP_Begin;
			m_gkcontext.addLog("ModuleFightRoot::enter() 开始处理战斗");
			m_gkcontext.m_cbUIEvent = new CBUIEvent(m_gkcontext);
			
			var logic:FightSceneLogic = new FightSceneLogic();
			logic.m_gkcontext = m_gkcontext;
			logic.init();
			m_gkcontext.m_sceneLogic = logic;
			
			
			m_gkcontext.m_UIMgr.loadForm(UIFormID.UICloud);			
			
			var fightmapname:uint = 0;
			if(m_gkcontext.m_mapInfo.m_bInArean)
			{
				fightmapname = 9052;		// 如果从竞技场进入战斗地图,统一进入 9052 这个地图
			}
			else
			{
				fightmapname = this.m_gkcontext.m_mapInfo.fightMapName;
			}
			
			// 停止主场景音乐
			if(!m_gkcontext.m_sysOptions.isSet(SysOptions.COMMONSET_CLIENT_LDSSound))
			{
				if(m_gkcontext.m_mapInfo.m_sceneMusic.length)
				{
					this.m_gkcontext.m_context.m_soundMgr.stop(m_gkcontext.m_mapInfo.m_sceneMusic);
				}
			}
			
			Logger.info(null, null, "enter fight map,fightmapID = " + fightmapname);
			var nameFileName:String = m_gkcontext.m_context.m_path.getPathByName("x" + fightmapname + ".swf", EntityCValue.PHXMLTINS);			
			m_gkcontext.m_context.m_sceneView.gotoSceneFight(nameFileName, fightmapname);
			// 播放背景音乐
			var bgmusicname:String;
			if(!m_gkcontext.m_sysOptions.isSet(SysOptions.COMMONSET_CLIENT_LDSSound))
			{
				bgmusicname = m_gkcontext.m_battleMgr.getBattleMapMusic(fightmapname);
				if(bgmusicname.length)
				{
					this.m_gkcontext.m_context.m_soundMgr.play(bgmusicname, EntityCValue.FXDft, 0.0, int.MAX_VALUE);
				}
				else
				{
					this.m_gkcontext.m_context.m_soundMgr.play(EntityCValue.DFMusic, EntityCValue.FXDft, 0.0, int.MAX_VALUE);
				}
			}
		}
		
		public function onBattleMapLoaded():void
		{
			m_step = STEP_mapLoaded;
			m_fightControl.enterFightScene();			
			m_fightControl.prepInitRes();
		}
		
		public function leave():void
		{
			m_gkcontext.addLog("离开战斗场景");
			m_gkcontext.m_battleMgr.m_fastover = 0;
			m_gkcontext.m_cbUIEvent.destroy();
			m_gkcontext.m_cbUIEvent = null;
			
			var cmd:stPKOverUserCmd = m_gkcontext.m_contentBuffer.getContent(FightEn.Modulefight_stPKOverUserCmd, true) as stPKOverUserCmd;
			
			if(cmd)
			{				
				var sendcmd:stRequestQuestUserCmd = new stRequestQuestUserCmd();
				
				sendcmd.target = cmd.target;
				sendcmd.offset = cmd.offset;
				
				this.m_gkcontext.sendMsg(sendcmd);
			}
			
			if (m_gkcontext.m_sanguozhanchangMgr.inZhanchang)
			{
				var finishFightUserCmd:reqFinishFightUserCmd = new reqFinishFightUserCmd();
				this.m_gkcontext.sendMsg(finishFightUserCmd);
			}
			
			m_gkcontext.m_localMgr.clear(LocalDataMgr.LOCAL_QiangDuoBaowuBattle);
			destroy();
			m_step = STEP_NONE;
			m_gkcontext.m_objMgr.playAfterBattle();
		}
		
		private function destroy():void
		{
			// 给服务器发送消息		
			m_fightNetHandle.destroy();
			m_fightNetHandle = null;			
			m_gkcontext.m_sceneLogic.destroy();
			m_gkcontext.m_sceneLogic = null;			
	
		
			m_fightControl.destroy();
			m_fightControl = null;					
		}
		
		public function get isStep_Process():Boolean
		{
			return m_step != STEP_NONE;
		}
		
		public function get step():int
		{
			return m_step;
		}
	}
}