package  com.dgrigg.image
{
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author zouzhiqiang
	 */
	internal class LoadCommonSet 
	{
		public var m_resName:String;
		public var m_imageClass:Class;
		public var m_vecItem:Vector.<LoadCommonItem>;
		
		public var m_dicLoadedFun:Dictionary;
		public var m_dicFailedFun:Dictionary;
		
		public function LoadCommonSet()
		{
			m_vecItem = new Vector.<LoadCommonItem>();
			m_dicLoadedFun = new Dictionary();
			m_dicFailedFun = new Dictionary();
		}
		
		public function add(mode:String, onLoaded:Function, onFailed:Function):void
		{
			m_vecItem.push(new LoadCommonItem(mode, onLoaded, onFailed));			
		}
		
		public function remove(onLoaded:Function, onFailed:Function):void
		{
			var i:int = 0;
			var count:int = m_vecItem.length;
			for (i = 0; i < count; i++)
			{
				if (m_vecItem[i].m_LoadedFun == onLoaded && m_vecItem[i].m_FailedFun == onFailed)
				{
					m_vecItem.splice(i, 1);
					break;
				}
			}
			
		}
	}

}