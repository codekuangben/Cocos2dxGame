package modulecommon.net.msg.propertyUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stBatchMoveObjActionUserCmd extends stPropertyUserCmd 
	{
		public var m_action:int;
		public function stBatchMoveObjActionUserCmd() 
		{
			super();
			byParam = PARA_BATCH_MOVE_OBJ_ACTION_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_action = byte.readUnsignedByte();
		}
	}

}

/*const BYTE PARA_BATCH_MOVE_OBJ_ACTION_USERCMD = 43; 
    struct stBatchMoveObjActionUserCmd : public stPropertyUserCmd
    {   
        stBatchMoveObjActionUserCmd()
        {   
            byParam = PARA_BATCH_MOVE_OBJ_ACTION_USERCMD;
            action = 0;
        }   
        BYTE action;    //0:移动前  1:移动结束
    };*/ 