package modulecommon.net.msg.xingMaiCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stChangeUserSkillXMCmd extends stXingMaiCmd
	{
		public var m_skillid:uint;
		
		public function stChangeUserSkillXMCmd() 
		{
			byParam = PARA_CHANGE_USERSKILL_XMCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_skillid = byte.readUnsignedInt();
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeUnsignedInt(m_skillid);
		}
	}

}

/*
	//更换技能
	const BYTE PARA_CHANGE_USERSKILL_XMCMD = 4;
	struct stChangeUserSkillXMCmd : public stXingMaiCmd
	{
		stChangeUserSkillCmd()
		{
			byParam = PARA_CHANGE_USERSKILL_XMCMD;
			skillid = 0;
		}
		DWORD skillid;
	};
*/