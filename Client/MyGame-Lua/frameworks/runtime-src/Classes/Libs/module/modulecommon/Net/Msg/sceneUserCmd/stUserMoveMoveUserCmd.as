package modulecommon.net.msg.sceneUserCmd
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	/*
	const BYTE USERMOVE_MOVE_USERCMD_PARA = 4;
		struct stUserMoveMoveUserCmd : public stSceneUserCmd 
	{
			stUserMoveMoveUserCmd()
			{
				byParam = USERMOVE_MOVE_USERCMD_PARA;
			}

			DWORD dwUserTempID;      //< 用户临时编号 
			float x;          //*< 目的坐标 
			float y;
		};
		*/
		
	public class stUserMoveMoveUserCmd extends stSceneUserCmd
	{
		public var dwUserTempID:uint;		
		public var x:Number;
		public var y:Number;
		
		public function stUserMoveMoveUserCmd() 
		{
			super();
			byParam = SceneUserParam.USERMOVE_MOVE_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			dwUserTempID = byte.readUnsignedInt();			
			x = byte.readFloat();
			y = byte.readFloat();
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(dwUserTempID);			
			byte.writeFloat(x);
			byte.writeFloat(y);
		}
	}
}

//struct stUserMoveMoveUserCmd : public stSceneUserCmd 
//{
	//stUserMoveMoveUserCmd()
	//{
		//byParam = USERMOVE_MOVE_USERCMD_PARA;
	//}
//
	//DWORD dwUserTempID;      /**< 用户临时编号 */
	//BYTE byDirect;        /**< 移动方向 */
	//BYTE speed;		
	//float x;          /**< 目的坐标 */
	//float y;
//};