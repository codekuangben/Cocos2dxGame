package modulefight.scene.fight.rank
{
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.scene.fight.FightGrid;

	/**
	 * ...
	 * @author 
	 * @brief 反击动作
	 */
	public class RankCAttackAction implements IRankFightAction
	{
		protected var m_battleArray:BattleArray;
		protected var m_delay:Number;		// 延迟时间，这个是动作结束后需要延迟的时间  
		protected var m_side:uint;			// 左边还是右边的队伍
		protected var m_fAction:Function;	// 执行的动作函数   
		protected var m_fEnd:Function;		// 结束回调 
	
		protected var m_hurtState:uint = 0;	// 攻击状态
		protected var m_fightGrids:Vector.<Vector.<FightGrid>>;	// 战斗格子
		protected var m_attGrid:FightGrid;		// 反击中攻击者格子(实际攻击中受伤者格子)
		
		protected var m_bcattOver:Boolean;		// 反击攻击动作是否结束
		protected var m_bchurtOver:Boolean;		// 反击受伤动作是否结束
		
		public function RankCAttackAction(battleArray:BattleArray) 
		{
			m_battleArray = battleArray;
			m_delay = 0;
			m_hurtState = EntityCValue.RKAttckNo;		
			m_bchurtOver = false;
			m_bcattOver = false;
		}
		
		public function onTick(deltaTime:Number):void
		{
			if (m_hurtState == EntityCValue.RKAttckNo)
			{
				m_delay -= deltaTime;
				if (m_delay <= 0)
				{
					// 开始反击
					m_fAction(this);
					m_hurtState = EntityCValue.RKAttacking;
				}
			}
			else if (m_hurtState == EntityCValue.RKAttacking)
			{
				if(m_bcattOver && m_bchurtOver)
				{
					m_hurtState = EntityCValue.RKAttackEnd;
					// 反击结束可以进行下一步动作了   
					onEnd();
				}
				else if (!m_bcattOver)
				{
					m_bcattOver = isOver();
				}
			}
		}
		
		public function onEnter():void
		{
			
		}
		
		public function onEnd():void
		{
			m_fEnd(this);
		}
		
		public function actType():uint
		{
			return EntityCValue.RKACTCAtt;
		}
		
		public function dispose():void
		{
			m_battleArray = null;
			m_fAction = null;
			m_fEnd = null;		
		
			
			var idx:int = 0;
			if(m_fightGrids)
			{	
				m_fightGrids = null;
			}
			
			m_attGrid = null;
		}
		
	
		// 
		protected function isOver():Boolean
		{
			var list:Vector.<NpcBattle>;
			var being:NpcBattle;

			list = m_attGrid.beingList;
			for each(being in list)
			{
				if (being.state != EntityCValue.TStand)
				{
					return false;
				}
			}
			
			return true;
		}
		
		public function get side():uint 
		{
			return m_side;
		}
		
		// bug: 这个值一定要设置，不设置就会出错的   
		public function set side(value:uint):void 
		{
			m_side = value;
		}
		
		public function get delay():Number 
		{
			return m_delay;
		}
		
		public function set delay(value:Number):void 
		{
			m_delay = value;
		}
		
		public function get fAction():Function 
		{
			return m_fAction;
		}
		
		public function set fAction(value:Function):void 
		{
			m_fAction = value;
		}
		
		public function get fEnd():Function 
		{
			return m_fEnd;
		}
		
		public function set fEnd(value:Function):void 
		{
			m_fEnd = value;
		}
		
		public function get fightGrids():Vector.<Vector.<FightGrid>> 
		{
			return m_fightGrids;
		}
		
		public function set fightGrids(value:Vector.<Vector.<FightGrid>>):void 
		{
			m_fightGrids = value;
		}
		
		public function get attGrid():FightGrid
		{
			return m_attGrid;
		}
		
		public function set attGrid(value:FightGrid):void
		{
			m_attGrid = value;
		}
		
		// 反击受伤是否是否结束
		public function bchurtOver():void
		{
			m_bchurtOver = true;
		}		
		
		public function get battleArray():BattleArray
		{
			return m_battleArray;
		}
	}
}