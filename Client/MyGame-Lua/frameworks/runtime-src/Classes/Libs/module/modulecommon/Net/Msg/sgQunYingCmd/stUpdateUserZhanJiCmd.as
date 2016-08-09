package modulecommon.net.msg.sgQunYingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stUpdateUserZhanJiCmd extends stSGQunYingCmd 
	{
		public var m_userZhanJi:UserZhanJi;
		public function stUpdateUserZhanJiCmd() 
		{
			super();
			byParam = PARA_UPDATE_USER_ZHANJI_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_userZhanJi = new UserZhanJi();
			m_userZhanJi.deserialize(byte);
		}
		
	}

}/*//更新战绩
	const BYTE PARA_UPDATE_USER_ZHANJI_CMD = 8;
	struct stUpdateUserZhanJiCmd : public stSGQunYingCmd
	{
		stUpdateUserZhanJiCmd()
		{
			byParam = PARA_UPDATE_USER_ZHANJI_CMD;
		}
		UserZhanJi userzj;
	};*/