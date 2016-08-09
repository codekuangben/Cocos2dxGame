package game.netmsg.scenePkCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.fight.stScenePkCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stPrePKUserCmd extends stScenePkCmd 
	{
		public var fastover:uint;

		public function stPrePKUserCmd() 
		{
			byParam = PARA_PRE_PK_USERCMD;		
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			fastover = byte.readUnsignedShort();
		}
	}
}

/*
客户端收到这个消息，表示马上进入战斗
const BYTE PARA_PRE_PK_USERCMD = 6;
struct stPrePKUserCmd : public stScenePkCmd
{   
	stPrePKUserCmd()
	{   
		byParam = PARA_PRE_PK_USERCMD;
		fastover = 0;
	}
	WORD fastover;		// 如果为 0 ，就是正常规则，如果不是 0 ，就是这个回合开始就显示
};
*/