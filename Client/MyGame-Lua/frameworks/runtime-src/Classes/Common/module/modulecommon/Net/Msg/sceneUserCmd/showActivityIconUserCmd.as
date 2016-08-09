package modulecommon.net.msg.sceneUserCmd 
{
	import flash.utils.ByteArray;

	public class showActivityIconUserCmd extends stSceneUserCmd
	{
		public var show:uint;
		public var type:uint;

		public function showActivityIconUserCmd() 
		{
			super();
			byParam = SceneUserParam.SHOW_ACTIVITY_ICON_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			show = byte.readByte();
			type = byte.readByte();
		}
	}
}

//活动按钮状态
//const BYTE SHOW_ACTIVITY_ICON_USERCMD = 52;
//struct showActivityIconUserCmd : public stSceneUserCmd
//{    
    //showActivityIconUserCmd()
    //{    
        //byParam = SHOW_ACTIVITY_ICON_USERCMD;
    //}    
    //BYTE show; //1:显示 0：隐藏
    //BYTE type; //参考ico
//};