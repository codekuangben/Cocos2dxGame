package modulecommon.scene.prop.table 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class TableConfigItem 
	{
		public var m_tableName:String;
		public var m_tableClass:Class;
		public var m_excelName:String;
		public function TableConfigItem(tableName:String, tableClass:Class, excelName:String) 
		{
			m_tableName = tableName;
			m_tableClass = tableClass;
			m_excelName = excelName;
		}
		
	}

}