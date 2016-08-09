package modulecommon.scene.prop.table 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;	
	public class TWJZhanliItem extends TDataItem 
	{
		public var m_zhanliLimit:int;	//武将（包括玩家）战力上限值。该值随等级变化。
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			m_zhanliLimit = bytes.readInt();
		}
		
	}

}