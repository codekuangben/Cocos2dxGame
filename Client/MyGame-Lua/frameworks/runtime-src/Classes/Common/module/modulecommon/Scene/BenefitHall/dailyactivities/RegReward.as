package modulecommon.scene.benefithall.dailyactivities 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 * 签到奖励
	 */
	public class RegReward 
	{
		public var m_level:Point;	//等级区段 x该区段最小等级  y 该区段最大等级
		public var m_propslist:Vector.<ItemProps>;	//奖励道具
		
		public function RegReward() 
		{
			m_level = new Point();
			m_propslist = new Vector.<ItemProps>();
		}
		
		public function parseXml(xml:XML):void
		{
			m_level.x = parseInt(xml.@level1);
			m_level.y = parseInt(xml.@level2);
			
			var propsXmlList:XMLList = xml.child("obj");
			var props:ItemProps;
			for each(var propsxml:XML in propsXmlList)
			{
				props = new ItemProps();
				props.parseXml(propsxml);
				m_propslist.push(props);
			}
		}
	}

}