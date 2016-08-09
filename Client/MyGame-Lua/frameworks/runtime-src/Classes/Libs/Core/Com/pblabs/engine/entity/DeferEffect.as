package com.pblabs.engine.entity
{
	import org.ffilmation.engine.core.fScene;
	/**
	 * @brief 延迟飞行特效，需要延迟释放的特效
	 * */
	public class DeferEffect
	{
		public var m_delay:Number = 0;			// 延迟时间
		public var m_defID:String = '';			// 特效 ID
		public var m_framerate:uint = 0;	// 帧率
		public var m_flyvel:Number = 0;			// 飞行速度
		
		public var m_startX:Number = 0;			// 飞行起始点
		public var m_startY:Number = 0			// 飞行起始点
		public var m_endX:Number = 0;			// 飞行终点
		public var m_endY:Number = 0;			// 飞行终点
		public var m_scene:fScene = null;			// 场景
		public var m_bFlip:uint = 0;			// 特效翻转
		
		public var m_insID:String = '';			// 人物ID，查找特效偏移使用
		public var m_effectSpeed:Number = 0;	// 飞行速度
		public var m_callback:Function = null;		// 特效回调函数
		
		// scene UI 特效专用
		public var m_repeat:Boolean = false;		// 
		
		// 下层，同时播放两个特效就会有这个
		public var m_delay1:Number = 0;			// 延迟时间
		public var m_defID1:String = '';			// 特效 ID
		public var m_framerate1:uint = 0;	// 帧率
		public var m_flyvel1:Number = 0;			// 飞行速度
		
		public var m_startX1:Number = 0;			// 飞行起始点
		public var m_startY1:Number = 0			// 飞行起始点
		public var m_endX1:Number = 0;			// 飞行终点
		public var m_endY1:Number = 0;			// 飞行终点
		public var m_scene1:fScene = null;			// 场景
		public var m_bFlip1:uint = 0;			// 特效翻转
		
		public var m_insID1:String = '';			// 人物ID，查找特效偏移使用
		public var m_effectSpeed1:Number = 0;	// 飞行速度
		public var m_callback1:Function = null;		// 特效回调函数
		
		// scene UI 特效专用
		public var m_repeat1:Boolean = false;		//
		// 特效类型
		public var m_type:uint = 0;
	}
}