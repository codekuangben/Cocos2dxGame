package modulecommon.scene.vip 
{
	/**
	 * ...
	 * @author ...
	 * 不同Vip等级段，特权数据
	 */
	public class PrivilegeValue 
	{
		public var viplevel:uint;	//对应Vip等级
		public var id:uint;			//vip.xml中不同特权项对应id
		public var value:uint;		//特权项对应特权值
		
		public function PrivilegeValue() 
		{
			
		}
		
		public function parseXml(xml:XML):void
		{
			id = parseInt(xml.@id);
			value = parseInt(xml.@value);
		}
		
	}

}