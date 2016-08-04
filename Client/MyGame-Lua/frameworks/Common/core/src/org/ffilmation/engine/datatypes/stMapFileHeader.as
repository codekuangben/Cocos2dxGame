package org.ffilmation.engine.datatypes
{
	import flash.utils.ByteArray;

	/**
	 * @brief 阻挡点文件头
	 * */
	public class stMapFileHeader
	{
		public var ver:uint;
		public var width:uint;
		public var height:uint;
		
		public function parseByteArray(bytes:ByteArray):void
		{
			ver = bytes.readUnsignedInt();
			width = bytes.readUnsignedInt();
			height = bytes.readUnsignedInt();
		}
	}
}

//struct stMapFileHeader
//{
//	DWORD ver;        /**< 版本 MAP_VERSION */
//	DWORD width;      /**< 宽度 */
//	DWORD height;      /**< 高度 */
//};