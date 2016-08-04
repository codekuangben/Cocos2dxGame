package modulecommon.net.msg.sgQunYingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stQunYingHuiOnlineCmd extends stSGQunYingCmd 
	{
		public var m_myrank:uint;
		public var m_group:uint;
		public var m_score:uint;
		public var m_zjList:Array;
		public function stQunYingHuiOnlineCmd() 
		{
			super();
			byParam = PARA_QUNYINGHUI_ONLINE_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_myrank = byte.readUnsignedShort();
			m_group = byte.readUnsignedByte();
			m_score = byte.readUnsignedInt();
			var num:uint = byte.readUnsignedByte();
			m_zjList = new Array();
			for (var i:uint = 0; i < num; i++ )
			{
				var user:UserZhanJi = new UserZhanJi();
				user.deserialize(byte);
				m_zjList.push(user);
			}
		}
	}

}/*const BYTE PARA_QUNYINGHUI_ONLINE_CMD = 3;
	struct stQunYingHuiOnlineCmd : public stSGQunYingCmd
	{
		stQunYingHuiOnlineCmd()
		{
			byParam = PARA_QUNYINGHUI_ONLINE_CMD;
			myrank = 0;
			group = 0;
			score = 0;
			zjnum = 0;
		}
		WORD myrank;
		BYTE group;
		DWORD score;
		BYTE zjnum;
		UserZhanJi zjlist[0];
	};*/