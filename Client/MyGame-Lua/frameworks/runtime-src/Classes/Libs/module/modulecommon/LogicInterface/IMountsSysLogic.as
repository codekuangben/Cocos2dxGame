package modulecommon.logicinterface
{
	import modulecommon.scene.beings.MountsSys;
	import modulecommon.net.msg.mountscmd.stMountData;
	import modulecommon.net.msg.mountscmd.TypeValue;
	
	/**
	 * @brief 坐骑系统逻辑
	 */
	public interface IMountsSysLogic
	{
		function get btnClkLoadModuleMode():Boolean;
		function set btnClkLoadModuleMode(value:Boolean):void;
		function get otherLoadModuleMode():Boolean;
		function set otherLoadModuleMode(value:Boolean):void;
		
		function psstViewOtherUserMountCmd(mountlist:Vector.<stMountData>, tplist:Vector.<TypeValue>):void
		function get otherMountsSys():MountsSys;
		
		function get otherTmpID():uint;
		function set otherTmpID(value:uint):void;
		function hasOtherMountsData():Boolean;
	}
}