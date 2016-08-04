package com.pblabs.engine.core
{
	/**
	 * @brief 帧的每一个阶段
	 * */
	public interface IFrameStage
	{
		function onFrameEnd():void;	// 一帧的结束
	}
}