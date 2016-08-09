package modulecommon.logicinterface
{
	
	/**
	 * @处理 UI 加载与卸载的接口 
	 */
	public interface ICBUIEvent 
	{
		function init():void;
		function destroy():void;
		
		function getLoadedFunc(id:uint):Function;
		function getFailedFunc(id:uint):Function;
	}
}