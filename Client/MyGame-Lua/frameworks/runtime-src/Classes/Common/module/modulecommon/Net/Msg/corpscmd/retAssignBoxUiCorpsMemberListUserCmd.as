package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class retAssignBoxUiCorpsMemberListUserCmd extends stCorpsCmd
	{
		public var dataList:Array;
		
		public function retAssignBoxUiCorpsMemberListUserCmd() 
		{
			byParam = RET_ASSIGN_BOX_UI_CORPS_MEMBER_LIST_USERCMD;
			dataList = new Array();
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			var size:int = byte.readUnsignedByte();
			var item:SimpleCorpsMember;
			for (var i:int = 0; i < size; i++)
			{
				item = new SimpleCorpsMember();
				item.deserialize(byte);
				dataList.push(item);
			}
		}
		
	}

}

/*
//返回分配宝箱军团成员列表 s->c
	const BYTE RET_ASSIGN_BOX_UI_CORPS_MEMBER_LIST_USERCMD = 56;
	struct retAssignBoxUiCorpsMemberListUserCmd : public stCorpsCmd
	{
		retAssignBoxUiCorpsMemberListUserCmd()
		{
			byParam = RET_ASSIGN_BOX_UI_CORPS_MEMBER_LIST_USERCMD;
		}
		BYTE size;
		SimpleCorpsMember data[0];
		WORD getSize() const { return sizeof(*this) + sizeof(SimpleCorpsMember)*size; }
	};
*/