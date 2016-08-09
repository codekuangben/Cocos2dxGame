package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stSetHeroXiaYeCmd extends stSceneHeroCmd 
	{
		public var heroid:uint;
		public var toXiaye:Boolean;
		public function stSetHeroXiaYeCmd() 
		{
			byParam = PARA_SET_HERO_XIAYE_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			heroid = byte.readUnsignedInt();
			toXiaye = byte.readBoolean();
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(heroid);
			byte.writeBoolean(toXiaye);
		}
		
	}

}

//设置下野
    /*const BYTE PARA_SET_HERO_XIAYE_USERCMD = 33; 
    struct stSetHeroXiaYeCmd : public stSceneHeroCmd
    {   
        stSetHeroXiaYeCmd()
        {   
            byParam = PARA_SET_HERO_XIAYE_USERCMD;
            heroid = 0;
        }   
        DWORD heroid;
		BYTE toXiaye;
    };  */