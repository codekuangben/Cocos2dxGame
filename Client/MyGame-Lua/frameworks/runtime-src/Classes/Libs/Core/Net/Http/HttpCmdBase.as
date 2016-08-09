package net.http
{
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	/**
	 * @brief 消息基类
	 */
	public class HttpCmdBase 
	{
		public var m_loaded:Function = null;
		public var m_failed:Function = null;
		public var m_SecurityError:Function = null;
		public var m_method:String = URLRequestMethod.POST;
		public var m_dataFormat:String = URLLoaderDataFormat.TEXT;
		
		public var m_serverurl:String;
		public var m_datadic:Dictionary;

		public function HttpCmdBase() 
		{
			m_datadic = new Dictionary();
			m_serverurl = "CrashReport.php";
		}		
	}
}