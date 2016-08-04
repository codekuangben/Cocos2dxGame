package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stNotifyOpenZhenWeiCmd extends stSceneHeroCmd 
	{
		public var pos:uint;
		public function stNotifyOpenZhenWeiCmd() 
		{
			byParam = PARA_NOTIFY_OPEN_ZHENWEI_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			pos = byte.readUnsignedShort();
		}
		
	}

}

//通知开放阵位
   /* const BYTE PARA_NOTIFY_OPEN_ZHENWEI_USERCMD = 23;
    struct stNotifyOpenZhenWeiCmd : public
    {
        stNotifyOpenZhenWeiCmd()
        {
            byParam = PARA_NOTIFY_OPEN_ZHENWEI_USERCMD;
            pos = 0;
        }
        WORD pos;
    };*/
