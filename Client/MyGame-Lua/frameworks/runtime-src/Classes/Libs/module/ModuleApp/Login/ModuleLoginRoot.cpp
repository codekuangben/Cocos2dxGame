package app.login
{
	//import adobe.utils.CustomActions;
	//import com.pblabs.engine.debug.Logger;
	//import com.pblabs.engine.resource.ResourceManager;
	//import com.pblabs.engine.resource.SWFResource;
	//import modulecommon.game.ConstValue;
	//import flash.display.Sprite;
	import app.login.netcb.LoginNetHandle;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.DataResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import common.Context;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;


	import login.LoginData;
	//import modulecommon.uiinterface.IUILogin;

	import com.pblabs.engine.entity.EntityCValue;
	
	/**
	 * ...
	 * @author ...
	 * @brief 全局空间 
	 */
	public class ModuleLoginRoot 
	{
		public var m_context:Context;
		
		public function ModuleLoginRoot(gk:Context) 
		{
			m_context = gk;
			m_context.m_loginHandleMsg = new LoginNetHandle(m_context);
				
		}		
	
		public function beginLogin():void
		{
			Logger.info(null, null, "选择登陆方式");
			if (m_context.m_platformMgr.byLoginplatform)
			{
				m_context.progLoading.reset();
				//m_gkcontext.m_UIs.progLoading.setText("服务器连接中...");
				m_context.progLoading.show();
				Logger.info(null, null, "通过平台验证的方式登陆游戏");
				m_context.m_config.m_ip = "login.wdsg.wanwan.sina.com";
				m_context.m_config.m_port = 7001;
				m_context.m_LoginMgr.begin(LoginData.LOGINTYPE_Login);				
			}
			else
			{
				loadLogin();
			}
		}
		private function loadLogin():void
		{
			this.m_context.m_resMgr.load("asset/config/base.txt", DataResource, onLoaded, onFailed);
		}

		private function onLoaded(event:ResourceEvent):void
		{
			var res:DataResource = event.resourceObject as DataResource;
			//m_gkcontext.startprogResLoaded(res.filename);
			parseCfg(res.data);
			this.m_context.m_resMgr.unload(res.filename, DataResource);
			m_context.addLog("base.txt loaded");
			Logger.info(null, null,  res.filename + "loaded");
			
			if (m_context.m_preLoad.loadNone)
			{
				m_context.m_preLoad.load();
			}
		}
		
		private function onFailed(event:ResourceEvent):void
		{
			var res:DataResource = event.resourceObject as DataResource;
			Logger.info(null, null,  res.filename + "failed");
			//m_gkcontext.startprogResFailed(res.filename);
		}
		
		protected function parseCfg(byteData:ByteArray):void
		{
			var str:String = byteData.readUTFBytes(byteData.bytesAvailable);
			var key:String = "";
			var value:String = "";
			var bKey:Boolean = true; // 当前是否在解析 key 的状态   
			var char:String = "";
			var k2vDic:Dictionary = new Dictionary(); // 键到值的映射  
			
			var idx:uint = 0;
			while (idx < str.length)
			{
				char = str.charAt(idx);
				if (char == "=")
				{
					bKey = false;
					++idx;
					continue;
				}
				else if (char == "\r" || char == "\n")
				{
					if (key != "" && !k2vDic[key])
					{
						k2vDic[key] = value;
					}
					bKey = true;
					key = "";
					value = "";
					++idx;
					continue;
				}
				
				if (bKey)
				{
					key += char;
				}
				else
				{
					value += char;
				}
				
				++idx;
			}
			// 把最后一个读取出来的放进去  
			if (key != "")
			{
				k2vDic[key] = value;
			}
			if (k2vDic["ip"])
			{
				m_context.m_config.m_ip = k2vDic["ip"];
			}
			if (k2vDic["port"])
			{
				m_context.m_config.m_port = parseInt(k2vDic["port"]);
			}
			if (k2vDic["ip2"])
			{
				m_context.m_config.m_ip2 = k2vDic["ip2"];
			}
			
			if (k2vDic["port2"])
			{
				m_context.m_config.m_port2 = parseInt(k2vDic["port2"]);
			}
			if (k2vDic["webip"])
			{
				m_context.m_config.m_webIP = k2vDic["webip"];
			}
		}
		
		// 如果设置过网络链接，就选择网络链接
		
	}
}