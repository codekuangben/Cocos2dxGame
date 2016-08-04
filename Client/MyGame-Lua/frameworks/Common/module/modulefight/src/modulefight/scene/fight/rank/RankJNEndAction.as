package modulefight.scene.fight.rank
{
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	
	import flash.utils.Dictionary;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.scene.fight.FightGrid;
	
	/**
	 * ...
	 * @author 
	 * @brief 锦囊动作结束，结束后就把全屏效果去掉   
	 */
	public class RankJNEndAction implements IRankFightAction
	{
		protected var m_battleArray:BattleArray;
		protected var m_hurtState:uint = 0;		// 受伤状态
		protected var m_gridList:Vector.<FightGrid>;	// 控制的格子列表，就是受伤的格子
		protected var m_fEnd:Function;			// 结束回调
		protected var m_id2Ret:Dictionary;	// 记录受伤 id 是否受伤完成
		protected var m_id2state:Dictionary;	// 记录受伤 id 第一个过程状态 0 是没有受伤 1 受伤中 2 受伤结束
		protected var m_hurtCnt:uint;		// 受伤的人的数量
		
		//protected var m_jnBA:BattleArray;	// 锦囊战斗数组
		public var m_fightIdx:int;
		
		public function RankJNEndAction(battleArray:BattleArray)
		{
			m_battleArray = battleArray;
			m_hurtState = EntityCValue.RKHurtNo;
			m_gridList = new Vector.<FightGrid>();
			m_id2Ret = new Dictionary();
			m_id2state = new Dictionary();
		}
		
		public function dispose():void
		{
			m_battleArray = null;
			if(m_gridList)
			{
				//m_gridList.length = 0;
				m_gridList = null;
			}
			
			m_fEnd = null;
			m_id2Ret = null;
			m_id2state = null;
		}
		
		public function onEnter():void
		{
			m_hurtState = EntityCValue.RKHurting;
		}
		
		public function onEnd():void
		{
			m_fEnd(this);
		}
		
		// 播放受伤动作，动作完成    
		public function onTick(deltaTime:Number):void
		{
			if (m_hurtState == EntityCValue.RKHurting)
			{
				if(isHurt())
				{
					m_hurtState = EntityCValue.RKHurtEnd;
					onEnd();
				}
			}
		}
		
		public function addGrid(grid:FightGrid):void
		{
			m_gridList.push(grid);
			m_hurtCnt += grid.totalCnt;
		}
		
		public function get getGrid():Vector.<FightGrid>
		{
			return m_gridList;
		}
		
		public function set setGrid(list:Vector.<FightGrid>):void
		{
			m_gridList = list;
		}
		
		public function get fEnd():Function 
		{
			return m_fEnd;
		}
		
		public function set fEnd(value:Function):void 
		{
			m_fEnd = value;
		}
		
		public function actType():uint
		{
			return EntityCValue.RKACTJNEnd;
		}
		
		//public function set jnBA(value:BattleArray):void
		//{
		//	m_jnBA = value;
		//}
		
		//public function get jnBA():BattleArray
		//{
		//	return m_jnBA;
		//}
		
		protected function isHurt():Boolean
		{
			var list:Vector.<NpcBattle>;
			var being:BeingEntity;
			var grid:FightGrid;
			for each(grid in m_gridList)
			{
				list = grid.beingList;
				for each(being in list)
				{
					// 如果处于受伤或者死亡状态都属于受伤    
					if (!m_id2Ret[being.id])
					{
						if(!m_id2state[being.id])
						{
							if(being.isState(EntityCValue.THurt) || being.isState(EntityCValue.TDie))
							{
								m_id2state[being.id] = 1;
							}
						}
						else if(1 == m_id2state[being.id])
						{
							if(being.isState(EntityCValue.TDie))
							{
								if (being.aniOver())
								{
									m_id2state[being.id] = 2;
									--m_hurtCnt;
									m_id2Ret[being.id] = true;
								}
							}
							else if(being.isState(EntityCValue.TStand))		// 又恢复站立状态
							{
								m_id2state[being.id] = 2;
								--m_hurtCnt;
								m_id2Ret[being.id] = true;
							}
						}
					}
				}
			}
			
			if (m_hurtCnt == 0)
			{
				return true;
			}
			return false;
		}
		
		public function inAction(list:Vector.<FightGrid>):Boolean
		{
			var idx:uint = 0;
			var interidx:uint = 0;
			while(idx < list.length)
			{
				interidx = 0;
				while(interidx < m_gridList.length)
				{
					if(list[idx] == m_gridList[interidx])
					{
						return true;
					}
					++interidx;
				}
				
				++idx;
			}
			
			return false;
		}
		public function get battleArray():BattleArray
		{
			return m_battleArray;
		}
		
	}
}