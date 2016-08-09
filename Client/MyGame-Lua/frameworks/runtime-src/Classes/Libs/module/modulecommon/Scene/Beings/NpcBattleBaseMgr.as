package modulecommon.scene.beings 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.wu.WuProperty;
	import com.util.UtilColor;
	
	public class NpcBattleBaseMgr 
	{
		private var m_gkContext:GkContext;
		public function NpcBattleBaseMgr(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		public function getTNpcBattleItem(npcID:uint):TNpcBattleItem
		{
			return m_gkContext.m_dataTable.getItem( DataTable.TABLE_NPCBATTLE, npcID) as TNpcBattleItem;
		}
		public function modelName(npcID:uint):String
		{
			var item:TNpcBattleItem = getTNpcBattleItem(npcID);
			if (item != null)
			{
				return item.npcBattleModel.m_strModel
			}
			return null;
		}
		public function halfingName(npcID:uint):String
		{
			var item:TNpcBattleItem = getTNpcBattleItem(npcID);
			if (item != null)
			{
				return item.m_halfing;
			}
			return null;
		}
		
		//合成半身像路径
		public static function  composehalfingPathName(name:String):String
		{
			return "halfing/" + name + ".png";
		}
		
		//半身像路径
		public function halfingPathName(npcID:uint):String
		{
			var name:String = halfingName(npcID);
			if (name != null)
			{
				return composehalfingPathName(name);				
			}
			return null;
		}
		
		public function squareHeadName(npcID:uint):String
		{
			var item:TNpcBattleItem = getTNpcBattleItem(npcID);
			if (item != null)
			{
				return item.m_squareHeadName;
			}
			return null;
		}
		public function squareHeadResName(npcID:uint):String
		{
			var name:String = squareHeadName(npcID);		
			return composeSquareHeadResName(name);
		}
		
		public static function  composeSquareHeadResName(name:String):String
		{
			return "head/" + name + ".png";
		}
		
		public static function composeRoundHeadResName(name:String):String
		{
			return "headroundsmall/" + name + "_s.png";
		}
		
		public static function  colorValue(color:uint):uint
		{
			var ret:uint;
			switch(color)
			{
				case WuProperty.COLOR_WHITE:	ret = UtilColor.WHITE;	break;
				case WuProperty.COLOR_GREEN:	ret = UtilColor.GREEN;	break;
				case WuProperty.COLOR_BLUE:	ret = UtilColor.BLUE;	break;
				case WuProperty.COLOR_PURPLE:	ret = UtilColor.PURPLE;	break;
				case WuProperty.COLOR_GOLD:	ret = UtilColor.GOLD;	break;
			}
			return ret;
		}		
		
	}
}