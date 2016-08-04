package modulecommon.net.msg.zhanXingCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.zhanxing.T_Star;
	/**
	 * ...
	 * @author ...
	 */
	public class stAddShenBingCmd extends stZhanXingCmd 
	{
		public static const SBACTION_OPTAIN:int = 0;//获得神兵
		public static const SBACTION_REFRESH:int = 1;//刷新神兵
		
		public var m_action:int;
		public var heronum:int;
		public var m_star:T_Star;
		public function stAddShenBingCmd() 
		{
			super();
			byParam = PARA_ADD_SHENBING_ZXCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_action = byte.readUnsignedByte();
			heronum = byte.readUnsignedByte();
			m_star = new T_Star();
			m_star.deserialize(byte);
		}
		
	}

}

//获得一个神兵
	/*const BYTE PARA_ADD_SHENBING_ZXCMD = 5;
	struct stAddShenBingCmd : public stZhanXingCmd
	{
		stAddShenBingCmd()
		{
			byParam = PARA_ADD_SHENBING_ZXCMD;
			action = 0;
		}
		BYTE action;
		BYTE heronum;
		t_ShenBingData shenbing;
	};*/