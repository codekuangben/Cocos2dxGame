package modulecommon.uiinterface 
{
	/**
	 * ...
	 * @author 
	 */
	public interface IUICreateNameHero extends IUIBase
	{
		function processCreateNameModifyNameCmd():void
		function createNameSucceed(name:String, bvalid:int):void
	}
}