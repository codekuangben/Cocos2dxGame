package modulefight.netmsg.stmsg 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import modulecommon.scene.wu.JinnangItem;
	public class stJNCastInfo 
	{
		public var round:int;
		public var aJNItem:JinnangItem;
		public var bJNItem:JinnangItem;
	   
		public function deserialize(byte:ByteArray):void
		{
			round = byte.readUnsignedByte();
			var aJNid:int = byte.readUnsignedInt();
			if (aJNid)
			{
				aJNItem = new JinnangItem();
				aJNItem.idLevel = aJNid;
			}
			aJNid = byte.readUnsignedInt();
			if (aJNid)
			{
				bJNItem = new JinnangItem();
				bJNItem.idLevel = aJNid;
			}
		}
		
		public function get jnNum():int
		{
			var ret:int=0;
			if (aJNItem)
			{
				ret++;
			}
			if (bJNItem)
			{
				ret++;
			}
			return ret;
		}
		
		public function getJNIdLevelBySide(side:uint):uint
		{
			if (side == 0)
			{
				if (aJNItem)
				{
					return aJNItem.idLevel;
				}
			}
			else
			{
				if (bJNItem)
				{
					return bJNItem.idLevel;
				}
			}
			return 0;
		}
		
	}

}

/*
 * //锦囊释放信息
    struct stJNCastInfo
    {
        BYTE  round;    //第几回合释放的	zero-based
        DWORD aJNid;    //a方锦囊id
        DWORD bJNid;    //b方锦囊id      
    };  

*/