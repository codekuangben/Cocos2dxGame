package modulecommon.scene.prop
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author 
	 * @brief 每一种表的接口 
	 */
	public interface ITbl 
	{
		// XML初始化 
		function initXML(content:XML, type:uint):void;
		// 字节流初始化    
		function initBin(content:ByteArray, type:uint):void;
	}
}