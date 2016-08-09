package modulecommon.scene.prop.table 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 * 武将属性表
	 */
	import flash.utils.ByteArray;
	import modulecommon.scene.wu.AttackRange;
	public class TWuPropertyItem extends TDataItem 
	{
		public var m_uForce:uint;	//武力
		public var m_uIQ:uint;		//智力
		public var m_uChief:uint;		//统帅
		public var m_uHPLimit:uint;		//带兵上限(生命上限，带兵总值)
		public var m_uZhanshu:uint;
		public var m_uJinnang1:uint;	//锦囊
		//public var m_uJinnang2:uint;
		
		public var m_uAtiveWu1:uint;	//激活武将
		public var m_uAtiveWu2:uint;
		public var m_uAtiveWu3:uint;
		public var m_uAtiveWu4:uint;		
		
		public var m_tianfu:Vector.<uint>;
		public var m_uCost:uint;		//消耗
		public var m_attackRange:AttackRange;	//武将攻击/辅助范围
		public var m_shenge:uint;		//神格(仙转神所需)
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			var i:int;
			var data:uint;
			
			super.parseByteArray(bytes);
			m_uForce = bytes.readUnsignedShort();
			m_uIQ = bytes.readUnsignedShort();
			m_uChief = bytes.readUnsignedShort();
			m_uHPLimit = bytes.readUnsignedInt();
			m_uZhanshu = bytes.readUnsignedShort();
			m_uJinnang1 = bytes.readUnsignedShort();			
			
			m_uAtiveWu1 = bytes.readUnsignedShort();
			m_uAtiveWu2 = bytes.readUnsignedShort();
			m_uAtiveWu3 = bytes.readUnsignedShort();
			m_uAtiveWu4 = bytes.readUnsignedShort();
			
			m_tianfu = new Vector.<uint>();
			for (i = 0; i < 4; i++)
			{
				data = bytes.readUnsignedShort();
				if (data > 0)
				{
					m_tianfu.push(data);
				}
			}
			
			m_uCost = bytes.readUnsignedShort();
			
			m_attackRange = new AttackRange();
			m_attackRange.parseByteArray(bytes);
			
			m_shenge = bytes.readUnsignedInt();
		}
		public function get tianfu():Vector.<uint>
		{
			return m_tianfu;
		}
		public function getVecAtiveWu():Vector.<uint>
		{
			var ret:Vector.<uint> = new Vector.<uint>();			
			if (m_uAtiveWu1 > 0)
			{
				ret.push(m_uAtiveWu1);
			}
			if (m_uAtiveWu2 > 0)
			{
				ret.push(m_uAtiveWu2);
			}
			if (m_uAtiveWu3 > 0)
			{
				ret.push(m_uAtiveWu3);
			}
			if (m_uAtiveWu4 > 0)
			{
				ret.push(m_uAtiveWu4);
			}
			return ret;
		}
	}

}