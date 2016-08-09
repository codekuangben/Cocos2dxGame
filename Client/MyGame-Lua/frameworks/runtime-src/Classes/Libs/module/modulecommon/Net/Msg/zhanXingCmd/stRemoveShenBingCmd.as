package modulecommon.net.msg.zhanXingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stRemoveShenBingCmd extends stZhanXingCmd 
	{
		public var thisid:uint;
		public function stRemoveShenBingCmd() 
		{
			super();
			byParam = PARA_REMOVE_SHENBING_ZXCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			thisid = byte.readUnsignedInt();
		}
	}

}

//删除神兵
	/*const BYTE PARA_REMOVE_SHENBING_ZXCMD = 6;
	struct stRemoveShenBingCmd : public stZhanXingCmd
	{
		stRemoveShenBingCmd()
		{
			byParam = PARA_REMOVE_SHENBING_ZXCMD;
			thisid = 0;
		}
		DWORD thisid;
	};*/