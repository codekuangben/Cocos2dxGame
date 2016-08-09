package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class updateCorpsBoxNumberUserCmd extends stCorpsCmd
	{
		public var num:uint;
		
		public function updateCorpsBoxNumberUserCmd() 
		{
			byParam = UPDATE_CORPS_BOX_NUMBER_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			num = byte.readUnsignedInt();
		}
	}

}

/*
	//更新争霸宝箱个数
	const BYTE UPDATE_CORPS_BOX_NUMBER_USERCMD = 54;
	struct updateCorpsBoxNumberUserCmd : public stCorpsCmd
	{
		updateCorpsBoxNumberUserCmd()
		{
			byParam = UPDATE_CORPS_BOX_NUMBER_USERCMD;
			num = 0;
		}
		DWORD num;
	};

*/