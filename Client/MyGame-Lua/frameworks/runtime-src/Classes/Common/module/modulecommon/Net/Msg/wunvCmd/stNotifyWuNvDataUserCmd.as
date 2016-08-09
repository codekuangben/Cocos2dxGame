package modulecommon.net.msg.wunvCmd 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public class stNotifyWuNvDataUserCmd extends stWuNvCmd 
	{
		public var m_id:Vector.<int>;
		public var m_sid:Dictionary;
		public var m_did:Vector.<DancingWuNvMsg>;
		public function stNotifyWuNvDataUserCmd() 
		{
			super();
			byParam = NOTIFY_WUNV_DATA_USERCMD;
			
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_id = new Vector.<int>();
			m_sid = new Dictionary();
			m_did = new Vector.<DancingWuNvMsg>();
			var normalSize:uint = byte.readUnsignedByte();
			var i:int;
			var data:int;
			for (i = 0; i < normalSize; i++ )
			{
				data = byte.readUnsignedInt();
				m_id.push(data);
			}
			var specialSize:uint = byte.readUnsignedByte();
			var sdata:SpecialWuNv;
			for (i = 0; i < specialSize; i++ )
			{
				sdata = new SpecialWuNv();
				sdata.deserialize(byte);
				m_sid[sdata.id] = sdata;
			}
			var dancingSize:uint = byte.readUnsignedByte();
			var ddata:DancingWuNvMsg;
			for (i = 0; i < dancingSize; i++)
			{
				ddata = new DancingWuNvMsg();
				ddata.deserialize(byte);
				m_did.push(ddata);
			}
		}
		
	}

}

/*//当前自身舞女信息 s->c
	const BYTE NOTIFY_WUNV_DATA_USERCMD = 1;
	struct stNotifyWuNvDataUserCmd : public stWuNvCmd
	{
		stNotifyWuNvDataUserCmd()
		{
			byParam = NOTIFY_WUNV_DATA_USERCMD;
			normalSize = specialSize = dancingSize = 0;
		}
		BYTE normalSize;
		DWORD id[0];  //已开放普通舞女
		BYTE specialSize;
		SpecialWuNv sid[0]; //已获得神秘舞女
		BYTE dancingSize;
		DancingWuNv did[0];//正在跳
	};*/