package modulecommon.net.msg.zhanXingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stRefreshMingLiCmd extends stZhanXingCmd 
	{
		public var type:uint;
		public var m_mingli:uint;
		public function stRefreshMingLiCmd() 
		{
			super();
			byParam = PARA_REFRESH_MINGLI_ZXCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			type = byte.readUnsignedByte();
			m_mingli = byte.readUnsignedInt();
		}
		
	}

}

//命力
	/*const BYTE PARA_REFRESH_MINGLI_ZXCMD = 12;
	struct stRefreshMingLiCmd : public stZhanXingCmd
	{
		stRefreshMingLiCmd()
		{
			byParam = PARA_REFRESH_MINGLI_ZXCMD;
			mingli = 0;
		}
		BYTE type;  //军种类型 0:前军 1:中军 2:后军
		DWORD mingli;
	};*/