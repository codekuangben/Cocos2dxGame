package modulefight.scene.fight.rank
{
	//import com.bit101.components.VBox;
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.netmsg.stmsg.BattleArray;
	
	import modulefight.netmsg.stmsg.DefList;
	import modulefight.render.BitmapRenderer;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.scene.fight.FightGrid;
	import modulefight.scene.fight.FightLogicCB;

	/**
	 * ...
	 * @author 
	 * @brief 队伍移动   
	 */
	public class RankMoveAction implements IRankFightAction
	{
		protected var m_battleArray:BattleArray;
		protected var m_delay:Number;		// 延迟时间  
		protected var m_fAction:Function;		// 执行的动作函数   
		protected var m_fEnd:Function;			// 结束回调
		public var m_moveTFrame:Function;	// 向前移动到某一帧回调
		
		protected var m_direction:uint;	// 		移动方向
		protected var m_side:uint;		// 左边还是右边的队伍 
		
		protected var m_moveState:uint = 0;
		protected var m_orderVector:Vector.<OrderBase>;		// 队形队列     
		protected var m_gridList:Vector.<FightGrid>;	// 控制的格子列表  
		protected var m_fightGrids:Vector.<Vector.<FightGrid>>;	// 战斗格子
		
		protected var m_bitmapRenderer:BitmapRenderer;		// 添加渲染
		public var m_fightLogicCB:FightLogicCB;
		protected var m_moveTime:Number = 0;	// 移动需要的时候
		protected var m_totalTime:Number = 0;	// 已经运行的时间
		protected var m_trigCB:Boolean;	// 是否触发移动中间回调函数
		
		public function RankMoveAction(battleArray:BattleArray) 
		{
			m_battleArray = battleArray;
			m_delay = 0;
			m_side = EntityCValue.RKLeft;
			m_direction = EntityCValue.RKDIRLeft;
			
			m_moveState = EntityCValue.RKMoveNo;
			m_orderVector = new Vector.<OrderBase>();
			m_gridList = new Vector.<FightGrid>();
		}
		
		// 向外移动一定要保证自己和被攻击方在 GSNormal 状态再移动，向里移动无所谓    
		public function onEnter():void
		{
			// 检测只有当当前队伍处于静止状态的时候，才移动  
			if (m_side != m_direction)	// 如果向外走 
			{
				
				var attrGrid:FightGrid;
				attrGrid = m_gridList[0];
				
				// bug: 有时候这个返回值 m_moveTime 竟然是 NaN
				m_moveTime = m_fightLogicCB.calcTimeBetGrid(attrGrid.attBattle) * 0.8;	// 基本到最后一帧再触发,不用中间某一帧了
				m_trigCB = false;
				m_totalTime = 0;
				
				var bExec:Boolean;
				if (attrGrid.state == EntityCValue.GSNormal)
				{
					if (m_battleArray.attackedList.isEmpty)
					{
						bExec = true;
					}
					else
					{
						if (m_fightGrids[1 - attrGrid.side][m_battleArray.attackedList.list[0].gridNO].state == EntityCValue.GSNormal)
						{
							bExec = true;
						}
					}					
				}
				if (bExec)
				{
					if (m_orderVector.length)
					{
						m_orderVector[0].buildOrder();
						m_moveState = EntityCValue.RKMoveing;
						// 开始的时候添加拖尾人物
						addBeingBlur();
					}
				}				
				else
				{
					// 设置等待进入可以移动状态   
					m_moveState = EntityCValue.RKMovePrep;
				}
			}
			else
			{
				if (m_orderVector.length)
				{
					m_orderVector[0].buildOrder();
					m_moveState = EntityCValue.RKMoveing;
					// 开始的时候添加拖尾人物
					addBeingBlur();
				}
			}
		}
		
		public function onEnd():void
		{
			correctDirect();
			m_fEnd(this);
		}
		
		public function onTick(deltaTime:Number):void
		{
			var def:DefList;
			var attrGrid:FightGrid;
			
			// 如果动作已经完成
			if (m_moveState == EntityCValue.RKMovePrep)
			{
				var bExec:Boolean;
				attrGrid = m_gridList[0];
				if (attrGrid.state == EntityCValue.GSNormal)
				{
					if (m_battleArray.attackedList.isEmpty)
					{
						bExec = true;
					}
					else
					{
						if (m_fightGrids[1 - attrGrid.side][m_battleArray.attackedList.list[0].gridNO].state == EntityCValue.GSNormal)
						{
							bExec = true;
						}
					}	
				}
				if (bExec)
				{
					if (m_orderVector.length)
					{
						m_orderVector[0].buildOrder();
						m_moveState = EntityCValue.RKMoveing;
						// 开始的时候添加拖尾人物
						//addBeingBlur();
					}
				}				
				
			}
			//else if (m_moveState == EntityCValue.RKMoveNo)
			//{
			//	m_delay -= deltaTime;
			//	if (m_delay <= 0)
			//	{
			//		m_fAction(this);
			//		m_moveState = EntityCValue.RKMoveing;
			//	}
			//}
			else if (m_moveState == EntityCValue.RKMoveing)
			{
				if (m_side != m_direction)		// 只有向外走的时候才触发这个事件
				{
					if(!m_trigCB)
					{
						m_totalTime += deltaTime;
						if(m_totalTime >= m_moveTime)
						{
							
							if(m_moveTFrame != null)
							{
								m_moveTFrame(this);
							}
							m_trigCB = true;
						}
					}
				}
				// 如果动作移动完了
				if(isOver())
				{
					// bug: 有时候两帧之间间隔很大,结果某一帧还没有触发，那么就在最后的时候触发一下
					if (m_side != m_direction)		// 只有向外走的时候才触发这个事件
					{
						if(!m_trigCB)
						{
							if(m_moveTFrame != null)
							{
								m_moveTFrame(this);
							}
							m_trigCB = true;
						}
					}
					// 清理人物拖尾
					clearBeingBlue();
					// 结束这个动作
					onEnd();
					m_moveState = EntityCValue.RKMoveEnd;
				}
			}
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
		
		public function set direction(value:uint):void 
		{
			m_direction = value;
		}
		
		public function get direction():uint 
		{
			return m_direction;
		}
		
		public function set fEnd(value:Function):void 
		{
			m_fEnd = value;
		}
		
		public function set fAction(value:Function):void 
		{
			m_fAction = value;
		}
		
		// bug: 这个值一定要设置，不设置就会出错的   
		public function get side():uint 
		{
			return m_side;
		}
		
		public function set side(value:uint):void 
		{
			m_side = value;
		}
		
		public function pushOrder(value:OrderBase):void 
		{
			m_orderVector.push(value);
		}
		
		public function actType():uint
		{
			return EntityCValue.RKACTMove;
		}
		
		public function dispose():void
		{
			m_battleArray = null;
			m_fAction = null;
			m_fEnd = null;
			m_moveTFrame = null;
			if(m_orderVector)
			{
				m_orderVector.length = 0;
				m_orderVector = null;
			}
			
			if(m_gridList)
			{
				//m_gridList.length = 0;
				m_gridList = null;
			}
			
			var idx:int = 0;
			if(m_fightGrids)
			{
				m_fightGrids = null;
			}
			
			m_bitmapRenderer = null;
			m_fightLogicCB = null;
		}
		
		/*
		 * 
		 * 如果是准备移动判断是否结束，就不移掉这个队列    
		 */ 
		protected function isOver():Boolean
		{
			var list:Vector.<NpcBattle>;
			var being:BeingEntity;
			var grid:FightGrid;
			
			// 如果之前就站立状态，每一帧还是要遍历，直到所有的都站立  
			for each(grid in m_gridList)
			{
				list = grid.beingList;
				for each(being in list)
				{
					if (!being.isState(EntityCValue.TStand))
					{
						return false;
					}
				}
			}
			
			// 说明上一个移动已经做完了，进行下一个移动   
			m_orderVector.shift();
			if (m_orderVector.length)
			{
				m_orderVector[0].buildOrder();
				return false;
			}
			
			// 所有移动都做完了，就结束移动  
			return true;
		}
		
		// 最终将所有玩家的方向放到正确的位置     
		protected function correctDirect():void
		{
			var list:Vector.<NpcBattle>;
			var being:NpcBattle;
			var grid:FightGrid;
			for each(grid in m_gridList)
			{
				list = grid.beingList;
				for each(being in list)
				{
					if (m_side == EntityCValue.RKLeft)
					{
						being.direction = 0;
					}
					else
					{
						being.direction = 180;
					}
				}
			}
		}
		
		public function get fightGrids():Vector.<Vector.<FightGrid>> 
		{
			return m_fightGrids;
		}
		
		public function set fightGrids(value:Vector.<Vector.<FightGrid>>):void 
		{
			m_fightGrids = value;
		}
		
		public function addBeingBlur():void
		{
			var list:Vector.<NpcBattle>;
			var being:NpcBattle;
			var grid:FightGrid;
			
			// 如果之前就站立状态，每一帧还是要遍历，直到所有的都站立  
			for each(grid in m_gridList)
			{
				list = grid.beingList;
				for each(being in list)
				{
					m_bitmapRenderer.addBeing(being);
				}
			}
		}
		
		public function clearBeingBlue():void
		{
			var list:Vector.<NpcBattle>;
			var being:NpcBattle;
			var grid:FightGrid;
			
			// 如果之前就站立状态，每一帧还是要遍历，直到所有的都站立  
			for each(grid in m_gridList)
			{
				list = grid.beingList;
				for each(being in list)
				{
					m_bitmapRenderer.clearBeing(being);
				}
			}
		}
		
		public function set bitmapRenderer(value:BitmapRenderer):void
		{
			m_bitmapRenderer = value;
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
			return m_battleArray.m_fightIdx;
		}
	}
}