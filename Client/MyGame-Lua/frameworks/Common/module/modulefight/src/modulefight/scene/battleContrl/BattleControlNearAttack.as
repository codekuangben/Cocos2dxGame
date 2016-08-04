package modulefight.scene.battleContrl
{
	/**
	 * ...
	 * @author
	 * 近攻，即跑到目标面前播放攻击动作
	 */
	import com.pblabs.engine.entity.EntityCValue;
	//import common.scene.fight.AttackItem;
	//import common.scene.fight.AttackTarget;
	//import common.scene.fight.HurtItem;
	import flash.geom.Point;
	//import modulecommon.scene.prop.table.TNpcBattleItem;
	//import modulefight.FightEn;
	import modulefight.netmsg.stmsg.BattleArray;
	//import modulefight.netmsg.stmsg.DefList;
	//import modulefight.netmsg.stmsg.PkValue;
	//import modulefight.netmsg.stmsg.stStrikeBack;
	//import modulefight.scene.beings.NpcBattle;
	import modulefight.scene.fight.FightDB;
	import modulefight.scene.fight.FightGrid;
	import modulefight.scene.fight.FightLogicCB;
	import modulefight.scene.fight.rank.InplaceOrder;
	import modulefight.scene.fight.rank.IRankFightAction;
	import modulefight.scene.fight.rank.RankAttackAction;
	import modulefight.scene.fight.rank.RankAttHurtEnd;
	import modulefight.scene.fight.rank.RankBufEffAction;
	//import modulefight.scene.fight.rank.RankCAttackAction;
	import modulefight.scene.fight.rank.RankHurtAction;
	import modulefight.scene.fight.rank.RankMoveAction;
	import modulefight.scene.fight.rank.RankSelfTeamEffectAction;
	import modulefight.scene.roundcontrol.RoundControl;
	public class BattleControlNearAttack extends BattleControlBase
	{
		private var m_fanjiControl:FanjiControl;
		public function BattleControlNearAttack(fightDB:FightDB, fightLogicCB:FightLogicCB, roundControl:RoundControl, bat:BattleArray)
		{
			super(fightDB, fightLogicCB, roundControl, bat);
		}
		
		override protected function prcessAttack():void
		{
			super.prcessAttack();
			processValueEffect();
			var act:RankMoveAction = new RankMoveAction(m_battleArray);
			// 队伍向前移动距离，生成移动动作  
			act.side = m_battleArray.aTeamid;
			act.direction = 1 - m_battleArray.aTeamid;
			act.fightGrids = m_fightDB.m_fightGrids;
			act.m_fightLogicCB = m_fightLogicCB;
			act.m_moveTFrame = moveTFrameCB;
			
			act.addGrid(m_attgrid);
			act.fEnd = moveEndBeforeAttack;
			act.fAction = null;
			
			act.bitmapRenderer = m_fightDB.m_bitmapRenderer;
			
			// 原地变换  
			var inplaceorder:InplaceOrder = new InplaceOrder();
			act.pushOrder(inplaceorder);
			inplaceorder.side = m_battleArray.aTeamid;
			inplaceorder.gkcontext = m_fightDB.m_gkcontext;
			
			inplaceorder.addGrid(m_attgrid);
			inplaceorder.totalCnt = m_attgrid.totalCnt;
			inplaceorder.vertX = m_attgrid.xPos;
			inplaceorder.vertY = m_attgrid.yPos;
			
			var top:Point = attGridTop(1 - m_battleArray.aTeamid, m_battleArray.getAttackActTargetPos(), m_attgrid.attType);
			inplaceorder.destX = top.x;
			inplaceorder.destY = top.y;
			
			// 记录上一次位置
			m_attgrid.xlastPos = top.x;
			m_attgrid.ylastPos = top.y;
			
			addToActionList(act);
			act.onEnter();
		}
		
		// 获取某一个格子的攻击格子顶点坐标，offgrid: 就是距离格子的距离， 整数是在这个歌格子的前面的巨鹿，负数是在这个格子后面的距离
		protected function attGridTop(side:uint, grididx:uint, offgrid:int):Point
		{
			// 左边的获取
			var top:Point = new Point();
			var grid:FightGrid = m_fightDB.m_fightGrids[side][grididx];
			if (EntityCValue.RKLeft == side)
			{
				top.x = grid.xPos + (offgrid - 1) * m_fightDB.m_gridWidth; // offgrid 是从 1 开始的
				top.y = grid.yPos;
			}
			else
			{
				top.x = grid.xPos - (offgrid - 1) * m_fightDB.m_gridWidth;
				top.y = grid.yPos;
			}
			
			return top;
		}
		
		override protected function onAttackActEnd(act:IRankFightAction):void
		{
			var actAttack:RankAttackAction = act as RankAttackAction;
			
			// 如果没有反击，直接退回去吧，有的话，走反击,attHurtEnd 存在说明有监听攻击和被击的反击事件
			if (!actAttack.attHurtEnd)
			{
				// 退回去,bug: 有时候退不回去，这是为什么啊
				var actMove:RankMoveAction = new RankMoveAction(m_battleArray);
				actMove.side = actAttack.side;
				actMove.setGrid = actAttack.getGrid;
				
				actMove.direction = actMove.side;
				actMove.fEnd = moveEndAfterAttack;
				//actMove.fAction = defaultActCB;
				
				actMove.bitmapRenderer = m_fightDB.m_bitmapRenderer;
				
				// 原地  
				var inplaceorder:InplaceOrder = new InplaceOrder();
				actMove.pushOrder(inplaceorder);
				inplaceorder.side = actMove.side;
				
				inplaceorder.gkcontext = m_fightDB.m_gkcontext;
				
				inplaceorder.addGrid(m_attgrid);
				inplaceorder.totalCnt = m_attgrid.totalCnt;
				
				// bug: 如果移动中间被打断,结果没有到达 m_vertX 就停下了, m_destX - m_vertX 的距离就是错误的
				inplaceorder.vertX = m_attgrid.xlastPos;
				inplaceorder.vertY = m_attgrid.ylastPos;
				
				inplaceorder.destX = m_attgrid.xPos;
				inplaceorder.destY = m_attgrid.yPos;
				
				addToActionList(actMove);
				actMove.onEnter();
				
				// 攻击动作播完成，触发下一次攻击
				m_roundControl.nextAttCB(EntityCValue.ASAttacked, m_battleArray);
			}
			else // attHurtEnd 存在说明有监听攻击和被击的反击事件，通知受伤动作已经完成
			{
				// 确定攻击结束
				(actAttack.attHurtEnd as RankAttHurtEnd).attEnd();
			}
			
			deleteFromActionList(actAttack);
		}
		
		protected function moveEndBeforeAttack(act:IRankFightAction):void
		{
			m_attgrid.state = EntityCValue.GSOuted;
			startAttack();
			
			deleteFromActionList(act);
		}
		
		//攻击动作完成、受伤动作完成，开始反击
		protected function onRankAttHurtEnd(act:IRankFightAction):void
		{
			deleteFromActionList(act);
			m_fanjiControl = new FanjiControl(m_fightDB, m_fightLogicCB, m_roundControl,m_battleArray);
			m_fanjiControl.funOnEnd = onFanjiControlEnd;
			m_fanjiControl.begin();
		}
		
		protected function onFanjiControlEnd(control:FanjiControl):void
		{
			m_fanjiControl = null;
			processOver();
		}
		
		override public function actHurtEnd(actHurt:RankHurtAction):void
		{
			// 技能释放时，屏幕暗处理，动作播放完成结束处理
			if (m_fightDB.m_bchGI)
			{
				m_fightLogicCB.chCharGI(m_battleArray, false);
			}
			
			if (actHurt.attHurtEnd)
			{
				(actHurt.attHurtEnd as RankAttHurtEnd).hurtEnd();
			}
			
			m_roundControl.nextAttCB(EntityCValue.ASHurted, m_battleArray);
			deleteFromActionList(actHurt);
		}
		
		
		protected function moveEndAfterAttack(act:IRankFightAction):void
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
		
		protected function startAttack():void
		{
			var actAttack:RankAttackAction = createRankAttackAction();
			var actHurt:RankHurtAction = createRankHurtAction();
			if (actHurt)
			{
				setParamForAttack(m_battleArray, actAttack, actHurt);
			}
			var actSefTeamEffect:RankSelfTeamEffectAction = createRankSelfTeamEffectAction();
			var actBufEff:RankBufEffAction = createRankBufEffAction();
			
			if (m_battleArray.strikeBackList)
			{
				var actAckHurtEnd:RankAttHurtEnd = new RankAttHurtEnd(m_battleArray);
				actAckHurtEnd.side = m_battleArray.aTeamid; // 永远填写攻击一边
				actAckHurtEnd.setGrid = actAttack.getGrid;
				actAckHurtEnd.fEnd = onRankAttHurtEnd;
				addToActionList(actAckHurtEnd);
				actAckHurtEnd.onEnter();
				
				// 赋值回调
				actAttack.attHurtEnd = actAckHurtEnd;
				actHurt.attHurtEnd = actAckHurtEnd;
			}
		}
		
		// 向前移动到某一帧回调
		protected function moveTFrameCB(act:IRankFightAction):void
		{
			var actMove:RankMoveAction;
			if (act.actType() == EntityCValue.RKACTMove)
			{
				actMove = act as RankMoveAction;
				m_roundControl.nextAttCB(EntityCValue.ASOuting, actMove.battleArray); // 触发下一次战斗
			}
		}
		
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);
			if (m_fanjiControl)
			{
				m_fanjiControl.onTick(deltaTime);
			}
		}
		
		override public function dispose():void 
		{
			if (m_fanjiControl)
			{
				m_fanjiControl.dispose();
			}
			super.dispose();
		}
	}

}