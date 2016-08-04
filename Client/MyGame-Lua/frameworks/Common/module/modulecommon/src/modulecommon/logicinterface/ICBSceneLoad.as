package modulecommon.logicinterface
{
	import org.ffilmation.engine.core.fScene;

	/**
	 * @brief 场景加载接口
	 * */
	public interface ICBSceneLoad
	{
		function onSceneLoaded(newScene:fScene, inplace:Boolean = false):void
		function preInit(scrSceneType:int, destSceneType:int, oldScene:fScene, destroyRender:Boolean, bclose:Boolean):void;
		function postInit(scrSceneType:int, destSceneType:int, newScene:fScene):void;
		function destroy():void;
	}
}