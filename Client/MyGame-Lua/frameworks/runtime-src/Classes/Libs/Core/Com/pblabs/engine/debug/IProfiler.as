package com.pblabs.engine.debug
{
	/**
	 * ...
	 * @author 
	 */
	public interface IProfiler 
	{
		function enter(blockName:String):void;
		function exit(blockName:String):void;
		function ensureAtRoot():void;
		
		function destroy():void;
	}
}