package modulefight.scene.fight.rank
{
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author 
	 * @brief 生成六边形队形  
	 */
	public class HexagonOrder extends OrderBase
	{
		protected var m_cntPerCol:uint;	// 每一列的人的数量，只支持奇数   
		
		public function HexagonOrder() 
		{
			super(EntityCValue.RKHexaOrder);
			m_cntPerCol = 3;
		}
		
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
			
			if (m_direction == EntityCValue.RKRight)
			{
				// 生成进攻队伍   
				while (idx < m_totalCnt)
				{
					y = -half;
					while (y < half + 1 && idx < m_totalCnt)	// 每一列的一半个数等于当前 x 值，每一列的总的个数等于 2 * x + 1，因为中间一行正好在中间线上     
					{
						gridx = m_vertX + (-x);
						if (x % 2 == 0)
						{
							gridy = m_vertY + y;
						}
						else
						{
							gridy = m_vertY + y * 2;
						}
						
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
						if (x % 2 == 0)
						{
							gridy = m_vertY + y;
						}
						else
						{
							gridy = m_vertY + y * 2;
						}
						
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
			
			// 暂时不需要，因此改为 null 
			return null;
		}
	}
}