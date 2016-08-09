package modulecommon.net.msg.zhanXingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stLightHeroCmd extends stZhanXingCmd 
	{
		public var m_no:uint;
		public function stLightHeroCmd() 
		{
			super();
			byParam = PARA_LIGHT_HERO_ZXCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_no = byte.readUnsignedByte();
		}
		
	}

}

//返回点亮那一个武将
	/*const BYTE PARA_LIGHT_HERO_ZXCMD = 4;
	struct stLightHeroCmd : public stZhanXingCmd
	{
		stLightHeroCmd()
		{
			byParam = PARA_LIGHT_HERO_ZXCMD;
			num = 0;
		}
		BYTE num;	//武将编号
	};*/