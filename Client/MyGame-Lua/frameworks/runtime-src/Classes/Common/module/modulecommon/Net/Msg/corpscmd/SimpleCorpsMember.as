package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author ...
	 */
	public class SimpleCorpsMember 
	{
		public var name:String;
		public var priv:uint;
		public var zhanli:uint;
		
		public function SimpleCorpsMember() 
		{
			name = "";
		}
		
		public function deserialize(byte:ByteArray):void
		{
			name = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			priv = byte.readUnsignedByte();
			zhanli = byte.readUnsignedInt();
		}
	}

}

/*
struct SimpleCorpsMember
    {
        char name[MAX_NAMESIZE];
        BYTE priv;
        DWORD zhanli;
    };
*/