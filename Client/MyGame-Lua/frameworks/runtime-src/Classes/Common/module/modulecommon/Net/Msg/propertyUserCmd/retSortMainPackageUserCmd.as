package modulecommon.net.msg.propertyUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class retSortMainPackageUserCmd extends stPropertyUserCmd 
	{
		public var type:int;
		public var list:Vector.<SortItem>;
		
		public function retSortMainPackageUserCmd() 
		{
			super();
			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			type = byte.readUnsignedByte();
			list = new Vector.<SortItem>();
			var size:int = byte.readUnsignedByte();
			var i:int;
			var item:SortItem;
			for (i = 0; i < size; i++)
			{
				item = new SortItem();
				item.deserialize(byte);
				list.push(item);
			}
		}
		
	}

}

//返回整理背包
	/*const BYTE RET_SORT_MAIN_PACKAGE_USERCMD = 38;
	struct retSortMainPackageUserCmd : public stPropertyUserCmd
	{
		retSortMainPackageUserCmd()
		{
			byParam = RET_SORT_MAIN_PACKAGE_USERCMD;
		}
		BYTE type; //0:道具包裹， 1：宝物包裹
		BYTE size;
		SortItem data[0];
		WORD getSize() const  { return sizeof(*this) + size*sizeof(SortItem); }
	};*/