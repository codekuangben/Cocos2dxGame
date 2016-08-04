package modulecommon.scene.prop 
{
	import modulecommon.scene.wu.WuMainProperty;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class MainPro 
	{
		private var m_wu:WuMainProperty;
		public function MainPro() 
		{
			
		}
		public function set wu(wu:WuMainProperty):void
		{
			m_wu = wu;
		}
		public function get level():uint
		{
			return m_wu.m_uLevel;
		}
	}

}