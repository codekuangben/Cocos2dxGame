package modulecommon.net.msg.propertyUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetFreeLingPaiInfoCmd extends stPropertyUserCmd
	{
		public var buylptimes:uint;
		public var freelp:uint;
		
		public function stRetFreeLingPaiInfoCmd() 
		{
			byParam = PARA_RET_FREE_LINGPAI_INFO_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			buylptimes = byte.readUnsignedShort();
			freelp = byte.readUnsignedShort();
		}
	}

}
/*
//返回令牌购买、免费令牌领取信息
const BYTE PARA_RET_FREE_LINGPAI_INFO_USERCMD = 40; 
    struct stRetFreeLingPaiInfoCmd : public stPropertyUserCmd
    {   
        stRetFreeLingPaiInfoCmd()
        {   
            byParam = PARA_RET_FREE_LINGPAI_INFO_USERCMD;
            buylptimes = freelpnum = 0;
        }   
        WORD buylptimes;    //今日已购买令牌次数
        WORD freelp;        //今日已领取的令牌纪录 //byte位记录数据  第3位表示Vip3  第5位表示Vip5 1表示已领  0表示未领
    };  
*/