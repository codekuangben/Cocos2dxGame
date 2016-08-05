package modulecommon.scene.prop
{
	import com.pblabs.engine.entity.EntityCValue;
	
	import flash.utils.Dictionary;
	
	import modulecommon.scene.prop.being.CharBase;
	import modulecommon.scene.prop.being.CharScene;
	import modulecommon.scene.prop.relation.ChatSystem;
	import modulecommon.scene.prop.relation.Relation;
	import modulecommon.scene.wu.WuProperty;
	
	/**
	 * ...
	 * @author 
	 * @brief 所有 hero 属性  
	 */
	public class BeingProp
	{
		public static const SILVER_COIN:int = 1;	//银币(游戏币)
		public static const GOLD_COIN:int = 2;		//金币(绑定rmb)
		public static const YUAN_BAO:int = 3;		//元宝(充值rmb)
		public static const JIANG_HUN:int = 4;		//将魂
		public static const BING_HUN:int = 5;		//兵魂
		public static const GREEN_SHENHUN:int = 6;	//绿色神魂
		public static const BLUE_SHENHUN:int = 7;	//蓝色神魂
		public static const PURPLE_SHENHUN:int = 8;	//紫色神魂
		public static const LING_PAI:int = 9;		//令牌
		public static const MONEY_WUNV:int = 10;		//好感度
		
		public static const RONGYU_PAI:int = 50;		//荣誉勋章。这是客户端自己定义的。目前没有这方面的数值
		public static const Jing_Yan:int = 51;			//经验
		public static const XINGYUN_BI:int = 52;		//幸运币
		
		public static const VIP_Level_0:int = 0;	//vip等级
		public static const VIP_Level_1:int = 1;	// >=100
		public static const VIP_Level_2:int = 2;	// >=500
		public static const VIP_Level_3:int = 3;	// >=1000
		public static const VIP_Level_4:int = 4;	// >=3000
		public static const VIP_Level_5:int = 5;	// >=6000
		public static const VIP_Level_6:int = 6;	// >=10000
		public static const VIP_Level_7:int = 7;	// >=30000
		public static const VIP_Level_8:int = 8;	// >=50000
		public static const VIP_Level_9:int = 9;	// >=100000
		public static const VIP_Level_Max:int = VIP_Level_9;
		
		public var m_charBase:CharBase;		// 人物基本属性
		public var m_charScene:CharScene;	// 人物场景属性
		public var m_vipscore:uint;			//vip分值
		protected var m_dicMoney:Dictionary;
		private var m_uCheckPoint:uint;    	//主角通关的最大关卡id
		private var m_behaviorState:Vector.<uint>;		// 玩家处于的活动中

		public var m_bShowFailTip:Boolean;			// 是否显示战斗失败提示框
		public var m_jnReason:uint;				// 锦囊失败原因 0 : 锦囊没有关系 1 : 数字比较失败 2 : 被克制
		public var m_otherJNID:uint;				// 对方锦囊 id
		
		public var m_fightFail:Boolean;		// 上一场战斗是否失败,主要是战役挑战中用
		public var m_rela:Relation;			// 关系
		public var m_chatSystem:ChatSystem;	// 聊天系统
		public var m_timeOnLine:uint;		//在线时间
		
		public var m_mood:String;		// 自己的签名
		
		public function BeingProp() 
		{
			m_charBase = new CharBase();
			m_charScene = new CharScene();
			
			m_dicMoney = new Dictionary();
			m_uCheckPoint = 0 -1;
			m_behaviorState = new Vector.<uint>(EntityCValue.BSCount/32 + 1, true);
			m_rela = new Relation();
			m_chatSystem = new ChatSystem();
		}

		public function setMoney(type:int, value:uint):void
		{
			m_dicMoney[type] = value;
		}
		
		public function getMoney(type:int):uint
		{
			var ret:int = m_dicMoney[type];
			return ret;
		}
		
		public function get checkPoint():uint
		{
			return m_uCheckPoint;
		}

		public function set checkPoint(value:uint):void
		{
			m_uCheckPoint = value;
		}

		public function getShenhunByColor(color:uint):uint
		{
			var ret:uint = 0;
			switch(color)
			{
				case WuProperty.COLOR_GREEN: ret = getMoney(GREEN_SHENHUN);	break;
				case WuProperty.COLOR_BLUE: ret = getMoney(BLUE_SHENHUN);	break;
				case WuProperty.COLOR_PURPLE: ret = getMoney(PURPLE_SHENHUN);	break;
			}
			return ret;
		}
		
		public function dayRefresh():void
		{
			
		}
		
		// 设置当前状态
		public function setBehaviorState(bit:uint):void
		{
			m_behaviorState[int(bit/32)] |= (1 << (bit % 32));
		}
		
		public function clsBehaviorState(bit:uint):void
		{
			m_behaviorState[int(bit/32)] &= (~(1 << (bit % 32)));
		}
		
		// 获取当前状态
		public function isBehaviorState(bit:uint):Boolean
		{
			return ((m_behaviorState[int(bit/32)] & (1 << (bit % 32))) > 0);
		}
		
		public static function s_vipscoreToLevel(score:int):int
		{
			var ret:int;
			if (score >= 100000)
			{
				ret = VIP_Level_9;
			}
			else if (score >= 50000)
			{
				ret = VIP_Level_8;
			}
			else if (score >= 30000)
			{
				ret = VIP_Level_7;
			}
			else if (score >= 10000)
			{
				ret = VIP_Level_6;
			}
			else if (score >= 6000)
			{
				ret = VIP_Level_5;
			}
			else if (score >= 3000)
			{
				ret = VIP_Level_4;
			}
			else if (score >= 1000)
			{
				ret = VIP_Level_3;
			}
			else if (score >= 500)
			{
				ret = VIP_Level_2;
			}
			else if (score >= 100)
			{
				ret = VIP_Level_1;
			}
			else
			{
				ret = VIP_Level_0;
			}
			
			return ret;
		}
		//VIP等级
		public function get vipLevel():int
		{
			return s_vipscoreToLevel(m_vipscore);
		}
		
		public function tokenIconIDByType(type:int):int
		{
			var tokenIconID:int;
			switch(type)
			{
				case SILVER_COIN:
					{
						tokenIconID = 2006;
						break;
					}
				case YUAN_BAO:
					{
						tokenIconID = 3010;
						break;
					}
				case JIANG_HUN:
					{
						tokenIconID = 6001;
						break;
					}
				case GREEN_SHENHUN:
					{
						tokenIconID = 10401;
						break;
					}
				case BLUE_SHENHUN:
					{
						tokenIconID = 10402;
						break;
					}
				case LING_PAI:
					{
						tokenIconID = 4001;
						break;
					}					
				case GOLD_COIN:			// 新添加的
					{
						tokenIconID = 6001;
						break;
					}
				case BING_HUN:
					{
						tokenIconID = 10401;
						break;
					}
				case PURPLE_SHENHUN:
					{
						tokenIconID = 10402;
						break;
					}
				case MONEY_WUNV:
					{
						tokenIconID = 4001;
						break;
					}
				default:
					{
						tokenIconID = 0;
					}
			}
			return tokenIconID;
		}
		
		// 获取经验道具id，图标和道具一样大
		public function expObjID():uint
		{
			return 10301;
		}
	}
}