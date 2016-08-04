package modulefight.scene.fight.rank
{
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.scene.beings.NpcBattle;
	
	import modulefight.netmsg.stmsg.DefList;
	import modulefight.scene.fight.FightGrid;

	/**
	 * ...
	 * @author 
	 * @brief 做攻击动作   
	 */
	public class RankAttackAction implements IRankFightAction
	{
		protected var m_battleArray:BattleArray;
		protected var m_delay:Number;		// 延迟时间
		protected var m_fAction:Function;	// 执行的动作函数
		protected var m_fEnd:Function;		// 结束回调
		
		protected var m_side:uint;			// 左边还是右边的队伍
		protected var m_hurtState:uint = 0;	// 攻击状态
		 
		protected var m_gridList:Vector.<FightGrid>;	// 控制的格子列表   
		protected var m_callback:Function;		// 这个是回调函数，飞行特效用来通知其它进行相关的处理
		protected var m_attHurtEnd:IRankFightAction;	// RankAttHurtEnd;		// 监听攻击和受伤都完成的动作
				
		public function RankAttackAction(battleArray:BattleArray) 
		{
			m_battleArray = battleArray;
			m_delay = 0;
			m_side = EntityCValue.RKLeft;

			m_hurtState = EntityCValue.RKAttckNo;
			m_gridList = new Vector.<FightGrid>();
		}
		
		// 攻击一定要保证对方在 GSNormal 状态再攻击  
		public function onEnter():void
		{
			//var def:DefList;
			//var defGrid:FightGrid;
			//defGrid = m_gridList[0];
			
			//def = defGrid.attBattle.defData[0];
			//if (m_fightGrids[1 - defGrid.side][def.bPos].state == EntityCValue.GSNormal)
			//{
				//m_hurtState = EntityCValue.RKAttckNo;
			//}
			//else
			//{
				//m_hurtState = EntityCValue.RKAttckPrep;
			//}
		}
		
		public function onEnd():void
		{
			m_fEnd(this);
		}
		
		public function onTick(deltaTime:Number):void
		{
			//var def:DefList;
			//var defGrid:FightGrid;
			
			//if (m_hurtState == EntityCValue.RKAttckPrep)
			//{
				//defGrid = m_gridList[0];
				//def = defGrid.attBattle.defData[0];
				//if (m_fightGrids[1 - defGrid.side][def.bPos].state == EntityCValue.GSNormal)
				//{
					//m_hurtState = EntityCValue.RKAttckNo;
				//}
			//}
			//else if (m_hurtState == EntityCValue.RKAttckNo)
			if (m_hurtState == EntityCValue.RKAttckNo)
			{
				m_delay -= deltaTime;
				if (m_delay <= 0)
				{
					// 开始攻击    
					m_fAction(this);
					m_hurtState = EntityCValue.RKAttacking;
				}
			}
			else if (m_hurtState == EntityCValue.RKAttacking)
			{
				if(isOver())
				{
					m_hurtState = EntityCValue.RKAttackEnd;
					// 攻击结束可以进行下一步动作了   
					onEnd();
				}
			}
		}
		
		public function actType():uint
		{
			return EntityCValue.RKACTAttack;
		}
		
		public function get delay():Number 
		{
			return m_delay;
		}
		
		public function set delay(value:Number):void 
		{
			m_delay = value;
		}
		
		public function addGrid(grid:FightGrid):void
		{
			m_gridList.push(grid);
		}
		
		public function get getGrid():Vector.<FightGrid>
		{
			return m_gridList;
		}
		
		public function set setGrid(list:Vector.<FightGrid>):void
		{
			m_gridList = list;
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
		
		public function dispose():void
		{
			m_battleArray = null;
			m_fAction = null;
			m_fEnd = null;
			
			if(m_gridList)
			{
				//m_gridList.length = 0;	// 不能清 0 ,后面要用到
				m_gridList = null;
			}
			
			m_callback = null;
			m_attHurtEnd = null;
		}
		
		protected function isOver():Boolean
		{
			var list:Vector.<NpcBattle>;
			var being:NpcBattle;
			var grid:FightGrid;
			
			for each(grid in m_gridList)
			{
				list = grid.beingList;
				for each(being in list)
				{
					if (being.state != EntityCValue.TStand)
					{
						return false;
					}
					
					// 近战攻击特效释放完成后才返回原来位置
					if(grid.attType != EntityCValue.ATTFar)
					{
						if(!being.bAttEffOver())
						{
							return false;
						}
					}
				}
			}
			
			return true;
		}
		
		public function set callback(value:Function):void
		{
			m_callback = value;
		}

		public function get callback():Function
		{
			return m_callback;
		}
		
		public function set attHurtEnd(value:IRankFightAction):void
		{
			m_attHurtEnd = value;
		}
		
		public function get attHurtEnd():IRankFightAction
		{
			return m_attHurtEnd;
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
		public function get fightIdx():int
		{
			return m_battleArray.m_fightIdx
		}
	}
}