package modulefight.scene.roundcontrol
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.control.JinNangEmitCtrol;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.netmsg.stmsg.DefList;
	import modulefight.netmsg.stmsg.stGridInfo;
	import modulefight.netmsg.stmsg.stRound;
	import modulefight.netmsg.stmsg.stValueEffect;
	import modulefight.scene.battleContrl.BattleControlBase;
	import modulefight.scene.battleContrl.BattleControlFarAttack;
	import modulefight.scene.battleContrl.BattleControlNearAttack;
	import modulefight.scene.battleContrl.BattleControlNoEnemy;
	import modulefight.scene.fight.FightDB;
	import modulefight.scene.fight.FightGrid;
	import modulefight.scene.fight.FightLogicCB;
	import modulefight.scene.fight.GameFightController;
	import modulefight.ui.uireplay.UIReplay;
	
	/**
	 * ...
	 * @author ...
	 * 回合控制块
	 */
	public class RoundControl
	{
		//在每回合之中，处理有如下阶段。顺序执行
		public static const STEP_armyEnter:int = 0; //回合开始时，可能需要进入部队
		public static const STEP_TianfuInRoundBegin:int = 1; //天赋处理
		public static const STEP_jinangEmit:int = 2; //回合开始时，可能会释放锦囊
		public static const STEP_processBattle:int = 3; //处理所有BattleArray
		public static const STEP_processValueEffet:int = 4; //处理所有stRound.effList中的数值
		public static const STEP_End:int = 5; //回合结束状态，或者是回合未开始
		
		private var m_fightDB:FightDB;
		private var m_fightLogicCB:FightLogicCB;
		private var m_fightControl:GameFightController;
		private var m_jnEmitCtrol:JinNangEmitCtrol;
		private var m_armyReplceControl:ArmyReplceControl;
		private var m_funOnRoundEnd:Function;
		
		private var m_roundData:stRound;
		private var m_step:int; //见STEP_armyEnter等定义
		private var m_iStart:uint;
		private var m_starTime:Number;
		private var m_NextIndex:int = 0; //要处理的新的战斗。zero-based
		
		private var m_battleCtrlList:Vector.<BattleControlBase>;
		private var m_battleCtrlListBuffer:Vector.<BattleControlBase>;
		
		
		public function RoundControl(fightDB:FightDB, fightLogicCB:FightLogicCB, fightControl:GameFightController, funOnRoundEnd:Function)
		{
			m_fightLogicCB = fightLogicCB;
			m_fightDB = fightDB;
			m_fightControl = fightControl;
			m_funOnRoundEnd = funOnRoundEnd;
			m_battleCtrlList = new Vector.<BattleControlBase>();
			m_battleCtrlListBuffer = new Vector.<BattleControlBase>();
			m_armyReplceControl = new ArmyReplceControl(fightDB, this);
			m_step = STEP_End;			
		}
		
		public function begin(roundData:stRound):void
		{
			m_starTime = 0;
			m_step = 0;
			m_NextIndex = 0;
			m_iStart = 0;
			m_roundData = roundData;
			
			var firstBat:BattleArray;
			if (m_roundData.m_jinnangProcess && m_roundData.m_jinnangProcess.m_battleArray)
			{
				firstBat = m_roundData.m_jinnangProcess.m_battleArray;
			}
			else if (m_roundData.m_BattleList.length)
			{
				firstBat = m_roundData.m_BattleList[0];
			}
			if (firstBat && firstBat.isArmyReplaced)
			{
				m_step = STEP_armyEnter;
				m_armyReplceControl.processArmyReplace(firstBat.aArmyNo == 255 ? 0 : firstBat.aArmyNo, firstBat.bArmyNo == 255 ? 0 : firstBat.bArmyNo);
			}
			else
			{
				stepIntopTianfuInRoundBegin();
			}
		}
		
		//回合开始，处理天赋
		private function stepIntopTianfuInRoundBegin():void
		{
			m_step = STEP_TianfuInRoundBegin;
			//m_fightDB.m_tianfuMgr.trigerByRoundBegin(m_roundData.m_tianfu_roundBegin);
			m_fightDB.m_tianfuMgr.processTianfuData(m_roundData.m_tianfu_roundBegin);
			if (m_fightDB.m_tianfuMgr.isTianfuTriggered)
			{
				m_starTime = 0;
			}
			else
			{
				stepIntoprocessJinangEmit();
			}
		}
		
		private function stepIntoprocessJinangEmit():void
		{
			if (m_roundData.m_jinnangProcess)
			{
				m_jnEmitCtrol = new JinNangEmitCtrol(m_fightDB.m_gkcontext, m_fightDB, m_fightControl, this);
				++m_fightDB.m_fightIdx; // 锦囊也要计数
				
				m_roundData.m_jinnangProcess.m_fightIdx = m_fightDB.m_fightIdx;
				m_fightDB.m_trigMode = EntityCValue.ASJNEnd;
				
				m_jnEmitCtrol.begin(m_roundData.m_jinnangProcess);
				m_iStart = 0;
				m_step = STEP_jinangEmit;
			}
			else
			{
				stepIntoprocessBattle();
			}
		}
		
		private function stepIntoprocessBattle():void
		{
			m_step = STEP_processBattle;
			m_iStart = 1;
			if (m_NextIndex >= m_roundData.m_BattleList.length)
			{
				tryEndProcessBattle();
			}
		}
		
		//尝试离开STEP_processBattle阶段，进入下一阶段
		private function tryEndProcessBattle():void
		{
			if (m_NextIndex >= m_roundData.m_BattleList.length && m_battleCtrlList.length == 0)
			{
				stepIntoProcessValueEffet();
			}
		}
		
		private function stepIntoProcessValueEffet():void
		{
			if (m_NextIndex >= m_roundData.m_BattleList.length && m_battleCtrlList.length == 0)
			{
				if (m_roundData.effList)
				{
					m_step = STEP_processValueEffet;
					processValueEffectList(m_roundData.effList);
					
					m_fightDB.m_tianfuMgr.processTianfuData(m_roundData.m_tianfu_Eff);
					if (m_fightDB.m_tianfuMgr.isTianfuTriggered)
					{
						m_starTime = 0;
						return;
					}
				}
				stepIntoEnd();
				
			}
		}
		
		private function stepIntoEnd():void
		{
			m_step = STEP_End;
			m_funOnRoundEnd(this);
		}
		
		public function combackFormJinnangEmit():void
		{
			stepIntoprocessBattle();
		}
		
		public function onTick(deltaTime:Number):void
		{			
			if (m_fightDB.m_gkcontext.m_battleMgr.m_stopInfo)
			{
				m_fightDB.m_gkcontext.addLog("RoundControl::m_step=" + m_step);
			}
			
			if (m_step == STEP_End)
			{
				return;
			}
			
			if (m_fightDB.m_gkcontext.m_battleMgr.m_stopInfo)
			{
				m_fightDB.m_gkcontext.addLog("RoundControl::m_battleCtrlList长度=" + m_battleCtrlList.length + " m_starTime=" + m_starTime + " m_NextIndex=" + m_NextIndex
				+ " m_iStart="+m_iStart+" m_roundData.m_BattleList.length="+m_roundData.m_BattleList.length);
			}
			else if (m_step == STEP_TianfuInRoundBegin)
			{
				m_starTime += deltaTime;
				if (m_starTime >= m_fightDB.m_tianfuMgr.timeForPlayTianfAni)
				{
					stepIntoprocessJinangEmit();
				}
				return;
			}
			else if (m_step == STEP_jinangEmit)
			{
				m_jnEmitCtrol.onTick(deltaTime);
				return;
			}
			else if (m_step == STEP_processValueEffet)
			{
				m_starTime += deltaTime;
				if (m_starTime >= m_fightDB.m_tianfuMgr.timeForPlayTianfAni)
				{
					stepIntoEnd();
				}
				return;
			}	
						
			var battleControl:BattleControlBase;
			m_battleCtrlListBuffer.length = 0;		
			for each (battleControl in m_battleCtrlList)
			{
				m_battleCtrlListBuffer.push(battleControl);				
			}
			for each (battleControl in m_battleCtrlListBuffer)
			{
				battleControl.onTick(deltaTime);
			}
			if (m_battleCtrlList.length > 0)
			{
				battleControl = m_battleCtrlList[0];
				if (battleControl.timeRun > 8 && m_fightControl.isUIReplayVisible==false)
				{
					m_fightControl.showUIReplay(UIReplay.MODE_jieshu);
				}
			}
			if (m_NextIndex >= m_roundData.m_BattleList.length)
			{
				return;
			}
			if (m_step < STEP_processBattle)
			{
				return;
			}
			if (m_iStart == 1)
			{
				m_starTime += deltaTime;
				if (m_starTime > m_fightDB.m_fightInterval)
				{
					m_iStart = 0;
					m_starTime = 0;
					
					var curBat:BattleArray = m_roundData.m_BattleList[m_NextIndex];
					if (curBat.isArmyReplaced)
					{
						m_armyReplceControl.processArmyReplace(curBat.aArmyNo == 255 ? 0 : curBat.aArmyNo, curBat.bArmyNo == 255 ? 0 : curBat.bArmyNo);
					}
					else
					{
						processNextBattle();
					}
				}
			}
		}
		
		private function processNextBattle():void
		{
			buildActionSeq();
			m_NextIndex++;
		}
		
		//部队替换完毕后，回调此函数
		public function onArmyReplaced():void
		{
			if (m_step == STEP_armyEnter)
			{
				stepIntopTianfuInRoundBegin();
			}
			else
			{
				processNextBattle();
			}
		}
		
		// 生成动作序列
		public function buildActionSeq():void
		{
			// 战斗索引计数增加
			++m_fightDB.m_fightIdx;
			
			if (2 == m_fightDB.m_fightIdx)
			{
				m_fightDB.m_UIBattleHead.showTips();
			}
			var attgrid:FightGrid; // 攻击格子
			
			var curBat:BattleArray = m_roundData.m_BattleList[m_NextIndex];
			var nextBat:BattleArray = (m_NextIndex + 1 >= m_roundData.m_BattleList.length) ? null : m_roundData.m_BattleList[m_NextIndex + 1];
			curBat.m_fightIdx = m_fightDB.m_fightIdx;
			
			// 判断
			calcNextGridInfo(curBat, nextBat);
			
			attgrid = m_fightDB.m_fightGrids[curBat.aTeamid][curBat.aGridNO];
			attgrid.setattBattle(curBat);
			
			var battleCtrl:BattleControlBase;
			if (curBat.attackedList.isEmpty)
			{
				battleCtrl = new BattleControlNoEnemy(m_fightDB, m_fightLogicCB, this, curBat);
			}
			else
			{
				if (attgrid.attType == EntityCValue.ATTFar)
				{
					battleCtrl = new BattleControlFarAttack(m_fightDB, m_fightLogicCB, this, curBat);
				}
				else
				{
					battleCtrl = new BattleControlNearAttack(m_fightDB, m_fightLogicCB, this, curBat);
				}
			}
			battleCtrl.funOnEnd = onBattleCtrlEnd;
			m_battleCtrlList.push(battleCtrl);
			battleCtrl.begin();
		}
		
		protected function onBattleCtrlEnd(battleControl:BattleControlBase):void
		{
			var i:int = m_battleCtrlList.indexOf(battleControl);
			if (i != -1)
			{
				m_battleCtrlList.splice(i, 1);
			}			
						
			if (m_battleCtrlList.length == 0)
			{
				nextAttCB(EntityCValue.ASAllActEnd, battleControl.battleArray);
				
				if (m_armyReplceControl.armyReplaceState == ArmyReplceControl.ARMYREPLACE_WaitAni)
				{
					m_armyReplceControl.processArmyReplaceEx();
				}
				
				if (m_NextIndex >= m_roundData.m_BattleList.length)
				{
					tryEndProcessBattle();
				}
			}
			battleControl.dispose();
		}
		
		// 不同情况下回调的函数,尝试发动下一次攻击
		public function nextAttCB(state:uint, ba:BattleArray):void
		{
			if (state == EntityCValue.ASAllActEnd || (m_fightDB.m_fightIdx == ba.m_fightIdx && m_fightDB.m_trigMode == state))
			{
				if (EntityCValue.FMPar == m_fightDB.m_fightMode)
				{
					m_iStart = 1;
				}
				else
				{
					// 顺序执行的时候只处理锦囊和默认状态
					if (EntityCValue.ASDefault == state || EntityCValue.ASJNEnd == state) // 顺序播放的时候使用,连续播放的时候不用
					{
						m_iStart = 1;
					}
				}
			}
		
		}
		
		// 确定触发下一次攻击的格子
		public function calcNextGridInfo(curBat:BattleArray, nextBat:BattleArray):void
		{
			var rel:uint = relBetBA(curBat, nextBat);
			if (EntityCValue.NRArmyReplace == rel) // 替换部队
			{
				m_fightDB.m_trigMode = EntityCValue.ASAllActEnd;
			}
			else if (EntityCValue.NRNextRount == rel) // 一个回合的最后一个战斗
			{
				m_fightDB.m_trigMode = EntityCValue.ASAllActEnd;
			}
			else if (EntityCValue.NRCAtt == rel) // 当前战斗存在反击
			{
				m_fightDB.m_trigMode = EntityCValue.ASCAttacked;
			}
			else if (EntityCValue.NRAN2AF == rel) // 攻击方近攻,攻击方远攻
			{
				// 第一个攻击方跑过去并造成伤害数字后第二个攻击方出手
				// 第一个被击方受伤后出发下一次攻击
				//m_fightDB.m_trigGridSide = 1 - m_fightDB.m_curBat.aTeamid;
				//m_fightDB.m_trigGridIdx = m_fightDB.m_curBat.defData[0].bPos;
				m_fightDB.m_trigMode = EntityCValue.ASHurting;
			}
			else if (EntityCValue.NRAN2AN == rel) // 攻击方近攻,攻击方近攻
			{
				// 第一个攻击方向外运动几帧,第二个攻击方开始向外运动
				// 攻击方出去几帧开始出发下一次攻击
				//m_fightDB.m_trigGridSide = m_fightDB.m_curBat.aTeamid;
				//m_fightDB.m_trigGridIdx = m_fightDB.m_curBat.aPos;
				m_fightDB.m_trigMode = EntityCValue.ASOuting;
			}
			else if (EntityCValue.NRAF2AN == rel) // 攻击方远攻,攻击方近攻
			{
				// 第一个攻击方一出手,第二个攻击方开始跑,调血后,第二个攻击方开始攻击
				// 攻击方出攻击完成触发下一次攻击
				//m_fightDB.m_trigGridSide = m_fightDB.m_curBat.aTeamid;
				//m_fightDB.m_trigGridIdx = m_fightDB.m_curBat.aPos;
				m_fightDB.m_trigMode = EntityCValue.ASAttacking;
			}
			else if (EntityCValue.NRAF2AF == rel) // 攻击方远攻,攻击方远攻
			{
				// 第一个攻击方造成伤害数字,第二个立刻出手
				// 被击方受伤完成触发下一次攻击
				//m_fightDB.m_trigGridSide = 1 - m_fightDB.m_curBat.aTeamid;
				//m_fightDB.m_trigGridIdx = m_fightDB.m_curBat.defData[0].bPos;
				m_fightDB.m_trigMode = EntityCValue.ASHurting;
			}
			else if (EntityCValue.NRA2DNo == rel) // 攻击方被击方没有任何关系
			{
				// 第一个攻击方动作做完,不用掉血,第二个开始攻击
				// 攻击方攻击动作做完出发下一次攻击
				//m_fightDB.m_trigGridSide = m_fightDB.m_curBat.aTeamid;
				//m_fightDB.m_trigGridIdx = m_fightDB.m_curBat.aPos;
				m_fightDB.m_trigMode = EntityCValue.ASAttacked;
			}
			else if (EntityCValue.NRATarget2D == rel) // 攻击方是下一次的被击方
			{
				// 第一个攻击方回到本格后,第二个攻击方才开始攻击
				// 攻击方回到原位置开始出发下一次攻击
				//m_fightDB.m_trigGridSide = m_fightDB.m_curBat.aTeamid;
				//m_fightDB.m_trigGridIdx = m_fightDB.m_curBat.aPos;
				m_fightDB.m_trigMode = EntityCValue.ASIned;
			}
			else if (EntityCValue.NRA2DAtt == rel) // 被击方是下一次的攻击方
			{
				// 第一个被击方动作播放完,不等第一个攻击方动作结束,第二个攻击方直接出手
				// 被击放动作播放完成触发下一次攻击
				//m_fightDB.m_trigGridSide = 1 - m_fightDB.m_curBat.aTeamid;
				//m_fightDB.m_trigGridIdx = m_fightDB.m_curBat.defData[0].bPos;
				m_fightDB.m_trigMode = EntityCValue.ASHurted;
			}
			else if (EntityCValue.NRHNULL == rel) // 被击列表为空
			{
				m_fightDB.m_trigMode = EntityCValue.ASBattleArrayEnd;
			}
			else
			{
				//m_fightDB.m_trigGridSide = uint.MAX_VALUE;
				//m_fightDB.m_trigGridIdx = uint.MAX_VALUE;
				m_fightDB.m_trigMode = uint.MAX_VALUE;
			}
		}
		
		// 两次攻击之间的关系
		public function relBetBA(curBat:BattleArray, nextBat:BattleArray):uint
		{
			
			var curgrid:FightGrid;
			var nextgrid:FightGrid;
			var nextdef:DefList;
			
			curgrid = m_fightDB.m_fightGrids[curBat.aTeamid][curBat.aGridNO];
			if (nextBat)
			{
				nextgrid = m_fightDB.m_fightGrids[nextBat.aTeamid][nextBat.aGridNO];
			}
			
			if (nextBat == null)
			{
				curBat.m_rel2Next = EntityCValue.NRNextRount;
			}
			else if (nextBat.isArmyReplaced) // 部队替换
			{
				curBat.m_rel2Next = EntityCValue.NRArmyReplace;
			}
			else if (curBat.strikeBackList) // 当前的攻击中有反击
			{
				curBat.m_rel2Next = EntityCValue.NRCAtt;
			}
			else if (curBat.hasAttackActTarget == false) // 被击列表为空
			{
				curBat.m_rel2Next = EntityCValue.NRHNULL;
			}
			else if (curBat.aTeamid == nextBat.aTeamid) // 队伍相同
			{
				if (EntityCValue.ATTFar == curgrid.attType)
				{
					if (EntityCValue.ATTFar == nextgrid.attType)
					{
						curBat.m_rel2Next = EntityCValue.NRAF2AF;
					}
					else
					{
						curBat.m_rel2Next = EntityCValue.NRAF2AN;
					}
				}
				else
				{
					if (EntityCValue.ATTFar == nextgrid.attType)
					{
						curBat.m_rel2Next = EntityCValue.NRAN2AF;
					}
					else
					{
						curBat.m_rel2Next = EntityCValue.NRAN2AN;
					}
				}
			}
			else // 队伍不同
			{
				// 下一次战斗的被击方是当前战斗的攻击方
				if (nextBat.attackedList.isAttacked(curBat.aGridNO))
				{
					curBat.m_rel2Next = EntityCValue.NRATarget2D;
				}
				
				if (uint.MAX_VALUE == curBat.m_rel2Next)
				{
					// 下一次战斗的攻击方是当前战斗的被击方
					if (curBat.attackedList.isAttacked(nextBat.aGridNO))
					{
						curBat.m_rel2Next = EntityCValue.NRA2DAtt;
					}
					
					if (uint.MAX_VALUE == curBat.m_rel2Next)
					{
						curBat.m_rel2Next = EntityCValue.NRA2DNo;
					}
				}
			}
			
			return curBat.m_rel2Next;
		}
		
		public function processValueEffectList(effList:Vector.<stValueEffect>):void
		{
			var item:stValueEffect;
			for each (item in effList)
			{
				m_fightDB.getFightGrid(item.pos).processValueEffect(item);
			}
		}
		
		public function get battleCtrlListLen():int
		{
			return m_battleCtrlList.length;
		}
		
		public function dispose():void
		{
			clearAction();
		}
		
		public function clearAction():void
		{
			var battleCtrl:BattleControlBase;
			for each (battleCtrl in m_battleCtrlList)
			{
				battleCtrl.dispose();
			}
			m_battleCtrlList.length = 0;
			if (m_armyReplceControl)
			{
				m_armyReplceControl.clear();
			}
		}
		
		//返回值：true - (team, gridNO)是m_battleCtrlList中的的攻击目标之一
		public function isAttack(team:int, gridNO:int):Boolean
		{
			var battleControl:BattleControlBase;			
			for each (battleControl in m_battleCtrlList)
			{
				if (battleControl.isAttack(team, gridNO))
				{
					return true;
				}
			}
			return false;
		}
	}
}