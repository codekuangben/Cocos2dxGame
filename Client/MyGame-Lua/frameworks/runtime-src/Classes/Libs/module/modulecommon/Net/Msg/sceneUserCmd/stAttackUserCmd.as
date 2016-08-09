package modulecommon.net.msg.sceneUserCmd
{
	import flash.utils.ByteArray;
	//import game.netmsg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.fight.stScenePkCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stAttackUserCmd extends stScenePkCmd
	{
		public var byAttTempID:uint;
		public var byDefTempID:uint;
		public var attackType:uint;
		
		public function stAttackUserCmd() 
		{
			super();
			byParam = SceneUserParam.PARA_ATTACK_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(byAttTempID);
			byte.writeUnsignedInt(byDefTempID);
			byte.writeByte(attackType);
		}
	}
}

//开始攻击
//const BYTE PARA_ATTACK_USERCMD = 2;
//struct stAttackUserCmd : public stScenePkCmd
//{
	//stAttackUserCmd()
	//{
		//byParam = PARA_ATTACK_USERCMD;
	//}
	//DWORD byAttTempID;	//攻击者临时ID
	//DWORD byDefTempID;	//被攻击者临时ID
	//BYTE  attackType;	//攻击类型（攻击人或是NPC）
//
//};