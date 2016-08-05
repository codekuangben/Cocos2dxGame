package com.dgrigg.image 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class LoadCommonItem
	{
		public var m_mode:String;
		public var m_LoadedFun:Function;
		public var m_FailedFun:Function;	
		public function LoadCommonItem(mode:String, loadedFun:Function, failedFun:Function) 
		{
			m_mode = mode;
			m_LoadedFun = loadedFun;
			m_FailedFun = failedFun;
		}
	}

}