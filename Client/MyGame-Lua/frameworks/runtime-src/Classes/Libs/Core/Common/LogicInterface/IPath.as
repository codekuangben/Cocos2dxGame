package common.logicinterface
{
	/**
	 * ...
	 * @author 
	 * @brief 获取路径都通过这里   
	 */
	public interface IPath
	{
		function getPathByID(id:uint, type:uint = 0):String;
		function getPathByName(name:String, type:uint = 0):String;
		function convPath2ID(path:String):uint;
		function init():void;
	}
}