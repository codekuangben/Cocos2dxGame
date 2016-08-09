package modulecommon.scene.prop.table 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 * 战斗武将属性表 之 武将成长表
	 */
	public class THeroGrowupItem extends TDataItem
	{
		public var m_uForce:uint;		//武力
		public var m_uIQ:uint;			//智力
		public var m_uChief:uint;		//统帅
		public var m_uHPLimit:uint;		//带兵上限(生命上限，带兵总值)
		public var m_uSpeed:uint;		//速度
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			
			m_uForce = bytes.readUnsignedShort();
			m_uIQ = bytes.readUnsignedShort();
			m_uChief = bytes.readUnsignedShort();
			m_uHPLimit = bytes.readUnsignedInt();
			m_uSpeed = bytes.readUnsignedShort();
		}
	}

}