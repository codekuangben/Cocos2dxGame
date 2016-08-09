package modulecommon.net.msg.giftCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.giftCmd.GiftItem;
	import modulecommon.net.msg.giftCmd.stGiftCmd;
	import modulecommon.scene.prop.object.ZObject;
	import com.pblabs.engine.entity.EntityCValue;
	
	/**
	 * ...
	 * @author 
	 */
	public class retOnlineGiftContentUserCmd extends stGiftCmd
	{
		public var size:uint;
		public var data:Vector.<GiftItem>;
		public var m_objList:Vector.<ZObject>;
		
		public function retOnlineGiftContentUserCmd() 
		{
			byParam = RET_ONLINE_GIFT_CONTENT_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			size = byte.readUnsignedShort();

			data ||= new Vector.<GiftItem>();
			data.length = 0;
			
			m_objList ||= new Vector.<ZObject>();
			m_objList.length = 0;
			
			var item:GiftItem;
			var obj:ZObject;
			var idx:int = 0;
			while (idx < size)
			{
				item = new GiftItem();
				item.deserialize(byte);
				data.push(item);
				
				obj = ZObject.createClientObject(item.id, item.num, item.upgrade);
				m_objList.push(obj);
				
				++idx;
			}
		}
		
		public function hasWuJiang():Boolean
		{
			for each(var item:GiftItem in data)
			{
				if (item.id == EntityCValue.WUJIANG   ||
				    item.id == EntityCValue.WUJIANG1f ||
					item.id == EntityCValue.WUJIANG2f)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function getWuJiang():uint
		{
			for each(var item:GiftItem in data)
			{
				if (item.id == EntityCValue.WUJIANG   ||
				    item.id == EntityCValue.WUJIANG1f ||
					item.id == EntityCValue.WUJIANG2f)
				{
					return item.id;
				}
			}
			
			return 0;
		}
	}
}

//const BYTE RET_ONLINE_GIFT_CONTENT_USERCMD = 4;
//struct retOnlineGiftContentUserCmd : public stGiftCmd
//{
	//retOnlineGiftContentUserCmd()
	//{
		//byParam = RET_ONLINE_GIFT_CONTENT_USERCMD;
		//size = 0;
	//}
	//WORD size;
	//GiftItem data[0];
	//WORD getSize() const{ return sizeof(*this) + size*sizeof(GiftItem); }
//};