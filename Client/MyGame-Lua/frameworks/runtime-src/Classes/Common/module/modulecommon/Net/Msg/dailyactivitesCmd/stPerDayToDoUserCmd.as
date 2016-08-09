package modulecommon.net.msg.dailyactivitesCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stPerDayToDoUserCmd extends stSceneUserCmd
	{
		public var reg:uint;
		public var count:uint;
		public var todoList:Array;
		
		public function stPerDayToDoUserCmd() 
		{
			byParam = SceneUserParam.PARA_PER_DAY_TO_DO_USERCMD;
			todoList = new Array();
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			reg = byte.readUnsignedInt();
			count = byte.readUnsignedByte();
			var size:int = byte.readUnsignedByte();
			var item:ToDoItem;
			for (var i:int = 0; i < size; i++)
			{
				item = new ToDoItem();
				item.deserialize(byte);
				
				todoList.push(item);
			}
		}
	}

}
/*
	const BYTE PARA_PER_DAY_TO_DO_USERCMD = 47;
	struct stPerDayToDoUserCmd : public stSceneUserCmd
	{
		stPerDayToDoUserCmd()
		{
			byParam = PARA_PER_DAY_TO_DO_USERCMD;
			reg = 0;
			size = 0;
		}
		DWORD reg; //本月签到情况， 按位
		BYTE count; //累计签到次数
		BYTE size;
		ToDoItem item[0];
		WORD getSize() const { return sizeof(*this) + sizeof(ToDoItem)*size; }
	};
*/