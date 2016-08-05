package modulecommon.net.msg.godlyweaponCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stWearGodlyWeaponCmd extends stSceneUserCmd
	{
		public var gwid:uint;
		
		public function stWearGodlyWeaponCmd() 
		{
			byParam = SceneUserParam.PARA_WEAR_GODLY_WEAPON_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			gwid = byte.readUnsignedInt();
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeUnsignedInt(gwid);
		}
	}

}

/*
    //佩戴神兵
    const BYTE PARA_WEAR_GODLY_WEAPON_USERCMD = 68;
    struct stWearGodlyWeaponCmd : public stSceneUserCmd
    {
        stWearGodlyWeaponCmd()
        {
            byParam = PARA_WEAR_GODLY_WEAPON_USERCMD;
            gwid = 0;
        }
        DWORD gwid;
    };
*/