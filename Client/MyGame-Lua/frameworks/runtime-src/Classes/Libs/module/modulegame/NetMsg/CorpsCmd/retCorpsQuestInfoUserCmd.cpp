package game.netmsg.corpscmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.corpscmd.stCorpsCmd;
	import modulecommon.scene.prop.relation.corps.CorpsQuestItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class retCorpsQuestInfoUserCmd extends stCorpsCmd 
	{
		public var m_taskInfoList:Array;
		public function retCorpsQuestInfoUserCmd() 
		{
			byParam = RET_CORPS_QUEST_INFO_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			var size:uint = byte.readUnsignedByte();
			var i:int;
			var item:CorpsQuestItem;
			m_taskInfoList = new Array();
			for (i = 0; i < size; i++)
			{
				item = new CorpsQuestItem();
				item.deserialize(byte);
				m_taskInfoList.push(item);
			}
		}
		
	}

}

//返回所有军团任务信息 s->c
	/*const BYTE RET_CORPS_QUEST_INFO_USERCMD = 41;
	struct retCorpsQuestInfoUserCmd : public stCorpsCmd
	{
		retCorpsQuestInfoUserCmd()
		{
			byParam = RET_CORPS_QUEST_INFO_USERCMD;
		}
		BYTE size;
		CorpsQuestItem item[0];
	};*/