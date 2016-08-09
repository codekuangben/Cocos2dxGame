package modulecommon.net.msg.xingMaiCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stNotifyXMSkillActiveXMCmd extends stXingMaiCmd
	{
		public var m_skillid:uint;
		
		public function stNotifyXMSkillActiveXMCmd() 
		{
			byParam = PARA_NOTIFY_XMSKILL_ACTIVE_XMCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_skillid = byte.readUnsignedInt();
		}
	}

}

/*
	//星脉技能激活 s->c
	const PARA_NOTIFY_XMSKILL_ACTIVE_XMCMD = 3;
	struct stNotifyXMSkillActiveXMCmd : public stXingMaiCmd
	{
		stNotifyXMSkillActiveXMCmd()
		{
			byParam = PARA_NOTIFY_XMSKILL_ACTIVE_XMCMD;
			skillid = 0;
		}
		DWORD skillid;
	};
*/