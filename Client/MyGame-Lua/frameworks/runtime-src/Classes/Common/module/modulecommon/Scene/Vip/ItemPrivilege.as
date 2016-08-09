package modulecommon.scene.vip 
{
	/**
	 * ...
	 * @author ...
	 * vip特权项
	 */
	public class ItemPrivilege 
	{
		public var id:uint;			//特权项编号
		public var image:String;	//icon名
		public var desc:String;		//详细描述说明
		
		public function ItemPrivilege() 
		{
			image = "";
			desc = "";
		}
		
		public function parseXml(xml:XML):void
		{
			id = parseInt(xml.@id);
			image = xml.@image;
			desc = xml.@desc;
		}
	}

}