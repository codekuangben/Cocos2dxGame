package modulecommon.scene.prop.table
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * @brief 坐骑
	 */
	public class TMouseItem extends TDataItem 
	{
		public var m_name:String;
		//public var m_attrStr:String;
		public var m_strDesc:String;
		public var m_lvlMax:uint;
		
		public var m_mountsCardID:uint;
		public var m_mountsCardNum:uint;
		
		public var m_strModel:String;
		
		// 转换后的数据
		public var m_attrDic:Dictionary;

		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			
			m_attrDic = new Dictionary();
			
			m_name = TDataItem.readString(bytes);
			m_strDesc = TDataItem.readString(bytes);
			
			m_lvlMax = bytes.readUnsignedShort();
			
			m_mountsCardID = bytes.readUnsignedInt();
			m_mountsCardNum = bytes.readUnsignedShort();
			
			var m_attrStr:String;
			m_attrStr = TDataItem.readString(bytes);
			// 分裂字符串，转换成自己需要的数据
			var maohaolst:Array = m_attrStr.split(":");
			var lianjiefulst:Array;
			var idx:int = 0;
			while(idx < maohaolst.length)
			{
				if (maohaolst[idx].length)	// 表中现在有的长度是 0 
				{
					lianjiefulst = maohaolst[idx].split("-");
					m_attrDic[lianjiefulst[0]] = int(lianjiefulst[1]);		// bug 存储 int 类型
				}
				++idx;
			}
			
			m_strModel = TDataItem.readString(bytes);
		}
	}
}