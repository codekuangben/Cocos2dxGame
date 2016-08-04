package modulecommon.uiinterface 
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IUIConfirmDlg  extends IUIBase
	{
		function process():void
		function clearData():void
		function isRadioButtonCheck():Boolean
		function updateDesc(desc:String):void
		function getInputNumber():int
	}
	
}