package modulecommon.logicinterface
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import org.ffilmation.engine.core.fRenderableElement;

	/**
	 * ...
	 * @author 
	 */
	public interface ISceneLogic 
	{
		function init():void;
		function destroy():void;
		function keyPressed(evt:KeyboardEvent):void;
		function keyReleased(evt:KeyboardEvent):void;
		function onClick(evt:MouseEvent):void;
		function removeKeyEventListener():void;
		function addKeyEventListener():void;
		function disposeElement(element:fRenderableElement):void;
	}
}