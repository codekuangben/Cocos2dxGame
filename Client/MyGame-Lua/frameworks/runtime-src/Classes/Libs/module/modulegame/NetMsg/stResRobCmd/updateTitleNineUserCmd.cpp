package game.netmsg.stResRobCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.stResRobCmd.stResRobCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class updateTitleNineUserCmd extends stResRobCmd 
	{
		public var list:Vector.<TitleItem>;
		public function updateTitleNineUserCmd() 
		{
			super();
			byParam = UPDATE_TITLE_NINE_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			list = new Vector.<TitleItem>();
			var size:int = byte.readUnsignedByte();
			var i:int;
			var item:TitleItem;
			for (i = 0; i < size; i++)
			{
				item = new TitleItem();
				item.deserialize(byte);
				list.push(item);
			}
		}
		
	}

}

//更新玩家军衔9屏
	/*const BYTE UPDATE_TITLE_NINE_USERCMD = 7;
	struct updateTitleNineUserCmd : public stResRobCmd
	{
		updateTitleNineUserCmd()
		{
			byParam = UPDATE_TITLE_NINE_USERCMD;
			size = 0;
		}
		BYTE size;
		TitleItem data[0];
		WORD getSize() const { return sizeof(*this)+ sizeof(TitleItem)*size; }
	};*/