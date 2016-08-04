package com.pblabs.engine.core
{	
	/**
	 * ...
	 * @author 
	 * @brief 需要处理窗口大小改变的对象实现这个接口   
	 */
	public interface IResizeObject 
	{
		// 大小改变的时候会调用这个函数    
		function onResize(viewWidth:int, viewHeight:int):void
	}
}