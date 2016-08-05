package modulecommon.net.msg.godlyweaponCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stAddGodlyWeaponCmd extends stSceneUserCmd
	{
		public var m_gwId:uint;
		
		public function stAddGodlyWeaponCmd() 
		{
			byParam = SceneUserParam.PARA_ADD_GODLY_WEAPON_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_gwId = byte.readUnsignedInt();
		}
	}

}
/*
//获得神兵
    const BYTE PARA_ADD_GODLY_WEAPON_USERCMD = 67;
    struct stAddGodlyWeaponCmd : public stSceneUserCmd
    {
        stAddGodlyWeaponCmd()
        {
            byParam = PARA_ADD_GODLY_WEAPON_USERCMD;
            gwid = 0;
        }
        DWORD gwid;
    };
*/