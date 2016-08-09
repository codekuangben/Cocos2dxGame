package com.util 
{
	import common.Context;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class DebugBox 
	{
		public static var m_context:Context;
		public static function info(str:String):void		
		{
			if (m_context.m_debugLog && (m_context.m_config.m_versionForOutNet == false || (m_context.m_gkcontext && m_context.m_gkcontext.isCOMMONSET_CLIENT_DebugBoxSet)))
			{
				m_context.m_debugLog.info(str);
			}
			
			m_context.addLog(str);
		}
		
		//强制弹出白色框
		public static function forceInfo(str:String):void
		{
			if (m_context.m_debugLog)
			{
				m_context.m_debugLog.info(str);
			}
			m_context.addLog(str);
		}
		
		public static function addLog(str:String):void
		{
			m_context.addLog(str);
		}
		
		public static function sendToDataBase(str:String):void
		{
			m_context.sendErrorToDataBase(str);
		}
		
	}

}