package modulecommon.scene.wu 
{
	/**
	 * ...
	 * @author ...
	 * 武将培养属性
	 */
	public class TrainAttr 
	{
		public static const HT_ADDATK:int = 1;		//增加攻击
		public static const HT_ADDDOUBLEDEF:int = 2;//增加双防
		public static const HT_ADDBAOJI:int = 3;	//增加暴击
		public static const HT_ADDBJDEF:int = 4;	//增加防暴击
		public static const HT_ADDSPEED:int = 5;	//增加出手速度
		
		public var m_id:uint;		//培养等级
		public var m_maxpower:uint;	//该等级需要经验值
		public var m_cost:uint;		//该等级培养所需银币
		public var m_proptype:uint;	//增加属性类型
		public var m_propvalue:uint;//所增加属性值
		
		public function TrainAttr() 
		{
			
		}
		
		public function paresXml(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_maxpower = parseInt(xml.@maxpower);
			m_cost = parseInt(xml.@cost);
			m_proptype = parseInt(xml.@proptype);
			m_propvalue = parseInt(xml.@propvalue);
		}
		
		public static function getStrAddAttr(type:int):String
		{
			var ret:String;
			switch(type)
			{
				case HT_ADDATK:
					ret = "攻击";
					break;
				case HT_ADDDOUBLEDEF:
					ret = "双防";
					break;
				case HT_ADDBAOJI:
					ret = "暴击";
					break;
				case HT_ADDBJDEF:
					ret = "防暴";
					break;
				case HT_ADDSPEED:
					ret = "速度";
					break;
			}
			
			return ret;
		}
	}

}