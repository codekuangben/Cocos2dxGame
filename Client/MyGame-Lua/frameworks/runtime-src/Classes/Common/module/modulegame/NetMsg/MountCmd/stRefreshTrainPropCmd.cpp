package game.netmsg.mountcmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.mountscmd.stMountCmd;
	import modulecommon.net.msg.mountscmd.stTrainProp;

	/**
	 * ...
	 * @author ...
	 */
	public class stRefreshTrainPropCmd extends stMountCmd
	{
		public var prop:stTrainProp;
		
		public function stRefreshTrainPropCmd() 
		{
			super();
			byParam = stMountCmd.PARA_REFRESH_TRAIN_PROP_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			prop = new stTrainProp();
			prop.deserialize(byte);
		}
	}
}

//刷新培养属性
//const BYTE PARA_REFRESH_TRAIN_PROP_CMD = 8;
//struct stRefreshTrainPropCmd : public stMountCmd
//{
	//stRefreshTrainPropCmd()
	//{
		//byParam = PARA_REFRESH_TRAIN_PROP_CMD;
		//bzero(&prop,sizeof(prop));
	//}
	//stTrainProp prop;
//};