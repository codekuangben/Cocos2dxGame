package modulecommon.net.msg.propertyUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	import modulecommon.scene.prop.object.stObjLocation;
	public class stSplitObjPropertyUserCmd extends stPropertyUserCmd 
	{
		public var srcthisid:uint;
		public var dstthisid:uint;
		public var num:uint;
		public var pos:stObjLocation;
		public function stSplitObjPropertyUserCmd() 
		{
			byParam = SPLITOBJ_PROPERTY_USRECMD;
			pos = new stObjLocation();
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			srcthisid = byte.readUnsignedInt();		
			dstthisid = byte.readUnsignedInt();	
			num = byte.readUnsignedInt();	
			pos.deserialize(byte);
		}
		
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);			
			byte.writeInt(srcthisid);
			byte.writeInt(dstthisid);
			byte.writeInt(num);
			pos.serialize(byte);	
		}
	}

}

/*
 * //分拆物品
	const BYTE SPLITOBJ_PROPERTY_USRECMD = 6;
	struct stSplitObjPropertyUserCmd : public stPropertyUserCmd
	{
		stSplitObjPropertyUserCmd()
		{
			byParam = SPLITOBJ_PROPERTY_USRECMD;
		}
		DWORD srcthisid;	//待拆分物品thisid
		DWORD dstthisid;	//拆分后物品thisid
		DWORD num;	//分拆的数量
		stObjLocation pos;	//拆分物品放的位置
	};
*/