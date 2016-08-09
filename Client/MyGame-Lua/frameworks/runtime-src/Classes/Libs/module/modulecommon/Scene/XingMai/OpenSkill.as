package modulecommon.scene.xingmai 
{
	/**
	 * ...
	 * @author ...
	 * 星脉技能开放等级
	 */
	public class OpenSkill 
	{
		public var m_attrlevel:uint;	//开放等级(属性等级)
		public var m_skillid:uint;		//技能id
		
		public function OpenSkill() 
		{
			m_attrlevel = 0;
			m_skillid = 0;
		}
		
		public function parseXml(xml:XML):void
		{
			m_attrlevel = parseInt(xml.@attrlevel);
			m_skillid = parseInt(xml.@skill);
		}
	}

}