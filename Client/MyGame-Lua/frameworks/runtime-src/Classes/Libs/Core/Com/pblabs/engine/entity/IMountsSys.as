package com.pblabs.engine.entity
{
	import org.ffilmation.engine.elements.fObject;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;

	/**
	 * @author 整个马匹系统
	 */
	public interface IMountsSys 
	{
		function dispose():void;
		// 放生一批坐骑
		function disposeOneMount(tmpid:uint):void;
		function get curHorseID():uint;
		function set curHorseID(value:uint):void;
		// 获取当前的马匹数据
		function get curHorseData():fObject;
		// 获取当前的马匹显示数据
		function get curHorseRenderData():fFlash9ElementRenderer;
		// 创建一批马出来
		function createHorse(horseid:uint, modelstr:String = ""):fObject;
		// 骑马
		function rideHorse(horseid:uint, modelstr:String = ""):void;
		// 下马
		function unRideHorse():void;
		// 切换骑乘，上下切换
		function toggleRideHorse(horseid:uint, modelstr:String = ""):void;
		// 换坐骑，在不同坐骑之间切换
		function changeRideHorse(horseid:uint):void;
	}
}