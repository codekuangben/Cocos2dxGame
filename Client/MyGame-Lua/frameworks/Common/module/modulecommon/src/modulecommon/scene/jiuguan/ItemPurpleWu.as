package modulecommon.scene.jiuguan 
{
	/**
	 * ...
	 * @author 
	 */
	public class ItemPurpleWu 
	{
		public var m_id:uint;
		public var m_baowuVec:Vector.<Baowu>;	//所需宝物
		public var m_heroVec:Vector.<uint>;		//所需武将
		public var m_bOpen:Boolean = false;
		public function ItemPurpleWu() 
		{
			m_id = 0;
			m_baowuVec = new Vector.<Baowu>();
			m_heroVec = new Vector.<uint>();
		}
		
		public function parseXml(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			var baowuList:XMLList = xml.child("baowu");
			var baowu:Baowu;
			for each(var item:XML in baowuList)
			{
				baowu = new Baowu();
				baowu.parseXml(item);
				m_baowuVec.push(baowu);
			}
			
			var heroList:XMLList = xml.child("hero");
			var id:uint;
			for each(var wu:XML in heroList)
			{
				id = parseInt(wu.@id);
				m_heroVec.push(id);
			}
		}
		
	}

}