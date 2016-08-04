package modulecommon.net.msg.xingMaiCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stLevelUpXMAttrXMCmd extends stXingMaiCmd
	{
		public var m_attrno:uint;
		
		public function stLevelUpXMAttrXMCmd() 
		{
			byParam = PARA_LEVELUP_XMATTR_XMCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeInt(m_attrno);
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_attrno = byte.readUnsignedShort();
		}
	}

}

/*
	//请求升级属性
	const PARA_LEVELUP_XMATTR_XMCMD = 2;
	struct stLevelUpXMAttrXMCmd : public stXingMaiCmd
	{
		stLevelUpAttrXMCmd()
		{
			byParam = PARA_LEVELUP_XMATTR_XMCMD;
			attrno = 0;
		}
		WORD attrno;	//属性编号	
	};
*/