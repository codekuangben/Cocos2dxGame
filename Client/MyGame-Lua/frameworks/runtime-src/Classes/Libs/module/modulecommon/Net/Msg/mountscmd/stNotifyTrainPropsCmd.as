package modulecommon.net.msg.mountscmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.mountscmd.TypeValue;
	import modulecommon.net.msg.mountscmd.stMountCmd;

	/**
	 * @brief 
	 */
	public class stNotifyTrainPropsCmd extends stMountCmd
	{
		public var num:uint = 0;
		public var trainprops:Vector.<TypeValue>;
		
		public function stNotifyTrainPropsCmd() 
		{
			super();
			byParam = stMountCmd.PARA_NOTIFY_TRAINPROPS_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			num = byte.readUnsignedShort();
			trainprops = new Vector.<TypeValue>();
			
			var item:TypeValue;
			var idx:uint = 0;
			while (idx < num)
			{
				item = new TypeValue();
				item.deserialize(byte);
				trainprops.push(item);
				
				++idx;
			}
		}
		
		public function findTrainProp(type:uint):TypeValue
		{
			for each(var item:TypeValue in trainprops)
			{
				if(item.type == type)
				{
					return item;
				}
			}
			
			return null;
		}
		
		public function findTrainPropValue(type:uint):uint
		{
			var item:TypeValue = findTrainProp(type);
			if(item)
			{
				return item.value;
			}
			
			return 0;
		}
	}
}

//通知培养属性
//const BYTE PARA_NOTIFY_TRAINPROPS_CMD = 2;
//struct stNotifyTrainPropsCmd : public stMountCmd
//{
	//stNotifyTrainPropsCmd()
	//{
		//byParam = PARA_NOTIFY_TRAINPROPS_CMD;
		//num = 0;
	//}
	//WORD num;
	//TypeValue trainprops[0];
//};