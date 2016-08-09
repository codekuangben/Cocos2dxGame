package modulecommon.appcontrol 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class MenuItem 
	{		
		public function MenuItem(_title:String, _processFun:Function, _param:Object)
		{
			title = _title;
			processFun = _processFun;
			param = _param;
		}
		public var title:String;
		public var processFun:Function;
		public var param:Object;		
	}

}