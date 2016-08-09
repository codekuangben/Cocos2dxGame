package game.netmsg.propertyUserCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class stPlayGainObjAniUserCmd extends stPropertyUserCmd 
	{
		public var m_bPlay:Boolean;
		public function stPlayGainObjAniUserCmd() 
		{
			super();
			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_bPlay = !byte.readBoolean();
		}
	}

}

//获得物品是否播放动画
    /*const BYTE PARA_PLAY_GAIN_OBJ_ANI_USERCMD = 44; 
    struct stPlayGainObjAniUserCmd : public stPropertyUserCmd
    {   
        stPlayGainObjAniUserCmd()
        {   
            byParam = PARA_PLAY_GAIN_OBJ_ANI_USERCMD;
            play = 0;
        }   
        BYTE play;  //0:播放 1:不播放   
    };*/