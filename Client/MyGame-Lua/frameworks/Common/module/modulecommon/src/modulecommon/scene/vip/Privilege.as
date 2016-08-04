package modulecommon.scene.vip 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Privilege 
	{
		public var id:uint;		//特权编号
		public var title:String;	//显示的小标题
		
		public function Privilege() 
		{
			title = "";
		}
		
		public function parseXml(xml:XML):void
		{
			id = parseInt(xml.@id);
			title = xml.@title;
		}
	}

}