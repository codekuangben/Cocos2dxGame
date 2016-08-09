package modulecommon.scene.prop.table 
{
	/**
	 * ...
	 * @author ...
	 */
	//import adobe.utils.CustomActions;
	import flash.utils.ByteArray;
	public class TZhanxingNumberItem extends TDataItem 
	{
		public var m_baseValue:int;
		public var m_valueList:Vector.<uint>;
		override public function parseByteArray(bytes:ByteArray):void 
		{
			super.parseByteArray(bytes);			
			m_baseValue = bytes.readUnsignedInt();
			var i:int;
			m_valueList = new Vector.<uint>(10);
			m_valueList[0]=bytes.readUnsignedShort();
			for (i = 1; i < 10; i++)
			{
				m_valueList[i]=bytes.readUnsignedInt();
			}			
		}
		
	}

}