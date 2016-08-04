package modulefight.scene.fight.rank
{
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import modulecommon.GkContext;
	import modulefight.scene.beings.NpcBattle;
	/**
	 * ...
	 * @author 
	 * @brief 生成一个四边形  
	 */
	public class QuadOrder extends OrderBase
	{
		protected var m_cntPerCol:uint;	// 每一列的人的数量，只支持奇数   
		
		public function QuadOrder() 
		{
			super(EntityCValue.RKQuadOrder);
			m_direction = EntityCValue.RKDIRRight;
			m_vertX = 0;
			m_vertY = 0;
			m_totalCnt = 9;
			m_cntPerCol = 3;
		}
		
		/*
		override public function buildOrder():Vector.<int>
		{
			var x:int = 0;
			var y:int = 0;
			
			var gridx:int = 0;
			var gridy:int = 0;
			var pixelX:Number = 0;
			var pixelY:Number = 0;
			
			var idx:uint = 0;
			var being:BeingEntity;
			var half:int = m_cntPerCol / 2;
			
			// 向右，是指队伍的前方是右方    
			if (m_direction == EntityCValue.RKDIRRight)
			{
				// 生成进攻队伍   
				while (idx < m_totalCnt)
				{
					y = -half;
					while (y < half + 1 && idx < m_totalCnt)	// 每一列的一半个数等于当前 x 值，每一列的总的个数等于 2 * x + 1，因为中间一行正好在中间线上     
					{
						gridx = m_vertX + (-x);
						gridy = m_vertY + y;
						
						pixelX = gridx * this.m_gkcontext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).gridSize + this.m_gkcontext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).gridSize / 2;
						pixelY = gridy * this.m_gkcontext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).gridSize + this.m_gkcontext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).gridSize / 2;
						
						if (m_bend)
						{
							m_grid.beingList[idx].goToPosf(pixelX, pixelY);
						}
						else
						{
							m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
						}
						++y;
						++idx;
					}
					
					++x;
				}
			}
			else
			{
				while (idx < m_totalCnt)
				{
					y = -half;
					while (y < half + 1 && idx < m_totalCnt)
					{
						gridx = m_vertX + x;
						gridy = m_vertY + y;
						
						pixelX = gridx * this.m_gkcontext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).gridSize + this.m_gkcontext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).gridSize / 2;
						pixelY = gridy * this.m_gkcontext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).gridSize + this.m_gkcontext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).gridSize/ 2;
						
						if (m_bend)
						{
							m_grid.beingList[idx].goToPosf(pixelX, pixelY);
						}
						else
						{
							m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
						}
						++y;
						++idx;
					}
					
					++x;
				}
			}
			
			return null;
		}
		*/
		
		/*
		// 矩形生成
		override public function buildOrder():Vector.<int>
		{
			var x:int = 0;
			var y:int = 0;
			
			var pixelX:Number = 0;
			var pixelY:Number = 0;
			
			var idx:uint = 0;
			var being:BeingEntity;
			
			// 向右，是指队伍的前方是右方    
			if (m_direction == EntityCValue.RKDIRRight)
			{
				// 生成进攻队伍
				x = 0;
				idx = 0;
				while (x < 2)
				{
					y = 0;
					while (y < 2)
					{
						pixelX = m_vertX - m_xOff - m_xGap - x * m_xGap;
						pixelY = m_vertY + m_yOff + m_yGap + y * m_yGap;
					
						if (m_bend)
						{
							m_grid.beingList[idx].goToPosf(pixelX, pixelY);
						}
						else
						{
							m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
						}
						++y;
						++idx;
					}
					
					++x;
				}
			}
			else
			{
				x = 0;
				idx = 0;
				while (x < 2)
				{
					y = 0;
					while (y < 2)
					{
						pixelX = m_vertX + m_xOff + m_xGap + x * m_xGap;
						pixelY = m_vertY + m_yOff + m_yGap + y * m_yGap;
						
						if (m_bend)
						{
							m_grid.beingList[idx].goToPosf(pixelX, pixelY);
						}
						else
						{
							m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
						}
						++y;
						++idx;
					}
					
					++x;
				}
			}
			
			return null;
		}
		*/
		
		// 菱形，添加 npc 按照左边:从上到下，从右到左的原则，右边:从上到下，从左到右的原则 这样还是按照格子排序，如果在同一个格子，先加入的就在前面了
		override public function buildOrder():Vector.<int>
		{
			//var x:int = 0;
			//var y:int = 0;
			
			var pixelX:Number = 0;
			var pixelY:Number = 0;
			
			var idx:uint = 0;
			var being:BeingEntity;
			
			// 左边向右，是指队伍的前方是右方
			if (m_direction == EntityCValue.RKDIRRight)
			{
				// 第一个定点
				idx = 0;
				pixelX = m_vertX - m_xOff - 1.5 * m_xGap;
				pixelY = m_vertY + m_yOff + 0.5 * m_yGap;
				
				if (m_bend)
				{
					m_grid.beingList[idx].goToPosf(pixelX, pixelY);
				}
				else
				{
					m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
				}
				
				// 第二个定点
				++idx;
				pixelX = m_vertX - m_xOff - 0.5 * m_xGap;
				pixelY = m_vertY + m_yOff + 1.5 * m_yGap;
				
				if (m_bend)
				{
					m_grid.beingList[idx].goToPosf(pixelX, pixelY);
				}
				else
				{
					m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
				}
				
				// 第三个定点
				++idx;
				pixelX = m_vertX - m_xOff - 2.5 * m_xGap;
				pixelY = m_vertY + m_yOff + 1.5 * m_yGap;
				
				if (m_bend)
				{
					m_grid.beingList[idx].goToPosf(pixelX, pixelY);
				}
				else
				{
					m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
				}
				
				// 第四个定点
				++idx;
				pixelX = m_vertX - m_xOff - 1.5 * m_xGap;
				pixelY = m_vertY + m_yOff + 2.5 * m_yGap;
				
				if (m_bend)
				{
					m_grid.beingList[idx].goToPosf(pixelX, pixelY);
				}
				else
				{
					m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
				}
			}
			else	// 右边向左
			{
				// 第一个定点
				idx = 0;
				pixelX = m_vertX + m_xOff + 1.5 * m_xGap;
				pixelY = m_vertY + m_yOff + 0.5 * m_yGap;
				
				if (m_bend)
				{
					m_grid.beingList[idx].goToPosf(pixelX, pixelY);
				}
				else
				{
					m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
				}
				
				// 第二个定点
				++idx;
				pixelX = m_vertX + m_xOff + 0.5 * m_xGap;
				pixelY = m_vertY + m_yOff + 1.5 * m_yGap;
				
				if (m_bend)
				{
					m_grid.beingList[idx].goToPosf(pixelX, pixelY);
				}
				else
				{
					m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
				}
				
				// 第三个定点
				++idx;
				pixelX = m_vertX + m_xOff + 2.5 * m_xGap;
				pixelY = m_vertY + m_yOff + 1.5 * m_yGap;
				
				if (m_bend)
				{
					m_grid.beingList[idx].goToPosf(pixelX, pixelY);
				}
				else
				{
					m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
				}
				
				// 第四个定点
				++idx;
				pixelX = m_vertX + m_xOff + 1.5 * m_xGap;
				pixelY = m_vertY + m_yOff + 2.5 * m_yGap;
				
				if (m_bend)
				{
					m_grid.beingList[idx].goToPosf(pixelX, pixelY);
				}
				else
				{
					m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
				}
			}
			
			return null;
		}
		
		override public function getHPStripBeing():NpcBattle
		{
			return m_grid.beingList[3];
		}
		
		/*
		// 矩形偏移
		// 中心点在格子中心，获取偏移  左边: 0 右上 1 左上 2 右下 3 左下  右边: 0 左上 1 右上 2 左下 3 右下 
		override public function getXOff2Center(idx:uint):int
		{
			// 左边  
			if (EntityCValue.RKLeft == m_side)
			{
				if(0 == idx)
				{
					return m_xGap/2;
				}
				else if(1 == idx)
				{
					return -m_xGap/2;
				}
				else if(2 == idx)
				{
					return m_xGap/2;
				}
				else if(3 == idx)
				{
					return -m_xGap/2;
				}
			}
			else
			{
				if(0 == idx)
				{
					return -m_xGap/2;
				}
				else if(1 == idx)
				{
					return m_xGap/2;
				}
				else if(2 == idx)
				{
					return -m_xGap/2;
				}
				else if(3 == idx)
				{
					return m_xGap/2;
				}
			}
			
			return 0;
		}
		
		override public function getYOff2Center(idx:uint):int
		{
			// 左边  
			if (EntityCValue.RKLeft == m_side)
			{
				if(0 == idx)
				{
					return -m_yGap/2;
				}
				else if(1 == idx)
				{
					return -m_yGap/2;
				}
				else if(2 == idx)
				{
					return m_yGap/2;
				}
				else if(3 == idx)
				{
					return m_yGap/2;
				}
			}
			else
			{
				if(0 == idx)
				{
					return -m_yGap/2;
				}
				else if(1 == idx)
				{
					return -m_yGap/2;
				}
				else if(2 == idx)
				{
					return m_yGap/2;
				}
				else if(3 == idx)
				{
					return m_yGap/2;
				}
			}
			
			return 0;
		}
		*/
		
		// 菱形偏移
		// 从上到下，从左到右一次编号
		override public function getXOff2Center(idx:uint):int
		{
			// 左边  
			if (EntityCValue.RKLeft == m_side)
			{
				if(0 == idx)
				{
					return 0;
				}
				else if(1 == idx)
				{
					return m_xGap;
				}
				else if(2 == idx)
				{
					return -m_xGap;
				}
				else if(3 == idx)
				{
					return 0;
				}
			}
			else
			{
				if(0 == idx)
				{
					return 0;
				}
				else if(1 == idx)
				{
					return -m_xGap;
				}
				else if(2 == idx)
				{
					return m_xGap;
				}
				else if(3 == idx)
				{
					return 0;
				}
			}
			
			return 0;
		}
		
		override public function getYOff2Center(idx:uint):int
		{
			// 左边  
			if (EntityCValue.RKLeft == m_side)
			{
				if(0 == idx)
				{
					return -m_yGap;
				}
				else if(1 == idx)
				{
					return 0;
				}
				else if(2 == idx)
				{
					return 0;
				}
				else if(3 == idx)
				{
					return m_yGap;
				}
			}
			else
			{
				if(0 == idx)
				{
					return -m_yGap;
				}
				else if(1 == idx)
				{
					return 0;
				}
				else if(2 == idx)
				{
					return 0;
				}
				else if(3 == idx)
				{
					return m_yGap;
				}
			}
			
			return 0;
		}
	}
}