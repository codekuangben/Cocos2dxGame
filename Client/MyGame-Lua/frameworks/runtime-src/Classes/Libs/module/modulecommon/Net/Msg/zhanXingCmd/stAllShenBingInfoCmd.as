package modulecommon.net.msg.zhanXingCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.zhanxing.T_Star;
	/**
	 * ...
	 * @author ...
	 */
	public class stAllShenBingInfoCmd extends stZhanXingCmd 
	{
		public var m_list:Vector.<T_Star>;
		public function stAllShenBingInfoCmd() 
		{
			super();
			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_list = new Vector.<T_Star>();
			var num:uint = byte.readUnsignedShort();
			var i:uint = 0;
			var star:T_Star;
			for (i = 0; i < num; i++)
			{
				star = new T_Star();
				star.deserialize(byte);
				m_list.push(star);
			}
		}
	}

}

//所有神兵信息
	/*const BYTE PARA_ALL_SHENBING_INFO_ZXCMD = 2;
	struct stAllShenBingInfoCmd : public stZhanXingCmd
	{
		stAllShenBingInfoCmd()
		{
			byParam = PARA_ALL_SHENBING_INFO_ZXCMD;
		}
		WORD num;
		t_ShenBingData list[0];
		WORD getSize()
		{
			return (sizeof(*this) + num*sizeof(t_ShenBingData));
		}
	};*/