package modulecommon.scene.prop.table 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class TObjectBaseItem extends TDataItem 
	{		
		public var m_name:String;	
		public var m_iType:uint;
		public var m_uMaxNum:uint;	//道具的最大数量
		public var m_iNeedLevel:int;		
		public var m_iLevel:int;
		public var m_iIconColor:int;
		public var m_gamePrice:int;	//游戏币价格
		public var m_iIconName:String;	
		public var m_iDesc:String;	
		public var m_iShareData1:uint;
		public var m_iShareData2:uint;
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			
			m_name = TDataItem.readString(bytes);
			m_iType = bytes.readUnsignedShort();	
			m_uMaxNum = bytes.readUnsignedInt();
			m_iNeedLevel = bytes.readShort();
			m_iLevel = bytes.readShort();
			m_iIconColor = bytes.readByte();
			m_gamePrice = bytes.readUnsignedShort();
			m_iIconName = TDataItem.readString(bytes);
			m_iDesc = TDataItem.readString(bytes);
			m_iShareData1 = bytes.readUnsignedInt();
			m_iShareData2 = bytes.readUnsignedInt();
		}
		
		public function pathIconName():String
		{
			return s_pathIconName(m_iIconName);
		}
		
		public static function s_pathIconName(name:String):String
		{
			return "objecticon/" + name + ".png";
		}
	}

}