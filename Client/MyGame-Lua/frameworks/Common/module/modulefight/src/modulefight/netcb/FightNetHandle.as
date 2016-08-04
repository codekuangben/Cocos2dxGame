package modulefight.netcb
{
	import com.util.DebugBox;
	import common.net.msg.basemsg.stNullUserCmd;
	import modulecommon.net.msg.fight.stAttackVictoryInfoUserCmd;
	import com.util.UtilColor;
	import modulecommon.ui.UIFormID;
	import modulefight.ModuleFightRoot;
	//import common.net.msg.basemsg.t_NullCmd;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	//import modulecommon.ui.UIFormID;
	//import modulecommon.uiinterface.IUICopiesAwards;
	//import modulecommon.uiinterface.IUITurnCard;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	
	//import common.net.endata.EnNet;
	import modulecommon.net.msg.fight.stScenePkCmd;
	
	import modulefight.FightEn;
	import modulefight.netmsg.fight.stAttackResultUserCmd;
	import modulefight.scene.fight.GameFightController;
	//import flash.events.Event;
	import modulefight.netmsg.fight.stPKOverUserCmd;
	
	/**
	 * ...
	 */
	public class FightNetHandle //implements INetHandle
	{
		public var m_regfunc:Dictionary;
		public var m_gkcontext:GkContext;
		public var m_ModuleFight:ModuleFightRoot;
		
		public function FightNetHandle(cont:GkContext, moduleFight:ModuleFightRoot):void
		{
			m_gkcontext = cont;
			m_ModuleFight = moduleFight;
			m_regfunc = new Dictionary();
			m_regfunc[stScenePkCmd.PARA_ATTACK_RESULT_USERCMD] = process_stAttackResultUserCmd;
			m_regfunc[stScenePkCmd.PARA_ATTACK_VICTORY_INFO_USERCMD] = process_stAttackVictoryInfoUserCmd;
			m_regfunc[stScenePkCmd.PARA_PK_OVER_USERCMD] = process_stPKOverUserCmd;
		}
		
		public function destroy():void
		{
			var key:String;
			for (key in m_regfunc)
			{
				m_regfunc[key] = null;
				delete m_regfunc[key];
			}
			
			m_gkcontext = null
		}
		
		public function handleMsg(msg:ByteArray, param:uint = 0):void
		{
			if (m_regfunc[param])
			{
				m_regfunc[param](msg);
			}
		}
		
		private function process_stAttackResultUserCmd(msg:ByteArray):void
		{
			var str:String = "";
			// 战斗返回消息     
			var fightControl:GameFightController = m_ModuleFight.m_fightControl;
			// bug:有时候已经进入战斗场景，但是又会收到这个消息，难道是多发了几次消息过去    
			if (m_ModuleFight.isStep_Process)
			{
				m_gkcontext.addLog("m_ModuleFight.isStep_Process==true");
				return;
			}
			if (m_gkcontext.m_UIs.npcTalk)
			{
				m_gkcontext.m_UIs.npcTalk.endNpcTalk();
			}
			try
			{
				var rev:stAttackResultUserCmd = new stAttackResultUserCmd();
				rev.deserialize(msg);
				if (rev.aArmylist.length == 0 || rev.bArmylist.length == 0)
				{
					str = "FightNetHandle ";
					if (rev.aArmylist.length == 0)
					{
						str += "a";
					}
					if (rev.bArmylist.length == 0)
					{
						str += "b";
					}
					str += " is Empty map=";
					str += m_gkcontext.m_mapInfo.m_servermapconfigID;
					m_gkcontext.addLog(str);
					DebugBox.sendToDataBase(str);
					return;
				}
			}
			catch (e: Error)
			{
				m_gkcontext.addLog("解析战斗消息出错"+e.getStackTrace());				
			}
			if (rev.m_version != stAttackResultUserCmd.VERSION)
			{
				str = "由于版本升级, 不能观看此战斗过程了！";
				m_gkcontext.addLog(str);
				m_gkcontext.m_systemPrompt.prompt(str, null, UtilColor.RED);
				return;
			}
			try
			{
				rev.init(m_gkcontext);
			}
			catch (e: Error)
			{
				m_gkcontext.addLog("初始化战斗消息出错"+e.getStackTrace());				
			}
			// 保存战斗流程
			fightControl.fightProcess = rev;
			m_gkcontext.m_beingProp.m_bShowFailTip = false;
			
			m_gkcontext.m_UIMgr.showFormEx(UIFormID.UISceneTran);
			m_gkcontext.m_mapInfo.inBattleIScene = true;
			
			m_gkcontext.m_sceneLogic.destroy();
			
			if (this.m_gkcontext.m_playerManager.hero)
			{
				this.m_gkcontext.m_playerManager.hero.stopMoving();
			}
			m_gkcontext.addLog("准备进入战斗");
			m_ModuleFight.enter();
		}
		
		private function process_stAttackVictoryInfoUserCmd(msg:ByteArray):void
		{
			var fightControl:GameFightController = m_ModuleFight.m_fightControl;
			if (fightControl.fightProcess == null)
			{
				return;
			}
			if (fightControl.fightProcess.m_stAttackVictoryInfoUserCmd)
			{
				return;
			}
			
			var rev:stAttackVictoryInfoUserCmd = new stAttackVictoryInfoUserCmd();
			
			rev.deserialize(msg);			
			fightControl.fightProcess.m_stAttackVictoryInfoUserCmd = rev;
			
			var cmdAttResult:stAttackResultUserCmd = (m_ModuleFight.m_fightControl as GameFightController).m_fightDB.m_fightProcess;
			if (cmdAttResult.aArmylist.length == 1 && cmdAttResult.bArmylist.length == 1 && rev.victoryTeam == 1 && cmdAttResult.aArmylist[0].users.length == 1 && cmdAttResult.aArmylist[0].users[0].name == m_gkcontext.playerMain.name)
			{
				m_gkcontext.m_beingProp.m_bShowFailTip = true;
			}
			
		
		}
		
		private function process_stPKOverUserCmd(msg:ByteArray):void
		{
			var cmd:stPKOverUserCmd = new stPKOverUserCmd();
			cmd.deserialize(msg);
			m_gkcontext.m_contentBuffer.addContent(FightEn.Modulefight_stPKOverUserCmd, cmd);			
		}
	}
}