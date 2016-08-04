package modulecommon.scene.wu 
{
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	/**
	 * ...
	 * @author ...
	 * "我的三国关系"，激活属性加成
	 */
	public class ItemActAttr 
	{
		//主角“我的三国关系”激活属性 //eUARProps
		public static const UARPROP_ATTACK:int = 1;		//攻击力
		public static const UARPROP_PHYDEF:int = 2;		//物理防御
		public static const UARPROP_STRATEGYDEF:int = 3;//策略防御
		public static const UARPROP_HPLIMIT:int = 4;	//兵力
		public static const UARPROP_ATTACKSPEED:int = 5;//速度
		
		public var m_id:uint;
		public var m_vecProps:Vector.<t_ItemData>;
		
		public function ItemActAttr() 
		{
			m_vecProps = new Vector.<t_ItemData>();
		}
		
		public function parseXml(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			
			parseXmlAttr(xml.@props);
		}
		
		private function parseXmlAttr(str:String):void
		{
			if (null == str || "" == str)
			{
				return;
			}
			
			var itemdata:t_ItemData;
			var ar:Array = str.split(":");
			var attr:String;
			var subar:Array;
			for (var i:int = 0; i < ar.length; i++)
			{
				attr = ar[i];
				if (attr && ("" != attr))
				{
					subar =  attr.split("-");
					if (subar[0] && subar[1])
					{
						itemdata = new t_ItemData();
						itemdata.type = parseInt(subar[0]);
						itemdata.value = parseInt(subar[1]);
						
						m_vecProps.push(itemdata);
					}
				}
			}
		}
		
		public static function getAttrStr(type:uint):String
		{
			var ret:String;
			
			switch(type)
			{
				case UARPROP_ATTACK:
					ret = "攻击力";
					break;
				case UARPROP_PHYDEF:
					ret = "物理防御";
					break;
				case UARPROP_STRATEGYDEF:
					ret = "策略防御";
					break;
				case UARPROP_HPLIMIT:
					ret = "兵力";
					break;
				case UARPROP_ATTACKSPEED:
					ret = "速度";
					break;
				default:
					ret = "";
			}
			
			return ret;
		}
	}

}