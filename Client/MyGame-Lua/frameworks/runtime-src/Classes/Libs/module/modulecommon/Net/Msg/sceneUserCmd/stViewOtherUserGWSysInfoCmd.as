package modulecommon.net.msg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 * 神兵信息-观察他人
	 */
	public class stViewOtherUserGWSysInfoCmd extends stSceneUserCmd
	{
		public var weargwid:uint;
		public var gwslevel:uint;
		
		public function stViewOtherUserGWSysInfoCmd() 
		{
			byParam = SceneUserParam.RET_VERIFY_USE_NAME_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			weargwid = byte.readUnsignedInt();
			gwslevel = byte.readUnsignedShort();
		}
	}

}
/*
const BYTE PARA_VIEW_OTHER_USER_GWSYS_INFO_USERCMD = 82;
    struct stViewOtherUserGWSysInfoCmd : public stSceneUserCmd
    {    
        stViewOtherUserGWSysInfoCmd()
        {    
            byParam = PARA_VIEW_OTHER_USER_GWSYS_INFO_USERCMD;
            weargwid = 0; 
            gwslevel = 0; 
        }    
        DWORD weargwid; //当前佩戴的神兵
        WORD gwslevel;  //号令天下等级
    }; 
*/