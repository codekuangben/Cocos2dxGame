package modulecommon.net.msg.propertyUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class stPickUpObjTypeNumberPropertyUserCmd extends stPropertyUserCmd 
	{
		public var type:uint;
		public var value:uint;
		public function stPickUpObjTypeNumberPropertyUserCmd() 
		{
			byParam = PICKUPOBJ_TYPE_NUMBER_PROPERTY_USRECMD;	//12
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			type = byte.readUnsignedByte();
			value = byte.readUnsignedInt();		
		}
		
	}

}

/*
 * //告诉客户端捡起掉落物品(各种钱)类型和数量，主角头上播放动画
    const BYTE PICKUPOBJ_TYPE_NUMBER_PROPERTY_USRECMD = 12; 
    struct stPickUpObjTypeNumberPropertyUserCmd : public stPropertyUserCmd
    {   
        stPickUpObjTypeNumberPropertyUserCmd()
        {   
            byParam = PICKUPOBJ_TYPE_NUMBER_PROPERTY_USRECMD;
        }   
        BYTE type; //参考掉率表类型字段:1银币(游戏币),2金币(绑定rmb),3元宝(充值rmb)
        DWORD value; //
    };
*/