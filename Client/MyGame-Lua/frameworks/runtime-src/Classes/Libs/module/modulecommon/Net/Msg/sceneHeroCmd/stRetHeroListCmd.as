package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	import modulecommon.scene.wu.WuProperty;
	public class stRetHeroListCmd extends stSceneHeroCmd 
	{
		public var datas:Array;
		public function stRetHeroListCmd() 
		{
			byParam = PARA_RET_HERO_LIST_USERCMD;
			datas = new Array();
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			var num:uint = byte.readUnsignedShort();
			var i:uint = 0;
			var obj:Object;
			var fData:t_HeroData;
			var list:Dictionary;
			while (i < num)
			{
				obj = new Object();
				fData = new t_HeroData();
				fData.deserialize(byte);				

				list = t_ItemData.readWidthNum(byte, WuProperty.PROPTYPE_MAX);
				
				obj.fData = fData;
				obj.list = list;
				datas.push(obj);
				i++;
			}
		}
		
	}

}

/*
 * const BYTE PARA_RET_HERO_LIST_USERCMD = 5;
	struct stRetHeroListCmd : public stSceneHeroCmd
	{
		stRetHeroListCmd()
		{
			byParam = PARA_RET_HERO_LIST_USERCMD;
			num = 0;
		}
		WORD num;
		struct{
			t_HeroData bdata;
			t_HeroVD vdata[PROPTYPE_MAX];
		}data[0];

		WORD getSize()
		{
			return sizeof(*this) + num*sizeof(data[0]);
		}
	};
*/