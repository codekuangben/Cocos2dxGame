package modulecommon.scene.xingmai 
{
	/**
	 * ...
	 * @author ...
	 * 属性信息
	 */
	public class AttrData 
	{
		public var m_id:uint;		//编号
		public var m_level:uint;	//等级
		public var m_growvalue:uint;//属性每级成长值
		
		public function AttrData() 
		{
			m_id = 0;
			m_level = 0;
			m_growvalue = 0;
		}
		
		public function get curValue():uint
		{
			return (m_level * m_growvalue);
		}
	}

}