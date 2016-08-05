package modulecommon.net.msg.fight 
{
	import flash.utils.ByteArray;	
	/**
	 * ...
	 * @author 
	 */
	public class stAttackVictoryInfoUserCmd extends stScenePkCmd
	{
		public static const PKTYPE_MainPlayerOnLeft:int = 0;
		public static const PKTYPE_MainPlayerOnLeftOrRight:int = 1;
		
		public var pkType:int;
		public var victoryTeam:uint;
		public var exp:uint;
		public var money:uint;

		public function stAttackVictoryInfoUserCmd() 
		{
			super();
			byParam = PARA_ATTACK_VICTORY_INFO_USERCMD;
			victoryTeam = 0;
			exp = 0;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);	
			pkType = byte.readUnsignedByte();
			victoryTeam = byte.readUnsignedByte();
			exp = byte.readUnsignedInt();
			//money = byte.readUnsignedInt();
		}
	}
}

//struct stAttackVictoryInfoUserCmd : public stScenePkCmd
//{
	//stAttackVictoryInfoUserCmd()
	//{
		//byParam = PARA_ATTACK_VICTORY_INFO_USERCMD;
		//victory = 0;
		//exp = gold = pinghun = 0;
		//exp =  0;
	//}
	//BYTE pktype;    //0:战斗结果(左方) 1:战斗结果(左右方都有可能,以charid判断)
	//BYTE victory;  //0:team0胜利 team1输 1:team1胜利 team0输
	//DWORD exp;    //经验
	////DWORD gold;    //钱
	////DWORD pinghun;   //兵魂
//};