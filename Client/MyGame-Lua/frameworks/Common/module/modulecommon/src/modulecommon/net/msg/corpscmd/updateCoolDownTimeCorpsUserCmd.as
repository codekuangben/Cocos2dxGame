package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class updateCoolDownTimeCorpsUserCmd extends stCorpsCmd 
	{	
		public var kejiCoolDown:uint;
		public var mainCoolDown:uint;
		
		public function updateCoolDownTimeCorpsUserCmd() 
		{
			byParam = UPDATE_COOL_DOWN_TIME_CORPS_USERCMD;		
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);			
			kejiCoolDown = byte.readUnsignedInt();
			mainCoolDown = byte.readUnsignedInt();
		}		
	}

}

//更新军团冷却
   /* const BYTE UPDATE_COOL_DOWN_TIME_CORPS_USERCMD = 61;
    struct updateCoolDownTimeCorpsUserCmd : public stCorpsCmd
    {    
        updateCoolDownTimeCorpsUserCmd()
        {    
            byParam = UPDATE_COOL_DOWN_TIME_CORPS_USERCMD;
            type = 0; 
            kejiCoolDown = mainCoolDown = 0; 
        }          
        DWORD kejiCoolDown;
        DWORD mainCoolDown;
    };   */