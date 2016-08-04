package modulefight.scene.fight.rank
{
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.scene.fight.FightGrid;
	/**
	 * ...
	 * @author 
	 * @brief 原地队形，队形不变，只是移动位置      
	 */
	public class InplaceOrder extends OrderBase
	{
		protected var m_destX:Number;	// 移动的终点位置  
		protected var m_destY:Number;	// 移动的终点位置  
		
		public function InplaceOrder() 
		{
			super(EntityCValue.RKInplaceOrder);
		}
		
		override public function buildOrder():Vector.<int>
		{
			var being:BeingEntity;
			
			var distx:Number = 0;
			var disty:Number = 0;

			// bug: 如果移动中间被打断,结果没有到达 m_vertX 就停下了, m_destX - m_vertX 的距离就是错误的 
			distx = m_destX - m_vertX;
			disty = m_destY - m_vertY;
			
			if(distx || disty)
			{
				var list:Vector.<NpcBattle>;
				//var grid:FightGrid;
				//for each(grid in m_gridList)
				//{
					list = m_grid.beingList;
					for each(being in list)
					{
						if (m_bend)
						{
							being.goToPosf(being.x + distx, being.y + disty);
						}
						else
						{
							being.moveToPosNoAIf(being.x + distx, being.y + disty);
						}
					}
				//}
			}
			
			// 暂时不需要，因此改为 null 
			return null;
		}
		
		public function set destX(value:Number):void 
		{
			m_destX = value;
		}
		
		public function set destY(value:Number):void 
		{
			m_destY = value;
		}
		
		public function get destX():Number 
		{
			return m_destX;
		}
		
		public function get destY():Number 
		{
			return m_destY;
		}
	}
}