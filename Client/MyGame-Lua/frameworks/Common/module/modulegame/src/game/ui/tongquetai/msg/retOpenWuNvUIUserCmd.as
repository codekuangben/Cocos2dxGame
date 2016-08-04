package game.ui.tongquetai.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.wunvCmd.stWuNvCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class retOpenWuNvUIUserCmd extends stWuNvCmd 
	{		
		public var m_fdata:Array;
		public function retOpenWuNvUIUserCmd() 
		{
			super();
			byParam = RET_OPEN_WU_NV_UI_USERCMD;
			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			var i:int;			
			m_fdata = new Array();
			
			var fsize:uint = byte.readUnsignedByte();
			var fdata:FriendWuNvState;
			for (i = 0; i < fsize; i++ )
			{
				fdata = new FriendWuNvState();
				fdata.deserialize(byte);
				m_fdata.push(fdata);
			}
		}
	}

}

/*	const BYTE RET_OPEN_WU_NV_UI_USERCMD = 3;
	struct retOpenWuNvUIUserCmd : public stWuNvCmd
	{
		retOpenWuNvUIUserCmd()
		{
			byParam = RET_OPEN_WU_NV_UI_USERCMD;
			size = fsize = 0;
		}		
		BYTE fsize;
		FriendWuNvState fdata[0];
	};*/