package modulecommon.scene.prop.table 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;	
	public class TRoleStateItem extends TDataItem 
	{
		public var m_name:String;
		public var m_iType:int;
		public var icon_id:uint;
		public var mode:uint;
		public var m_desc:String;
		public var m_picname:uint	//public var m_picname:String;		// 在屏幕中出现的美术字,名字是由两部分组成,表中填写一部分,例如 aaa ,如果是增益的 图片名字就是 aaa_0.png,如果是减益的就是 aaa_1.png 这样组合起来的
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			
			m_name = TDataItem.readString(bytes);
			m_iType = bytes.readUnsignedByte();				
			mode = bytes.readUnsignedByte();	
			icon_id = bytes.readUnsignedByte();	
			m_desc = TDataItem.readString(bytes);
			m_picname = bytes.readUnsignedByte();
			//m_picname = bytes.readUnsignedInt();//m_picname = TDataItem.readString(bytes); 
		}
	}

}