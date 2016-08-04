package modulefight.scene.fight.rank
{
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.scene.fight.FightGrid;
	import modulefight.netmsg.stmsg.BattleArray;
	/**
	 * ...
	 * @author 
	 * @brief 监听攻击和被击都完成
	 */
	public class RankAttHurtEnd implements IRankFightAction
	{
		protected var m_battleArray:BattleArray;
		protected var m_delay:Number;		// 延迟时间，这个是动作结束后需要延迟的时间  
		protected var m_side:uint;			// 左边还是右边的队伍
		//protected var m_fAction:Function;	// 执行的动作函数   
		protected var m_fEnd:Function;		// 结束回调 
		protected var m_gridList:Vector.<FightGrid>;	// 控制的格子列表
		protected var m_flags:Vector.<Boolean>;
		
		
		public function RankAttHurtEnd(battleArray:BattleArray) 
		{
			m_battleArray = battleArray;
			m_delay = 0;
			m_side = EntityCValue.RKLeft;
			m_gridList = new Vector.<FightGrid>();
			m_flags = new Vector.<Boolean>(2, true);
			m_flags[0] = false;
			m_flags[1] = false;
		}
		
		// 这个是通过回调触发的，不用每一帧都跑，就不用加到回调吧
		public function onTick(deltaTime:Number):void
		{
			
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
			return EntityCValue.RKACTAttHurtEnd;
		}
		
		public function dispose():void
		{
			m_battleArray = null;
			m_fEnd = null;
			if(m_gridList)
			{
				//m_gridList.length = 0;
				m_gridList = null;
			}
			
			if(m_flags)
			{		
				m_flags = null;
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
		
		//public function get fAction():Function 
		//{
			//return m_fAction;
		//}
		
		//public function set fAction(value:Function):void 
		//{
			//m_fAction = value;
		//}
		
		public function get fEnd():Function 
		{
			return m_fEnd;
		}
		
		public function set fEnd(value:Function):void 
		{
			m_fEnd = value;
		}
		
		// 攻击结束
		public function attEnd():void
		{
			m_flags[0] = true;
			if (m_flags[0] && m_flags[1])
			{
				onEnd();
			}
		}
		
		public function hurtEnd():void
		{
			m_flags[1] = true;
			if (m_flags[0] && m_flags[1])
			{
				onEnd();
			}
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