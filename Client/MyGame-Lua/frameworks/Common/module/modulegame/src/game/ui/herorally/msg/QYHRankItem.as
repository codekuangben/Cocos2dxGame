package game.ui.herorally.msg 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class QYHRankItem 
	{
		public var m_serverId:uint;
		public var m_serverNo:uint;
		public var m_name:String;
		public var m_score:uint;
		public var m_id:uint;
		public function deserialize(byte:ByteArray):void
		{
			m_serverId = byte.readUnsignedShort();
			m_serverNo = byte.readUnsignedShort();
			m_name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			m_score = byte.readUnsignedInt();
		}
	}

}/*struct QYHRankItem
	{
		WORD game;	//平台
		WORD zone;	//区
		char name[MAX_NAMESIZE];
		//WORD level;
		DWORD score;
		QYHRankItem()
		{
			game = zone = 0;
			bzero(name,sizeof(name));
			level = 0;
			score = 0;
		}
	};*/