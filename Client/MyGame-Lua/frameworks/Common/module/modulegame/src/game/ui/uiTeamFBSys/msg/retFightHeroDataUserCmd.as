package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class retFightHeroDataUserCmd extends stCopyUserCmd
	{
		public var size:uint;
		public var data:Vector.<UserHeroData>;
		
		public function retFightHeroDataUserCmd()
		{
			super();
			byParam = stCopyUserCmd.RET_FIGHT_HERO_DATA_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			size = byte.readUnsignedByte();
			data = new Vector.<UserHeroData>();
			
			var item:UserHeroData;
			var idx:uint;
			if(size)
			{
				while(idx < size)
				{
					item = new UserHeroData();
					item.deserialize(byte);
					data.push(item);
					
					++idx;
				}
			}
		}
		
		public function mergeOther(other:retFightHeroDataUserCmd):void
		{
			this.size += other.size;
			this.data = this.data.concat(other.data);
		}
	}
}

//返回出战武将基本信息 s->c 
//const BYTE RET_FIGHT_HERO_DATA_USERCMD = 57;
//struct retFightHeroDataUserCmd : public stCopyUserCmd
//{
//	retFightHeroDataUserCmd()
//	{
//		byParam = RET_FIGHT_HERO_DATA_USERCMD;
//	}   
//	BYTE size; 
//	UserHeroData data[0];
//};