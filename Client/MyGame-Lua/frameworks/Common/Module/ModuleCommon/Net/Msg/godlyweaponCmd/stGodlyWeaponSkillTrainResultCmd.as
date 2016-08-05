package modulecommon.net.msg.godlyweaponCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stGodlyWeaponSkillTrainResultCmd extends stSceneUserCmd
	{
		public var lefttraintimes:uint;		//剩余培养次数
		public var ybtraintimes:uint;		//元宝培养次数
		public var addexp:uint;		//培养增加的经验
		public var gwslevel:uint;	//神兵等级(号令天下)
		public var gwsexp:uint;		//神兵当前经验
		public var baoji:uint;		//是否暴击
		
		public function stGodlyWeaponSkillTrainResultCmd() 
		{
			byParam = SceneUserParam.PARA_GODLY_WEAPON_SKILL_TRAIN_RESULT_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			lefttraintimes = byte.readUnsignedShort();
			ybtraintimes = byte.readUnsignedShort();
			addexp = byte.readUnsignedShort();
			gwslevel = byte.readUnsignedShort();
			gwsexp = byte.readUnsignedInt();
			baoji = byte.readUnsignedByte();
		}
	}

}
/*
//神兵技能培养返回
    const BYTE PARA_GODLY_WEAPON_SKILL_TRAIN_RESULT_USERCMD = 80;
    struct stGodlyWeaponSkillTrainResultCmd : public stSceneUserCmd
    {
        stGodlyWeaponSkillTrainResultCmd()
        {
            byParam = PARA_GODLY_WEAPON_SKILL_TRAIN_RESULT_USERCMD;
            lefttraintimes = ybtraintimes = 0;
            addexp = gwslevel = 0;
            gwsexp = 0;
            baoji = 0;
        }
        WORD lefttraintimes;    //剩余培养次数
        WORD ybtraintimes;  //元宝培养次数
        WORD addexp;        //培养增加的经验
        WORD gwslevel;      //神兵等级  
        DWORD gwsexp;       //神兵当前经验
        BYTE baoji;         //是否暴击
    };
*/