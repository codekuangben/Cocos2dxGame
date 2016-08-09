package game.netmsg.propertyUserCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stRetPickUpObjPropertyUserCmd extends stPropertyUserCmd 
	{
		public var thisid:uint;
		public function stRetPickUpObjPropertyUserCmd() 
		{
			super();
			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			thisid = byte.readUnsignedInt();	
		}
	}

}

/*
 * 收到此消息后，表明：玩家拾取到了该掉落物(thisid)
 * const BYTE RET_PICKUPOBJ_PROPERTY_USRECMD = 36; 
    struct stRetPickUpObjPropertyUserCmd : public stPropertyUserCmd
    {   
        stRetPickUpObjPropertyUserCmd()
        {   
            byParam = RET_PICKUPOBJ_PROPERTY_USRECMD;
            thisid = 0;
            ret = 0;
        }
        DWORD thisid;       
    };*/