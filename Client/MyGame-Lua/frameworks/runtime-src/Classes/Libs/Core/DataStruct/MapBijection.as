package datast 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 * 一一映射Map。可以通过key得到value，也可通过value得到key
	 */
	public class MapBijection 
	{
		private var m_dicKeyToValue:Dictionary;
		private var m_dicValueToKey:Dictionary;
		public function MapBijection() 
		{
			m_dicKeyToValue = new Dictionary();
			m_dicValueToKey = new Dictionary();
		}
		
		public function value(key:Object):Object
		{
			return m_dicKeyToValue[key];
		}
		public function key(value:Object):Object
		{
			return m_dicValueToKey[value];
		}
		
		
		public function add(key:Object, value:Object):void
		{
			if (m_dicKeyToValue[key] == undefined)
			{
				m_dicKeyToValue[key] = value;
				m_dicValueToKey[value] = key;
			}
		}
		
		//list的长度必须是偶数。偶数索引(对象)是key, 其紧接着的奇数索引(对象)是value
		public function adds(list:Array):void
		{
			var i:int;
			for (i = 0; i < list.length; i += 2)
			{
				add(list[i],list[i+1]);
			}
		}
		
		public function removeByKey(key:Object):void
		{
			if (m_dicKeyToValue[key] != undefined)
			{				
				delete m_dicValueToKey[m_dicKeyToValue[key]];
				delete m_dicKeyToValue[key];
			}
		}
		
	}

} 