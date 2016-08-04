package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;

	public class UserHeroData
	{
		public var dwUserID:uint;
		public var size:uint;
		public var data:Vector.<HeroData>;
		
		public function deserialize(byte:ByteArray):void
		{
			dwUserID = byte.readUnsignedInt();
			size = byte.readUnsignedByte();
			
			data = new Vector.<HeroData>();
			
			var idx:int = 0;
			var item:HeroData;

			if(size)
			{
				while(idx < size)
				{
					item = new HeroData();
					item.deserialize(byte);
					data.push(item);
					
					++idx;
				}
			}
		}
	}
}

//struct UserHeroData {
//	DWORD dwUserID;
//	BYTE size;
//	HeroData data[0];
//};