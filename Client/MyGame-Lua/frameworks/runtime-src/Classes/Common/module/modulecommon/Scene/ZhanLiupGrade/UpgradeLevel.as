package modulecommon.scene.zhanliupgrade 
{
	/**
	 * ...
	 * @author ...
	 */
	public class UpgradeLevel 
	{
		public var m_levelMin:uint;
		public var m_levelMax:uint;
		public var m_value:uint;
		
		public function UpgradeLevel() 
		{
			
		}
		
		public function parseXML(xml:XML):void
		{
			m_levelMin = parseInt(xml.@min);
			m_levelMax = parseInt(xml.@max);
			m_value = parseInt(xml.@value);
		}
		
	}

}