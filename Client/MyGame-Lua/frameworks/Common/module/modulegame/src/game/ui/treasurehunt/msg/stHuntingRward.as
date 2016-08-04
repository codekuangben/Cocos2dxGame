package game.ui.treasurehunt.msg 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stHuntingRward 
	{
		public var id:uint;
		public var type:uint;
		public var upgrade:uint;
		public var num:uint;
		public function deserialize(byte:ByteArray):void
		{
			id = byte.readUnsignedInt();
			type = byte.readUnsignedShort();
			upgrade = byte.readUnsignedShort();
			num = byte.readUnsignedInt();
		}
		
		public function get picNO():int
		{
			return Math.floor(type / 10);
		}
		public function get rewardType():int
		{
			return Math.floor(type % 10);
		}
		
	}

}
/*struct stHuntingRward
    {
        DWORD id;
        WORD type;  //个位:1道具类 2:武将类 3:代币类 十位以上图片编号
        WORD upgrade;
        DWORD num;
        stHuntingRward()
        {
            id = 0;
            type = upgrade = num = 0;
        }
    };*/