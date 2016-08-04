package modulecommon.net.msg.propertyUserCmd
{
	/**
	 * ...刷新道具数量
	 * @author wangtianzhu
	 **/
	import flash.utils.ByteArray;
	
	public class stRefreshObjNumPropertyUserCmd extends stPropertyUserCmd
	{
		public var num:uint;
		public var thisid:uint;		
		public var isani:uint;
		public function stRefreshObjNumPropertyUserCmd()
		{
			byParam = REFRESH_OBJ_NUM_PROPERTY_USRECMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			num = byte.readUnsignedInt();
			thisid = byte.readUnsignedInt();	
			isani = byte.readUnsignedByte();
		}
	}
}/*const BYTE REFRESH_OBJ_NUM_PROPERTY_USRECMD = 13; 
    struct stRefreshObjNumPropertyUserCmd : public stPropertyUserCmd
    {   
        stRefreshObjNumPropertyUserCmd()
        {   
            byParam = REFRESH_OBJ_NUM_PROPERTY_USRECMD;
            num = 0;
            thisid = 0;
            ani = 0;
        }   
        DWORD num;
        DWORD thisid;
        BYTE isani; //默认:0播放动画 1:不播放动画 2:战斗结束后播放动画
    };  
*/