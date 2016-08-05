package modulecommon.net.msg.xingMaiCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stLevelUpXMSkillXMCmd extends stXingMaiCmd
	{
		public var m_skillid:uint;
		public var m_heroid:uint;
		
		public function stLevelUpXMSkillXMCmd() 
		{
			byParam = PARA_LEVELUP_XMSKILL_XMCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_skillid = byte.readUnsignedInt();
			m_heroid = byte.readUnsignedInt();
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeUnsignedInt(m_skillid);
			byte.writeUnsignedInt(m_heroid);
		}
	}

}

/*
	//星脉技能升级
	const BYTE PARA_LEVELUP_XMSKILL_XMCMD = 5;
	struct stLevelUpXMSkillXMCmd : public stXingMaiCmd
	{
		stLevelUpXMSkillXMCmd()
		{
			byParam = PARA_LEVELUP_XMSKILL_XMCMD;
			skillid = 0;
			heroid = 0;
		}
		DWORD skillid;
		DWORD heroid;
	};
*/