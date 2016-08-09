package modulecommon.scene.wu 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.prop.table.TDataItem;
	/**
	 * ...
	 * @author ...
	 * 武将 攻击范围/辅助范围 (辅助即对己方属性加成)
	 */
	public class AttackRange 
	{
		public static const ATTACK:int = 1;		//攻击
		public static const ASSIST:int = 2;		//辅助
		
		public static const ATTACKTYPE_None:int = 0;
		public static const ATTACKTYPE_Dan:int = 1;		//单体
		public static const ATTACKTYPE_Qian:int = 2;	//前军
		public static const ATTACKTYPE_Zhong:int = 3;	//中军
		public static const ATTACKTYPE_Hou:int = 4;		//后军
		public static const ATTACKTYPE_Zhixian:int = 5;	//直线
		public static const ATTACKTYPE_Shizi:int = 6;	//十字
		public static const ATTACKTYPE_Quan:int = 7;	//全军
		
		public var m_attacktype:String;
		public var m_type:int;		//类别 1:攻击 2:辅助
		public var m_range:int;		//范围
		
		public function AttackRange() 
		{
			m_type = 0;
			m_range = 0;
		}
		
		public function parseByteArray(bytes:ByteArray):void
		{
			m_attacktype = TDataItem.readString(bytes);
			
			var strlist:Array;
			if(m_attacktype != "")
			{
				strlist = m_attacktype.split("-");
				
				m_type = parseInt(strlist[0]);
				m_range = parseInt(strlist[1]);
			}
		}
		
		public static function getTypeStr(type:int):String
		{
			var ret:String;
			
			if (ASSIST == type)
			{
				ret = "辅助";
			}
			else
			{
				ret = "攻击";
			}
			
			return ret;
		}
		
		public static function getRangeStr(range:int):String
		{
			var ret:String;
			
			switch(range)
			{
				case ATTACKTYPE_Dan: ret = "单体"; break;
				case ATTACKTYPE_Qian: ret = "前军"; break;
				case ATTACKTYPE_Zhong: ret = "中军"; break;
				case ATTACKTYPE_Hou: ret = "后军"; break;
				case ATTACKTYPE_Zhixian: ret = "直线"; break;
				case ATTACKTYPE_Shizi: ret = "十字"; break;
				case ATTACKTYPE_Quan: ret = "全军"; break;
				default: ret = "";
			}
			
			return ret;
		}
	}

}