package modulecommon.scene.prop 
{
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.TCommonBaseItem;
	import modulecommon.scene.prop.table.DataTable;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class CommonData 
	{
		private var m_gkContext:GkContext;
		public function CommonData(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		public function getValue(id:uint):String
		{
			var item:TCommonBaseItem = m_gkContext.m_dataTable.getItem( DataTable.TABLE_COMMON, id) as TCommonBaseItem;
			if (item != null)
			{
				return item.m_value;
			}
			return null;
		}
		
	}

}