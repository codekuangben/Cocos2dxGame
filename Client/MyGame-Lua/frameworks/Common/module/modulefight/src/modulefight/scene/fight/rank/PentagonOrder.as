package modulefight.scene.fight.rank
{
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import modulecommon.GkContext;
	import modulefight.scene.beings.NpcBattle;
	
	/**
	 * ...
	 * @author 
	 * @brief 五边形    
	 */
	public class PentagonOrder extends OrderBase
	{
		public function PentagonOrder() 
		{
			super(EntityCValue.RKPentOrder);
		}
		
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
			
			if (EntityCValue.RKLeft == m_side)
			{
				if (m_direction == EntityCValue.RKDIRRight)
				{
					startx = m_vertX;
					starty = m_vertY;
					
					// 生成进攻队伍   
					while (y < 3 && idx < m_totalCnt)
					{
						x = 0;
						while (x < 3 && idx < m_totalCnt)  
						{
							// 如果 X 是偶数列偶数行，或者奇数列奇数行  
							if ((x % 2 == 0 && y % 2 == 0) || (x % 2 != 0 && y % 2 != 0))
							{
								pixelX = startx - m_xOff - (0.5 + x) * m_xGap;
								pixelY = starty + m_yOff + (0.5 + y) * m_yGap;
								
								if (m_bend)
								{
									m_grid.beingList[idx].goToPosf(pixelX, pixelY);
								}
								else
								{
									m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
								}
								++idx;
							}
							++x;
						}
						
						++y;
					}
				}
				else
				{
					startx = m_vertX - m_gridWith;
					starty = m_vertY;
					
					while (y < 3 && idx < m_totalCnt)
					{
						x = 0;
						while (x < 3 && idx < m_totalCnt)
						{
							if ((x % 2 == 0 && y % 2 == 0) || (x % 2 != 0 && y % 2 != 0))
							{
								pixelX = startx + m_xOff + (0.5 + x) * m_xGap;
								pixelY = starty + m_yOff + (0.5 + y) * m_yGap;
								
								if (m_bend)
								{
									m_grid.beingList[idx].goToPosf(pixelX, pixelY);
								}
								else
								{
									m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
								}
								++idx;
							}
							++x;
						}
						
						++y;
					}
				}
			}
			else
			{
				if (m_direction == EntityCValue.RKDIRRight)
				{
					startx = m_vertX + m_gridWith;
					starty = m_vertY;
					
					// 生成进攻队伍   
					while (y < 3 && idx < m_totalCnt)
					{
						x = 0;
						while (x < 3 && idx < m_totalCnt)  
						{
							// 如果 X 是偶数列偶数行，或者奇数列奇数行  
							if ((x % 2 == 0 && y % 2 == 0) || (x % 2 != 0 && y % 2 != 0))
							{
								pixelX = startx - m_xOff - (0.5 + x) * m_xGap;
								pixelY = starty + m_yOff + (0.5 + y) * m_yGap;
								
								if (m_bend)
								{
									m_grid.beingList[idx].goToPosf(pixelX, pixelY);
								}
								else
								{
									m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
								}
								++idx;
							}
							++x;
						}
						
						++y;
					}
				}
				else
				{
					startx = m_vertX;
					starty = m_vertY;
					
					while (y < 3 && idx < m_totalCnt)
					{
						x = 0;
						while (x < 3 && idx < m_totalCnt)
						{
							if ((x % 2 == 0 && y % 2 == 0) || (x % 2 != 0 && y % 2 != 0))
							{
								pixelX = startx + m_xOff + (0.5 + x) * m_xGap;
								pixelY = starty + m_yOff + (0.5 + y) * m_yGap;
								
								if (m_bend)
								{
									m_grid.beingList[idx].goToPosf(pixelX, pixelY);
								}
								else
								{
									m_grid.beingList[idx].moveToPosNoAIf(pixelX, pixelY);
								}
								++idx;
							}
							++x;
						}
						
						++y;
					}
				}
			}
			
			return null;
		}
		
		override public function getHPStripBeing():NpcBattle
		{
			return m_grid.beingList[4];
		}
		// 中心点在格子中心，获取偏移  左边: 0 右上 1 左上 2 中间 3 右下 4 左下   右边: 0 左上 1 右上 2 中间 3 左下 4 右下 
		// 4 是中心点   
		override public function getXOff2Center(idx:uint):int
		{
			// 左边  
			if (EntityCValue.RKLeft == m_side)
			{
				if(0 == idx)
				{
					return m_xGap;
				}
				else if(1 == idx)
				{
					return -m_xGap;
				}
				else if(2 == idx)
				{
					return 0;
				}
				else if(3 == idx)
				{
					return m_xGap;
				}
				else if(4 == idx)
				{
					return -m_xGap;
				}
			}
			else
			{
				if(0 == idx)
				{
					return -m_xGap;
				}
				else if(1 == idx)
				{
					return m_xGap;
				}
				else if(2 == idx)
				{
					return 0;
				}
				else if(3 == idx)
				{
					return -m_xGap;
				}
				else if(4 == idx)
				{
					return m_xGap;
				}
			}
			
			return 0;
		}
		
		// 4 是中心点   
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
					return -m_yGap;
				}
				else if(2 == idx)
				{
					return 0;
				}
				else if(3 == idx)
				{
					return m_yGap;
				}
				else if(4 == idx)
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
					return -m_yGap;
				}
				else if(2 == idx)
				{
					return 0;
				}
				else if(3 == idx)
				{
					return m_yGap;
				}
				else if(4 == idx)
				{
					return m_yGap;
				}
			}
			
			return 0;
		}
	}
}