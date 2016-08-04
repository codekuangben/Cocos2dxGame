package modulefight.scene.battleContrl
{
	/**
	 * ...
	 * @author ...
	 * 反击流程处理
	 */
	import com.pblabs.engine.entity.EntityCValue;
	import common.scene.fight.AttackItem;
	import common.scene.fight.AttackTarget;
	import common.scene.fight.HurtItem;
	import modulefight.tianfu.TianfuMgr;
	//import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	//import modulefight.FightEn;
	import modulefight.netmsg.stmsg.DefList;
	//import modulefight.netmsg.stmsg.PkValue;
	//import modulefight.netmsg.stmsg.stStrikeBack;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.scene.fight.FightDB;
	import modulefight.scene.fight.FightGrid;
	import modulefight.scene.fight.FightLogicCB;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.scene.fight.rank.InplaceOrder;
	import modulefight.scene.fight.rank.IRankFightAction;
	//import modulefight.scene.fight.rank.RankAttHurtEnd;
	import modulefight.scene.fight.rank.RankCAttackAction;
	import modulefight.scene.fight.rank.RankHurtAction;
	import modulefight.scene.fight.rank.RankMoveAction;
	import modulefight.scene.roundcontrol.RoundControl;
	public class FanjiControl extends ControlBase
	{
		public function FanjiControl(fightDB:FightDB, fightLogicCB:FightLogicCB, roundControl:RoundControl, bat:BattleArray)
		{
			super(fightDB, fightLogicCB, roundControl,bat);
		}
		
		override public function begin():void
		{
			// 开始反击，这个就相当于跑过来攻击
			// 检测受伤，受伤使用最简单的普通攻击动作和受伤动作
			// 只处理最简单的，一对一的情况
			
			var actCAttack:RankCAttackAction; // 反击			
			m_attgrid.state = EntityCValue.GSOuted;
			// 表现攻击
			actCAttack = new RankCAttackAction(m_battleArray);
			// 攻击需要延迟一点时间
			actCAttack.delay = 0;
			actCAttack.side = m_battleArray.aTeamid;
			
			actCAttack.fAction = actCAttackCB;
			actCAttack.fEnd = onRankCAttackActionEnd;
			actCAttack.fightGrids = m_fightDB.m_fightGrids;
			
			addToActionList(actCAttack);
			
			// 检测受伤过程 
			var actHurt:RankHurtAction = new RankHurtAction(m_battleArray);
			actHurt.side = m_battleArray.aTeamid; // 反击，受伤一边就是上一次发动攻击的一边
			actHurt.bitmapRenderer = m_fightDB.m_bitmapRenderer;
			
			// 受伤者是之前的攻击者
			actHurt.addGrid(m_attgrid);
			var def:DefList;
			// 查找反击攻击格子
			var grid:FightGrid;
			grid = m_fightDB.m_fightGrids[1 - actHurt.side][m_battleArray.strikeBackList[0].pos];
			if (grid.tianfu && grid.tianfu.baseTianfuID == TianfuMgr.TIANFU_LianYing)
			{
				grid.tianfu.playAni();
			}
			// 这里还赋值了
			actCAttack.attGrid = grid;
			// 都是普通攻击			
			
			var battlenpcitem:TNpcBattleItem = grid.npcBaseItem;
			// 如果战斗 npc 表中配置命中特效播放帧数  
			if (battlenpcitem)
			{
				// 普通攻击播放完后就触发
				actHurt.delay = grid.beingList[0].getActLength(EntityCValue.TActAttack);
				actHurt.delayType = EntityCValue.DTTime;
			}
			else // 锦囊立马播放吧 
			{
				actHurt.delay = 0;
				actHurt.delayType = EntityCValue.DTTime;
			}
			
			actHurt.delay += actCAttack.delay; // 由于攻击延迟因此受伤也需要加上延迟
			actHurt.fAction = actCHurtCB;
			actHurt.fEnd = actCHurtEnd;
			actHurt.attGrid = grid;
			actHurt.cattAct = actCAttack; // 反击受伤通知反击攻击检测结束
			addToActionList(actHurt);
			
			// 注意攻击完受伤
			actCAttack.onEnter();
			actHurt.onEnter();
		
		}
		
		public function actCAttackCB(cattAct:RankCAttackAction):void
		{
			// 左边队伍向前移动距离 
			var attackBeing:NpcBattle;
			var attack:AttackItem;
			var atttarget:AttackTarget;
			
			var grid:FightGrid; // 攻击格子			
			// 被攻击者才是反击的攻击者
			grid = m_fightDB.m_fightGrids[1 - m_battleArray.aTeamid][m_battleArray.strikeBackList[0].pos];
			
			var list:Vector.<NpcBattle>;
			list = grid.beingList;
			for each (attackBeing in list)
			{
				attack = new AttackItem();
				
				attack.delay = 0;
				// 反击都是普通攻击
				attack.m_skillBaseitem = null;
				
				atttarget = new AttackTarget();
				atttarget.dam = 0;
				
				// 从供给空精灵取值   
				atttarget.hurtID = m_attgrid.topEmptySprite.id;
				atttarget.hurtType = EntityCValue.TEmptySprite;
				
				attack.addTarget(atttarget);
				attack.attackType = EntityCValue.ATFanJi; // 攻击类型是反击攻击，仅仅是一对一
				
				attackBeing.fightList.addAttackItem(attack);
			}
			
			// 播放反击声音
			grid.playAttMsc(false);
		
			// 回合处理完了，清理数据
			// 清理的是受伤的格子，就是攻击格子
			// 反击就不清理了，反击要等到受伤后才清理，后面还要继续用这个
			//defgrid.clearBattle();
		}
		
		protected function onRankCAttackActionEnd(act:IRankFightAction):void
		{
			if (!m_attgrid.isDie)
			{
				// 普通反击结束
				var actMove:RankMoveAction;
				var actCAttack:RankCAttackAction = act as RankCAttackAction;
				// 退回去,bug: 有时候退不回去，这是为什么啊     
				actMove = new RankMoveAction(act.battleArray);
				actMove.side = actCAttack.side;
				actMove.addGrid(m_attgrid)
				
				actMove.direction = actMove.side;
				actMove.fEnd = moveEndAfterFanji;
				//actMove.fAction = defaultActCB;
				
				actMove.bitmapRenderer = m_fightDB.m_bitmapRenderer;
				
				// 原地  
				var inplaceorder:InplaceOrder;
				inplaceorder = new InplaceOrder();
				actMove.pushOrder(inplaceorder);
				inplaceorder.side = actMove.side;
				
				inplaceorder.gkcontext = m_fightDB.m_gkcontext;
				
				inplaceorder.addGrid(m_attgrid);
				inplaceorder.totalCnt = m_attgrid.totalCnt;
				
				inplaceorder.vertX = m_attgrid.xlastPos;
				inplaceorder.vertY = m_attgrid.ylastPos;
				
				inplaceorder.destX = m_attgrid.xPos;
				inplaceorder.destY = m_attgrid.yPos;
				
				m_fightDB.m_actionList.push(actMove);
				actMove.onEnter();
			}
						
			m_roundControl.nextAttCB(EntityCValue.ASCAttacked, m_battleArray); // 反击触发
			deleteFromActionList(act);
			
			if (m_attgrid.isDie)
			{
				m_attgrid.state = EntityCValue.GSNormal;
				processOver();
			}
		}
		
		public function actCHurtEnd(actHurt:RankHurtAction):void
		{	
			(actHurt.cattAct as RankCAttackAction).bchurtOver();
			m_roundControl.nextAttCB(EntityCValue.ASHurted, m_battleArray);
			deleteFromActionList(actHurt);
		}
		
		// 反击受伤完成
		// 受伤动作回调    
		public function actCHurtCB(hurtAct:RankHurtAction):void
		{
			// 播放受伤动作    
			var hurtBeing:NpcBattle;
			
			
			var grid:FightGrid = m_fightDB.m_fightGrids[m_battleArray.aTeamid][m_battleArray.aGridNO]; // 受伤格子
			var attgrid:FightGrid; // 攻击格子
			
			var list:Vector.<NpcBattle>;
			attgrid = hurtAct.attGrid; // 取出攻击格子
			
			// 随机
			var timeList:Vector.<Number> = new Vector.<Number>();
			var totalcnt:uint;
			var curidx:uint;
			
			// 初始化时间数据			
			timeList.push(0);
			timeList.push(0.1);
			timeList.push(0.2);
			timeList.push(0.3);
			timeList.push(0.4);
			timeList.push(0.5);
			
			totalcnt = grid.beingList.length;
			
			list = grid.beingList;
			// 伤害值或者回血			
			
			grid.onStrikeBackList(m_battleArray);
			//badd = (pv.type == FightEn.ADD_HP);
			
			// 只有掉血才表现受伤特效    
			for each (hurtBeing in list)
			{
				var hurtitem:HurtItem = new HurtItem();
				
				hurtitem.hurtAct = EntityCValue.TActHurt;
				hurtitem.delay = 0;
				hurtitem.attackID = "";
				//hurtitem.dam = dam;
				hurtitem.m_hurtType = EntityCValue.HTFanJi; // 反击受伤
				
				// 随机计算延迟时间
				curidx = (int)(Math.random() * totalcnt);
				hurtitem.delay = timeList[curidx];
				timeList.splice(curidx, 1);
				totalcnt -= 1;
				hurtBeing.fightList.addHurtItem(hurtitem);			
			}
			
			// 回合处理完了，清理数据 
			//grid.clearBattle();
			//grid.clearAttBattle();
			
			// 播放反击受伤声音
			grid.playHurtMsc(false);
			
			m_fightDB.m_UIBattleHead.updateHp(0);
			m_fightDB.m_UIBattleHead.updateHp(2);
		}
		
		//被反击后，回到原地
		protected function moveEndAfterFanji(act:IRankFightAction):void
		{
			// 如果正在向原地运动，最后设置原地状态   
			if (m_attgrid.state == EntityCValue.GSOuted)
			{
				// 只有回到原始位置的时候才需要触发,向外移动不需要触发
				m_attgrid.state = EntityCValue.GSNormal;
				m_roundControl.nextAttCB(EntityCValue.ASIned, m_battleArray);
			}
			deleteFromActionList(act);
			processOver();
		}
		
		override protected function tryOver():void
		{
			if (m_bEndState && m_actionList.length == 0)
			{
				if (m_funOnEnd != null)
				{
					m_funOnEnd(this);
				}
			}
		}		
	}

}