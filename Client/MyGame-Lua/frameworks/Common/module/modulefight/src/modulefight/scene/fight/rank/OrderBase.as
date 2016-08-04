package modulefight.scene.fight.rank
{
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.scene.beings.NpcBattle;
	
	import modulecommon.GkContext;
	
	import modulefight.scene.fight.FightGrid;
	
	/**
	 * ...
	 * @author 
	 * @brief 队伍队形  
	 */
	public class OrderBase 
	{
		protected var m_type:uint;
		protected var m_gkcontext:GkContext;
		protected var m_side:uint;		// 左边还是右边的队伍 
		protected var m_direction:uint;	// 运动方向    
		protected var m_vertX:uint;	// 顶点 X 格子，如果是左边的队伍，表示右上角坐标，如果是右边的队伍，表示左上角坐标。现在这个是像素坐标   
		protected var m_vertY:uint;	// 顶点 Y 格子，左边的是右上角坐标，右边的是左上角坐标，现在这个是像素坐标
		protected var m_totalCnt:uint;		// 列的数量 
		//protected var m_beingList:Vector.<BeingEntity>;
		protected var m_grid:FightGrid;	// 控制的格子，移动只控制一个格子
		
		protected var m_gridWith:uint;		// 九宫格格子宽度 
		protected var m_gridHeight:uint;	// 九宫格格子高度 
		
		protected var m_xGap:uint;		// 行之间的间隙   
		protected var m_yGap:uint;		// 列之间的间隙   
		
		protected var m_xOff:uint;		// 顶点 x 偏移   
		protected var m_yOff:uint;		// 顶点 y 偏移   
		
		/**
		 * @brief true 直接跳转到终点， false 一步一步走到终点   
		 */
		protected var m_bend:Boolean; 	
		
		public function OrderBase(type:uint)
		{
			m_type = type;
			m_bend = false;
			
			m_gridWith = 140;
			m_gridHeight = 140;
			
			m_xGap = 40;
			m_yGap = 40;
			
			m_xOff = 10;	// 四边各留出 m_xOff 偏移间隔
			m_yOff = 10;
		}
		
		public function set direction(value:uint):void 
		{
			m_direction = value;
		}
		
		public function set vertX(value:int):void 
		{
			m_vertX = value;
		}
		
		public function set vertY(value:int):void 
		{
			m_vertY = value;
		}
		
		public function get vertX():int 
		{
			return m_vertX;
		}
		
		public function get vertY():int 
		{
			return m_vertY;
		}
		
		public function set totalCnt(value:uint):void 
		{
			m_totalCnt = value;
		}
		
		//public function set beingList(value:Vector.<BeingEntity>):void 
		//{
			//m_beingList = value;
		//}
		
		public function addGrid(grid:FightGrid):void
		{
			m_grid = grid;
		}
		
		public function get getGrid():FightGrid
		{
			return m_grid;
		}
		
		public function set gkcontext(value:GkContext):void 
		{
			m_gkcontext = value;
		}
		
		public function set side(value:uint):void 
		{
			m_side = value;
		}
		
		public function get side():uint 
		{
			return m_side;
		}
		
		public function get direction():uint 
		{
			return m_direction;
		}
		
		public function get bend():Boolean 
		{
			return m_bend;
		}
		
		public function set bend(value:Boolean):void 
		{
			m_bend = value;
		}
		
		/* *
		 * @brief 生成队伍队形  
		 * @ret 返回队伍坐标   
		 */
		public function buildOrder():Vector.<int>
		{
			return null;
		}
		
		public function getHPStripBeing():NpcBattle
		{
			return null;
		}
		
		public function getHPStripXOffset():int
		{
			return 0;
		}
		// 获取索引是 idx 的角色，中心点在格子中心，获取偏移   
		public function getXOff2Center(idx:uint):int
		{
			return 0;
		}
		
		public function getYOff2Center(idx:uint):int
		{
			return 0;
		}
	}
}