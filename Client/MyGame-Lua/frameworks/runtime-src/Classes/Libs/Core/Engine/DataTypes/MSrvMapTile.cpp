package org.ffilmation.engine.datatypes
{
	import flash.utils.ByteArray;

	/**
	 * @brief 地图文件中的阻挡点记录
	 * */
	public class stSrvMapTile
	{
		public var flags:uint;
		public var type:uint;
		public var m_x:uint;	// 记录格子位置
		public var m_y:uint;	// 记录格子位置
		
		public function parseByteArray(bytes:ByteArray):void
		{
			flags = bytes.readUnsignedByte();
			type = bytes.readUnsignedByte();
		}
	}
}

//struct stSrvMapTile
//{
//	BYTE  flags;  // 格子属性
//	BYTE  type;  // 格子类型
//};