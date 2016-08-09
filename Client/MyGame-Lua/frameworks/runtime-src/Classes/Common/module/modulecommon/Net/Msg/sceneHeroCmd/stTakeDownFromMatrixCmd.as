package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class stTakeDownFromMatrixCmd extends stSceneHeroCmd 
	{
		public var heroid:uint;
		public function stTakeDownFromMatrixCmd() 
		{
			byParam = PRAR_TAKEDOWN_FROM_MATRIX_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			heroid = byte.readUnsignedInt();			
		}
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(heroid);					
		}
	}

}

/*
 * //从阵法中取下一个武将
    const BYTE PRAR_TAKEDOWN_FROM_MATRIX_USERCMD = 12; 
    struct stTakeDownFromMatrixCmd : public stSceneHeroCmd
    {   
        stTakeDownFromMatrixCmd()
        {   
            byParam = PRAR_TAKEDOWN_FROM_MATRIX_USERCMD;
            heroid = 0;
        }   
        DWORD heroid;
    };
*/