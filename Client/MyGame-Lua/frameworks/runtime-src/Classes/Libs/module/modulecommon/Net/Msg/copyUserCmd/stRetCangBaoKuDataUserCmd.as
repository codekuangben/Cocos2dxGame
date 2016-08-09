package modulecommon.net.msg.copyUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class stRetCangBaoKuDataUserCmd extends stCopyUserCmd 
	{
		public var m_iRemainedTimes:int;
		public var m_iLayer:int;
		public var m_baoxiangList:Vector.<int>;
		public var m_time:uint;
		
		public var refreshtimes:uint;
		public var needmoney:uint;
		
		public function stRetCangBaoKuDataUserCmd() 
		{
			byParam = RET_CANG_BAO_KU_DATA_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			m_iRemainedTimes = byte.readUnsignedByte();
			m_iLayer = byte.readUnsignedByte();
			m_baoxiangList = new Vector.<int>();
			var i:int = 0;
			var data:int;
			for (i = 0; i < 19; i++)
			{
				data = byte.readUnsignedByte();
				if (data > 0)
				{
					m_baoxiangList.push(data);					
				}
				else
				{
					byte.position += 19 - (i + 1);
					break;					
				}
			}
			
			m_time = byte.readUnsignedInt();
			refreshtimes = byte.readUnsignedShort();
			needmoney = byte.readUnsignedInt();
		}
	}

}

/*
 * 	//登陆后，服务器主动发到客户端
	const BYTE  RET_CANG_BAO_KU_DATA_USERCMD = 12;
	struct  stRetCangBaoKuDataUserCmd: public stCopyUserCmd
	{
		stRetCangBaoKuDataUserCmd()
		{
			byParam = RET_CANG_BAO_KU_DATA_USERCMD;
			remainingCount = layer = 0;
			bzero(box, MAX_BOX_SIZE);
		}
		BYTE remainingCount; //剩余探宝次数		
		BYTE layer; //第几层
		BYTE box[MAX_BOX_SIZE]; //<!--白箱子: 1 绿箱子:2 蓝箱子:3 紫箱子:4 金箱子: 5-->
		DWORD time;	//冷却时间
		WORD refreshtimes;
		DWORD needmoney;
	};
*/