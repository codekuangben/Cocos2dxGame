package modulecommon.scene.vip 
{
	/**
	 * ...
	 * @author ...
	 */
	public class ItemVipLevel 
	{
		public var viplevel:uint;	//vip等级
		public var vipscor:uint;	//vip积分zhi
		public var tequanList:Array;	//当前vip等级段特权项
		
		public function ItemVipLevel() 
		{
			tequanList = new Array();
		}
		
		public function parseXml(xml:XML):void
		{
			viplevel = parseInt(xml.@level);
			vipscor = parseInt(xml.@vipjifen);
			
			var list:XMLList = xml.child("tequan");
			var privilege:Privilege;
			for each(var item:XML in list)
			{
				privilege = new Privilege();
				privilege.parseXml(item);
				tequanList.push(privilege);
			}
			
		}
		
	}

}