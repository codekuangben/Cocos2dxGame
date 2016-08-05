package network 
{
	/**
	 * ...
	 * @author ...
	 */
	import com.pblabs.engine.debug.Logger;
	import com.util.PBUtil;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import common.crypto.CryptoSys;
	//import network.socketTools;
	import flash.utils.Endian;
	
	public class TcpSocket  extends StreamSocket
	{
		/**
		 * 
		 * */
		private var m_CBuffer:CircularBuffer;
		protected var m_cryptoSys:CryptoSys;
		
		override public function set cryptoSys(value:CryptoSys):void
		{
			m_cryptoSys = value;
		}
		
		/**
		 * 
		 * */
		public function TcpSocket(socketHandle:ISocketHandler) 
		{
			super(socketHandle);
			init();
		}
		
		private function init():void 
		{
			m_CBuffer = new CircularBuffer(2 * 1024);
		}		
		/**
		 * @brief 解析网络的数据包都在这里，包头是压缩后的自己的长度
		 * */
		override protected function onSocketData(event:ProgressEvent):void
		{
			if (PBUtil.SocketReceiveLog)
			{
				Logger.info(null, null, "onSocketData");
			}
			var subpacklst:Array;
			var idx:int = 0;			
			while (m_socket.bytesAvailable)
			{
				if (m_CBuffer.GetReadHeader)	// 读取消息头 
				{
					// 解析消息 
					if (m_CBuffer.GetLeftBytes)	// 上一个消息还有这么多没有读取凑够一个完整包 
					{
						if (m_CBuffer.GetLeftBytes <= m_socket.bytesAvailable)	// 凑够一个完整的包 
						{
							m_socket.readBytes(m_CBuffer.GetDateRaw, m_CBuffer.GetTotalBytes - m_CBuffer.GetLeftBytes, m_CBuffer.GetLeftBytes);
							
							if(m_cryptoSys.bStartEncrypt)	// 解密,现在可能是几个包一起加密，里面好几个包
							{
								m_cryptoSys.decrypt(m_CBuffer.GetDateRaw);
								subpacklst = [];
								readSubPack(m_CBuffer.GetDateRaw, 0, subpacklst);
								idx = 0;
								while(idx < subpacklst.length)
								{
									m_CBuffer.Write(subpacklst[idx].m_msg, subpacklst[idx].m_msg.length);
									++idx;
								}
								subpacklst.length = 0;
							}
							else
							{
								// 进行解压 
								if (m_CBuffer.GetCompressed)
								{
									EncDec.Uncompress(m_CBuffer.GetDateRaw);
								}
	
								// 写入对列 
								m_CBuffer.Write(m_CBuffer.GetDateRaw, m_CBuffer.GetDateRaw.length);
							}
							m_CBuffer.Reset();
						}
						else
						{
							var uRead:uint = m_socket.bytesAvailable;
							m_socket.readBytes(m_CBuffer.GetDateRaw, m_CBuffer.GetTotalBytes - m_CBuffer.GetLeftBytes, m_socket.bytesAvailable);
							m_CBuffer.SetLeftBytes = m_CBuffer.GetLeftBytes - uRead;
						}
					}
					else 
					{
						m_CBuffer.SetReadHeader = false;
					}
				}
				else
				{
					if (m_socket.bytesAvailable < m_CBuffer.GetHeaderBytes)	// 连消息的基本的头都不全，不读取了，下一次一起读取
					{
						break;
					}
					else
					{
						m_CBuffer.SetReadHeader = true;
						
						// 解包消息长度
						var len:uint = m_socket.readUnsignedInt();
						if (len & NetEnum.PACKET_ZIP)	// 需要解压
						{
							len &= ~NetEnum.PACKET_ZIP;
						}
						else
						{
							m_CBuffer.SetCompressed = false;
						}
						
						m_CBuffer.SetTotalBytes = len;
						m_CBuffer.SetLeftBytes = m_CBuffer.GetTotalBytes;
					}
				}
			}
			
			super.onSocketData(event);
		}
		
		/**
		 * @brief 从一个解密的数据包中读取出几个数据包
		 * */
		protected function readSubPack(origpack:ByteArray, offset:int, subpacklst:Array):void
		{
			var len:uint = 0;
			origpack.position = offset;
			var bcompress:Boolean = false;
			while(true)
			{
				bcompress = false;
				if(origpack.position + 4 < origpack.length)	// 这个地方一定要小于，因为读取完了头后，至少还需要有内容才行，如果等于，必然说明最后四个字节是填充的
				{
					// 读取消息的头
					len = origpack.readUnsignedInt();
					if(len == 0)		// 如果长度 len == 0，说明从这四个字节开始已经读取的是填充字段了
					{
						break;
					}
					if (len & NetEnum.PACKET_ZIP)	// 需要解压
					{
						len &= ~NetEnum.PACKET_ZIP;
						bcompress = true;
					}
					if(origpack.position + len <= origpack.length)
					{
						// 读取消息内容
						subpacklst[subpacklst.length] = new SubPack();
						subpacklst[subpacklst.length - 1].m_msg = new ByteArray();
						subpacklst[subpacklst.length - 1].m_msg.endian = Endian.LITTLE_ENDIAN;
						origpack.readBytes(subpacklst[subpacklst.length - 1].m_msg, 0, len);
						
						if(bcompress)
						{
							EncDec.Uncompress(subpacklst[subpacklst.length - 1].m_msg);
						}
					}
					else
					{
						break;
					}
				}
				else
				{
					break;
				}
			}
		}
		
		
		/**
		 * @brief 这样发送 sendData 数据中已经有大小了  
		 * */
		override public function SendData(sendData:ByteArray):void 
		{
			if (!IsConnect)
			{
				return;
			}
			
			// 加密 
			var packetlen:uint = sendData.length;
			var compacketlen:uint = packetlen;
			if (sendData.length > NetEnum.PACKET_ZIP_MIN)
			{
				// 压缩
				EncDec.Compress(sendData);
				// 加密
				if(m_cryptoSys.bStartEncrypt)
				{
					m_cryptoSys.encrypt(sendData);
				}
				packetlen = sendData.length;
				compacketlen = packetlen | NetEnum.PACKET_ZIP;
			}
			else if(m_cryptoSys.bStartEncrypt) 	// 加密
			{
				m_cryptoSys.encrypt(sendData);
				
				packetlen = sendData.length;
				compacketlen = packetlen;
			}
			
			m_CBuffer.GetSenddata.clear();
			m_CBuffer.GetSenddata.writeUnsignedInt(compacketlen);
			m_CBuffer.GetSenddata.writeBytes(sendData, 0, packetlen);
			
			super.SendData(m_CBuffer.GetSenddata);
		}
		
		/**
		 * 
		 * */
		override public function GetMsg():ByteArray
		{
			return m_CBuffer.GetMsg();
		}
		
		/**
		 * 
		 * */
		private function set SetCBuffer(buffer:CircularBuffer):void
		{
			m_CBuffer = buffer;
		}
		
		/**
		 * 
		 * */
		public function get GetBuffer():CircularBuffer
		{
			return m_CBuffer;
		}
		
		override public function onConnect(event:Event):void
		{
			super.onConnect(event);
		}
		
		// 这个是 socket 自己断开 
		override public function onClose(event:Event):void
		{
			super.onClose(event);
		}
		
		// 这个是上层主动断开链接    
		override public function close():void
		{
			super.close();
		}
	}
}