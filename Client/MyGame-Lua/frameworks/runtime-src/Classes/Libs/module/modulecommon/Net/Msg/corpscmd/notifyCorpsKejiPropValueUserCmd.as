package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	import modulecommon.scene.prop.relation.KejiLearnedItem;
	/**
	 * ...
	 * @author 
	 */
	public class notifyCorpsKejiPropValueUserCmd extends stCorpsCmd 
	{
		public var m_list:Array;
		public function notifyCorpsKejiPropValueUserCmd() 
		{
			byParam = NOTIFY_CORPS_KEJI_PROP_VALUE_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			var size:uint = byte.readUnsignedByte();
			m_list = KejiLearnedItem.readWidthNum_Array(byte, size);
		}
	}

}

//主角个人学习的军团科技属性值信息 s->c
	/*const BYTE NOTIFY_CORPS_KEJI_PROP_VALUE_USERCMD = 25;
	struct notifyCorpsKejiPropValueUserCmd : public stCorpsCmd
	{
		notifyCorpsKejiPropValueUserCmd()
		{
			byParam = NOTIFY_CORPS_KEJI_PROP_VALUE_USERCMD;
		}
		BYTE size; 
		TypeValue kt[0]; //类型:值
		WORD getSize()const { return sizeof(*this) + size*sizeof(KeyValue); }

	};*/