package modulecommon.uiinterface
{
	import flash.utils.ByteArray;
	/**
	 * @brief
	 */
	public interface IUIPaoShangSys 
	{
		function openUI(formid:uint):void;
		function isResReady():Boolean;
		//function psnotifyBusinessDataUserCmd(msg:ByteArray):void;
		function psstRetBusinessUiDataUserCmd(msg:ByteArray):void;
		function psretBeginBusinessUserCmd(msg:ByteArray):void;
		function psretStartBusinessUserCmd(msg:ByteArray):void;
		//function psaddOneRoberInfoUserCmd(msg:ByteArray):void;
	}
}