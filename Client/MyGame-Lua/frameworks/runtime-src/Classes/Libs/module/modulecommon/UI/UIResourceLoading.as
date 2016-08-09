package modulecommon.ui
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public final class UIResourceLoading 
	{
		private var m_ResName:String;	//SWF文件名称(对应于相应界面，包含路径）
		private var m_ID:uint;
		/*public function UIResourceLoading() 
		{		
			
		}*/
		public function get resName():String
		{
			return m_ResName;
		}
		public function set resName(name:String):void
		{
			m_ResName = name;
		}
			
		public function get id():uint
		{
			return m_ID;
		}
		public function set id(id:uint):void
		{
			m_ID = id;
		}
	}
}