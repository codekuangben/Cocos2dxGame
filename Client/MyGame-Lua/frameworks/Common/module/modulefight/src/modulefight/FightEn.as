package modulefight
{
	/**
	 * ...
	 * @author 
	 * @brief 战斗模块所有的常量    
	 */
	public class FightEn 
	{		
		// 网络消息常量 
		public static const ENPath:uint = 0;	// 当前场景路径    
		//public static const ENRoot:uint = 1;	//  ModuleFightRoot 对象    
		public static const ENResult:uint = 2;	// 战斗结果消息   
		
		
		// 部队伤害常量    
		public static const RESULT_NONE:uint = 0;	// 默认值，没有结果  
		public static const RESULT_ALL_LIVE:uint = 1;	// 攻击方与防御方都活着     
		public static const RESULT_ATT_DIE:uint = 2;	// 攻击方挂了    
		public static const RESULT_DEF_DIE:uint = 3;	// 防御方挂了   
		public static const RESULT_ALL_DIE:uint = 4;	// 攻击方与防御方都挂了      
		
		public static const DAM:uint = 1;	//攻击者对被攻击者的伤害
		//public static const ADD_HP:uint = 2;	//攻击者对被攻击者的回血
		public static const DAM_TYPE_BAOJI:uint = 2;	//攻击者对被攻击者的暴击掉血
		public static const DAM_TYPE_GEDANG:uint = 3;	//攻击者对被攻击者的格挡掉血
		
		public static const DAMTYPE_VEADDHP:uint = 4;    //攻击者对被攻击者的回血
        public static const DAMTYPE_VEREDUCEHP:uint = 5; //减血
        public static const DAMTYPE_VEADDSHIQI:uint = 6; //士气增加
        public static const DAMTYPE_VEREDUCESHIQI:uint = 7;  //士气减少		
		
		public static const DAM_TYPE_FANJI:uint = 20;	//反击掉血
		public static const DAM_TYPE_Buffer_Methysis:uint = 21;	//中buffer(中毒)掉血
		
		
		
		public static const DAM_None:uint = 0;	//不是任何伤害
		public static const DAM_Physical:uint = 1;	//物理伤害
		public static const DAM_Strategy:uint = 2;	//策略伤害
		
		public static const StateMax:uint = 5;
		public static const WuJiangMax:uint = 5;
		
		// 头顶飘的名字的
		public static const NTUp:uint = 0;	// 垂直上升
		public static const NTDn:uint = 1;	// 垂直下降
		
		
		public static const BUFFERID_Methysis:uint = 35;	//中毒
		public static const USTATE_SHIQIPROPMOT:uint = 32;	//士气上升
		public static const USTATE_SHIQIREDUCE:uint = 33;	//士气下降
		
		public static const Modulefight_stPKOverUserCmd:String = "Modulefight_stPKOverUserCmd";
	}
}

//enum FightResult
//{
    //RESULT_NONE = 0,
    //RESULT_ALL_LIVE = 1,
    //RESULT_ATT_DIE  = 2,
    //RESULT_DEF_DIE  = 3,
    //RESULT_ALL_DIE  = 4,
//};  

/*enum eDamType
    {   
        DAMTYPE_NONE = 0,
        DAMTYPE_NORMAL = 1, //普通伤害
        DAMTYPE_BAOJI = 2,  //暴击
        DAMTYPE_GEDANG = 3, //格挡
        DAMTYPE_VEADDHP = 4,    //攻击者对被攻击者的回血
        DAMTYPE_VEREDUCEHP = 5, //减血
        DAMTYPE_VEADDSHIQI = 6, //士气增加
        DAMTYPE_VEREDUCESHIQI = 7,  //士气减少
        DAMTYPE_MAX,
    }; */
//};