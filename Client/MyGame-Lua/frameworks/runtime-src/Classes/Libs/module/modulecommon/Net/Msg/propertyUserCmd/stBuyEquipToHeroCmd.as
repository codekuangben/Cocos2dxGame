package modulecommon.net.msg.propertyUserCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.prop.object.stObjLocation;
	/**
	 * ...
	 * @author 
	 */
	public class stBuyEquipToHeroCmd extends stPropertyUserCmd 
	{
		public var m_location:stObjLocation;		
		public function stBuyEquipToHeroCmd() 
		{
			super();
			byParam = PARA_BUY_EQUIP_TO_HERO_USERCMD;
			m_location = new stObjLocation();
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			m_location.serialize(byte);
		}		
	}

}

//购买装备并装备到武将身上
   /* const BYTE PARA_BUY_EQUIP_TO_HERO_USERCMD = 42; 
    struct stBuyEquipToHeroCmd : public stPropertyUserCmd
    {   
        stBuyEquipToHeroCmd()
        {   
            byParam = PARA_BUY_EQUIP_TO_HERO_USERCMD;
        }   
        stObjLocation dstloc;
    };*/