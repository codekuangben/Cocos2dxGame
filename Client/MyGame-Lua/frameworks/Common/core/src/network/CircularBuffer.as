package network 
{
	/**
	 * ...
	 * @author ...
	 */
	//import com.pblabs.engine.debug.Logger;
	import common.net.endata.EnNet;
	//import flash.text.ime.CompositionAttributeRange;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import datast.Queue;
	import network.Msg;
	
	public class CircularBuffer 
	{
		/**
		 * 
		 * */
		private var m_CircleBuffer:ByteArray;		// 环形环形冲区
		private var m_dataRaw:ByteArray;						// 原始的数据 
		private var m_dataTmp:ByteArray;						// 临时的数据 
		private var m_Senddata:ByteArray;			// 发送的数据 
		
		private var m_head:uint;					// 记录开始位置 
		private var m_tail:uint;					// 记录结束位置，指向内容字符串后面的第一个位置
		private var m_max:uint;						// 记录可以使用的最大字节数 
		
		private var m_count:uint;	// 记录当前已写入的字节数 
		private var m_Queue:Queue;	// 记录每一个消息的 
		private var m_HeaderBytes:uint;	// 记录消息头大小 
		
		private var m_InitBytes:uint;	// 初始空间分配大小
		private var m_MaxBytes:uint;	// 最大空间分配大小 
		 
		private var m_LeftBytes:uint; 	// 当前包还剩多少没有读取近来 
		private var m_bReadHeader:Boolean;	// 是否读取了消息 
		private var m_TotalBytes:uint;	// 当前处理的包的总的长度 
		private var m_bCompressed:Boolean;	// 当前正在接收的包是否压缩过 
		
		/**
		 * 
		 * */
		public function CircularBuffer(size:uint) 
		{
			init();
			
			m_max = size;
			m_InitBytes = size;
			m_CircleBuffer.length = size;
		}
		
		/**
		 * 
		 * */
		public function init():void
		{
			m_CircleBuffer = new ByteArray();
			//m_CircleBuffer.endian = Endian.LITTLE_ENDIAN;
			m_CircleBuffer.endian = EnNet.DATAENDIAN;
			
			m_dataRaw = new ByteArray();
			//m_dataRaw.endian = Endian.LITTLE_ENDIAN;
			m_dataRaw.endian = EnNet.DATAENDIAN;
			
			m_dataTmp = new ByteArray();
			//m_dataTmp.endian = Endian.LITTLE_ENDIAN;
			m_dataTmp.endian = EnNet.DATAENDIAN;
			
			m_Senddata = new ByteArray();
			//m_Senddata.endian = Endian.LITTLE_ENDIAN;
			m_Senddata.endian = EnNet.DATAENDIAN;
			
			m_Queue = new Queue();
			
			m_head = 0;
			m_tail = 0;
			m_max = 0;
			
			m_count = 0;
			m_MaxBytes = 8 * 1024 * 1024;
			m_bReadHeader = false;
			m_HeaderBytes = 4;
			m_bCompressed = true;		// 默认是否压缩
		}
		
		/**
		 * 
		 * */
		public function Write(databyte:ByteArray, len:uint):Boolean
		{
			var left:uint = 0;	
			
			if (m_count + len > m_max - 1)
			{
				
				do
				{
					m_InitBytes *= 2;
				}
				while (m_count + len > m_InitBytes - 1);
				
				if (m_InitBytes > m_MaxBytes)
				{
					m_InitBytes /= 2;
					return false;									
				}
				
				m_CircleBuffer.length = m_InitBytes;
				if (m_tail < m_head)
				{
					if (m_tail >= m_CircleBuffer.length - m_max)
					{
						left = m_tail - (m_CircleBuffer.length - m_max);
						m_CircleBuffer.position = 0;
						m_CircleBuffer.readBytes(m_dataTmp, 0, m_CircleBuffer.length - m_max);
						m_CircleBuffer.position = m_max;
						m_CircleBuffer.writeBytes(m_dataTmp, 0, m_CircleBuffer.length - m_max);						
						
						m_tail = left;						
					}
					else
					{
						m_CircleBuffer.position = 0;
						m_CircleBuffer.readBytes(m_dataTmp, 0, m_tail);
						m_CircleBuffer.position = m_max;
						m_CircleBuffer.writeBytes(m_dataTmp, 0, m_tail);
						m_tail = m_max + m_tail;
					}
				}
				
				m_max = m_CircleBuffer.length;
			}
			
			m_count += len;
			if (m_tail + len > m_max)	// 分两次写 
			{
				left = len - (m_max - m_tail);
				m_CircleBuffer.position = m_tail;
				m_CircleBuffer.writeBytes(databyte, 0, m_max - m_tail);
				m_CircleBuffer.position = 0;
				m_CircleBuffer.writeBytes(databyte, m_max - m_tail, left);
				
				m_tail = left;				
			}
			else 	// 一次写进去 
			{				
				m_CircleBuffer.position = m_tail;
				m_CircleBuffer.writeBytes(databyte, 0, len);
				m_tail += len;		
			}			
			
			// 进队后再进消息对列
			var pushMsg:Msg = new Msg();
			pushMsg.SetSize = len;
			m_Queue.enqueue(pushMsg);
			
			// debug 调试打印接收的消息 
			var cmd:uint = databyte.readUnsignedByte();
			var param:uint = databyte.readUnsignedByte();
			//Logger.info(null, null, "push msg: cmd=" + cmd + " param=" + param + " len=" + len);
			
			return true;
		}
		
		/**
		 * 
		 * */
		public function Read(msgdata:ByteArray):Boolean
		{
			if (m_Queue.IsEmpty())
			{
				return false;
			}
			
			var popMsg:Msg = m_Queue.dequeue();
			m_CircleBuffer.readBytes(msgdata, m_head, popMsg.GetSize);
			
			return true;
		}
		
		/**
		 * 
		 * */
		private function IsFull():Boolean
		{
			if (m_tail + 1 == m_head)
			{
				return false;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 
		 * */
		public function IsEmpty():Boolean
		{
			if (m_head == m_tail)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * @brief 入队的时候不解析，提取消息的时候再解析 
		 * */
		public function GetMsg():ByteArray
		{
			if (m_Queue.IsEmpty())
			{
				return null;
			}
			
			var msgdata:ByteArray = new ByteArray();
			msgdata.endian = Endian.LITTLE_ENDIAN;
			var popMsg:Msg = m_Queue.dequeue();
			if (popMsg)
			{
				if (popMsg.GetSize <= m_max - m_head)
				{
					m_CircleBuffer.position = m_head;
					m_CircleBuffer.readBytes(msgdata, 0, popMsg.GetSize);					
					m_head += popMsg.GetSize;
					m_head %= m_max;
				}
				else	// 分两段 
				{
					m_CircleBuffer.position = m_head;
					var left:uint = popMsg.GetSize - (m_max - m_head);
					m_CircleBuffer.readBytes(msgdata, 0, m_max - m_head);
					m_CircleBuffer.position = 0;
					m_CircleBuffer.readBytes(msgdata, m_max - m_head, left);
					
					m_head = left;
					m_head %= m_max;
				}
				
				m_count -= popMsg.GetSize;
				
				return msgdata;
			}
			return null;
		}
		
		/**
		 * 
		 * */
		public function get GetDateRaw():ByteArray
		{
			return m_dataRaw;
		}

		/**
		 * 
		 * */
		public function get GetReadHeader():Boolean
		{
			return m_bReadHeader;
		}
		
		/**
		 * 
		 * */
		public function set SetReadHeader(readHeader:Boolean):void
		{
			m_bReadHeader = readHeader;
		}
		
		/**
		 * 
		 * */
		public function get GetLeftBytes():uint
		{
			return m_LeftBytes;
		}
		
		/**
		 * 
		 * */
		public function set SetLeftBytes(leftBytes:uint):void
		{
			m_LeftBytes = leftBytes;
		}
		
		/**
		 * 
		 * */
		public function get GetTotalBytes():uint
		{
			return m_TotalBytes;
		}
		
		/**
		 * 
		 * */
		public function set SetTotalBytes(totalBytes:uint):void
		{
			m_TotalBytes = totalBytes;
		}
		
		/**
		 * 
		 * */
		public function get GetHeaderBytes():uint
		{
			return m_HeaderBytes;
		}
		 
		/**
		 * 
		 * */
		public function set SetHeaderBytes(headerBytes:uint):void
		{
			m_HeaderBytes = headerBytes;
		}
		
		/**
		 * 
		 * */
		private function SetReadPos():void
		{
			m_CircleBuffer.position = m_head;
		}
		
		/**
		 * 
		 * */
		private function SetWritePos():void
		{
			m_CircleBuffer.position = m_tail;
		}
		
		/**
		 * 
		 * */
		private function set SetCircleBuffer(circleBuffer:ByteArray):void 
		{
			m_CircleBuffer = circleBuffer;
		}
		
		/**
		 * 
		 * */
		public function get GetCircleBuffer():ByteArray
		{
			return m_CircleBuffer;
		}
		
		/**
		 * 
		 * */
		private function set SetSenddate(senddata:ByteArray):void
		{
			m_Senddata = senddata;
		}
		
		/**
		 * 
		 * */
		public function get GetSenddata():ByteArray
		{
			return m_Senddata;
		}
		
		/**
		 * 
		 * */
		private function set SetTmpData(data:ByteArray):void
		{
			m_dataTmp = data;
		}
		
		/**
		 * 
		 * */
		public function get GetTmpdata():ByteArray
		{
			return m_dataTmp;
		}
		
		/**
		 * 
		 * */
		public function set SetCompressed(bcompressed:Boolean):void
		{
			m_bCompressed = bcompressed;
		}
		
		/**
		 * 
		 * */
		public function get GetCompressed():Boolean
		{
			return m_bCompressed;
		}
		
		/**
		 * @brief 数据处理完毕恢复默认的状态 
		 * */
		public function Reset():void
		{
			m_dataRaw.clear();
			m_bReadHeader = false;
			m_bCompressed = true;
		}
	}
}