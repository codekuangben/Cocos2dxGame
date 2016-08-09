package common
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import net.http.HttpCmdBase;
	import org.ffilmation.engine.helpers.fActDirOff;

	/**
	 * ...
	 * @author 
	 * @brief 为了底层存储上层全局变量，因此定义这个接口    
	 */
	public interface IGKContext 
	{
		function linkOff(beingid:uint, effid:uint):Point;
		function getTagHeight(beingid:uint):int;
		function modelOff(beingid:uint, act:uint, dir:uint):Point;
		function modelOffAll(beingid:uint):fActDirOff;
		function effFrame(effid:uint):int;
		function effFrame2scale(effid:uint):Dictionary;
		function modelFrameRate(beingid:uint):Dictionary;
		
		// 进度条资源加载成功
		function progResLoaded(path:String):void;
		// 进度条资源加载失败
		function progResFailed(path:String):void;
		function progResProgress(path:String, percent:Number):void;
		// 进度条资源加载开始
		function progResStarted(path:String):void;
		function addProgLoadResPath(path:String):void;
		function get curMapID():uint;
		function get bInBattleIScene():Boolean;
		function onLoseFocus():void;
		function onHasFocus():void;
		function addLog(str:String):void;
		function playMsc(mscid:uint, loopCount:int=1):void;
		//function progLoadingisVisible():Boolean;
		function progLoadingaddResName(path:String):void;
		function progLoading_isState(state:uint):Boolean;
		
		function get isCOMMONSET_CLIENT_DebugBoxSet():Boolean
		function getLink1fHeight(beingid:uint):int;
		function modelMountserOffAll(beingid:uint):fActDirOff;
		
		function startprogResLoaded(path:String):void;
		function startprogResProgress(path:String, percent:Number):void;
		function startprogResFailed(path:String):void;
		function isSetLocalFlags(flag:uint):Boolean;
		
		function onIntoScene():void
		function onNetWorkDropped(type:int):void
		function onPreloaded():void
		function getMoreGameInfo(httpCmd:HttpCmdBase):void		
	}
}