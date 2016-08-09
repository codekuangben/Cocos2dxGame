package network 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class EncDec 
	{
		/**
		 * 
		 * */
		public function EncDec() 
		{
			
		}
		
		/**
		 * @brief 压缩工具 
		 * */
		public static function Compress(bytesPacket:ByteArray):void
		{
			bytesPacket.compress();
		}
		
		/**
		 * @brief 解压缩工具 
		 * */
		public static function Uncompress(bytesPacket:ByteArray):void
		{
			bytesPacket.uncompress();
		}
	}
}