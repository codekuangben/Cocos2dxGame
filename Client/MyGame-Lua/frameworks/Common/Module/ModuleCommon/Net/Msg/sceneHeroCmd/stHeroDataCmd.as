package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	public class stHeroDataCmd extends stSceneHeroCmd 
	{		
		public var heroid:uint;
		public var datas:Dictionary;
		public function stHeroDataCmd() 
		{
			byParam = PARA_HERO_DATA_USERCMD;
			datas = new Dictionary();
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			heroid = byte.readUnsignedInt();
			datas = t_ItemData.read(byte);			
		}
	}

}

/*
 * const BYTE PARA_HERO_DATA_USERCMD = 3;
	struct stHeroDataCmd : public stSceneHeroCmd
	{
		stHeroDataCmd()
		{
			byParam = PARA_HERO_DATA_USERCMD;
			num = 0;
		}
		WORD num;
		DWORD heroid;
		struct{
			WORD type;
			DWORD value;
		}data[0];
		WORD getSize()
		{
			return sizeof(*this) + num*sizeof(data[0]);
		}
	};
*/