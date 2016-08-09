package modulecommon.scene.zhanxing 
{	
	import modulecommon.GkContext;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TZhanxingItem;
	import modulecommon.scene.prop.table.TZhanxingNumberItem;
	/**
	 * ...
	 * @author ...
	 */
	public class ZStar 
	{
		public static const TopLevel:int = 10;	//最高等级
		public static const JingYanWuxue:int = 100;	//经验武学属性值
		public var m_base:TZhanxingItem;
		public var m_numberBase:TZhanxingNumberItem;
		public var m_expBase:TZhanxingNumberItem;
		public var m_tStar:T_Star;
		public static var m_gkContext:GkContext;
		public function ZStar()    
		{
			
		}
		
		public function setStar(star:T_Star):void
		{
			m_tStar = star;
			m_base = m_gkContext.m_dataTable.getItem(DataTable.TABLE_ZHANXING, star.m_id) as TZhanxingItem;
			m_numberBase = m_gkContext.m_dataTable.getItem(DataTable.TABLE_ZHANXING_Number, m_base.m_attr * 10 + m_base.m_color) as TZhanxingNumberItem;
			m_expBase = m_gkContext.m_dataTable.getItem(DataTable.TABLE_ZHANXING_Number, m_base.m_color) as TZhanxingNumberItem;
		}
		
		public function computeLevelFor(totalExp:uint):int
		{
			var i:int;
			for (i = 9; i >= 0; i--)
			{
				if (totalExp >= m_expBase.m_valueList[i])				
				{
					return i + 1;
				}
			}
			return 0;
		}
		
		public function get path():String
		{
			return "zhanxing/" + m_base.m_icon +".swf";
			//return "zhanxing/" + 111 +".swf";
		}
		public function get colorValue():uint
		{
			return NpcBattleBaseMgr.colorValue(m_base.m_color);
		}
		
		public function get expOfTotalAndBase():uint
		{
			return m_tStar.m_totalExp + m_expBase.m_baseValue;
		}
		public function get needExpForNext():uint
		{
			if (m_tStar.m_level >= TopLevel)
			{
				return 0;
			}
			
			return m_expBase.m_valueList[m_tStar.m_level];
		}
		
		public function get isTopLevel():Boolean
		{
			return m_tStar.m_level >= TopLevel;
		}
		
		public function get isTopColor():Boolean
		{
			return m_base.m_color >= ZObjectDef.COLOR_GOLD;
		}
				
		public function get attrName():String
		{
			return m_gkContext.m_zhanxingMgr.getAttrName(m_base.m_attr);
		}
		
		public function get attrValue():int
		{
			return m_numberBase.m_valueList[m_tStar.m_level - 1];
		}
		//上一等级的属性值
		public function get attrValueOfPurple():int
		{
			var numberBase:TZhanxingNumberItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_ZHANXING_Number, m_base.m_attr * 10 + ZObjectDef.COLOR_PURPLE) as TZhanxingNumberItem;
			return numberBase.m_valueList[m_tStar.m_level - 1];
		}
		
		public function get color():int
		{
			return m_base.m_color;
		}
		
		public function isNeedPromptWhenDelete():Boolean
		{
			return m_base.m_color >= ZObjectDef.COLOR_GOLD || m_tStar.m_level >= 4;
		}
		public function isjingyan():Boolean
		{
			if (Math.floor(m_tStar.m_id / 10) == JingYanWuxue)
			{
				return true;
			}
			return false;
		}
		public static function createClientStar(id:uint):ZStar
		{
			var zStar:ZStar = new ZStar();
			var tStar:T_Star = new T_Star();
			tStar.m_id = id;
			tStar.m_level = 1;
			zStar.setStar(tStar);
			return zStar;
		}
	}

}