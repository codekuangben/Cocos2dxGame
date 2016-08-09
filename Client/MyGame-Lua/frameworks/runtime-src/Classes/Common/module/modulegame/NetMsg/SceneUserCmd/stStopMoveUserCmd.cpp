package game.netmsg.sceneUserCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author 
	 */
	//s->c 停止移动
	/*const BYTE STOP_MOVE_USERCMD_PARA = 32; 
	struct stStopMoveUserCmd : public stSceneUserCmd
	{   
		stStopMoveUserCmd()
		{   
			byParam = STOP_MOVE_USERCMD_PARA;
		}   
	};  */
	
	public class stStopMoveUserCmd extends stSceneUserCmd
	{
		
		public function stStopMoveUserCmd() 
		{
			super();
			byParam = SceneUserParam.STOP_MOVE_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
		}	
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
		}
	}
}