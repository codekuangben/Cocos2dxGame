package modulecommon.uiinterface
{
	import flash.utils.ByteArray;
	
	/**
	 * @brief 坐骑系统
	 */
	public interface IUIMountsSys 
	{
		function showCCSUI(formid:uint):void;
		function psstAddMountToUserCmd():void;
		function psstChangeUserMountCmd():void;
		function psstRefreshTrainPropCmd():void;
		function psstNotifyTrainPropsCmd():void;
		function onObjNumChange():void;
		function psstRefreshFreeMountTrainTimesCmd():void;
		function isResReady():Boolean;
		function psstViewOtherUserMountCmd(msg:ByteArray):void;
	}
}