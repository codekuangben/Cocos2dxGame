package modulecommon.net.msg.sceneUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	public class stUserDataUserCmd extends stSceneUserCmd 
	{
		public var num:uint;
		public var datas:Dictionary;
		public function stUserDataUserCmd() 
		{
			byParam = SceneUserParam.USER_DATA_USERCMD_PARA;
			datas = new Dictionary;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			datas = t_ItemData.read(byte);
		}
		
	}

}
/*
 * const BYTE USER_DATA_USERCMD_PARA = 17; 
    struct stUserDataUserCmd : public stSceneUserCmd
    {   
        stUserDataUserCmd()
        {   
            byParam = USER_DATA_USERCMD_PARA;
            num = 0;
        }   
        WORD num;
        t_ItemData data[0];
        WORD getSize()
        {   
            return sizeof(*this) + num*sizeof(t_ItemData);
        }   
    };  
*/