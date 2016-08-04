package modulefight.scene.fight.rank
{
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.DebugBox;
	import org.ffilmation.engine.helpers.fUtil;
	
	import flash.utils.Dictionary;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.render.BitmapRenderer;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.scene.fight.FightGrid;

	/**
	 * ...
	 * @author 
	 * @brief 做受伤动作   
	 */
	public class RankHurtAction implements IRankFightAction
	{
		protected var m_battleArray:BattleArray;
		protected var m_delayType:uint;
		protected var m_delay:Number;			// 延迟时间  
		protected var m_delayFrame:int;		// 延迟的帧数    
		protected var m_fAction:Function;		// 执行的动作函数，播放受伤动作   
		protected var m_fEnd:Function;			// 结束回调 
		
		protected var m_side:uint;				// 左边还是右边的队伍 
		protected var m_hurtState:uint = 0;		// 受伤状态   
		
		protected var m_hurtCnt:uint;		// 受伤的人的数量    
		protected var m_id2Ret:Dictionary;	// 记录受伤 id 是否检查过  
		protected var m_gridList:Vector.<FightGrid>;	// 控制的格子列表，就是受伤的格子   
		protected var m_attGrid:FightGrid;				// 就是攻击的格子 
		protected var m_bitmapRenderer:BitmapRenderer;		// 添加渲染
		protected var m_attHurtEnd:IRankFightAction; // RankAttHurtEnd;		// 通知反击攻击和受伤动作都完成
		protected var m_cattAct:IRankFightAction; 	 // RankCAttackAction;	// 通知反击攻击反击受伤结束
		protected var m_bDisposed:Boolean;
		
		public function RankHurtAction(battleArray:BattleArray) 
		{
			m_battleArray = battleArray;
			m_delayType = EntityCValue.DTTime;
			m_side = EntityCValue.RKLeft;
			m_hurtState = EntityCValue.RKHurtNo;
			m_id2Ret = new Dictionary();
			m_gridList = new Vector.<FightGrid>();			
		}
		
		public function onEnter():void
		{
			
		}
		
		public function onEnd():void
		{
			m_fEnd(this);
		}
		
		// 播放受伤动作，动作完成    
		public function onTick(deltaTime:Number):void
		{
			//if (m_hurtState == EntityCValue.RKHurtNo)
			//{
				//if(isHurt())
				//{
					//m_hurtState = EntityCValue.RKHurting;
				//}
			//}
			if (m_hurtState == EntityCValue.RKHurtNo)
			{
				if (m_delayType == EntityCValue.DTTime)
				{
					m_delay -= deltaTime;
					if (m_delay <= 0)
					{
						// 开始播放受伤         
						m_fAction(this);
						m_hurtState = EntityCValue.RKHurting;
						
						// 开始的时候添加拖尾人物
						addBeingBlur();
					}
				}
				else if(m_delayType == EntityCValue.DTFrame)
				{
					--m_delayFrame;
					if (m_delayFrame <= 0)
					{
						// 开始播放受伤         
						m_fAction(this);
						m_hurtState = EntityCValue.RKHurting;
					}
				}
			}
			else if (m_hurtState == EntityCValue.RKHurting)
			{
				if(isOver())
				{
					// 清理人物拖尾
					clearBeingBlue();
					
					m_hurtState = EntityCValue.RKHurtEnd;
					onEnd();
				}
			}
			
			if (m_battleArray&&m_battleArray.m_gkContext.m_battleMgr.m_stopInfo)
			{
				var strLog:String = "RankHurtAction::onTick--m_hurtState=" + m_hurtState + " m_delayType=" + m_delayType + " m_delayFrame=" + m_delayFrame;
				m_battleArray.m_gkContext.addLog(strLog);
			}
		}
		
		public function actType():uint
		{
			return EntityCValue.RKACTHurt;
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
		
		public function get side():uint 
		{
			return m_side;
		}
		
		// bug: 这个值一定要设置，不设置就会出错的   
		public function set side(value:uint):void 
		{
			m_side = value;
		}
		
		public function get hurtCnt():uint 
		{
			return m_hurtCnt;
		}
		
		// 这个一定要设置正确，受伤的人数根据进攻的人数确定，不是根据受伤队伍的人数确定，有时候受伤队伍人数和受伤人数是不相同的       
		public function set hurtCnt(value:uint):void 
		{
			m_hurtCnt = value;
		}
		
		public function get delayFrame():int 
		{
			return m_delayFrame;
		}
		
		public function set delayFrame(value:int):void 
		{
			m_delayFrame = value;
		}
		
		public function get delayType():uint 
		{
			return m_delayType;
		}
		
		public function set delayType(value:uint):void 
		{
			m_delayType = value;
		}
		
		public function dispose():void
		{
			m_bDisposed = true;
			
			m_bitmapRenderer = null;
			if(m_gridList)
			{
				//m_gridList.length = 0;
				m_gridList = null;
			}
			m_fAction = null;
			m_fEnd = null;
			m_battleArray = null;
			m_id2Ret = null;
			m_attGrid = null;
			m_attHurtEnd = null;
			m_cattAct = null;
		}
		
		protected function isOver():Boolean
		{
			var list:Vector.<NpcBattle>;
			var being:BeingEntity;
			var grid:FightGrid;
			for each(grid in m_gridList)
			{
				list = grid.beingList;
				for each(being in list)
				{
					// 死亡状态判断动作是否播放完毕 
					if (being.isState(EntityCValue.TDie))
					{
						if (!being.aniOver())
						{
							if (m_battleArray.m_gkContext.m_battleMgr.m_stopInfo)
							{
								var str:String = "RankHurtAction:isOver:EntityCValue.TDie";
								m_battleArray.m_gkContext.addLog(str);
							}
							
							return false;
						}
					}
					else if (!being.isState(EntityCValue.TStand))
					{
						if (m_battleArray.m_gkContext.m_battleMgr.m_stopInfo)
						{
							str = "RankHurtAction:isOver:EntityCValue.TStand, 当前state="+being.state;
							m_battleArray.m_gkContext.addLog(str);
						}
						return false;
					}
				}
			}
			
			return true;
		}
		
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
					if (!m_id2Ret[being.id] && (being.isState(EntityCValue.THurt) || being.isState(EntityCValue.TDie)))
					{
						--m_hurtCnt;
						m_id2Ret[being.id] = true;
					}
				}
			}
			
			if (m_hurtCnt == 0)
			{
				return true;
			}
			return false;
		}
		
		public function set attGrid(value:FightGrid):void
		{
			m_attGrid = value;
		}
		
		public function get attGrid():FightGrid
		{
			return m_attGrid;
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
		
		// 这个是外部通过函数通知可以表现受伤了
		public function callback():void
		{
			// 开始播放受伤         
			if (m_fAction !=null)
			{
				m_fAction(this);
			}
			else
			{
				var str:String = "RankHurtAction::callback m_bDisposed=" + m_bDisposed;
				str= fUtil.getStackInfo(str);
				DebugBox.sendToDataBase(str);
			}
			
			m_hurtState = EntityCValue.RKHurting;
		}
		
		public function set attHurtEnd(value:IRankFightAction):void
		{
			m_attHurtEnd = value;
		}
		
		public function get attHurtEnd():IRankFightAction
		{
			return m_attHurtEnd;
		}
		
		public function set cattAct(value:IRankFightAction):void
		{
			m_cattAct = value;
		}
		
		public function get cattAct():IRankFightAction
		{
			return m_cattAct;
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