package modulefight.scene.battleContrl
{
	import com.pblabs.engine.entity.EntityCValue;
	import common.scene.fight.AttackItem;
	import common.scene.fight.AttackTarget;
	import common.scene.fight.HurtItem;
	//import flash.display.InteractiveObject;
	import modulecommon.appcontrol.UIBattleSceneShadow;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	import modulecommon.ui.UIFormID;
	import modulefight.netmsg.stmsg.AttackedInfoGrid;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.netmsg.stmsg.DefList;
	import modulefight.netmsg.stmsg.SelfInfoGrid;
	//import modulefight.netmsg.stmsg.stEntryState;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.scene.fight.FightDB;
	import modulefight.scene.fight.FightGrid;
	import modulefight.scene.fight.FightLogicCB;
	import modulefight.scene.fight.rank.IRankFightAction;
	import modulefight.scene.fight.rank.RankAttackAction;
	import modulefight.scene.fight.rank.RankAttackEndAction;	
	import modulefight.tianfu.TianfuBase;
	import modulefight.tianfu.TianfuMgr;
	//import modulefight.scene.fight.rank.RankAttHurtEnd;
	import modulefight.scene.fight.rank.RankBufEffAction;
	//import modulefight.scene.fight.rank.RankCAttackAction;
	import modulefight.scene.fight.rank.RankHurtAction;
	//import modulefight.scene.fight.rank.RankHurtEndAction;
	//import modulefight.scene.fight.rank.RankMoveAction;
	import modulefight.scene.fight.rank.RankSelfTeamEffectAction;
	import org.ffilmation.engine.helpers.fObjectDefinition;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.utils.mathUtils;
	import modulefight.scene.roundcontrol.RoundControl;
	/**
	 * ...
	 * @author
	 */
	public class BattleControlBase extends ControlBase
	{
		public static const STEP_Preparation:int = 0;	//准备中阶段
		public static const STEP_Before:int = 1;	//处理战斗前的预处理
		public static const STEP_JuqiSkill:int = 2;	//释放技能时，聚气特效
		public static const STEP_processAttack:int = 3;	//处理战斗
		public static const STEP_After:int = 4;	//处理战斗的后处理
		public static const STEP_End:int = 5;	//结束
		
		protected var m_step:int;
		protected var m_timeInterval:Number;
		protected var m_timeRun:Number;	//已经执行了的时间
		public function BattleControlBase(fightDB:FightDB, fightLogicCB:FightLogicCB, roundControl:RoundControl, bat:BattleArray)
		{
			m_timeRun = 0;
			super(fightDB, fightLogicCB, roundControl, bat);			
		}		
		
		override public function begin():void 
		{
			m_timeRun = 0;
			prcessPreparation();
		}
		
		override protected function tryOver():void
		{
			if (m_bEndState && m_actionList.length == 0)
			{
				prcessAfter();
			}
		}
		protected function prcessPreparation():void
		{
			m_step = STEP_Preparation;
			var being:NpcBattle;
			var list:Vector.<NpcBattle> = m_attgrid.beingList;
			for each(being in list)
			{
				if (!being.isState(EntityCValue.TStand))
				{
					return;
				}
			}
			
			//判断本次攻击者是前面攻击的目标之一吗? 如果是, 直接返回.
			if (m_roundControl.isAttack(m_battleArray.aTeamid, m_battleArray.aGridNO))
			{
				return;
			}
			prcessBefore(); 
			
		}
		protected function prcessBefore():void
		{
			m_step = STEP_Before;
			var tianfu:TianfuBase = m_attgrid.tianfu;
			if (tianfu)
			{
				if ( tianfu.baseTianfuID == TianfuMgr.TIANFU_LianYing)
				{
					tianfu.playAni();
					m_timeInterval = 0;
					return;
				}
				else if (tianfu.type == TianfuBase.TYPE_AttackBegin)
				{
					if (tianfu.isTriger(m_battleArray))
					{
						tianfu.exec();
						m_timeInterval = 0;				
						return;
					}
				}
			}
			processJuqiSkill();
		}
		
		protected function processJuqiSkill():void
		{
			m_step = STEP_JuqiSkill;
			if (m_battleArray.type == 1)
			{
				m_attgrid.showJuqiSkillAni();
				m_timeInterval = 0;
			}
			else
			{
				prcessAttack();
			}
		}
		protected function prcessAttack():void
		{
			m_step = STEP_processAttack;
			if (m_battleArray.type == 1)	// 技能攻击    
			{
				m_attgrid.showSkillName();
				
				// 技能释放时，屏幕暗处理，只有自己释放技能的时候才显示
				if (!m_fightDB.m_bchGI && m_battleArray.aTeamid == EntityCValue.RKLeft)
				{
					m_fightLogicCB.chCharGI(m_attgrid.attBattle, true);
				}
			}
		}
		
		protected function prcessAfter():void
		{
			m_step = STEP_After;			
			m_attgrid.setShiqi(m_battleArray.aShiQi);
			m_attgrid.setHP(m_battleArray.aCurHp);
			m_fightDB.m_tianfuMgr.processTianfuData(m_battleArray.m_tianfuAfterAttack);
			if (m_fightDB.m_tianfuMgr.isTianfuTriggered)
			{
				m_timeInterval = 0;
				return;
			}
			prcessEnd();
		}
		
		protected function prcessEnd():void
		{
			m_step = STEP_End;
			m_roundControl.nextAttCB(EntityCValue.ASBattleArrayEnd, m_battleArray);
			if (m_funOnEnd != null)
			{
				m_funOnEnd(this);
			}
		}
		override public function onTick(deltaTime:Number):void 
		{
			m_timeRun += deltaTime;
			if (m_step == STEP_Preparation)
			{
				prcessPreparation();
			}
			if (m_step == STEP_Before)
			{
				m_timeInterval += deltaTime;
				if (m_timeInterval >= m_fightDB.m_tianfuMgr.timeForPlayTianfAni)
				{
					processJuqiSkill();		
				}
				return;
			}
			else if (m_step == STEP_JuqiSkill)
			{
				m_timeInterval += deltaTime;
				if (m_timeInterval >= 0.5)
				{
					prcessAttack();
				}
			}
			else if (m_step == STEP_After)
			{
				m_timeInterval += deltaTime;
				if (m_timeInterval >= m_fightDB.m_tianfuMgr.timeForPlayTianfAni)
				{
					prcessEnd();
				}
				return;
			}
			super.onTick(deltaTime);
		}
		protected function processValueEffect():void
		{
			/*if (m_battleArray.effList)
			{
				m_roundControl.processValueEffectList(m_battleArray.effList);
			}*/
		}
		
		// 攻击动作回调
		public function actAttackCB(attAct:RankAttackAction):void
		{
			// 左边队伍向前移动距离 
			var attackBeing:NpcBattle;
			var attack:AttackItem;
			var atttarget:AttackTarget;
			
			var defgrid:FightGrid;
			var gridlist:Vector.<FightGrid> = attAct.getGrid;
			var list:Vector.<NpcBattle>;
			
			var battlenpcid:uint;
			
			var timeList:Vector.<Number> = new Vector.<Number>();
			var totalcnt:uint;
			var curidx:uint;
			var effid:String;
			
			var attEndRank:RankAttackEndAction;
			
			// 初始化时间数据
			timeList.length = 0
			timeList.push(0);
			timeList.push(0.1);
			timeList.push(0.2);
			timeList.push(0.3);
			timeList.push(0.4);
			timeList.push(0.5);
			
			totalcnt = m_attgrid.beingList.length;
			
			var skillitem:TSkillBaseItem;
			var battlenpcitem:TNpcBattleItem;
			// 把攻击特效转变成受伤特效    
			if (m_battleArray.type == 1) // 技能攻击    
			{
				skillitem = m_battleArray.skillBaseitem;
				if (skillitem)
				{
					if (skillitem.hasAttFlyEff())
					{
						effid = skillitem.attFlyEff();
						// 设置攻击时候攻击特效释放的时候是每一个为单位还是每个格子为单位
						m_attgrid.bindType = fUtil.modelBindType(effid, m_fightDB.m_gkcontext.m_context);
					}
				}
				
				// 技能释放时，屏幕暗处理,攻击移动的时候就释放
				//if (!m_fightDB.m_bchGI)
				//{
				//	m_fightLogicCB.chCharGI(m_attgrid.attBattle, true);
				//}
				// 播放攻击声音
				m_attgrid.playAttMsc(true);
			}
			else
			{
				battlenpcitem = m_attgrid.npcBaseItem;
				
				if (battlenpcitem)
				{
					if (battlenpcitem.npcBattleModel.hasAttFlyEff())
					{
						effid = battlenpcitem.npcBattleModel.attFlyEff();
						// 设置攻击时候攻击特效释放的时候是每一个为单位还是每个格子为单位
						m_attgrid.bindType = fUtil.modelBindType(effid, m_fightDB.m_gkcontext.m_context);
					}
				}
				
				// 播放攻击声音
				m_attgrid.playAttMsc(false);
			}
			
			list = m_attgrid.beingList;
			var posActTarget:int = m_battleArray.getAttackActTargetPos();
			var hurtID:String = "";
			if (posActTarget != -1)
			{
				defgrid = m_fightDB.m_fightGrids[1 - attAct.side][posActTarget];
				hurtID = defgrid.topEmptySprite.id;
			}
			for each (attackBeing in list)
			{
				attack = new AttackItem();
				
				attack.delay = 0;
				attack.m_skillBaseitem = m_attgrid.attBattle.skillBaseitem;
				
				atttarget = new AttackTarget();
				atttarget.dam = 0;				
				atttarget.hurtID = hurtID;
				atttarget.hurtType = EntityCValue.TEmptySprite;
				attack.addTarget(atttarget);
				attack.attackType = 0;
				// 攻击飞行特效释放完毕后，回调，只在有 fEmptySprite 的 npc 上加
				if (attackBeing.topEmptySprite)
				{
					attack.callback = attAct.callback;
				}
				
				// 随机计算延迟时间
				curidx = (int)(Math.random() * totalcnt);
				attack.delayEff = timeList[curidx];
				timeList.splice(curidx, 1);
				totalcnt -= 1;
				
				attackBeing.fightList.addAttackItem(attack);
			}
			
			// 攻击指令执行结束，攻击动作将要发动
			m_roundControl.nextAttCB(EntityCValue.ASAttacking, m_battleArray);
		}
		
		protected function onAttackActEnd(act:IRankFightAction):void
		{
		
		}
		
		protected function createRankAttackAction():RankAttackAction
		{
			var actAttack:RankAttackAction = new RankAttackAction(m_battleArray);
			actAttack.side = m_battleArray.aTeamid;
			// 攻击需要延迟一点时间
			actAttack.delay = 0.5;
			actAttack.addGrid(m_attgrid);
			actAttack.fAction = actAttackCB;
			actAttack.fEnd = onAttackActEnd;
			
			addToActionList(actAttack);
			actAttack.onEnter();
			return actAttack;
		}
		
		protected function createRankHurtAction():RankHurtAction
		{
			var actHurt:RankHurtAction;
			if (m_battleArray.attackedList.isEmpty==false)
			{				
				actHurt = new RankHurtAction(m_battleArray);
				actHurt.side = 1 - m_battleArray.aTeamid;
				actHurt.bitmapRenderer = m_fightDB.m_bitmapRenderer;
				
				var enemyGrids:Vector.<FightGrid> = m_fightDB.m_fightGrids[actHurt.side];			
				var attackedList:Vector.<AttackedInfoGrid> = m_battleArray.attackedList.list;
				var attackedInfo:AttackedInfoGrid;
				for each(attackedInfo in attackedList)
				{
					actHurt.addGrid(enemyGrids[attackedInfo.gridNO]);
				}			
				
				actHurt.fAction = actHurtCB;
				actHurt.fEnd = actHurtEnd;
				actHurt.attGrid = m_attgrid;
				
				addToActionList(actHurt);
				actHurt.onEnter();
			}
			return actHurt;
		}
		
		protected function createRankSelfTeamEffectAction():RankSelfTeamEffectAction
		{
			var actSefTeamEffect:RankSelfTeamEffectAction;
			if (m_battleArray.selfList.isEmpty==false)
			{
				actSefTeamEffect = new RankSelfTeamEffectAction(m_battleArray, m_fightDB);
				actSefTeamEffect.fEnd = onSefTeamEffectEnd;
				addToActionList(actSefTeamEffect);
			}
			return actSefTeamEffect;
		}
		
		protected function createRankBufEffAction():RankBufEffAction
		{
			var actBufEff:RankBufEffAction;
			var skillitem:TSkillBaseItem = m_battleArray.skillBaseitem;
			if (m_battleArray.type == 1 && skillitem.hasPreAct())
			{
				actBufEff = new RankBufEffAction(m_battleArray);
				
				// 计算播放时间
				actBufEff.delay = skillitem.attPreFrame() / m_attgrid.beingList[0].getActFrameRate(EntityCValue.TActSkill);
				actBufEff.fAction = actBufEffAdd;
				actBufEff.fEnd = onDefaultActEnd;
				actBufEff.side = m_battleArray.aTeamid;
				// 所有的特效都是两层，上层
				actBufEff.effId = skillitem.preActEff();
				actBufEff.frameRate = skillitem.attPreEffFrameRate();
				// 下层
				actBufEff.effId1 = skillitem.preActEff1();
				actBufEff.frameRate1 = skillitem.attPreEffFrameRate1();
				// 添加 buf 的列表
				
				var list:Vector.<SelfInfoGrid> = m_battleArray.selfList.list;
				var selfGrids:Vector.<FightGrid> = m_fightDB.m_fightGrids[m_battleArray.aTeamid];
				var selfInfo:SelfInfoGrid;
				for each(selfInfo in list)
				{
					if (selfInfo.buffer)
					{
						actBufEff.addGrid(m_fightDB.m_fightGrids[actBufEff.side][selfInfo.buffer]);
					}
				}
				
				// 放入循环列表
				addToActionList(actBufEff);
				// 初始化
				actBufEff.onEnter();
			}
			return actBufEff;
		}
		
		
		protected function onDefaultActEnd(act:IRankFightAction):void
		{
			deleteFromActionList(act);
		}
		
		protected function onSefTeamEffectEnd(act:IRankFightAction):void
		{
			deleteFromActionList(act);
		}
		
		public function actHurtEnd(actHurt:RankHurtAction):void
		{
			// 技能释放时，屏幕暗处理，动作播放完成结束处理
			if (m_fightDB.m_bchGI)
			{
				m_fightLogicCB.chCharGI(m_battleArray, false);
			}
			m_roundControl.nextAttCB(EntityCValue.ASHurted, m_battleArray);
			deleteFromActionList(actHurt);
		}		
		// 受伤动作回调    
		public function actHurtCB(hurtAct:RankHurtAction):void
		{
			// 播放受伤动作    
			var hurtBeing:NpcBattle;
			var charID:String = "";			
			
			var grid:FightGrid; // 受伤格子	
			var list:Vector.<NpcBattle>;
			
			// 随机
			var timeList:Vector.<Number> = new Vector.<Number>();
			var totalcnt:uint = 0;
			var curidx:uint = 0;
			
			// bug: 这个地方如果不初始化，后面如果没有给这个值赋值，那么这个值就是 null
			var effid:String = "";
			var effid1:String = "";
			var hurttype:uint = EntityCValue.HTCom; //受伤类型
			
			// 暴击效果
			// 攻击动作完成后进行特殊屏幕特效
			var bhType:uint = m_battleArray.bjType();
			if (bhType == EntityCValue.BJer)
			{
				m_fightDB.m_quake.quake(20, 5, 0.05);
			}
			else if (bhType == EntityCValue.BJee) // 闪屏红色
			{
				var form:UIBattleSceneShadow = m_fightDB.m_gkcontext.m_UIMgr.getForm(UIFormID.UIBattleSceneShadow) as UIBattleSceneShadow;
				form.showBaoJi();
			}	
			var enemyGrids:Vector.<FightGrid> = m_fightDB.m_fightGrids[1 - m_battleArray.aTeamid];
			var attackType:uint = m_attgrid.matrixInfo.attackType; //是物理攻击，还是策略攻击
			var attackedList:Vector.<AttackedInfoGrid> = m_battleArray.attackedList.list;
			var attackedInfo:AttackedInfoGrid;
			for each(attackedInfo in attackedList)
			{
				grid = enemyGrids[attackedInfo.gridNO];
				// 初始化时间数据
				timeList.length = 0
				timeList.push(0);
				timeList.push(0.1);
				timeList.push(0.2);
				timeList.push(0.3);
				timeList.push(0.4);
				timeList.push(0.5);
				
				totalcnt = grid.beingList.length;
				
				list = grid.beingList;
				
				grid.onAttacked(m_battleArray, attackType);
									
				
				var battlenpcid:uint;
				var skillitem:TSkillBaseItem;
				var battlenpcitem:TNpcBattleItem;
				// 把攻击特效转变成受伤特效    
				if (m_battleArray.type == 1) // 技能攻击    
				{
					hurttype = EntityCValue.HTSkill;
					skillitem = hurtAct.battleArray.skillBaseitem;
					if (skillitem)
					{
						if (skillitem.hasAttHitEff())
						{
							effid = skillitem.hitEff();
							effid1 = skillitem.hitEff1();
							// 设置受伤时候受伤特效绑定到格子上还是每一个人身上，特效分两层，但是只能绑定类型只能绑定到一个类型
							grid.bindType = fUtil.modelBindType(effid, m_fightDB.m_gkcontext.m_context);
						}
					}
					
					// 播放被击声音
					grid.playHurtMsc(true);
					
				}
				else
				{
					hurttype = EntityCValue.HTCom;
					battlenpcitem = m_attgrid.npcBaseItem;
					
					if (battlenpcitem)
					{
						if (battlenpcitem.npcBattleModel.hasAttHitEff())
						{
							effid = battlenpcitem.npcBattleModel.hitEff();
							effid1 = battlenpcitem.npcBattleModel.hitEff1();
							// 设置受伤时候受伤特效绑定到格子上还是每一个人身上
							grid.bindType = fUtil.modelBindType(effid, m_fightDB.m_gkcontext.m_context);
						}
					}
					
					// 播放被击声音
					grid.playHurtMsc(false);
				}
				
				// bug: 如果受伤是在格子上，这个地方再延迟就有问题了
				var idxarr:int = 0;
				// 只有掉血才表现受伤特效    
				for each (hurtBeing in list)
				{
					var hurtitem:HurtItem = new HurtItem();
					
					hurtitem.hurtAct = EntityCValue.TActHurt;
					hurtitem.delay = 0;
					hurtitem.attackID = "";
					//hurtitem.dam = dam;
					hurtitem.hurtEffectID = effid;
					hurtitem.hurtEffectID1 = effid1;
					hurtitem.m_hurtType = hurttype; // 设置受伤类型
					
					// 随机计算延迟时间
					if (EntityCValue.EBGrid == grid.bindType && 0 == idxarr) // 如果受伤特效绑定在格子上，第一个播放的延迟必须要为0，否则如果有多个受伤格子，受伤特效可能会延时
					{
						curidx = 0;
					}
					else
					{
						curidx = (int)(Math.random() * totalcnt);
					}
					hurtitem.delay = timeList[curidx];
					timeList.splice(curidx, 1);
					totalcnt -= 1;
					hurtBeing.fightList.addHurtItem(hurtitem);			
			
					++idxarr;
				}
			}
			
			var def:DefList;		
						
			// 受伤指令执行完，受伤动作即将播放
			m_roundControl.nextAttCB(EntityCValue.ASHurting, hurtAct.battleArray);
		}
		
		// 根据特效 ID 获取特效定义 fObjectDefinition    
		public function getEffDef(effid:String):fObjectDefinition
		{
			var delimit:int = effid.indexOf("_");
			var insID:String = "";
			if (delimit != -1)
			{
				insID = effid.substring(delimit + 1, effid.length);
				return m_fightDB.m_gkcontext.m_context.m_sceneResMgr.getInsDefinition(insID);
			}
			
			return null;
		}
		
		// buf 特效添加
		public function actBufEffAdd(bufEffAct:RankBufEffAction):void
		{
			var grid:FightGrid;
			var gridlist:Vector.<FightGrid> = bufEffAct.getGrid;
			var being:NpcBattle; // 战斗npc 
			// 把战斗 npc 中的代码移动到这里
			for each (grid in gridlist)
			{
				// 所有的特效都是两层，上层
				if (bufEffAct.effId != "")
				{
					if (EntityCValue.EBGrid == fUtil.modelBindType(bufEffAct.effId, m_fightDB.m_gkcontext.m_context))
					{
						if (fUtil.effLinkLayer(bufEffAct.effId, m_fightDB.m_gkcontext.m_context))
						{
							grid.botEmptySprite.addLinkEffect(bufEffAct.effId, bufEffAct.frameRate, false, EntityCValue.EffHurt);
						}
						else
						{
							grid.topEmptySprite.addLinkEffect(bufEffAct.effId, bufEffAct.frameRate, false, EntityCValue.EffHurt);
						}
					}
					else // 绑定到人身上
					{
						for each (being in grid.beingList)
						{
							being.addLinkEffect(bufEffAct.effId, bufEffAct.frameRate, false, EntityCValue.EffHurt);
						}
					}
				}
				else if (bufEffAct.effId1 != "") // 下层
				{
					if (EntityCValue.EBGrid == fUtil.modelBindType(bufEffAct.effId1, m_fightDB.m_gkcontext.m_context))
					{
						if (fUtil.effLinkLayer(bufEffAct.effId1, m_fightDB.m_gkcontext.m_context))
						{
							grid.botEmptySprite.addLinkEffect(bufEffAct.effId1, bufEffAct.frameRate1, false, EntityCValue.EffHurt);
						}
						else
						{
							grid.topEmptySprite.addLinkEffect(bufEffAct.effId1, bufEffAct.frameRate1, false, EntityCValue.EffHurt);
						}
					}
					else // 绑定到人身上
					{
						for each (being in grid.beingList)
						{
							being.addLinkEffect(bufEffAct.effId1, bufEffAct.frameRate1, false, EntityCValue.EffHurt);
						}
					}
				}
			}
		}
		
		
		
		public function setParamForAttack(attBat:BattleArray, actAttack:RankAttackAction, actHurt:RankHurtAction):void
		{
			var grid:FightGrid = m_fightDB.m_fightGrids[attBat.aTeamid][attBat.aGridNO];
			var skillitem:TSkillBaseItem;
			var battlenpcitem:TNpcBattleItem;
			var battlenpcid:uint;
			var dist:Number = 200;
			var flyeffvel:Number = m_fightDB.m_effVel; // 飞行特效的速度
			var flyeddframerate:uint = 5; // 飞行特效帧率
			var flydef:fObjectDefinition;
			var battlenpc:NpcBattle;
			var defGrid:FightGrid;
			defGrid = m_fightDB.m_fightGrids[actHurt.side][attBat.getAttackActTargetPos()];
			
			// 把攻击特效转变成受伤特效
			if (attBat.type == 1) // 技能攻击
			{
				//grid = actMove.getGrid[0];
				skillitem = attBat.skillBaseitem;
				
				// 如果命中特效指定在第几帧播放   
				// if (skillitem && skillitem.hasAttHitEff() && skillitem.hitEffFrame() != 0)
				// 命中特效如果没有配置，那么命中特效播放帧数就是命中播放帧数
				if (skillitem && skillitem.hitEffFrame() != 0)
				{
					// 攻击准备动作时间 + 攻击延迟时间   
					actHurt.delay = grid.beingList[0].getActLength(EntityCValue.TActSkillPre) + skillitem.hitEffFrame() / grid.beingList[0].getActFrameRate(EntityCValue.TActSkill)
					actHurt.delayType = EntityCValue.DTTime;
				}
				else
				{
					// 如果有飞行特效，根据飞行特效帧率计算，并且计算飞行特效的飞行速度
					//if (skillitem && skillitem.hasAttFlyEff() && skillitem.attFlyEffFrameRate())
					if (skillitem && skillitem.hasAttFlyEff())
					{
						flyeddframerate = skillitem.attFlyEffFrameRate();
						flydef = getEffDef(skillitem.attFlyEff());
						// 如果没有配置飞行特效帧率
						if (!flyeddframerate)
						{
							if (flydef)
							{
								flyeddframerate = flydef.dicAction[0].framerate;
							}
						}
						
						if (flydef)
						{
							// 注意 e11 类型的课缩放的飞行特效的帧数在 TEffectItem 这个表中配置的，需要从这个表中读取，但是如果飞行可缩放特效，一般需要配置命中特效帧数，或者这里需要修改一下
							actHurt.delay = flydef.dicAction[0].xCount / flyeddframerate;
							if (skillitem.hasAttPreEff())
							{
								actHurt.delay += grid.beingList[0].getActLength(EntityCValue.TActSkillPre)
							}
							if (skillitem.attFlyEffFrame())
							{
								actHurt.delay += skillitem.attFlyEffFrame() / grid.beingList[0].getActFrameRate(EntityCValue.TActSkill);
							}
							else
							{
								actHurt.delay += grid.beingList[0].getActLength(EntityCValue.TActSkill);
							}
						}
						
						// 通过飞行特效的话，就通过回调
						actHurt.delayType = EntityCValue.DTCallBack;
						// 受伤靠回调触发
						actAttack.callback = actHurt.callback;
					}
					else
					{
						// 根据距离计算时间延迟
						// 第一个点是左边格子中心点，第二个点是右边格子中心点
						dist = mathUtils.distance(grid.xCenterLast, grid.yCenterLast, defGrid.xCenter, defGrid.yCenter);
						
						actHurt.delay = dist / m_fightDB.m_effVel;
						
						if (skillitem.hasAttPreEff())
						{
							actHurt.delay += grid.beingList[0].getActLength(EntityCValue.TActSkillPre);
						}
						if (skillitem.attFlyEffFrame())
						{
							actHurt.delay += skillitem.attFlyEffFrame() / grid.beingList[0].getActFrameRate(EntityCValue.TActSkill);
						}
						else
						{
							actHurt.delay += grid.beingList[0].getActLength(EntityCValue.TActSkill);
						}
						
						actHurt.delayType = EntityCValue.DTTime;
					}
						//actHurt.delayType = EntityCValue.DTTime;
				}
				
				// 计算飞行特效的速度
				if (skillitem && skillitem.hasAttFlyEff())
				{
					// 根据距离计算时间延迟
					// 第一个点是左边格子中心点，第二个点是右边格子中心点，这个计算放在最前面
					dist = mathUtils.distance(grid.xCenterLast, grid.yCenterLast, defGrid.xCenter, defGrid.yCenter);
					
					flyeddframerate = skillitem.attFlyEffFrameRate();
					flydef = getEffDef(skillitem.attFlyEff());
					// 如果没有配置飞行特效帧率
					if (!flyeddframerate)
					{
						if (flydef)
						{
							flyeddframerate = flydef.dicAction[0].framerate;
						}
					}
					
					if (flydef)
					{
						flyeffvel = (dist * flyeddframerate) / flydef.dicAction[0].xCount;
					}
				}
				
				// 攻击和被击玩家和武将赋值帧率  
				
				var effFrameRateList:Vector.<uint>;
				var effFrameRateList1:Vector.<uint>;
				if (skillitem)
				{
					effFrameRateList = skillitem.m_effFrameRateList;
					effFrameRateList1 = skillitem.m_effFrameRateList1;
				}
				else
				{
					effFrameRateList = m_fightDB.m_effFrameRateList;
					effFrameRateList1 = m_fightDB.m_effFrameRateList;
				}
				
			}
			else if (attBat.type == 0) // 普通攻击   
			{
				//grid = actMove.getGrid[0];
				battlenpcitem = grid.npcBaseItem;
				// 如果战斗 npc 表中配置命中特效播放帧数  
				if (battlenpcitem && battlenpcitem.npcBattleModel.hasAttHitEff() && battlenpcitem.npcBattleModel.hitEffFrame() > 0)
				{
					actHurt.delay = battlenpcitem.npcBattleModel.hitEffFrame() / grid.beingList[0].getActFrameRate(EntityCValue.TActAttack)
					actHurt.delayType = EntityCValue.DTTime;
				}
				else // 如果战斗 npc 表中配置没有命中特效播放帧数
				{
					// 特效配置文件动态加载，这个时候还不知道特效的帧数，因此同意配置一个飞行速度   
					// 如果有飞行特效
					//if (battlenpcitem && battlenpcitem.hasAttFlyEff() && battlenpcitem.attFlyEffFrameRate())
					if (battlenpcitem && battlenpcitem.npcBattleModel.hasAttFlyEff())
					{
						flyeddframerate = battlenpcitem.npcBattleModel.attFlyEffFrameRate();
						flydef = getEffDef(battlenpcitem.npcBattleModel.attFlyEff());
						if (!flyeddframerate)
						{
							if (flydef)
							{
								flyeddframerate = flydef.dicAction[0].framerate;
							}
						}
						
						if (flydef)
						{
							actHurt.delay = flydef.dicAction[0].xCount / flyeddframerate;
						}
						if (battlenpcitem.npcBattleModel.attFlyEffFrame())
						{
							actHurt.delay += battlenpcitem.npcBattleModel.attFlyEffFrame() / grid.beingList[0].getActFrameRate(EntityCValue.TActAttack);
						}
						else
						{
							actHurt.delay += grid.beingList[0].getActLength(EntityCValue.TActAttack);
						}
						
						// 通过飞行特效的话，就通过回调
						actHurt.delayType = EntityCValue.DTCallBack;
						// 受伤靠回调触发
						actAttack.callback = actHurt.callback;
					}
					else
					{
						// 根据距离计算时间延迟
						// 第一个点是左边格子中心点，第二个点是右边格子中心点 
						
						dist = mathUtils.distance(grid.xCenterLast, grid.yCenterLast, defGrid.xCenter, defGrid.yCenter);
						
						actHurt.delay = dist / m_fightDB.m_effVel;
						
						if (battlenpcitem.npcBattleModel.attFlyEffFrame())
						{
							actHurt.delay += battlenpcitem.npcBattleModel.attFlyEffFrame() / grid.beingList[0].getActFrameRate(EntityCValue.TActAttack);
						}
						else
						{
							actHurt.delay += grid.beingList[0].getActLength(EntityCValue.TActAttack);
						}
						
						actHurt.delayType = EntityCValue.DTTime;
					}
						//actHurt.delayType = EntityCValue.DTTime;
				}
				
				// 计算飞行特效的速度
				if (battlenpcitem && battlenpcitem.npcBattleModel.hasAttFlyEff())
				{
					// 根据距离计算时间延迟
					// 第一个点是左边格子中心点，第二个点是右边格子中心点，这个计算放在最前面
					dist = mathUtils.distance(grid.xCenterLast, grid.yCenterLast, defGrid.xCenter, defGrid.yCenter);
					
					flyeddframerate = battlenpcitem.npcBattleModel.attFlyEffFrameRate();
					flydef = getEffDef(battlenpcitem.npcBattleModel.attFlyEff());
					// 如果没有配置飞行特效帧率
					if (!flyeddframerate)
					{
						if (flydef)
						{
							flyeddframerate = flydef.dicAction[0].framerate;
						}
					}
					
					if (flydef)
					{
						flyeffvel = (dist * flyeddframerate) / flydef.dicAction[0].xCount;
					}
				}
				
				// 攻击和被击玩家和武将赋值帧率  
				
				if (battlenpcitem)
				{
					effFrameRateList = battlenpcitem.npcBattleModel.m_effFrameRateList;
					effFrameRateList1 = battlenpcitem.npcBattleModel.m_effFrameRateList1;
				}
				else
				{
					effFrameRateList = m_fightDB.m_effFrameRateList;
					effFrameRateList1 = m_fightDB.m_effFrameRateList;
				}
				
			}
			actHurt.delay += actAttack.delay; // 由于攻击延迟因此受伤也需要加上延迟
			
			for each (battlenpc in grid.beingList)
			{
				battlenpc.effFrameRateList = effFrameRateList;
				battlenpc.effFrameRateList1 = effFrameRateList1;
				battlenpc.m_effectSpeed = flyeffvel;
			}
			for each (defGrid in actHurt.getGrid)
			{
				for each (battlenpc in defGrid.beingList)
				{
					battlenpc.effFrameRateList = effFrameRateList;
					battlenpc.effFrameRateList1 = effFrameRateList1;
				}
			}
			
			// 注意攻击完受伤			
			actHurt.onEnter();
		}
		
		//返回值：true - (team, gridNO)是m_battleArray的攻击目标之一
		public function isAttack(team:int, gridNO:int):Boolean
		{
			var ret:Boolean = false;
			if (m_battleArray.aTeamid != team)
			{
				ret = m_battleArray.attackedList.isAttacked(gridNO);
			}
			return ret;
		}
		
		public function get timeRun():Number
		{
			return m_timeRun;
		}
	
	}

}
