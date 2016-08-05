package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stJiuGuanHeroListCmd extends stSceneHeroCmd
	{
		public var list:Vector.<uint>;
		public function stJiuGuanHeroListCmd() 
		{
			byParam = PARA_JIUGUAN_HEROLIST_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			var num:uint = byte.readUnsignedShort();
			list = new Vector.<uint>(num);
			for (var i:uint = 0; i < num; i++)
			{
				list[i] = byte.readUnsignedShort();
			}
		}
	}

}

/*
///上线发送酒馆武将列表
	const BYTE PARA_JIUGUAN_HEROLIST_USERCMD = 18;
	struct stJiuGuanHeroListCmd : public stSceneHeroCmd
	{
		stJiuGuanHeroListCmd()
		{
			byParam = PARA_JIUGUAN_HEROLIST_USERCMD;
			num = 0;
		}
		WORD num;
		WORD list[0];	//武将id列表(合成id)
		WORD getSize()
		{
			return (sizeof(*this) + num*sizeof(WORD));
		}
	};

*/