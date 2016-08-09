package ui.player
{
	import com.util.DebugBox;
	import flash.utils.Dictionary;
	import org.ffilmation.engine.helpers.fUtil;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 * c100+ 都是主角
	   11X 是猛将模型， 12X是弓，13X是军师
	   X单数是男，X双数是女
	 */
	public class PlayerResMgr
	{
		public static const JOB_MENGJIANG:int = 1; //猛将，发出物理攻击
		public static const JOB_JUNSHI:int = 2; //军师, 发出策略攻击
		public static const JOB_GONGJIANG:int = 3; //弓将，发出物理攻击
		
		public static const GENDER_male:int = 1; //男
		public static const GENDER_female:int = 2; //女
		
		// 头像
		public static const HDOrig:uint = 0; // 原始大小
		public static const HDSmall:uint = 1; // 小
		public static const HDMid:uint = 2; // 大
		public static const HDHalf:uint = 3; // 主角半身像
		public static const HDBigHalf:uint = 4; // 主角大半身像
		
		public static const HDHeroHalf1f:uint = 4; // 主角又一个半身像
		
		public var m_dicHeadPath:Dictionary; // 头像目录
		
		public var dicPlayer:Dictionary;
		
		public function PlayerResMgr():void
		{
			dicPlayer = new Dictionary();
			dicPlayer[toKey(JOB_MENGJIANG, GENDER_male)] = new PlayerResItem("c2_c111", "main_mengjiang_male", "half.mjm");
			dicPlayer[toKey(JOB_MENGJIANG, GENDER_female)] = new PlayerResItem("c2_c112", "main_mengjiang_female", "half.mjfm");
			
			dicPlayer[toKey(JOB_JUNSHI, GENDER_male)] = new PlayerResItem("c2_c131", "main_junshi_male", "half.jsm");
			dicPlayer[toKey(JOB_JUNSHI, GENDER_female)] = new PlayerResItem("c2_c132", "main_junshi_female", "half.jsfm");
			
			dicPlayer[toKey(JOB_GONGJIANG, GENDER_male)] = new PlayerResItem("c2_c121", "main_gongjiang_male", "half.gjm");
			dicPlayer[toKey(JOB_GONGJIANG, GENDER_female)] = new PlayerResItem("c2_c122", "main_gongjiang_female", "half.gjfm");
			
			m_dicHeadPath = new Dictionary();
			m_dicHeadPath[HDOrig] = "roundhead";
			m_dicHeadPath[HDSmall] = "roundsmall";
			m_dicHeadPath[HDMid] = "roundmid";
			m_dicHeadPath[HDHalf] = "herohalfing";
			m_dicHeadPath[HDBigHalf] = "halfing";
			m_dicHeadPath[HDHeroHalf1f] = "herohalf1f";
		}
		
		protected static function toKey(job:uint, gender:uint):uint
		{
			return (job << 24) + gender;
		}
		
		public function modelName(job:uint, gender:uint):String
		{
			try
			{
				var res:PlayerResItem = dicPlayer[toKey(job, gender)] as PlayerResItem;
				return res.modelName;
			}
			
			catch (e:Error)
			{
				var str:String = "PlayerResMgr::modelName("+job+","+gender +")"+e.getStackTrace();
				DebugBox.info(str);
				res= dicPlayer[toKey(1, 1)] as PlayerResItem;
				return res.modelName;
			}
			
		}
		
		// 根据职业和性别获取战斗npc表中的 ID 
		// 查找 npc 表中的 id 
		// 1 男猛将 2 女猛将 3 男军师 4 女军师 5 男弓将 6 女弓将 
		public function battleNpcID(job:uint, gender:uint):uint
		{
			if (job == JOB_MENGJIANG)
			{
				if (gender == GENDER_male)
				{
					return 1;
				}
				else
				{
					return 2;
				}
			}
			else if (job == JOB_JUNSHI)
			{
				if (gender == GENDER_male)
				{
					return 3;
				}
				else
				{
					return 4;
				}
			}
			else if (job == JOB_GONGJIANG)
			{
				if (gender == GENDER_male)
				{
					return 5;
				}
				else
				{
					return 6;
				}
			}
			
			return 0;
		}
		
		public function uiName(job:uint, gender:uint):String
		{
			var res:PlayerResItem = dicPlayer[toKey(job, gender)] as PlayerResItem;
			if (res == null)
			{
				var str:String = "uiName(" + job + "," + gender + ")";
				str = fUtil.getStackInfo(str);
				DebugBox.info(str);
				return null;
			}
			else
			{
				return res.uiName;
			}
		}
		
		//返回玩家的圆头像的名称(包含路径) small:true 带背景的小圆头像
		//public function roundHeadPathName(job:uint, gender:uint, small:Boolean = false):String
		public function roundHeadPathName(job:uint, gender:uint, path:uint = 0):String
		{
			//var str:String = "roundhead/";
			//if (small)
			//{
			//	str = "roundsmall/";
			//}
			
			//return str + uiName(job, gender) + ".png";
			if (HDHalf == path) // 这个是压缩资源
			{
				return "asset/uiimage/" + m_dicHeadPath[path] + "/" + uiName(job, gender) + ".swf";
			}
			else
			{
				return m_dicHeadPath[path] + "/" + uiName(job, gender) + ".png";
			}
		}
		
		// 获取大的半身像的类名字
		public function halfImgClsName(job:uint, gender:uint):String
		{
			var res:PlayerResItem = dicPlayer[toKey(job, gender)] as PlayerResItem;
			if (res == null)
			{
				return null;
			}
			else
			{
				return res.classname;
			}
		}
		
		public static function toJobName(job:int):String
		{
			var ret:String;
			switch (job)
			{
				case JOB_MENGJIANG: 
					ret = "猛将";
					break;
				case JOB_JUNSHI: 
					ret = "军师";
					break;
				case JOB_GONGJIANG: 
					ret = "弓将";
					break;
			}
			return ret;
		}
		
		/*根据等级和颜色返回经验
		 * level - 玩家等级
		 * color - 见TaskManager::COLOR_WHITE定义
		 */
		public static function s_computeExp(level:uint, color:uint):uint
		{
			return Math.floor(((level * level + level * 10) / 10)) * color * 30 + 1;
		}
		
		//输入:job职业
		//输出:对于技能
		public static function toZhanshuID(job:uint, gender:uint):uint
		{
			var ret:uint = 0;
			switch (job)
			{
				case JOB_MENGJIANG: 
				{
					if (gender == GENDER_male)
					{
						ret = 2401;
						break;
					}
					else
					{
						ret = 2404;
						break;
					}
				}
				case JOB_JUNSHI: 
				{
					if (gender == GENDER_male)
					{
						ret = 2403;
						break;
					}
					else
					{
						ret = 2406;
						break;
					}
					
				}
				case JOB_GONGJIANG: 
				{
					if (gender == GENDER_male)
					{
						ret = 2402;
						break;
					}
					else
					{
						ret = 2405;
						break;
					}
				}
			}
			return ret;
		}
	}

}