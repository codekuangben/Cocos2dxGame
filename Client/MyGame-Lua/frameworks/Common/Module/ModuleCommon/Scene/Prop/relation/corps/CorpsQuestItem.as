package modulecommon.scene.prop.relation.corps 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import com.util.UtilTools;
	public class CorpsQuestItem 
	{
		public var m_taskID:uint;
		public var m_name:String;
		
		public function deserialize(byte:ByteArray):void 
		{
			m_taskID = byte.readUnsignedInt();
			m_name = UtilTools.readStrEx(byte);
		}
	}

}

/*struct CorpsQuestItem
	{
		DWORD id;
		WORD size;
		char desc[0];
	};*/