package network 
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class socketTools 
	{
		/**
		 * @brief 压缩工具 
		 * */
		//public static function Compress(bytesPacket:ByteArray):void
		//{
		//	bytesPacket.compress();
		//}
		
		/**
		 * @brief 解压缩工具 
		 * */
		//public static function Uncompress(bytesPacket:ByteArray):void
		//{
		//	bytesPacket.uncompress();
		//}
		
		/**
		 * @brief 名字拼凑，主要是查找 socket 用的 
		 */
		public static function socketKey(ip:String, port:int):String
		{
			return ip + ":" + port;
		}
	}
}