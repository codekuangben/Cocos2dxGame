package net.http
{
	import com.util.UtilWeb;
	import common.Context;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	
	
	import com.pblabs.engine.debug.Logger;	
	import org.ffilmation.engine.helpers.fUtil;
	import flash.system.Capabilities;
	
	/**
	 * @brief as3 和 php 通信流程
	 */
	public class HttpCom
	{
		protected var m_context:Context;
		
		public function HttpCom(gk:Context)
		{
			m_context = gk;
		}
		
		// 通信结束前，参数一定要存在
		public function sendHttpMsg(httpmsg:HttpCmdBase):void
		{
			var loader:URLLoader=new URLLoader();
			var url:URLRequest =new URLRequest("http://" + m_context.m_config.m_webIP +  "/phpcrashreport/crashreport/" + httpmsg.m_serverurl);
			url.method = httpmsg.m_method;
			var values:URLVariables = new URLVariables();
			for (var key:String in httpmsg.m_datadic)
			{
				values[key] = httpmsg.m_datadic[key];
			}
			// 加入版本
			values.version = 1;
			//values.XDEBUG_SESSION_START = "ECLIPSE_DBGP";
			//values.KEY = "14049604242583";
			url.data =values;
			loader.dataFormat = httpmsg.m_dataFormat;
			if (httpmsg.m_loaded)
			{
				loader.addEventListener(Event.COMPLETE, httpmsg.m_loaded);
			}
			else
			{
				loader.addEventListener(Event.COMPLETE, onCompleteHandlerVer);
			}
			if (httpmsg.m_failed)
			{
				loader.addEventListener(IOErrorEvent.IO_ERROR, httpmsg.m_failed);
			}
			else
			{
				loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandlerVer);
			}
			if (httpmsg.m_SecurityError)
			{
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, httpmsg.m_SecurityError);
			}
			else
			{
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			}
			loader.load(url);
		}
		
		public function onCompleteHandlerVer(evt:Event):void 
		{
			Logger.info(null, null, "crashreport loaded");
		}
		
		public function onErrorHandlerVer(evt:ErrorEvent):void
		{
			Logger.error(null, null, "crashreport failed");
		}
		
		private function onSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			Logger.error(null, null, "crashreport securityerror");
		}
		public function createHttpCmd(str:String, type:int=1):HttpCmdBase
		{
			var httpmsg:HttpCmdBase = new HttpCmdBase();
		
			var selfIP:String = m_context.m_LoginMgr.selfIP;
			if (selfIP == null)
			{
				selfIP = "";
			}
			var curT:Date = new Date();
			
			var diffLocaltime:Number = curT.time - m_context.m_timeMgr.localTimeStart;
			var diffRelativeTime:Number = getTimer() - m_context.m_timeMgr.relativeTimeStart;
			
			var errorLog:String = fUtil.keyValueToString("ip", selfIP, "loginTime", getTimer(), 
			"isDebugger", Capabilities.isDebugger, "version", Capabilities.version, "BrowserAgent", UtilWeb.BrowserAgent,
			"diffRelativeTime",diffRelativeTime, "diffLocaltime", diffLocaltime);
			
			errorLog = str + errorLog;
			
			httpmsg.m_datadic["error"] = errorLog;
			httpmsg.m_datadic["id"] = m_context.m_LoginData.m_platform_Qianduan;
			
			httpmsg.m_datadic["swfversion"] = m_context.m_version;
			httpmsg.m_datadic["type"] = type;
			httpmsg.m_datadic["platform"] = m_context.m_platformMgr.getZoneName(m_context.m_LoginData.m_platform_Qianduan, m_context.m_LoginData.m_ZoneID_Qianduan);		
			return httpmsg;
			
		}
		
	}
}