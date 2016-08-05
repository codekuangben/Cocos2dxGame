package modulecommon.net.msg.sgQunYingCmd 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class MatchUserInfo 
	{
		public var m_matchTime:uint;
		public var m_name:String;
		public var m_level:uint;
		public var m_sex:uint;
		public var m_job:uint;
		public var m_serverId:uint;
		public var m_serverNo:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			m_matchTime = byte.readUnsignedInt();
			m_name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			m_level = byte.readUnsignedShort();
			m_sex = byte.readUnsignedByte();
			m_job = byte.readUnsignedByte();
			m_serverId = byte.readUnsignedShort();
			m_serverNo = byte.readUnsignedShort();
		}
	}

}/*//匹配对象信息
	struct MatchUserInfo
	{
		DWORD matchtime;
		char name[MAX_NAMESIZE];
		WORD level;
		BYTE sex;
		BYTE job;
		WORD game;
		WORD zone;
		MatchUserInfo()
		{
			matchtime = 0;
			bzero(name,sizeof(name));
			level = 0;
			sex = job = 0;
			game = zone = 0;
		}
	};*/