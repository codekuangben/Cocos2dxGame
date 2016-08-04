package game.ui.uibackpack.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	
	/**
	 * ...
	 * @author 
	 * 售出道具
	 */
	public class stSaleObjPropertyUserCmd extends stPropertyUserCmd 
	{		
		public var m_list:Vector.<stObjSaleInfo>;
		public function stSaleObjPropertyUserCmd() 
		{
			byParam = PARA_SALE_OBJ_PROPERTY_USERCMD;
			m_list = new Vector.<stObjSaleInfo>();
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeShort(m_list.length);
			var i:int;
			for (i = 0; i < m_list.length; i++)
			{
				m_list[i].serialize(byte);
			}
			
		}
	}

}

/*const BYTE PARA_SALE_OBJ_PROPERTY_USERCMD = 34; 
    struct stSaleObjPropertyUserCmd : public stPropertyUserCmd
    {   
        stSaleObjPropertyUserCmd()
        {   
            byParam = PARA_SALE_OBJ_PROPERTY_USERCMD;
            num = 0;
        }   
        WORD num;
        stObjSaleInfo salelist[0];
    };*/