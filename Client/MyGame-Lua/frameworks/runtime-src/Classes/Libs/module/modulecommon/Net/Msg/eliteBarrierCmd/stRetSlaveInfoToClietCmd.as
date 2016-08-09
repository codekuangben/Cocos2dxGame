package modulecommon.net.msg.eliteBarrierCmd
{
	import common.net.endata.EnNet;
	
	import flash.utils.ByteArray;
	
	import com.util.UtilTools;

	public class stRetSlaveInfoToClietCmd extends stEliteBarrierCmd
	{
		public var slavename:String;
		public function stRetSlaveInfoToClietCmd()
		{
			byParam = PARA_RET_SLAVEINFO_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			slavename = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
		}
		
		public function getSlaveName():String
		{
			return slavename;
		}
	}
	
	/*
	//抓到奴隶后返给客户端
	const BYTE PARA_RET_SLAVEINFO_CMD = 9;
	struct stRetSlaveInfoToClietCmd : public stEliteBarrierCmd
	{   
	stRetSlaveInfoToClietCmd()
	{   
	byParam = PARA_RET_SLAVEINFO_CMD;
	bzero(slavename,sizeof(slavename));
	}   
	char slavename[MAX_NAMESIZE];
	};  
	*/
}