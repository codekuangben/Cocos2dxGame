package modulecommon.login
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import modulecommon.GkContext;
	import com.pblabs.engine.entity.EntityCValue;

	/**
	 * @brief 主要处理网络 ISP 的切换
	 */
	public class NetISP implements INetISP
	{
		public static const ISPNameChange:String = "ISPNameChange";
		public static var m_ISPNameVec:Vector.<String>;
		
		//protected var m_daojishi:Daojishi;
		protected var m_gkcontext:GkContext;
		protected var m_ISPID:uint;					// ISP id，从 0 开始
		protected var m_connectNextIP:Function;		// 回调
		protected var m_ISPChangeEventDispatcher:EventDispatcher;	// 这个是 ISP 改变的时候发送事件使用的

		public function NetISP(gk)
		{
			m_gkcontext = gk;
			
			if (!m_ISPNameVec)
			{
				m_ISPNameVec = new Vector.<String>(EntityCValue.ISPCnt, true);
				m_ISPNameVec[0] = "电信";
				m_ISPNameVec[1] = "网通";
			}
			
			m_ISPChangeEventDispatcher = new EventDispatcher();
			ISPID = EntityCValue.ISPTele;			// 设置电信
		}
		
		//单位毫秒
		//public function beginDaojishi(leftTime:int):void
		//{
		//	m_daojishi.end();

		//	m_daojishi.initLastTime = leftTime;
		//	m_daojishi.begin();
		//}
		
		//public function updateDaojishi(d:Daojishi):void
		//{	
		//	if (m_daojishi.isStop())
		//	{
		//		m_daojishi.end();
		//	}
		//}
		
		// 链接失败回调函数
		public function onConnectToLoginServerFailed():void
		{
			// 显示按钮
			//m_gkcontext.m_UIs.progLoading.changeNetBtn(true);
		}
		
		// 成功连接服务器
		public function onConnectToLoginServer():void 
		{
			// 显示按钮
			//m_gkcontext.m_context.progLoading.changeNetBtn(false);
		}
		
		// 点击按钮触发的服务器处理
		public function onBtnClkConnectServer():void
		{
			// 切换 ISP
			/*toggleISPID();
			// 关闭之前的 socket
			if (EntityCValue.ISPTele == m_ISPID)	// 电信
			{
				m_gkcontext.m_LoginMgr.sockMgr.closeSocket(m_gkcontext.m_context.m_config.m_ip2, m_gkcontext.m_context.m_config.m_port2);
			}
			else	// 网通
			{
				m_gkcontext.m_LoginMgr.sockMgr.closeSocket(m_gkcontext.m_context.m_config.m_ip, m_gkcontext.m_context.m_config.m_port);
			}
			
			// 开始新的连接
			if (m_connectNextIP)
			{
				if (EntityCValue.ISPTele == m_ISPID)	// 电信
				{
					m_connectNextIP(m_gkcontext.m_context.m_config.m_ip, m_gkcontext.m_context.m_config.m_port);
				}
				else
				{
					m_connectNextIP(m_gkcontext.m_context.m_config.m_ip2, m_gkcontext.m_context.m_config.m_port2);
				}
			}*/
		}
		
		public function set connectNextIP(value:Function):void
		{
			m_connectNextIP = value;
		}
		
		public function get ISPID():uint
		{
			return m_ISPID;
		}
		
		public function set ISPID(value:uint):void
		{
			m_ISPID = value;
			m_ISPChangeEventDispatcher.dispatchEvent(new Event(NetISP.ISPNameChange));
		}
		
		public function toggleISPID():void
		{
			if (EntityCValue.ISPTele == m_ISPID)
			{
				m_ISPID = EntityCValue.ISPCNC;
			}
			else if (EntityCValue.ISPCNC == m_ISPID)
			{
				m_ISPID = EntityCValue.ISPTele;
			}
			
			m_ISPChangeEventDispatcher.dispatchEvent(new Event(NetISP.ISPNameChange));
		}
		
		public function getUserStr():String
		{
			var retstr:String;
			if (EntityCValue.ISPTele == m_ISPID)
			{
				retstr = "网通铁通用户点此连接";
			}
			else if (EntityCValue.ISPCNC == m_ISPID)
			{
				retstr = "电信用户点此连接";
			}
			else
			{
				retstr = "请点击此连接";
			}
			
			return retstr;
		}
		
		public function addISPChangeEventDispatcher(cb:Function):void
		{
			m_ISPChangeEventDispatcher.addEventListener(NetISP.ISPNameChange, cb);
		}
	}
}