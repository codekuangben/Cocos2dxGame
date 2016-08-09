package modulecommon.net.msg.zhanXingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stZhanXingInfoCmd extends stZhanXingCmd 
	{
		public var lighthero:uint;
		public var sbpnum:uint;
		public var lpnum:uint;
		public var score:uint;
		public var frontMingli:uint;
		/**
		 * 剩余银币探访次数
		 */
		public var silvervisittimes:uint;
		public var midMingli:uint;
		public var backMingli:uint;
		public function stZhanXingInfoCmd() 
		{
			super();
			byParam = PARA_ZHAN_XING_INFO_ZXCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			lighthero = byte.readUnsignedByte();
			sbpnum = byte.readUnsignedByte();
			lpnum = byte.readUnsignedByte();
			silvervisittimes = byte.readUnsignedShort();
			score = byte.readUnsignedInt();
			frontMingli = byte.readUnsignedInt();
			midMingli = byte.readUnsignedInt();
			backMingli = byte.readUnsignedInt();
		}
	}

}

//占星信息
	/*const BYTE PARA_ZHAN_XING_INFO_ZXCMD = 1;
	struct stZhanXingInfoCmd : public stZhanXingCmd
	{
		stZhanXingInfoCmd()
		{
			byParam = PARA_ZHAN_XING_INFO_ZXCMD;
			lighthero = 0;
			sbpnum = lpnum = 0;
			silvervisittimes = 0;
            score = 0;
            bzero(mingli,sizeof(mingli));

		}
		BYTE lighthero;
		BYTE sbpnum;	//神兵包裹花钱开的格子数
		BYTE lpnum;		//不合成神兵包裹花钱开启的格子数
		WORD silvervisittimes;  //剩余银币探访次数
		DWORD score;    //积分
		DWORD mingli[3] //前中后军命力(0:前军 1:中军 2:后军)
	};*/