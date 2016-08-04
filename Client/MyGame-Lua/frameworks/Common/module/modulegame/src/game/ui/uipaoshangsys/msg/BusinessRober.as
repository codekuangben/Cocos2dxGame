package game.ui.uipaoshangsys.msg 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author ...
	 */
	public class BusinessRober
	{
		public var time:uint;
		public var name:String;
		public var lost:uint;
		
		public function deserialize(byte:ByteArray):void 
		{
			time = byte.readUnsignedInt();
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			lost = byte.readUnsignedInt();
		}
		
		public function serialize(byte:ByteArray):void 
		{
			byte.writeUnsignedInt(time);
			UtilTools.writeStr(byte, name, EnNet.MAX_NAMESIZE);
			byte.writeUnsignedInt(lost);
		}
	}
}

//struct BusinessRober {
	//BusinessRober( void ):time(0),lost(0){
		//bzero(name, MAX_NAMESIZE);
	//}
	//DWORD time;
	//char name[MAX_NAMESIZE];
	//DWORD lost; //损失银币
//};