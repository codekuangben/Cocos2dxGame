package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	import modulecommon.net.msg.copyUserCmd.DispatchHero;

	public class reqChangeAssginHeroUserCmd extends stCopyUserCmd
	{
		public var type:uint;
		public var dh:DispatchHero;

		public function reqChangeAssginHeroUserCmd()
		{
			super();
			byParam = stCopyUserCmd.REQ_CHANGE_ASSGIN_HERO_USERCMD;
			dh = new DispatchHero();
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeByte(type);
			dh.serialize(byte);
		}
	}
}

//请求调整上阵武将 c->s
//const BYTE REQ_CHANGE_ASSGIN_HERO_USERCMD = 53; 
//struct reqChangeAssginHeroUserCmd : public stCopyUserCmd
//{   
//	reqChangeAssginHeroUserCmd()
//	{   
//		byParam = REQ_CHANGE_ASSGIN_HERO_USERCMD;
//	}   
//	BYTE type; //0:添加  1:移动 2：取下
//	DispatchHero dh; //要调整到的位置
//};