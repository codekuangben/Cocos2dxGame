package com.pblabs.engine.core 
{
	import flash.events.Event;
	//import org.ffilmation.engine.core.fScene;
	import com.pblabs.engine.core.IFrameStage;
	
	/**
	 * @brief 接口 
	 */
	public interface IProcessManager 
	{
		function get timeScale():Number;
        function set timeScale(value:Number):void;
        function set TimeScale(value:Number):void;
        function get TimeScale():Number;

        function get interpolationFactor():Number;
        function get virtualTime():Number;
        function get platformTime():Number;
        function start():void;

        function stop():void;
        function get isTicking():Boolean;
        function schedule(delay:Number, thisObject:Object, callback:Function, ...arguments):void;

        function addTickedObject(object:ITickedObject, priority:Number = 0.0):void;
        function queueObject(object:IQueuedObject):void;
        function removeTickedObject(object:ITickedObject):void;

        function testAdvance(amount:Number):void;
        function seek(amount:Number):void;
        function callLater(method:Function, args:Array = null):void;
		
		// 舞台大小改变事件处理过程    
		function onResize(event:Event = null):void;
		function addResizeObject(object:IResizeObject, priority:Number = 0.0):void;
		function removeResizeObject(object:IResizeObject):void;
		
		function add1SecondUpateObject(obj:ITimeUpdateObject):void;
		function remove1SecondUpateObject(obj:ITimeUpdateObject):void;		
		
		function add1MinuteUpateObject(obj:ITimeUpdateObject):void
		function remove1MinuteUpateObject(obj:ITimeUpdateObject):void
		
		function add10MinuteUpateObject(obj:ITimeUpdateObject):void
		function remove10MinuteUpateObject(obj:ITimeUpdateObject):void
		
		function addFrameObject(object:IFrameStage):void;
		function removeFrameObject(object:IFrameStage):void;
		
		function toggleTimer(frame:uint):void;
		
		function get runMode():uint;
		function set runMode(value:uint):void;
		function get internalTime():Number;
		function set internalTime(value:Number):void;
		function nextFrameStep():void;
		function setUseIdleTime(b:Boolean):void
	}
}