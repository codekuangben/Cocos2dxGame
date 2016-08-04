package modulefight.scene.fight.rank
{
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import modulecommon.GkContext;
	import flash.geom.Point;
	import modulefight.scene.beings.NpcBattle;
	/**
	 * ...
	 * @author 
	 * @brief 生成三角形队列，方向向左或者向右   
	 */
	public class TriangleOrder extends OrderBase
	{
		public function TriangleOrder() 
		{
			super(EntityCValue.RKTriOrder);
		}
		
		/*
		override public function buildOrder():Vector.<int>
		{
			var x:int = 0;
			var y:int = 0;
			
			var startx:int = 0;		// 起始像素坐标      
			var starty:int = 0;		// 起始像素坐标      
			var pixelX:Number = 0;
			var pixelY:Number = 0;
			
			var idx:uint = 0;
			var being:BeingEntity;
			
			// 左边  
			if (EntityCValue.RKLeft == m_side)
			{
				// 向右，是指三角形顶点向右      
				if (m_direction == EntityCValue.RKDIRRight)
				{
					// 右上角坐标 
					startx = m_vertX;
					starty = m_vertY;
					// 生成进攻队伍   
					x = 0;
					while (x < 3 && idx < m_totalCnt)
					{
						y = 0;
						while (y < 3 && idx < m_totalCnt)
						{
							// 如果是第一列，就存放一个 
							if (x == 0)
							{
								pixelX = startx - m_xOff - m_xGap/2 - x * m_xGap;
								pixelY = starty + m_yOff + m_yGap/2 + (y + 1) * m_yGap;
							}
							else	// 其余存放 3 个    
							{
								pixelX = startx - m_xOff - m_xGap/2 - x * m_xGap;
								pixelY = starty + m_yOff + m_yGap/2 + y * m_yGap;
							}
							
							if (m_bend)
							{
								m_grid.beingList[idx].goToPosf(pixelX, pixelY);
							}
							else
							{
								m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
							}
							
							++idx;
							++y;
							
							if (x == 0)
							{
								break;
							}
						}
						
						++x;
					}
				}
				else	// 向左，是指三角形顶点向左          
				{
					// 左上角坐标 
					startx = m_vertX - m_gridWith;
					starty = m_vertY;
					x = 0;
					while (x < 3 && idx < m_totalCnt)
					{
						y = 0;
						while (y < 3 && idx < m_totalCnt)
						{
							if (x == 0)
							{
								pixelX = m_vertX + m_xOff + m_xGap/2 + x * m_xGap;
								pixelY = m_vertY + m_yOff + m_yGap/2 + (y + 1) * m_yGap;
								break;
							}
							else	// 其余存放 3 个    
							{
								pixelX = m_vertX + m_xOff + m_xGap/2 + x * m_xGap;
								pixelY = m_vertY + m_yOff + m_yGap/2 + y * m_yGap;
							}
							
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
							if (x == 0)
							{
								break;
							}
						}
						
						++x;
					}
				}
			}
			else	// 右边    
			{
				// 向右，是指三角形顶点向右        
				if (m_direction == EntityCValue.RKDIRRight)
				{
					// 右上角坐标 
					startx = m_vertX + m_gridWith;
					starty = m_vertY;
					
					// 生成进攻队伍   
					x = 0;
					while (x < 3 && idx < m_totalCnt)
					{
						y = 0;
						while (y < 3 && idx < m_totalCnt)	// 每一列的一半个数等于当前 x 值，每一列的总的个数等于 2 * x + 1，因为中间一行正好在中间线上     
						{
							if (x == 0)
							{
								pixelX = m_vertX - m_xOff - m_xGap/2 - x * m_xGap;
								pixelY = m_vertY + m_yOff + m_yGap/2 + (y + 1) * m_yGap;
								break;
							}
							else	// 其余存放 3 个    
							{
								pixelX = m_vertX - m_xOff - m_xGap/2 - x * m_xGap;
								pixelY = m_vertY + m_yOff + m_yGap/2 + y * m_yGap;
							}
							
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
							if (x == 0)
							{
								break;
							}
						}
						
						++x;
					}
				}
				else	// 向左，是指三角形顶点向左         
				{
					// 左上角坐标 
					startx = m_vertX;
					starty = m_vertY;
					
					x = 0
					while (x < 3 && idx < m_totalCnt)
					{
						y = 0;
						while (y < 3 && idx < m_totalCnt)
						{
							if (x == 0)
							{
								pixelX = m_vertX + m_xOff + m_xGap/2 + x * m_xGap;
								pixelY = m_vertY + m_yOff + m_yGap/2 + (y + 1) * m_yGap;
								break;
							}
							else	// 其余存放 3 个    
							{
								pixelX = m_vertX + m_xOff + m_xGap/2 + x * m_xGap;
								pixelY = m_vertY + m_yOff + m_yGap/2 + y * m_yGap;
							}
							
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
							if (x == 0)
							{
								break;
							}
						}
						
						++x;
					}
				}
			}
			
			// 暂时不需要，因此改为 null 
			return null;
		}
		*/
		
		// 添加 npc 按照左边:从上到下，从右到左的原则，右边:从上到下，从左到右的原则
		override public function buildOrder():Vector.<int>
		{
			//var x:int = 0;
			//var y:int = 0;
			
			var startx:int = 0;		// 起始像素坐标      
			var starty:int = 0;		// 起始像素坐标      
			var pixelX:Number = 0;
			var pixelY:Number = 0;
			
			var idx:uint = 0;
			var being:BeingEntity;
			
			// 左边  
			if (EntityCValue.RKLeft == m_side)
			{
				// 向右，是指三角形顶点向右      
				if (m_direction == EntityCValue.RKDIRRight)
				{
					// 右上角坐标 
					startx = m_vertX;
					starty = m_vertY;
					// 生成进攻队伍
					
					// 第一个
					idx = 0;
					
					if(idx < m_grid.beingList.length)
					{
						pixelX = startx - m_xOff - 2 * m_xGap;
						pixelY = starty + m_yOff + 0.5 * m_yGap;
						
						if (m_bend)
						{
							m_grid.beingList[idx].goToPosf(pixelX, pixelY);
						}
						else
						{
							m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
						}
					}
					
					// 第二个
					++idx;
					if(idx < m_grid.beingList.length)
					{
						pixelX = startx - m_xOff - m_xGap;
						pixelY = starty + m_yOff + 1.5 * m_yGap;
						
						if (m_bend)
						{
							m_grid.beingList[idx].goToPosf(pixelX, pixelY);
						}
						else
						{
							m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
						}
					}
					
					// 第三个
					++idx;
					
					if(idx < m_grid.beingList.length)
					{
						pixelX = startx - m_xOff - 2 * m_xGap;
						pixelY = starty + m_yOff + 2.5 * m_yGap;
						
						if (m_bend)
						{
							m_grid.beingList[idx].goToPosf(pixelX, pixelY);
						}
						else
						{
							m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
						}
					}
				}
			}
			else	// 右边    
			{
				// 向右，是指三角形顶点向右        
				if (m_direction == EntityCValue.RKDIRLeft)
				{
					// 右上角坐标 
					startx = m_vertX;
					starty = m_vertY;
					
					// 生成进攻队伍
					// 第一个
					idx = 0;
					if(idx < m_grid.beingList.length)
					{
						pixelX = startx + m_xOff + 2 * m_xGap;
						pixelY = starty + m_yOff + 0.5 * m_yGap;
						
						if (m_bend)
						{
							m_grid.beingList[idx].goToPosf(pixelX, pixelY);
						}
						else
						{
							m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
						}
					}
					
					// 第二个
					++idx;
					if(idx < m_grid.beingList.length)
					{
						pixelX = startx + m_xOff + m_xGap;
						pixelY = starty + m_yOff + 1.5 * m_yGap;
						
						if (m_bend)
						{
							m_grid.beingList[idx].goToPosf(pixelX, pixelY);
						}
						else
						{
							m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
						}
					}
					
					// 第三个
					++idx;
					
					if(idx < m_grid.beingList.length)
					{
						pixelX = startx + m_xOff + 2 * m_xGap;
						pixelY = starty + m_yOff + 2.5 * m_yGap;
						
						if (m_bend)
						{
							m_grid.beingList[idx].goToPosf(pixelX, pixelY);
						}
						else
						{
							m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
						}
					}
				}
			}
			
			// 暂时不需要，因此改为 null 
			return null;
		}
		
		override public function getHPStripBeing():NpcBattle
		{
			return m_grid.beingList[2];
		}
		
		override public function getHPStripXOffset():int
		{
			return 0;
		}
		
		// 中心点在格子中心，获取偏移
		override public function getXOff2Center(idx:uint):int
		{
			// 左边  
			if (EntityCValue.RKLeft == m_side)
			{
				// 向右，是指三角形顶点向右      
				if (m_direction == EntityCValue.RKDIRRight)
				{
					if(0 == idx)
					{
						return -m_xGap * 0.5;
					}
					else if(1 == idx)
					{
						return m_xGap * 0.5;
					}
					else if(2 == idx)
					{
						return -m_xGap * 0.5;
					}
				}
			}
			else
			{
				// 向左，是指三角形顶点向左      
				if (m_direction == EntityCValue.RKDIRLeft)
				{
					if(0 == idx)
					{
						return m_xGap * 0.5;
					}
					else if(1 == idx)
					{
						return -m_xGap * 0.5;
					}
					else if(2 == idx)
					{
						return m_xGap * 0.5;
					}
				}
			}
			
			return 0;
		}
		
		override public function getYOff2Center(idx:uint):int
		{
			// 左边  
			if (EntityCValue.RKLeft == m_side)
			{
				// 向右，是指三角形顶点向右      
				if (m_direction == EntityCValue.RKDIRRight)
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
						return m_yGap;
					}
				}
			}
			else
			{
				// 向左，是指三角形顶点向左      
				if (m_direction == EntityCValue.RKDIRLeft)
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
						return m_yGap;
					}
				}
			}
			
			return 0;
		}
	}
}