package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	import modulecommon.net.msg.copyUserCmd.UserDispatch;

	public class retOpenAssginHeroUiCopyUserCmd extends stCopyUserCmd
	{
		public var size:uint;
		public var ud:Vector.<UserDispatch>;	// 直接保存3 个,方便操作数据,不用每一次都查找了

		public function retOpenAssginHeroUiCopyUserCmd()
		{
			super();
			byParam = stCopyUserCmd.RET_OPEN_ASSGIN_HERO_UI_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			size = byte.readUnsignedByte();
			ud = new Vector.<UserDispatch>(3, true);
			
			var idx:uint = 0;
			var item:UserDispatch;
			while(idx < size)
			{
				item = new UserDispatch();
				//ud.push(item);
				item.deserialize(byte);
				if(0 <= item.pos && item.pos < 3)
				{
					ud[item.pos] = item;
				}

				++idx;
			}
		}
	}
}

//返回请求打开队伍布阵界面 s->c
//const BYTE RET_OPEN_ASSGIN_HERO_UI_USERCMD = 50;
//struct retOpenAssginHeroUiCopyUserCmd : public stCopyUserCmd
//{
//	retOpenAssginHeroUiCopyUserCmd()
//	{
//		byParam = RET_OPEN_ASSGIN_HERO_UI_USERCMD;
//	}
//	BYTE size;
//	UserDispatch ud[0];
//	WORD getSize( void )  const { return sizeof(*this) + size* sizeof(UserDispatch); }
//};