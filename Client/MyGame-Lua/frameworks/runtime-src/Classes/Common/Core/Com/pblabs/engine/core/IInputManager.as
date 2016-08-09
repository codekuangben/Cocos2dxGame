package com.pblabs.engine.core 
{
	//import common.Context;
	/**
	 * ...
	 * @author 
	 */
	public interface IInputManager 
	{
        function onTick(deltaTime:Number):void;
        function keyJustPressed(keyCode:int):Boolean;
        function keyJustReleased(keyCode:int):Boolean;

        function isKeyDown(keyCode:int):Boolean;
        function isAnyKeyDown():Boolean;
        function simulateKeyDown(keyCode:int):void;
        function simulateKeyUp(keyCode:int):void;

        function simulateMouseDown():void;
        function simulateMouseUp():void;
        function simulateMouseMove():void;
        function simulateMouseOver():void;
		
        function simulateMouseOut():void;
        function simulateMouseWheel():void;
	}
}