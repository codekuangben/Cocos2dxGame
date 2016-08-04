package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;

	public class HeroData
	{
		public var id:uint;
		public var zhanli:uint;
		public var speed:uint;
		public var active:uint;
		
		// 客户端使用的排序 id
		public var m_sortID:int = 0;
		
		public function deserialize(byte:ByteArray):void
		{
			id = byte.readUnsignedInt();
			zhanli = byte.readUnsignedInt();
			speed = byte.readUnsignedInt();
			active = byte.readUnsignedByte();
		}
	}
}

//struct HeroData {
//	DWORD id; //合成id;
//	DWORD zhanli; //战力
//	DWORD speed; //出手速度
//	BYTE active; //激活
//};