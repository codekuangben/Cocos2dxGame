package network 
{
	/**
	 * ...
	 * @author ...
	 */
	//import com.pblabs.engine.debug.Logger;
	import flash.utils.ByteArray;
	
	import common.crypto.CryptoSys;
	import common.net.endata.EnNet;
	import common.net.msg.basemsg.t_NullCmd;
	
	public class WorldSocket implements IWorldHandler
	{
		/**
		 * 
		 * */
		private var m_Socket:SocketT;
		private var m_SocketMgr:IWorldSocketMgr;
		// 发送数据的临时缓冲区，避免每一次都申请  
		private var m_SendData:ByteArray;
		protected var m_cryptoSys:CryptoSys;
		
		public function set cryptoSys(value:CryptoSys):void
		{
			m_cryptoSys = value;
			m_Socket.cryptoSys = m_cryptoSys;
		}
		 
		/**
		 * 
		 * */
		public function WorldSocket(socket:SocketT, socketMgr:IWorldSocketMgr) 
		{
			m_Socket = socket;
			m_SocketMgr = socketMgr;
			
			m_SendData = new ByteArray();
			init();
		}
		
		/**
		 * 
		 * */
		private function init():void
		{
			// bug: 因为这里给服务器的内部不对    
			m_SendData.endian = EnNet.DATAENDIAN;
		}
		
		/**
		 * 
		 * */
		public function SendData(sendData:ByteArray):void
		{
			m_Socket.SendData(sendData);
		}
		
		/**
		 * 
		 * */
		public function GetMsg():ByteArray
		{
			return m_Socket.GetMsg();
		}
		
		public function get Socket():SocketT 
		{
			return m_Socket;
		}
		
		public function set Socket(value:SocketT):void 
		{
			m_Socket = value;
		}
		
		// KBEN: 发送消息用这个函数    
		public function sendMsg(cmd:t_NullCmd):void
		{
			// 清除缓冲区    
			m_SendData.clear();
			// 发送数据    
			cmd.serialize(m_SendData);
			m_Socket.SendData(m_SendData);
			// 发送消息打印消息日志			
		}
		
		public function get bclosestate():Boolean
		{
			return m_Socket.bclosestate;
		}
		
		public function get ip():String 
		{
			return m_Socket.ip;
		}
		
		public function get port():int 
		{
			return m_Socket.port;
		}
	}
}