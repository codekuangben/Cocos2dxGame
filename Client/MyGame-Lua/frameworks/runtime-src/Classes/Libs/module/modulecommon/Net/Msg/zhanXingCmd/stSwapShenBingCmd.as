package modulecommon.net.msg.zhanXingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stSwapShenBingCmd extends stZhanXingCmd 
	{
		public var thisid:uint;
		public var m_location:stLocation;
		public function stSwapShenBingCmd() 
		{
			super();
			byParam = PARA_SWAP_SHENBING_ZXCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			thisid = byte.readUnsignedInt();
			m_location = new stLocation();
			m_location.deserialize(byte);
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(thisid);
			m_location.serialize(byte);
		}
		
	}

}

//移动神兵
	/*const BYTE PARA_SWAP_SHENBING_ZXCMD = 7;
	struct stSwapShenBingCmd : public stZhanXingCmd
	{
		stSwapShenBingCmd()
		{
			byParam = PARA_SWAP_SHENBING_ZXCMD;
			thisid = 0;
		}
		DWORD thisid;
		stLocation dst;
	};*/