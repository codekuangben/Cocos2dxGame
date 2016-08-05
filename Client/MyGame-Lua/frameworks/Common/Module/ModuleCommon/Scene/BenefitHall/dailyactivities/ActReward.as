package modulecommon.scene.benefithall.dailyactivities 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 * 活跃奖励
	 */
	public class ActReward 
	{
		public var m_level:Point;	//等级区段 x该区段最小等级  y 该区段最大等级
		public var m_todoList:Array;	//活跃任务
		public var m_dicActLevel:Dictionary;	//奖励道具
		public var m_valueVec:Vector.<uint>;	//活跃度值奖励段 10,40,70,90
		
		public function ActReward() 
		{
			m_level = new Point();
			m_todoList = new Array();
			m_dicActLevel = new Dictionary();
			m_valueVec = new Vector.<uint>();
		}
		
		public function parseXml(xml:XML):void
		{
			var xmlList:XMLList;
			var xmlitem:XML;
			xmlList = xml.child("huoyue");
			for each(xmlitem in xmlList)
			{
				m_todoList.push(parseInt(xmlitem.@id));
			}
			
			xmlList = xml.child("fen");
			var propslist:Vector.<ItemProps>;
			var propsXmlList:XMLList;
			var props:ItemProps;
			var value:uint;
			for each(xmlitem in xmlList)
			{
				propsXmlList = xmlitem.child("obj");
				propslist = new Vector.<ItemProps>();
				for each(var propsxml:XML in propsXmlList)
				{
					props = new ItemProps();
					props.parseXml(propsxml);
					propslist.push(props);
				}
				
				value = parseInt(xmlitem.@num);
				m_valueVec.push(value);
				m_dicActLevel[value] = propslist;
			}
		}
		
		public function setLevel(x:uint, y:uint):void
		{
			m_level.x = x;
			m_level.y = y;
		}
	}

}