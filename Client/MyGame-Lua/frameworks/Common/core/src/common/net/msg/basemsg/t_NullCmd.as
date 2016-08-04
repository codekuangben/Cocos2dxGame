package common.net.msg.basemsg
{
	//import common.net.endata.EnNet;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class t_NullCmd 
	{
		public var byCmd:uint;
		public var byParam:uint;
		
		//public function t_NullCmd(cmd:uint = EnNet.CMD_NULL, para:uint = EnNet.PARA_NULL) 
		public function t_NullCmd(cmd:uint = 0, para:uint = 0) 
		{
			this.byCmd = cmd;
			this.byParam = para;
		}
		
		public function serialize(byte:ByteArray):void 
		{
			byte.writeByte(byCmd);
			byte.writeByte(byParam);
		}
		
		public function deserialize(byte:ByteArray):void
		{
			byCmd = byte.readUnsignedByte();
			byParam = byte.readUnsignedByte();
		}
	}
}

/**
 * \brief 空操作指令，测试信号和对时间指令
 */
//struct t_NullCmd
//{
	//union{
		//struct {
			//BYTE  byCmd;
			//BYTE  byParam;
		//};
		//struct {
			//BYTE  cmd;
			//BYTE  para;
		//};
	//};
//
	//t_NullCmd(const BYTE cmd = CMD_NULL,const BYTE para = PARA_NULL) : cmd(cmd),para(para) {};
//};