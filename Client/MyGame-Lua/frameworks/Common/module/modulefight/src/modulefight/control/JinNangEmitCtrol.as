package modulefight.control
{
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.DebugBox;
	import modulefight.netmsg.stmsg.AttackedInfoGrid;
	import modulefight.netmsg.stmsg.SelfInfoGrid;
	import modulefight.ui.uireplay.UIReplay;
	//import modulefight.netmsg.stmsg.stEntryState;
	import modulefight.netmsg.stmsg.stUserInfo;
	import modulefight.scene.roundcontrol.RoundControl;
	
	import common.scene.fight.HurtItem;
	
	import modulecommon.GkContext;
	
	import modulefight.FightEn;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.netmsg.stmsg.DefList;
	import modulefight.netmsg.stmsg.JinNangProcess;
	import modulefight.netmsg.stmsg.stArmy;
	//import modulefight.netmsg.stmsg.stJNCastInfo;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.scene.fight.FightDB;
	import modulefight.scene.fight.FightGrid;
	import modulefight.scene.fight.GameFightController;
	import modulefight.scene.fight.rank.RankHurtAction;
	import modulefight.ui.UIJNHalfImg;
	import modulefight.ui.battlehead.DataJNAni;
	
	/**
	 * ...
	 * @author
	 *
	 */
	public class JinNangEmitCtrol
	{
		public static const STEP_JinnangPlay:int = 0;	//锦囊特效播放阶段
		public static const STEP_PostProcess:int = 1;	//锦囊特效播放完毕后，后处理阶段
		public static const STEP_End:int = 2;	//锦囊播放结束
		
		private var m_gkContext:GkContext;
		private var m_fightDB:FightDB;
		private var m_fightCtrol:GameFightController;
		private var m_roundControl:RoundControl;
		
		public var m_jnProcess:JinNangProcess;
		private var m_aArmy:stArmy;
		private var m_bArmy:stArmy;
		
		private var m_step:int;
		private var m_timeInterval:Number;
		protected var m_timeRun:Number;	//已经执行了的时间
		public function JinNangEmitCtrol(gk:GkContext, fightDB:FightDB, fightCtrol:GameFightController, roundControl:RoundControl)
		{
			m_gkContext = gk;
			m_fightDB = fightDB;
			m_fightCtrol = fightCtrol;
			m_roundControl = roundControl;
		}
		
		public function dispose():void
		{
			m_jnProcess = null;
			m_aArmy = null;
			m_bArmy = null;
			m_gkContext = null;
		}
		
		/*input:关于锦囊释放的信息
		 * 执行此函数，导致执行的控制权从GameFightController对象转移JinNangEmitCtrol对象
		 * 锦囊释放完毕后，执行的控制权回到JinNangEmitCtrol对象
		 */
		public function begin(jnProcess:JinNangProcess):void
		{
			m_timeRun = 0;
			m_jnProcess = jnProcess;
			m_aArmy = m_fightCtrol.aArmy;
			m_bArmy = m_fightCtrol.bArmy;
			m_step = STEP_JinnangPlay;
			beginStep1();
		}
		
		/*
		 * 开始锦囊卡片动画飞行
		 */
		public function beginStep1():void
		{
			// 黑屏,直接放在 UI 上
			//if (!m_fightDB.m_bchGI)
			//{
			//	m_fightCtrol.m_fightLogicCB.chCharGI(null, true);
			//}
			
			// 使用锦囊
			m_fightDB.m_UIBattleHead.m_jnAniData.setJnProcess(m_jnProcess);			
			
			// 获取锦囊释放原因
			if(m_fightDB.m_UIBattleHead.m_jnAniData.jnCnt() == 2)
			{
				var reason:uint = m_fightDB.m_UIBattleHead.m_jnAniData.relBetwJN();
				// bug: 只要等级相等,就是相等比拼.并且 m_battleArray 为 null
				if(reason == DataJNAni.RelKZ || reason == DataJNAni.RelNotEqual)
				{
					// 判断被克制, 被克制 m_battleArray 是 null 的
					if(reason == DataJNAni.RelKZ && m_jnProcess.m_battleArray.aTeamid == 1)
					{
						m_gkContext.m_beingProp.m_jnReason = 2;
						m_gkContext.m_beingProp.m_otherJNID = m_fightDB.m_UIBattleHead.m_jnAniData.getJNI(1);
					}
					/*else if(m_jnProcess.m_battleArray.aTeamid == 0 && reason == DataJNAni.RelHurt)	// 判断数字比价失败
					{
						m_gkContext.m_beingProp.m_jnReason = 1;
						m_gkContext.m_beingProp.m_otherJNID = m_fightDB.m_UIBattleHead.m_jnAniData.getJNI(1);
					}
					else if(m_jnProcess.m_battleArray.aTeamid == 1 && reason == DataJNAni.RelAtt)	// 判断数字比价失败
					{
						m_gkContext.m_beingProp.m_jnReason = 1;
						m_gkContext.m_beingProp.m_otherJNID = m_fightDB.m_UIBattleHead.m_jnAniData.getJNI(1);
					}*/
				}
			}
			
			m_fightDB.m_UIBattleHead.useJinnang();
			
			if (DataJNAni.RelEqual != m_fightDB.m_UIBattleHead.m_jnAniData.relBetwJN())
			{
				// 现在需要有人物半身像了
				//m_fightDB.m_UIBattleHead.m_jnAniData.m_firEndCB = beginStep3;
				m_fightDB.m_UIBattleHead.m_jnAniData.m_firEndCB = beginStep2;
			}
			else
			{
				m_fightDB.m_UIBattleHead.m_jnAniData.m_firEndCB = stepIntoPostProcess;
			}
		}
		
		/*	判断是否释放锦囊
		   1. 没有释放，则控制权返回
		   2. 否则，开始播放角色飞入动画
		 */
		public function beginStep2():void
		{
			if(m_fightDB.m_UIBattleHead.m_jnAniData.jnCnt() == 1)	//只释放一个锦囊
			{
				// 如果是左边释放的
				if(m_fightDB.m_UIBattleHead.m_jnAniData.jnSide() == EntityCValue.RKLeft)	// 如果释放的是左边
				{
					// 自己半身像
					playSelfHalf();
				}
				else	// 右边释放
				{
					// 对方半身像
					playOppent();
				}
			}
			else	// 两个锦囊释放
			{
				var reason:uint = m_fightDB.m_UIBattleHead.m_jnAniData.relBetwJN();
				// 只有这三种情况需要处理, RelNo 上面已经处理了, RelEqual 肯定不播放
				if(reason == DataJNAni.RelKZ)	// 攻击方一定是成功的一方，被克制的一方一定是被击的一方
				{
					if(m_jnProcess.m_battleArray.aTeamid == EntityCValue.RKRight)	// 如果自己被克制
					{
						// 对方半身像
						playOppent();
					}
					else
					{
						// 自己半身像
						playSelfHalf();
					}
				}
				else if(reason == DataJNAni.RelNotEqual)
				{
					if(m_fightDB.m_UIBattleHead.m_jnAniData.ifFailSide(EntityCValue.RKLeft))	// 如果自己是失败方
					{
						// 对象半身像
						playOppent();
					}
					else
					{
						// 自己半身像
						playSelfHalf();
					}
				}
			}
		}
		
		/*	开始锦囊效果的释放
		 * 包括：地震,每个格子上的特效，掉血，buffer处理
		 * 此流程结束后，执行的控制权回到GameFightController对象
		 */
		public function beginStep3():void
		{
			//释放锦囊
			//m_fightCtrol.m_fightLogicCB.actJinNangCB(null);
			var actHurt:RankHurtAction = new RankHurtAction(m_jnProcess.m_battleArray);
			actHurt.bitmapRenderer = m_fightDB.m_bitmapRenderer;
			//actHurt.m_fightIdx = m_jnProcess.m_fightIdx;
			
			var grid:FightGrid;
			// 受伤的格子
			//if(1 == m_fightDB.m_UIBattleHead.m_jnAniData.jnCnt())	// 如果只有一个就作为被击者
			//{
			//	grid = m_fightDB.m_fightGrids[m_jnProcess.m_battleArray.aTeamid][m_jnProcess.m_battleArray.aPos];
			//}
			//else	// 两方都是放进囊,但是同时只有一个是供给方,另外只有一个是被击方 bug:  如果是比数值，并且都相等，说明名优释放锦囊，直接走 stepIntoPostProcess 这个函数
			//{
			if (m_jnProcess.m_battleArray.attackedList.list.length == 0)
			{
				DebugBox.sendToDataBase("JinNangEmitCtrol::beginStep3 被击列表为空");
				stepIntoPostProcess();
				return;
			}
			grid = m_fightDB.m_fightGrids[1 - m_jnProcess.m_battleArray.aTeamid][m_jnProcess.m_battleArray.attackedList.list[0].gridNO];
			//}
			//grid.sethurtBattle(m_jnProcess.m_battleArray, actHurt.fightIdx);
			actHurt.addGrid(grid);
			actHurt.delay = 0;
			actHurt.delayType = EntityCValue.DTTime;
			actHurt.fAction = actJinNangCB;
			actHurt.fEnd = actJinNangEndCB;
			m_fightDB.m_actionList.push(actHurt);
			actHurt.onEnter();
		}
		
		// 锦囊动作回调    
		private function actJinNangCB(hurtAct:RankHurtAction):void
		{
			// 播放受伤动作
			var hurtBeing:NpcBattle;
			var grid:FightGrid; // 受伤格子			
			var list:Vector.<NpcBattle>;
			
			// 播放锦囊特效
			// 震动
			m_fightDB.m_quake.quake(20, 10, 0.05);
			// 黑屏,直接放在 UI 上
			//if (!m_fightDB.m_bchGI)
			//{
			//	m_fightCtrol.m_fightLogicCB.chCharGI(grid.attBattle, true);
			//}
			// 释放特效，仅仅一方释放
			grid = hurtAct.getGrid[0];
			// 这个特效肯定存在
			m_fightCtrol.m_fightLogicCB.playJinNangEffect(hurtAct.battleArray, grid.side);
			// 释放锦囊持续特效,这个特效不一定存在,需要判断
			// bug: 可能有多次换部队，换部队后就有可能再次释放锦囊，但是一次战斗不换部队，只能释放一个锦囊
			// 释放锦囊持续特效,这个特效是一致持续的，因此需要释放掉
			//m_fightDB.m_terEntity.disposeAllSceneJinNangEff();
			if (hurtAct.battleArray.skillBaseitem.bjinnangPostEff())
			{
				m_fightCtrol.m_fightLogicCB.playJinNangPostEffect(hurtAct.battleArray, grid.side);
			}
			
			
			var hurtidx:uint = 0;
			var bat:BattleArray = m_jnProcess.m_battleArray;
			var defList:Vector.<DefList>;
			var defItem:DefList;
			var size:int;
			
			var enemyGrids:Vector.<FightGrid> = m_fightDB.m_fightGrids[1 - bat.aTeamid];
			var attackedList:Vector.<AttackedInfoGrid> = bat.attackedList.list;
			var attackedInfo:AttackedInfoGrid;
			for each(attackedInfo in attackedList)	
			{				
				grid = enemyGrids[attackedInfo.gridNO];
				hurtAct.addGrid(grid);
				grid.onAttacked(bat,FightEn.DAM_None,true);
				
				list = grid.beingList;
				
				for each (hurtBeing in list)
				{						
				
					var hurtitem:HurtItem = new HurtItem();
					
					hurtitem.hurtAct = EntityCValue.TActHurt;
					hurtitem.delay = 0;
					hurtitem.attackID = "";
					//hurtitem.dam = dam;
					
					hurtBeing.fightList.addHurtItem(hurtitem);
					
				}
				hurtidx++;
			}
			
			var listSelf:Vector.<SelfInfoGrid> = bat.selfList.list;
			var selfGrids:Vector.<FightGrid> = m_fightDB.m_fightGrids[bat.aTeamid];
			var selfInfo:SelfInfoGrid;
			for each(selfInfo in listSelf)
			{
				selfGrids[selfInfo.gridNO].onZengyiByBattleArray(bat);
			}			
		}
			
		public function actJinNangEndCB(act:RankHurtAction):void
		{
			var idx:int = m_fightDB.m_actionList.indexOf(act);
			m_fightDB.m_actionList.splice(idx, 1);
			act.dispose();
					
			stepIntoPostProcess();
		}
		
		
		private function stepIntoPostProcess():void
		{
			m_step = STEP_PostProcess;
			if (m_jnProcess.m_battleArray)
			{				
				m_fightDB.m_tianfuMgr.processTianfuData(m_jnProcess.m_battleArray.m_tianfuAfterAttack);
				if (m_fightDB.m_tianfuMgr.isTianfuTriggered)
				{
					m_timeInterval = 0;
					return;
				}
			}
			
			backToGameFightController();
		}
		
		//执行的控制权回到GameFightController对象
		private function backToGameFightController():void
		{
			//if (m_fightDB.m_bchGI)
			//{
			//	m_fightCtrol.m_fightLogicCB.chCharGI(null, false);
			//}
			
			m_step = STEP_End;
			m_roundControl.combackFormJinnangEmit();
			m_jnProcess = null;
			m_aArmy = null;
			m_bArmy = null;
		}
		public function onTick(deltaTime:Number):void
		{
			m_timeRun += deltaTime;
			if (m_fightDB.m_gkcontext.m_battleMgr.m_stopInfo)
			{
				m_fightDB.m_gkcontext.addLog("JinNangEmitCtrol::onTick() m_step=" + m_step+"m_timeInterval="+m_timeInterval);
			}
			
			if (m_step == STEP_PostProcess)
			{
				m_timeInterval += deltaTime;
				if (m_timeInterval >= m_fightDB.m_tianfuMgr.timeForPlayTianfAni)
				{
					backToGameFightController();
				}
			}
			
			if (m_timeRun > 20 && m_fightCtrol.isUIReplayVisible==false)
			{
				m_fightCtrol.showUIReplay(UIReplay.MODE_jieshu);
			}
		}
		protected function playSelfHalf():void
		{
			// 自己半身像
			m_fightDB.m_UIJNHalfImg = new UIJNHalfImg();
			m_fightDB.m_UIJNHalfImg.m_fEndCB = beginStep3;
			m_fightDB.m_gkcontext.m_UIMgr.addForm(m_fightDB.m_UIJNHalfImg);
			m_fightDB.m_UIJNHalfImg.show(); // 显示
			
			var user:stUserInfo = m_fightCtrol.aArmy.users[0];
			m_fightDB.m_UIJNHalfImg.setHalfImage(0, user.job, user.sex);
			m_fightDB.m_UIJNHalfImg.setSide(EntityCValue.RKLeft);
			
			m_fightDB.m_UIJNHalfImg.startAni();
		}
		
		// 播放对手半身像
		protected function playOppent():void
		{
			// 对象半身像
			if(m_bArmy.isPlayer)		// 如果释放的是玩家
			{
				m_fightDB.m_UIJNHalfImg = new UIJNHalfImg();
				m_fightDB.m_UIJNHalfImg.m_fEndCB = beginStep3;
				m_fightDB.m_gkcontext.m_UIMgr.addForm(m_fightDB.m_UIJNHalfImg);
				m_fightDB.m_UIJNHalfImg.show(); // 显示
				
				var user:stUserInfo = m_fightCtrol.bArmy.users[0];
				m_fightDB.m_UIJNHalfImg.setHalfImage(0, user.job, user.sex);
				m_fightDB.m_UIJNHalfImg.setSide(EntityCValue.RKRight);
				
				m_fightDB.m_UIJNHalfImg.startAni();
			}
			else		// 如果释放的是怪
			{
				//m_fightDB.m_UIJNHalfImg.setHalfImage(1);
				//m_fightDB.m_UIJNHalfImg.setSide(EntityCValue.RKRight);
				beginStep3();
			}
		}
		
		public function get timeRun():Number
		{
			return m_timeRun;
		}
	}
}
