package game.ui.herorally.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sgQunYingCmd.stSGQunYingCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stViewUserZhanJiCmd extends stSGQunYingCmd 
	{
		public var m_zhanjiId:uint;
		public function stViewUserZhanJiCmd() 
		{
			super();
			byParam = stSGQunYingCmd.PARA_VIEW_USER_ZHANJI_CMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(m_zhanjiId);
		}
		
	}

}/*	//查看战绩
	const BYTE PARA_VIEW_USER_ZHANJI_CMD = 9;
	struct stViewUserZhanJiCmd : public stSGQunYingCmd
	{
		stViewUserZhanJiCmd()
		{
			byParam = PARA_VIEW_USER_ZHANJI_CMD;
			zjid = 0;
		}
		DWORD zjid;
	};*/