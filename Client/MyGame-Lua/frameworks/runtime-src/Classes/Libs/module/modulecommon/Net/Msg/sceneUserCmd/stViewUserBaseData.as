package modulecommon.net.msg.sceneUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	public class stViewUserBaseData 
	{
		public var job:uint;
		public var name:String;
		public var sex:uint;
		public var level:uint;
		public var soldier_type:uint;	
		public var userskill:uint;
		public function deserialize (byte:ByteArray) : void
		{	
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			job = byte.readUnsignedByte();
			sex = byte.readByte();
			level= byte.readUnsignedShort();
			soldier_type = byte.readUnsignedInt();
			userskill = byte.readUnsignedInt();
		}
		
	}

}

/*	struct stViewUserBaseData
    {    
        char name[MAX_NAMESIZE];
        BYTE job; 
        BYTE sex; 
		WORD level;
        DWORD soldier_type;
        DWORD userskill;
        stViewUserBaseData()
        {    
            bzero(name,sizeof(name));
            job = sex = 0; 
			level = 0; 
            soldier_type = userskill = 0; 
        }    
    };   
*/