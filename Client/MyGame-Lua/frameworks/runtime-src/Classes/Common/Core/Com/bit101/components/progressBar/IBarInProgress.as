package com.bit101.components.progressBar 
{
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public interface IBarInProgress
	{
		function set maximum(m:Number):void;
		function set initValue(v:Number):void;	//设置_value的初始值
		function set value(v:Number):void;
		function initBar():void;
	}
}