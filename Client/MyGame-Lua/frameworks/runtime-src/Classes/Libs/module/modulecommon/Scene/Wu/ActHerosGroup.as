package modulecommon.scene.wu 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 * "我的三国关系"
	 */
	public class ActHerosGroup 
	{
		public var m_groupID:uint;			//组合关系ID
		public var m_desc:String;			//说明
		public var m_vecHeros:Vector.<uint>;//激活关系武将列表
		public var m_dicAttrs:Dictionary;	//t_ItemData
		
		public function ActHerosGroup() 
		{
			m_desc = "";
			
			m_dicAttrs = new Dictionary();
		}
		
		public function parseXml(xml:XML):void
		{
			m_groupID = parseInt(xml.@id);
			m_desc = xml.@desc;
			
			parseXmlVecHeros(xml.@actheros);
			
			var xmlList:XMLList = xml.child("item");
			var item:XML;
			var itemactattr:ItemActAttr;
			for each (item in xmlList)
			{
				itemactattr = new ItemActAttr();
				itemactattr.parseXml(item);
				
				m_dicAttrs[itemactattr.m_id] = itemactattr;
			}
		}
		
		//激活武将列表
		private function parseXmlVecHeros(str:String):void
		{
			if (null == str || "" == str)
			{
				return;
			}
			
			m_vecHeros = new Vector.<uint>();
			
			var ar:Array = str.split(":");
			for (var i:int = 0; i < ar.length; i++)
			{
				m_vecHeros.push(parseInt(ar[i]));
			}
		}
	}

}