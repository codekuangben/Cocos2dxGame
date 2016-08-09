package modulecommon.net.msg.sceneUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	public class retViewedMainUserDataUserCmd extends stSceneUserCmd 
	{
		public var m_mainData:stViewUserBaseData;
		public var datas:Dictionary;
		
		public function retViewedMainUserDataUserCmd() 
		{
			byParam = SceneUserParam.RET_VIEWED_MAIN_USER_DATA_USERCMD_PARA;
		}
		override public function deserialize (byte:ByteArray) : void
		{
			super.deserialize(byte);
			
			m_mainData = new stViewUserBaseData();
			m_mainData.deserialize(byte);
			datas = t_ItemData.readWidthNum(byte, 11);
		}
	}

}

//发送被观察者人物主信息
    /*const BYTE RET_VIEWED_MAIN_USER_DATA_USERCMD_PARA = 42;
    struct retViewedMainUserDataUserCmd : public stSceneUserCmd
    {    
        retViewedMainUserDataUserCmd()
        {    
            byParam = RET_VIEWED_MAIN_USER_DATA_USERCMD_PARA;
        }    
        stViewUserBaseData basedata;    
        TypeValue data[10];
    };
*/
