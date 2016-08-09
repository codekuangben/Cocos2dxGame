package modulecommon.net.msg.sceneUserCmd
{
	import flash.utils.ByteArray;
	import com.util.UtilTools;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class stRetVerifyUseNameUserCmd extends stSceneUserCmd
	{
		public var m_bvalid:int;
		public var m_name:String;
		public function stRetVerifyUseNameUserCmd():void
		{
			byParam = SceneUserParam.RET_VERIFY_USE_NAME_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_bvalid = byte.readUnsignedByte();			
			m_name = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
		}	
		
	}

}
/*
//s->c 确认使用xx名字
     //s->c 确认使用xx名字
    const BYTE RET_VERIFY_USE_NAME_USERCMD_PARA = 29;
    struct stRetVerifyUseNameUserCmd : public stSceneUserCmd
    {    
        stRetVerifyUseNameUserCmd()
        {    
            byParam = RET_VERIFY_USE_NAME_USERCMD_PARA;
            valid = 0; 
            bzero(name,sizeof(name));
        }    
        BYTE valid; //是否可用 0-不可用 1-可用 2:名字非法
        char name[MAX_NAMESIZE];
    };  

*/