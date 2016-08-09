package org.ffilmation.engine.core 
{
	import org.ffilmation.engine.helpers.fEngineCValue;
	/**
	 * KBEN: 场景配置文件 
	 */
	public class fSceneConfig 
	{
		private var m_isDebugStopPoint:Boolean = false;	// 是否调试阻挡点   
		/**
		 * KBEN: 0:就是当前引擎 1:正好斜45，地形不变换，只有场景中的实体位置变化 2:横版      
		 */
		private var m_mapType:uint = fEngineCValue.Engine2d;
		private var m_fogOpened:Boolean = false;	// 是否开启雾，地形分块 fFloor 要小一点，大了比较卡   
		private static var m_instance:fSceneConfig;
		private var m_optimizeCutting:Boolean = true;	// 是否开启裁剪优化，还没有测试，等着地形分块好了再测试  
		public var m_background:Boolean = false;	// 是否显示场景中人物整个背景  
		
		protected var m_bshowCharCenter:Boolean = false;	// 是否显示人物中心
		protected var m_bshowEffCenter:Boolean = false;	// 是否显示特效中心
		protected var m_bshowEmptyCenter:Boolean = false;	// 是否显示 EmptySprite 中心
		
		public static function get instance():fSceneConfig
		{
			return m_instance;
		}
		
		public function fSceneConfig()
		{
			m_instance = this;
		}
		
		public function get isDebugStopPoint():Boolean 
		{
			return m_isDebugStopPoint;
		}
		
		public function set isDebugStopPoint(value:Boolean):void 
		{
			m_isDebugStopPoint = value;
		}
		
		public function get mapType():uint 
		{
			return m_mapType;
		}
		
		public function set mapType(value:uint):void 
		{
			m_mapType = value;
		}
		
		public function get fogOpened():Boolean 
		{
			return m_fogOpened;
		}
		
		public function set fogOpened(value:Boolean):void 
		{
			m_fogOpened = value;
		}
		
		public function get optimizeCutting():Boolean 
		{
			return m_optimizeCutting;
		}
		
		public function get bshowCharCenter():Boolean 
		{
			return m_bshowCharCenter;
		}
		
		public function get bshowEffCenter():Boolean 
		{
			return m_bshowEffCenter;
		}
		
		public function get bshowEmptyCenter():Boolean 
		{
			return m_bshowEmptyCenter;
		}
		
		public function set bshowCharCenter(value:Boolean):void 
		{
			m_bshowCharCenter = value;
		}
		
		public function set bshowEffCenter(value:Boolean):void 
		{
			m_bshowEffCenter = value;
		}
		
		public function set bshowEmptyCenter(value:Boolean):void 
		{
			m_bshowEmptyCenter = value;
		}
	}
}