package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.copyUserCmd.DispatchHero;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class retChangeAssginHeroUserCmd extends stCopyUserCmd
	{
		public var pos:uint;
		public var type:uint;
		public var dh:DispatchHero;
		
		public var srcpos:int;		// 这个就是拖动的时候上一次的位置，客户端使用，不是消息中的字段 -1 就是错误

		public function retChangeAssginHeroUserCmd()
		{
			super();
			byParam = stCopyUserCmd.RET_CHANGE_ASSGIN_HERO_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			pos = byte.readUnsignedByte();
			type = byte.readUnsignedByte();
			dh = new DispatchHero();
			dh.deserialize(byte);
		}
	}
}

//返回请求调整上阵武将 s->c (玩家调整了上阵武将后，队伍所有 人都会收到此消息)
//const BYTE RET_CHANGE_ASSGIN_HERO_USERCMD = 54; 
//struct retChangeAssginHeroUserCmd : public stCopyUserCmd
//{   
//	retChangeAssginHeroUserCmd()
//	{   
//		byParam = RET_CHANGE_ASSGIN_HERO_USERCMD;
//		pos = 0;
//	}   
//	BYTE pos; //调整武将的玩家所在行索引 
//	BYTE type; //0:添加  1:移动 2：取下
//	DispatchHero dh; //调整到的新位置
//};