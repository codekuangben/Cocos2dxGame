package modulefight.netmsg.stmsg 
{
	/**
	 * ...
	 * @author 
	 */
	import datast.ListPart;
	import flash.utils.ByteArray;
	
	public class TianfuPart extends ListPart
	{
		public function getTianfuDataBYPos(pos:int):stTianFuData
		{
			var item:stTianFuData;
			for each(item in m_list)
			{
				if (item.pos == pos)
				{
					return item;
				}
			}
			return null;
		}
	}

}