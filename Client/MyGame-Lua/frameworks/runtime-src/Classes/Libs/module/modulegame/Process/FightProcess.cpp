package game.process
{
	import com.pblabs.engine.entity.EntityCValue;
	import flash.utils.ByteArray;
	import game.netmsg.scenePkCmd.stPrePKUserCmd;
	import modulecommon.commonfuntion.LocalDataMgr;
	import net.ContentBuffer;
	
	//import modulecommon.CommonEn;
	import modulecommon.GkContext;
	
	//import modulecommon.net.MessageBuffer;
	import modulecommon.net.msg.fight.stScenePkCmd;
	//import common.net.endata.EnNet;
	//import modulecommon.uiinterface.IUISceneTran;
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author
	 * @brief 战斗模块消息处理的地方
	 */
	public class FightProcess
	{
		public var m_gkcontext:GkContext;		
		
		public function FightProcess(cont:GkContext):void
		{
			m_gkcontext = cont;
		}
		
		public function destroy():void
		{			
			m_gkcontext = null;
		}
		
		public function processFightCmd(msg:ByteArray, param:uint, serverData:Boolean = true):void
		{
			if (param == stScenePkCmd.PARA_PRE_PK_USERCMD)
			{
				// 解析一下这个消息
				var cmd:stPrePKUserCmd = new stPrePKUserCmd();
				cmd.deserialize(msg);
				m_gkcontext.m_battleMgr.m_fastover = cmd.fastover;		// 记录需要哪一回合显示

				m_gkcontext.m_localMgr.set(LocalDataMgr.LOCAL_WillIntoBattle);
				return;
			}
			
			if (stScenePkCmd.PARA_ATTACK_RESULT_USERCMD == param)
			{
				if (serverData)
				{
					m_gkcontext.addLog("收到战斗消息");
					m_gkcontext.m_battleMgr.addBattle(msg);
					m_gkcontext.m_battleMgr.m_bClientBattleSimulation = false;
				}		
				else
				{
					m_gkcontext.m_battleMgr.m_bClientBattleSimulation = true;
				}
			}
			
			m_gkcontext.m_battleMgr.moduleFight.handleFightUserCmd(msg, param);					
		}
	}
}