package game.netmsg.mountcmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.mountscmd.stMountCmd;
	
	/**
	 * @brief 这个消息不处理了，直接从表中读取 
	 */
	public class stNotifyMountPropsCmd extends stMountCmd
	{
		public var num:uint;
		public var mountmapprops:Vector.<TypeValue>;
		
		public function stNotifyMountPropsCmd() 
		{
			super();
			byParam = stMountCmd.PARA_NOTIFY_MOUNT_PROPS_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			num = byte.readUnsignedShort();
			mountmapprops = new Vector.<TypeValue>();
			var item:TypeValue;
			
			var idx:uint = 0;
			while (idx < num)
			{
				item = new TypeValue();
				mountmapprops.push(item);
				item.deserialize(byte);
				
				++idx;
			}
		}
	}
}

////通知坐骑图鉴属性
//const BYTE PARA_NOTIFY_MOUNT_PROPS_CMD = 3;
//struct stNotifyMountPropsCmd : public stMountCmd
//{
	//stNotifyMountPropsCmd()
	//{
		//byParam = PARA_NOTIFY_MOUNT_PROPS_CMD;
		//num = 0;
	//}
	//WORD num;
	//TypeValue mountmapprops[0];
//};