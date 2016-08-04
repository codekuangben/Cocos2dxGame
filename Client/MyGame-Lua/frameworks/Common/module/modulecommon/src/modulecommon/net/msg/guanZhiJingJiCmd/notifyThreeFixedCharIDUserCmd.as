package modulecommon.net.msg.guanZhiJingJiCmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.guanZhiJingJiCmd.stGuanZhiJingJiCmd;

	public class notifyThreeFixedCharIDUserCmd extends stGuanZhiJingJiCmd
	{
		public var text:Vector.<CharItem>;

		public function notifyThreeFixedCharIDUserCmd()
		{
			byParam = stGuanZhiJingJiCmd.NOTIFY_THREE_FIXED_CHARID_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			text ||= new Vector.<CharItem>(3, true);
			var item:CharItem;
			var idx:uint = 0;
			while(idx < 3)
			{
				item = new CharItem();
				item.deserialize(byte);
				text[idx] = item;
				++idx;
			}
		}
	}
}

//三个固定对手信息
//const BYTE NOTIFY_THREE_FIXED_CHARID_USERCMD = 15; 
//struct notifyThreeFixedCharIDUserCmd: public stGuanZhiJingJiCmd
//{   
//	notifyThreeFixedCharIDUserCmd()
//	{   
//		byParam = NOTIFY_THREE_FIXED_CHARID_USERCMD;
//	}   
//	CharItem text[3];
//};