package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class retClickMultiCopyUiUserCmd extends stCopyUserCmd
	{
		public var size:uint;
		//public var data:Vector.<UnFullCopyData>;
		public var data:Array;

		public function retClickMultiCopyUiUserCmd()
		{
			super();
			byParam = stCopyUserCmd.RET_CLICK_MULTI_COPY_UI_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			size = byte.readUnsignedByte();
			var idx:uint = 0;
			var item:UnFullCopyData;
			
			data = [];
			while(idx < size)
			{
				item = new UnFullCopyData();
				item.deserialize(byte);
				data.push(item);
				
				++idx;
			}
		}
	}
}

//const BYTE RET_CLICK_MULTI_COPY_UI_USERCMD = 40;
//struct retClickMultiCopyUiUserCmd : public stCopyUserCmd
//{
//	retClickMultiCopyUiUserCmd()
//	{
//		byParam = RET_CLICK_MULTI_COPY_UI_USERCMD;
//		size = 0;
//	}
//	BYTE size; 
//	UnFullCopyData data[0];
//	WORD getSize() const { return sizeof( UnFullCopyData)*size + sizeof(*this); }
//};