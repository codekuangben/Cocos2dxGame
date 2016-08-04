package modulefight.scene.fight.rank
{
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.scene.fight.FightGrid;
	import modulefight.netmsg.stmsg.BattleArray;
	/**
	 * ...
	 * @author 
	 * @brief 根据技能添加 buffer 特效，主要是控制时间，可以通过延迟字段，直接添加在人身上。
	 */
	public class RankBufEffAction implements IRankFightAction
	{
		protected var m_battleArray:BattleArray;
		protected var m_delay:Number;		// 延迟时间
		protected var m_fAction:Function;	// 执行的动作函数
		protected var m_fEnd:Function;		// 结束回调
		
		protected var m_side:uint;			// 左边还是右边的队伍
		protected var m_gridList:Vector.<FightGrid>;	// 控制的格子列表
		protected var m_EffId:String = "";		// 特效 id ，上层特效 id
		protected var m_EffId1:String = "";		// 特效 id ，下层特效 id
		protected var m_frameRate:uint = 0;		// buf 特效播放帧率，上层特效 id
		protected var m_frameRate1:uint = 0;		// buf 特效播放帧率，下层特效 id
		
		public function RankBufEffAction(battleArray:BattleArray) 
		{
			m_battleArray = battleArray;
			m_delay = 0;
			m_side = EntityCValue.RKLeft;
			m_gridList = new Vector.<FightGrid>();
		}
		
		public function onTick(deltaTime:Number):void
		{
			m_delay -= deltaTime;
			if (m_delay <= 0)
			{ 
				m_fAction(this);
				// 添加完特效直接结束吧
				onEnd();
			}
		}
		
		public function onEnter():void
		{
			
		}
		
		public function onEnd():void
		{
			m_fEnd(this);
		}
		
		public function dispose():void
		{
			m_battleArray = null;
			m_fAction = null;
			m_fEnd = null;
			
			if(m_gridList)
			{
				//m_gridList.length = 0;
				m_gridList = null;
			}
		}
		
		public function actType():uint
		{
			return EntityCValue.RKACTBufEff;
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
		
		public function get frameRate():uint
		{
			return m_frameRate;
		}
		
		public function set frameRate(value:uint):void
		{
			m_frameRate = value;
		}
		
		public function get frameRate1():uint
		{
			return m_frameRate1;
		}
		
		public function set frameRate1(value:uint):void
		{
			m_frameRate1 = value;
		}
		
		public function get effId():String
		{
			return m_EffId;
		}
		
		public function set effId(value:String):void
		{
			m_EffId = value;
		}
		
		public function get effId1():String
		{
			return m_EffId1;
		}
		
		public function set effId1(value:String):void
		{
			m_EffId1 = value;
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