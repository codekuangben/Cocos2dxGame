package modulecommon.net.msg.propertyUserCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.prop.object.stObjLocation;
	/**
	 * ...
	 * @author 
	 */
	public class stReqBatchMoveObjPropertyUserCmd extends stPropertyUserCmd 
	{
		public var m_list:Vector.<stBatchObj>;
		public function stReqBatchMoveObjPropertyUserCmd() 
		{
			byParam = PARA_REQ_BATCH_MOVE_OBJ_PROPERTY_USERCMD;
			m_list = new Vector.<stBatchObj>();
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeShort(m_list.length );
			var i:int;
			for (i = 0; i < m_list.length; i++)
			{
				m_list[i].serialize(byte);
			}
			
		}
		public function push(thisID:uint, loc:stObjLocation):void
		{
			m_list.push(new stBatchObj(thisID, loc));
		}
		
	}

}
//批量道具
  /*  struct stBatchObj
    {   
        DWORD thisid;
        stObjLocation loc;    
    };
const BYTE PARA_REQ_BATCH_MOVE_OBJ_PROPERTY_USERCMD = 33; 
    struct stReqBatchMoveObjPropertyUserCmd() : public stPropertyUserCmd
    {   
        stReqBatchMoveObjPropertyUserCmd()
        {   
            byParam = PARA_REQ_BATCH_MOVE_OBJ_PROPERTY_USERCMD;
            num = 0;
        }   
        WORD num;
        stBatchObj objlist[0];
    }; */