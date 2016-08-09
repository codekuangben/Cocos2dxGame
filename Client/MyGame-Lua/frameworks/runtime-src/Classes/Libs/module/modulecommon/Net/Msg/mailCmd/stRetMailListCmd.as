package modulecommon.net.msg.mailCmd
{
	import modulecommon.net.msg.mailCmd.stMailCmd;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stRetMailListCmd extends stMailCmd 
	{
		public var m_systemList:Array;
		public var m_playerList:Array;
		public function stRetMailListCmd() 
		{
			byParam = RET_MAIL_LIST_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			var num:int = byte.readUnsignedByte();
			var i:int = 0;
			var head:MailHead;
			m_systemList = new Array();
			m_playerList = new Array();
			
			for (i = 0; i < num; i++)
			{
				head = new MailHead();
				head.deserialize(byte);
				if (head.type & 0x1)
				{
					m_systemList.push(head);
				}
				else
				{
					m_playerList.push(head);
				}
			}
			
			m_systemList.sort(MailHead.compare);
			m_playerList.sort(MailHead.compare);
		}
	}

}

/*
 * const BYTE RET_MAIL_LIST_USERCMD = 2;
	struct stRetMailListCmd : public stMailCmd
	{
		stRetMailListCmd()
		{
			byParam = RET_MAIL_LIST_USERCMD;
			size = 0;
		}
		BYTE size;
		MailHead list[0];
		WORD getSize(){ return sizeof(*this) + size*sizeof(MailHead); }
	};
*/