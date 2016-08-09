package modulecommon.net.msg.xingMaiCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 * 属性信息
	 */
	public class stAttrInfo 
	{
		public var m_attrno:uint;	//属性编号
		public var m_level:uint;	//等级
		
		public function stAttrInfo() 
		{
			m_attrno = 0;
			m_level = 0;
		}
		
		public function deserialize(byte:ByteArray):void
		{
			m_attrno = byte.readUnsignedShort();
			m_level = byte.readUnsignedShort();
		}
		
	}

}

/*
	struct stAttrInfo
	{
		WORD attrno;	//属性编号
		WORD level;	//等级
		stAttrInfo()
		{
			attrno = level = 0;
		}
		stAttrInfo(const WORD _attrno,const WORD _level)
			: attrno(_attrno),level(_level)
		{
		}
	};
*/