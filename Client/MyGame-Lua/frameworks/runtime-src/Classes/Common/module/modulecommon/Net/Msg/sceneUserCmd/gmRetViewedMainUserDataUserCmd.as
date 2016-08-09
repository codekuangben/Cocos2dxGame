package modulecommon.net.msg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class gmRetViewedMainUserDataUserCmd extends stSceneUserCmd 
	{
		public var m_mainData:stViewUserBaseData;
		public var datas:Dictionary;
		public var m_money:Dictionary;
		
		public function gmRetViewedMainUserDataUserCmd() 
		{
			super();
			byParam = SceneUserParam.GM_RET_VIEWED_MAIN_USER_DATA_USERCMD_PARA;
		}
		override public function deserialize (byte:ByteArray) : void
		{
			super.deserialize(byte);
			
			m_mainData = new stViewUserBaseData();
			m_mainData.deserialize(byte);
			datas = t_ItemData.readWidthNum(byte, 11);
			m_money = t_ItemData.readWidthNum(byte, 7);
		}
	}

}
/*const BYTE GM_RET_VIEWED_MAIN_USER_DATA_USERCMD_PARA = 77;
    struct gmRetViewedMainUserDataUserCmd : public stSceneUserCmd
    {    
        gmRetViewedMainUserDataUserCmd()
        {
            byParam = GM_RET_VIEWED_MAIN_USER_DATA_USERCMD_PARA;
        }
        stViewUserBaseData basedata;    
        TypeValue data[11];
		TypeValue money[7]; //参考eMoney
    }; */