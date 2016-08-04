package modulecommon
{
	/**
	 * ...
	 * @author 
	 * @brief common 模块常量   
	 */	
	public class CommonEn 
	{
		//攻击类型
		//enum AttackType{
			//ATTACKTYPE_U2U = 1,	//人攻击人
			//ATTACKTYPE_U2N = 2,	//人攻击NPC
			//ATTACKTYPE_U2FU = 3,    //人攻击假玩家

		//};
		public static const ATTACKTYPE_U2U:uint = 1;
		public static const ATTACKTYPE_U2N:uint = 2;
		public static const ATTACKTYPE_U2FU:uint = 4;
		
		// 消息缓存标志位  
		public static const MCFFight:uint = 1 << 0;		// 战斗消息
	}
}