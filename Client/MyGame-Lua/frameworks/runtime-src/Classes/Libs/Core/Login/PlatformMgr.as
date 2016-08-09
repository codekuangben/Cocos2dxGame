package login
{
	import com.pblabs.engine.debug.Logger;
	import common.Context;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import net.loginUserCmd.stPlatformUserRequestLoginCmd;
	import com.util.UtilTools;
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.DebugBox;
	
	/**
	 * ...
	 * @author ...
	 *
	 */
	public class PlatformMgr
	{
		//url的参数定义
		public static const PARA_platform:String = "platform";
		public static const PARA_sid:String = "sid";
		public static const PARA_ticket:String = "ticket";
		
		public static const TYPE_wanwan:String = "wanwan"; //玩玩
		public static const TYPE_weiyouxi:String = "weiyouxi"; //微游戏
		
		public static const UIDTYPE_sina:int = 2;
		public static const UIDTYPE_sina_wanwan:int = 0;
		public static const UIDTYPE_sina_weiyouxi:int = 1;
		
		private var m_context:Context;
		private var m_browserURL:String;	//这是完整的url，可能包含参数
		private var m_topWindowURL:String;		//只包括url的域名部分，不包括参数
		private var m_parameter:Object;
		
		public function PlatformMgr(gk:Context)
		{
			m_context = gk;
			
		}
		
		public function init():void
		{
			try	// 工具没有浏览器，会出错
			{
				m_topWindowURL = ExternalInterface.call('getURL');
			}
			catch (e:Error)
			{
				return;			// 处错误就直接返回
			}
			
			/*Logger.info(null, null, "顶端浏览器地址" + m_topWindowURL);
			Logger.info(null, null, "顶端浏览器地址2:" + ExternalInterface.call('function(){return top.location.href.toString()}'));*/
			try
			{
				m_browserURL = ExternalInterface.call('function(){return document.location.href.toString()}');
			}
			catch (e:Error)
			{
				
			}
			
			m_parameter = new Object();
			
			var urlStr:String = m_browserURL;
			var keyword:String;
			var iQuestmark:int = urlStr.search("\\?");
			if (iQuestmark == -1)
			{
				
			}
			else
			{				
				var paramterStr:String = urlStr.substring(iQuestmark+1);
				var urlStrArray:Array = paramterStr.split("&");
				var twoTuple:String;
				var keyValue:Array;
				var key:String;
				var value:String;
				var i:int;
				for each (twoTuple in urlStrArray)
				{
					i = twoTuple.indexOf("=");
					if (i != -1)
					{
						key = twoTuple.substr(0, i);
						value = twoTuple.substr(i + 1);
						m_parameter[key] = value;
					}
				}
			}
			
			Logger.info(null, null, "浏览器地址" + m_browserURL);
			m_context.m_LoginData.m_ZoneID_Qianduan = serverID;
		}
		
		public function sendLoginInfo():void
		{
			m_context.m_cryptoSys.bStartEncrypt = false;
			var send:stPlatformUserRequestLoginCmd = new stPlatformUserRequestLoginCmd();
			send.ticket = m_parameter[PARA_ticket];
			send.subType = m_parameter[PARA_platform];
			send.zone = parseInt(m_parameter[PARA_sid]);
			send.plattype = 2;
			m_context.sendMsg(send);
			m_context.m_LoginMgr.setLoginprocessDesc("发送ticket");
		}
		
		public function get byLoginplatform():Boolean
		{
			if (m_parameter)
			{
				return m_parameter[PARA_ticket] != undefined;
			}
			
			return false;
		}
		
		public function get platform():String
		{
			return m_parameter[PARA_platform];
		}
		public function get serverID():int
		{
			return parseInt(m_parameter[PARA_sid]);
		}
		
		public function get service():String
		{
			var pf:String = platform;
			var sid:int = serverID;
			var str:String="";
			if (pf == TYPE_wanwan)
			{
				str = "webgame211";
				if (sid > 0)
				{
					str += (sid - 1).toString();
				}
			}
			else if (pf == TYPE_weiyouxi)
			{
				
				str = "180012111"+ UtilTools.intToString(sid,3);
			}
			return str;
		}
		public function get browserURL():String
		{
			return m_browserURL;
		}
		public function get topWindowURL():String
		{
			return m_topWindowURL;
		}
		
		//通过平台ID获取平台名称
		public function getPlatformName(platform:int):String
		{
			if (UIDTYPE_sina == platform)
			{
				return "新浪";			
			}
			return "";
		}
		
		public function getZoneName(platform:int, zoneID:int):String
		{
			if (m_context.m_config.m_versionForOutNet == false)
			{
				return "内网" + zoneID;
			}
			var str:String;
			if (zoneID <= 1000)
			{
				str = zoneID + "服";
			}
			else
			{
				str = "体验" + (zoneID -1000) + "服";
			}
			return "新浪" + str;
			
		}
		
		//打开充值页面
		public function openRechargeWeb():void
		{
			var URL:String;
			var pf:String = platform;
			var sid:int = serverID;
			if (pf == TYPE_wanwan)
			{
				URL = "http://wanwan.sina.com.cn/payment/pgame.php?gid=310212&srv=" + sid;
			}
			else if (pf == TYPE_weiyouxi)
			{
				//URL =  "http://game.weibo.com/wodesanguo/?pay=180012111" + UtilTools.intToString(sid, 3);
				URL =  "http://game.weibo.com/wodesanguo?pay=18001211";
			}
			else
			{
				URL = "http://wanwan.sina.com.cn/wdsg/";
			}
			var talkURL:URLRequest = new URLRequest(URL);
			var math:String = "_blank";
			navigateToURL(talkURL, math);
		}
		
		public function getNetType():uint
		{
			var sharObject:SharedObject = SharedObject.getLocal(EntityCValue.NetType);
			if (sharObject.data.nettype != undefined)
			{
				return sharObject.data.nettype;
			}
			return 0;
		}
		
		public function setNetType(type:uint):void
		{
			var sharObject:SharedObject = SharedObject.getLocal(EntityCValue.NetType);
			sharObject.data.nettype = type;
			var ret:String = sharObject.flush();
			if (ret != SharedObjectFlushStatus.FLUSHED)
			{
				DebugBox.info(SharedObjectFlushStatus.PENDING);
			}
		}
	}
}