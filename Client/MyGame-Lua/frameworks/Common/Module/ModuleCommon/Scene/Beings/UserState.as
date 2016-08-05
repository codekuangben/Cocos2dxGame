package modulecommon.scene.beings 
{
	import com.util.UtilCommon;
	/**
	 * ...
	 * @author 
	 */
	public class UserState
	{
		public static const USERSTATE_DAZUO:uint = 0;//打坐状态
		public static const USERSTATE_FUYOUEXP:uint = 1;//能否出售浮游经验
		public static const USERSTATE_FIGHTING:uint = 2;//战斗状态
		public static const USERSTATE_ORE_GREEN:uint = 3;//抱绿矿石状态
		public static const USERSTATE_ORE_BLUE:uint = 4;//抱蓝矿石状态
		public static const USERSTATE_ORE_PURPLE:uint = 5;//抱紫矿石状态
		public static const USERSTATE_DIE:uint = 6;//死亡状态
		public static const USERSTATE_GM:uint = 7;   //gm
		//public static const USERSTATE_RIDEMOUNT:uint = 8;    //骑马
		public static const USERSTATE_4NORMALPHEFFECT:uint = 8;  //4个紫将特效
		public static const USERSTATE_4GUIPHEFFECT:uint = 9;     //4个鬼紫将特效
		public static const USERSTATE_4XIANPHEFFECT:uint = 10;   //4个仙紫将特效
		public static const USERSTATE_4SHENPHEFFECT:uint = 11;   //4个神紫将特效
		public static const USERSTATE_CORPSTREASURE:uint = 12;   //军团夺宝中抱箱子状态
		public static const USERSTATE_MAX:uint = 13;	 //状态数量
		
		public static function createStates():Vector.<uint>
		{
			return new Vector.<uint>((USERSTATE_MAX + UtilCommon.UNITSIZE - 1) / UtilCommon.UNITSIZE);
			
		}
		
		public static function s_shouldUpdateHeadTopOnStateChange(id:uint):Boolean
		{
			switch(id)
			{
				case USERSTATE_FIGHTING:
				case USERSTATE_ORE_GREEN:
				case USERSTATE_ORE_BLUE:
				case USERSTATE_ORE_PURPLE:
					{
						return true;
					}
			}
			return false;
		}
	}

}

//需发九屏状态
/*enum UserState
{
    USERSTATE_DAZUO = 0,    //打坐状态
    USERSTATE_FUYOUEXP = 1, //能否出售浮游经验
    USERSTATE_FIGHTING = 2, //战斗状态
    USERSTATE_ORE_GREEN = 3,    //抱绿矿石状态
    USERSTATE_ORE_BLUE = 4, //抱蓝矿石状态
    USERSTATE_ORE_PURPLE = 5,   //抱紫矿石状态
    USERSTATE_DIE = 6,  //死亡状态
	USERSTATE_GM = 7,  //gm
	//USERSTATE_RIDEMOUNT = 8,    //骑马
	USERSTATE_4NORMALPHEFFECT = 8,  //4个紫将特效
    USERSTATE_4GUIPHEFFECT = 9,     //4个鬼紫将特效
    USERSTATE_4XIANPHEFFECT = 10,   //4个仙紫将特效
	USERSTATE_4SHENPHEFFECT = 11,   //4个神紫将特效
	USERSTATE_CORPSTREASURE = 12,   //军团夺宝中抱箱子状态
    USERSTATE_MAX,
};
*/