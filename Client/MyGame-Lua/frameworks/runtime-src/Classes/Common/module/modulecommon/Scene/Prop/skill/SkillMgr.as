package modulecommon.scene.prop.skill
{
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class SkillMgr 
	{
		public static const JNTYPE_FIRE:int = 1;	//火
		public static const JNTYPE_WOOD:int = 2;	//木
		public static const JNTYPE_EARTH:int = 3;	//土
		public static const JNTYPE_WATER:int = 4;	//水
		
		public static const ICONSIZE_SMALL:uint = 24;
		public static const ICONSIZE_Normal:uint = 40;
		
		private var m_gkContext:GkContext;
		
		public function SkillMgr(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		
		public function iconName(skillID:uint):String
		{
			var item:TSkillBaseItem = m_gkContext.m_dataTable.getItem( DataTable.TABLE_SKILL, skillID) as TSkillBaseItem;
			if (item != null)
			{
				return item.m_iconName;
			}
			return null;
		}
		
		public function iconResName(skillID:uint):String
		{
			var name:String = iconName(skillID);
			if (name != null)
			{
				return "skillicon/" + name + ".png";
			}
			return null;
		}
		
		public function skillDesc(skillID:uint):String
		{
			var item:TSkillBaseItem = m_gkContext.m_dataTable.getItem( DataTable.TABLE_SKILL, skillID) as TSkillBaseItem;
			if (item != null)
			{
				return item.m_desc;
			}
			return null;
		}
		
		public function skillItem(skillID:uint):TSkillBaseItem
		{
			var item:TSkillBaseItem = m_gkContext.m_dataTable.getItem( DataTable.TABLE_SKILL, skillID) as TSkillBaseItem;
			if (item != null)
			{
				return item;
			}
			return null;
		}
		
		public function getName(skillID:uint):String
		{
			var item:TSkillBaseItem = skillItem(skillID);
			if (item != null)
			{
				return item.m_name;
			}
			return null;
		}
		
		public function getType(skillID:uint):uint
		{
			var item:TSkillBaseItem = skillItem(skillID);
			if (item != null)
			{
				return item.m_type;
			}
			return 0;
		}
		
		//input:type锦囊属性类型
		//output:type所能克制的类型
		public static function jnAttrInhibit(type:int):int
		{
			var ret:int = type + 1;
			if (ret > 4)
			{
				ret = 1;
			}
			return ret;
		}
		//input:type锦囊属性类型
		//output:克制type的类型
		public static function jnAttrInhibitedBy(type:int):int
		{
			var ret:int = type -1;
			if (ret == 0)
			{
				ret = 4;
			}
			return ret;
		}
		
		//input:锦囊ID
		//output:锦囊属性的类型
		public static function jnAttrType(jnID:uint):int
		{
			jnID /= 100;
			var ret:int;
			switch(jnID)
			{
				case 30:ret = JNTYPE_FIRE; break;
				case 33:ret = JNTYPE_WOOD; break;
				case 36:ret = JNTYPE_EARTH; break;
				case 39:ret = JNTYPE_WATER; break;
			}
			return ret;
		}
		
		//input:锦囊属性的类型
		//output:锦囊属性名称
		public static function jnAttrName(type:int):String
		{
			var ret:String;
			switch(type)
			{
				case JNTYPE_FIRE: ret = "火"; break;
				case JNTYPE_WOOD: ret = "木"; break;
				case JNTYPE_EARTH: ret = "土"; break;
				case JNTYPE_WATER: ret = "水"; break;
			}
			return ret;
		}
		
		//input:锦囊ID
		//output:锦囊属性名称
		public static function jnAttrNameByID(jnID:uint):String
		{
			return jnAttrName(jnAttrType(jnID));
		}
		
		//input:锦囊ID
		//output:锦囊等级
		public static function jnLevel(jnID:uint):int
		{
			return jnID % 100;
		}
		
		// 返回两个锦囊是不是克制关系
		public static function relBetJN(aid:uint, bid:uint):Boolean
		{
			// 如果 aid 可以克制 bid
			if(jnAttrInhibitedBy(jnAttrType(aid)) == jnAttrType(bid))
			{
				return true;
			}
			
			// 如果 bid 可以克制 aid
			if(jnAttrInhibitedBy(jnAttrType(bid)) == jnAttrType(aid))
			{
				return true;
			}
			
			return false;
		}
	}
}