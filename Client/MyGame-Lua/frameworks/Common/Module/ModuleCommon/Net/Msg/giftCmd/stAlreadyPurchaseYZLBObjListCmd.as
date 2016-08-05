package modulecommon.net.msg.giftCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stAlreadyPurchaseYZLBObjListCmd extends stGiftCmd 
	{
		public var m_list:Vector.<uint>;
		public function stAlreadyPurchaseYZLBObjListCmd() 
		{
			super();
			byParam = PARA_ALREADY_PURCHASE_YZLB_OBJLIST_CMD;
		}
	override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			
			m_list = new Vector.<uint>();
			var num:int = byte.readUnsignedShort();
			var i:int;
			var data:uint;
			for (i = 0; i < num; i++)
			{
				data = byte.readUnsignedShort();
				m_list.push(data);
			}
		}
	}

}

//一折礼包已购买的物品
   /* const BYTE PARA_ALREADY_PURCHASE_YZLB_OBJLIST_CMD = 22; 
    struct stAlreadyPurchaseYZLBObjListCmd : public stGiftCmd
    {   
        stAlreadyPurchaseYZLBObjListCmd()
        {   
            byParam = PARA_ALREADY_PURCHASE_YZLB_OBJLIST_CMD;
            num = 0;
        }   
        WORD num;
        WORD objlist[0];	//千位百位: 标签编号 十位个位:物品唯一编号
        WORD getSize()
        {   
            return (sizeof(*this) + num*sizeof(WORD));
        }   
    }; */