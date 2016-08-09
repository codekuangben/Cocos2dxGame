package modulecommon.net.msg.mailCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	
	import flash.utils.ByteArray;
	public class BaoWuRansom 
	{
		public var ransom:Boolean;
		public var robberid:uint;
		public var objid:uint;
		public function deserialize(byte:ByteArray):void 
		{
			ransom = !byte.readBoolean();
			robberid = byte.readUnsignedInt();
			objid = byte.readUnsignedInt();
		}
		
	}

}

//邮件正文中的额外信息：被抢夺的宝物
/*struct BaoWuRansom {
        BYTE ransom ; //1:未赎回 0：已赎回
		DWORD robberid; //打劫者id
        DWORD objid; //宝物id
    }; */