package modulecommon.scene.xingmai 
{
	/**
	 * ...
	 * @author ...
	 * 星脉中技能:配置文件中数据
	 */
	public class ItemSkill 
	{
		public var m_id:uint;		//技能id
		public var m_name:String;	//技能名
		public var m_vecActWus:Vector.<uint>;	//技能激活武将 TableID
		public var m_desc:String;	//技能历史描述
		
		public function ItemSkill() 
		{
			m_vecActWus = new Vector.<uint>();
		}
		
		public function parseXml(xml:XML):void
		{
			var str:String;
			var ar:Array;
			
			m_id = parseInt(xml.@id);
			m_name = xml.@name;
			
			str = xml.@actheros;
			if (str)
			{
				ar = str.split("-");
				for (var i:int = 0; i < ar.length; i++)
				{
					m_vecActWus.push(parseInt(ar[i]));
				}
			}
			
			m_desc = xml.@desc;
		}
		
	}

}