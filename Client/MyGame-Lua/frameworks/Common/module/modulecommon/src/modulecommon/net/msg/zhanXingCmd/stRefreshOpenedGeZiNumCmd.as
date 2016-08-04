package modulecommon.net.msg.zhanXingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stRefreshOpenedGeZiNumCmd extends stZhanXingCmd 
	{
		public var m_numGridInCommon:int;
		public var m_numGridInReserve:int;
		public function stRefreshOpenedGeZiNumCmd() 
		{
			super();
			byParam = PARA_REFRESH_OPENED_GEZI_NUM_ZXCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			
			m_numGridInCommon = byte.readUnsignedByte();
			m_numGridInReserve = byte.readUnsignedByte();
		}
		
	}

}

//刷新格子数
	/*const BYTE PARA_REFRESH_OPENED_GEZI_NUM_ZXCMD = 11;
	struct stRefreshOpenedGeZiNumCmd : public stZhanXingCmd
	{
		stRefreshOpenedGeZiNumCmd()
		{
			byParam = PARA_REFRESH_GEZI_NUM_ZXCMD;
			bzero(opennum,sizeof(opennum));
		}
		BYTE opennum[2];	//0:神兵包裹 1:不合成神兵包裹 
	};*/