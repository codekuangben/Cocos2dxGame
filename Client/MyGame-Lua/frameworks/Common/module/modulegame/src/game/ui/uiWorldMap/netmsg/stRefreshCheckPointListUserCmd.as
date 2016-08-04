package game.ui.uiWorldMap.netmsg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class stRefreshCheckPointListUserCmd extends stCopyUserCmd 
	{
		public var list:Vector.<uint>;
		public function stRefreshCheckPointListUserCmd() 
		{
			byParam = PARA_REFRESH_CHECK_POINT_LIST_USERCMD;
			list = new Vector.<uint>();
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			var size:uint = byte.readUnsignedByte();
			var i:int;
			for (i = 0; i < size; i++)
			{
				list.push(byte.readUnsignedInt());
			}
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			var size:uint = list.length;
			byte.writeByte(size);
			var i:int;
			for (i = 0; i < size; i++)
			{
				byte.writeUnsignedInt(list[i]);
			}
		}
		
	}

}

/*const BYTE PARA_REFRESH_CHECK_POINT_LIST_USERCMD = 36; 
    struct stRefreshCheckPointListUserCmd : public stCopyUserCmd
    {   
        stRefreshCheckPointListUserCmd()
        {   
            byParam = PARA_REFRESH_CHECK_POINT_LIST_USERCMD;
        }   
        BYTE size;
        DWORD list[0];
        WORD getSize() const { return sizeof(*this) + sizeof(DWORD)*size; }
    }; */ 
