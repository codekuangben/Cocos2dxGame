package modulecommon.net.msg.mountscmd
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stTrainProp 
	{
		public var proptype:uint;
		public var proplevel:uint;
		public var explimt:uint;
		public var exp:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			proptype = byte.readUnsignedByte();
			proplevel = byte.readUnsignedInt();
			explimt = (proplevel + 1) * 25 - 15;
			//explimt = byte.readUnsignedInt();
			exp = byte.readUnsignedInt();
		}
		
		public function copyFrom(rh:stTrainProp):void
		{
			this.proptype = rh.proptype;
			this.proplevel = rh.proplevel;
			this.explimt = rh.explimt;
			this.exp = rh.exp;
		}
	}
}

//培养属性信息
//struct stTrainProp
//{   
	//BYTE proptype;
	//DWORD explimt;	// 现在这个是属性等级
	//DWORD exp;
//};