package modulecommon.scene.zhanliupgrade 
{
	/**
	 * ...
	 * @author ...
	 */
	public class UpgradeItem 
	{
		private var m_levelList:Vector.<UpgradeLevel>;
		
		public function UpgradeItem() 
		{
			m_levelList = new Vector.<UpgradeLevel>();
		}
		
		public function parseXml(xml:XML):void
		{
			
			var levelList:XMLList;
			var levelXML:XML;
			var level:UpgradeLevel;
			
			levelList= xml.child("level");
			for each(levelXML in levelList)
			{
				level = new UpgradeLevel();
				level.parseXML(levelXML);
				m_levelList.push(level);
			}
			
		}
		
		public function get levelList():Vector.<UpgradeLevel>
		{
			return m_levelList;
		}
	}

}