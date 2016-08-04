package game.netmsg.mountcmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.mountscmd.stMountCmd;

	/**
	 * ...
	 * @author ...
	 */
	public class stMountSysPropTrainCmd extends stMountCmd
	{
		public var propno:uint;
		public var traintype:uint;
		public var useyb:uint;

		public function stMountSysPropTrainCmd() 
		{
			super();
			byParam = stMountCmd.PARA_MOUNTSYS_PROP_TRAIN_CMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeByte(propno);
			byte.writeByte(traintype);
			byte.writeByte(useyb);
		}
	}
}

//坐骑系统属性培养
//const BYTE PARA_MOUNTSYS_PROP_TRAIN_CMD = 7;
//struct stMountSysPropTrainCmd : public stMountCmd
//{
	//stMountSysPropTrainCmd()
	//{
		//byParam = PARA_MOUNTSYS_PROP_TRAIN_CMD;
		//propno = 0;
		//traintype = 0;
		//useyb = 0;
	//}
	//BYTE propno;	//属性编号
	//BYTE traintype;	//0-普通培养 1-高级培养
	//BYTE useyb;	//使用元宝
//};