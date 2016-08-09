package modulecommon.scene.zhanxing 
{
	import modulecommon.net.msg.zhanXingCmd.stLocation;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class T_Star 
	{
		public var thisid:uint;
		public var m_id:uint;
		public var m_totalExp:uint;
		public var m_level:uint;
		public var m_location:stLocation;
		public function T_Star()
		{
			
		}
		public function deserialize(byte:ByteArray):void
		{
			thisid = byte.readUnsignedInt();
			m_id = byte.readUnsignedInt();
			m_totalExp = byte.readUnsignedInt();
			m_level = byte.readUnsignedShort();
			
			m_location = new stLocation();
			m_location.deserialize(byte);
		}
	}

}

//神兵数据
	/*struct t_ShenBingData
	{
		t_ShenBingData()
		{
			thisid = id = 0;
			totalexp = 0;
			level = 0;
		}
		DWORD thisid;
		DWORD id;
		DWORD totalexp;
		WORD level;
		stLocation loc;	
	};*/