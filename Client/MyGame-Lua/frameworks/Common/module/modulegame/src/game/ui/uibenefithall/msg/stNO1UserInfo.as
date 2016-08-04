package game.ui.uibenefithall.msg 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	
	public class stNO1UserInfo 
	{
		public var m_name:String;
		public var sex:int;
		public var job:int;
		public var level:int;
		public function deserialize(byte:ByteArray):void 
		{
			m_name = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			sex = byte.readUnsignedByte();
			job = byte.readUnsignedByte();
			level = byte.readUnsignedShort();
		}
		
	}

}

//第一名玩家信息
    /*struct stNO1UserInfo
    {
        char name[MAX_NAMESIZE];
        BYTE sex;
        BYTE job;
        WORD level;
        stNO1UserInfo()
        {
            bzero(name,sizeof(name));
            sex = job = 0;
            level = 0;
        }
    };*/