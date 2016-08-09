package common.scene
{
	//import flash.events.Event;
	import org.ffilmation.engine.events.fEventIn;
	import org.ffilmation.engine.events.fProcessEvent;
	import org.ffilmation.engine.core.fEngine;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.core.fCamera;
	//import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.entity.BeingEntity;
	
	/**
	 * @brief 
	 */
	public interface ISceneView 
	{
		//function gotoScene(path:String):void;
		function gotoScene(path:String, sceneid:uint):void;
		//function gotoSceneInOutFight(path:String, sceneid:uint, bin:Boolean = true, destroyRender:Boolean = true, bdispose:Boolean = false):void;
		function gotoSceneFight(path:String, sceneid:uint):void
		function leaveSceneFight():void
		
		function gotoSceneUI(path:String, sceneid:uint):void
		function leaveSceneUI():void
		
		//function loadProgressHandler(evt:fProcessEvent):void;
		//function loadCompleteHandler(evt:fProcessEvent):void;

		//function activateScene():void;		
		//function INlistener(evt:fEventIn):void;		
		//function control(evt:Event):void;
		function hasScene(path:String):Boolean;
		
		function get engine():fEngine; 
		function scene(which:uint = 0):fScene; 
		function curCamera(which:uint = 0):fCamera;
		function path(which:uint = 0):String;
		function get curSceneType():int;
		
		function getScene(path:String):fScene;
		//function getScenePath(sc:fScene):String;
		function getGameScene():fScene;
		function followHero(hero:BeingEntity, which:uint = 0/*EntityCValue.SCGAME*/):void;
		function stopFollowHero(hero:BeingEntity, which:uint = 0/*EntityCValue.SCGAME*/):void;
		function get sorSceneType():int;
		function curScene():fScene;
		function get isLoading():Boolean
	}
}