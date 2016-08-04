package modulefight.scene.fight.rank
{
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.scene.beings.NpcBattle;
	/**
	 * ...
	 * @author 
	 * @brief 生成一边形队形  
	 */
	public class OneOrder extends OrderBase
	{
		public function OneOrder()
		{
			super(EntityCValue.RKHexaOrder);
		}
		
		override public function buildOrder():Vector.<int>
		{
			var startx:int = 0;		// 起始像素坐标      
			var starty:int = 0;		// 起始像素坐标   
			var pixelX:Number = 0;
			var pixelY:Number = 0;
			
			startx = m_vertX;
			starty = m_vertY;
			
			if (EntityCValue.RKLeft == m_side)
			{
				pixelX = startx - m_xOff - m_xGap/2 - m_xGap;
				pixelY = starty + m_yOff + m_yGap/2 + m_yGap;
			}
			else
			{
				pixelX = startx + m_xOff + m_xGap/2 + m_xGap;
				pixelY = starty + m_yOff + m_yGap/2 + m_yGap;
			}
			
			if (m_bend)
			{
				m_grid.beingList[0].goToPosf(pixelX, pixelY);
			}
			else
			{
				m_grid.beingList[0].moveToPosNoAIf(pixelX, pixelY);
			}
			
			return null;
		}
		
		override public function getHPStripBeing():NpcBattle
		{
			return m_grid.beingList[0];
		}
		
		// 中心点在格子中心，获取偏移   
		override public function getXOff2Center(idx:uint):int
		{
			return 0;
		}
		
		override public function getYOff2Center(idx:uint):int
		{
			return 0;
		}
	}
}