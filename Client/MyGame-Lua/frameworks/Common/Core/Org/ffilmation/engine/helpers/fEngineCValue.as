package org.ffilmation.engine.helpers
{
	/**
	 * @brief 引擎所有的常量都存放在这里  
	 */
	public class fEngineCValue 
	{
		// 显示模型定义 
		public static const MdMovieClip:uint = 0;	// 显示模型是 MovieClip    
		public static const MdPicSeq:uint = 1;	// 显示模型是图片序列，在单独的图片序列上 
		public static const MdPicOne:uint = 2;	// 显示模型是图片序列，都在整张图片上     
		
		public static const MdEffPicSeq:uint = 3;	// 显示粒子图片序列，在单独的图片序列上 
		public static const MdEffPicOne:uint = 4;	// 显示粒子是图片序列，都在整张图片上   
		
		// 引擎类型   
		public static const EngineISO:uint = 0;	// 当前引擎的行为，人物、地物位置、地形形状需要缩放
		public static const Engine25d:uint = 1;	// 2.5d ，人物、地物位置变换，地形形状不变 
		public static const Engine2d:uint = 2;	// 完全 2d ，不进行任何变换  
		
		// 路径定义 
		public static const PathRelative:uint = 0;	// 相对于当前文件定义路径 
		public static const PathAbsolute:uint = 1;	// 相对于启动的 swf 文件路径，基本就是绝对路径   
		
		// 动作重复播放次数，还没想好   
		//public static const Repeat
	}
}