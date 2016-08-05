package modulecommon.net.msg.sceneUserCmd 
{	
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	/**
	 * ...S->C。与NPC的对话内容
	 * @author zouzhiqiang
	 */
	
	public class stQuestDialogUserCmd extends stSceneUserCmd 
	{		
		public var type:uint;		
		public var menuTxt:String;
		
		public function stQuestDialogUserCmd() 
		{
			byParam = SceneUserParam.QUEST_DIALOG_USERCMD_PARAMETER;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);			
			type = byte.readUnsignedByte();
			var size:uint = byte.readUnsignedShort();
			menuTxt = byte.readMultiByte(size, EnNet.UTF8);			
		}	
	}
	
	/*
	const BYTE  QUEST_DIALOG_USERCMD_PARAMETER = 12; 
        struct stQuestDialogUserCmd:public stSceneUserCmd
    {   
        stQuestDialogUserCmd()
        {   
            byParam = QUEST_DIALOG_USERCMD_PARAMETER;
            type = 0;
            size = 0;
        }   
        BYTE type; //0:正常显示 1:头顶显示
        WORD size;
        char menuTxt[0];
        WORD getSize(){ return sizeof(*this) + size; }
    };  

	*/

}