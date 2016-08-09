package modulecommon.net.msg.propertyUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import modulecommon.scene.prop.object.stObjLocation;
	import flash.utils.ByteArray;
	public class stBatchObj 
	{
		public var m_thisID:uint;
		public var m_dst:stObjLocation;
		public function stBatchObj(thisID:uint, dst:stObjLocation) 
		{
			m_thisID = thisID;
			m_dst = dst;
		}
		public function serialize(byte:ByteArray):void 
		{
			byte.writeUnsignedInt(m_thisID);
			m_dst.serialize(byte);	
		}
	}

}

 /*  struct stBatchObj
    {   
        DWORD thisid;
        stObjLocation loc;    
    };*/