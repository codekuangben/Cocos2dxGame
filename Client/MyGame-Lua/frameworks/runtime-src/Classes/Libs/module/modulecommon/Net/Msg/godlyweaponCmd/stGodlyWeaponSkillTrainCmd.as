package modulecommon.net.msg.godlyweaponCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stGodlyWeaponSkillTrainCmd extends stSceneUserCmd
	{
		public var traintype:int;
		
		public function stGodlyWeaponSkillTrainCmd() 
		{
			byParam = SceneUserParam.PARA_GODLY_WEAPON_SKILL_TRAIN_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeByte(traintype);
		}
	}

}
/*
//神兵技能培养
    const BYTE PARA_GODLY_WEAPON_SKILL_TRAIN_USERCMD = 80;
    struct stGodlyWeaponSkillTrainCmd : public stSceneUserCmd
    {
        stGodlyWeaponSkillTrainCmd()
        {
            byParam = PARA_GODLY_WEAPON_SKILL_TRAIN_USERCMD;
            traintype = 0;
        }
        BYTE traintype; //1-绿魂培养 2-蓝魂培养 3-元宝培养
    };
*/