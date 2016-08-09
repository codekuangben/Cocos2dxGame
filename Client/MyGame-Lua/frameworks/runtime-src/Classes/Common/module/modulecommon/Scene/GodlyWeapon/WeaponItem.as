package modulecommon.scene.godlyweapon 
{
	import com.util.UtilXML;
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	/**
	 * ...
	 * @author ...
	 * 各神兵数据
	 * t_ItemData中type值同 MountsAttr.as 中图鉴属性编号
	 */
	public class WeaponItem 
	{
		public var m_id:uint;			//编号
		public var m_name:String;		//名称
		public var m_objID:uint;		//对于的道具id
		public var m_loginDays:uint;	//登陆天数
		public var m_onlineTime:uint;	//在线时间(秒)
		public var m_zhanli:uint;		//战力
		public var m_effect:Vector.<t_ItemData>;	//加成属性
		public var m_image:String;		//图片
		public var m_desc:String;		//描述
		
		public function WeaponItem() 
		{
			m_effect = new Vector.<t_ItemData>();
		}
		
		public function parseXml(xml:XML):void
		{
			var str:String;
			var ar:Array;
			var i:int;
			var subAr:Array;
			var effItem:t_ItemData;
			
			m_id = parseInt(xml.@id);
			m_name = xml.@name;
			m_loginDays = parseInt(xml.@logindays);
			m_onlineTime = parseInt(xml.@onlinetime);
			m_zhanli = parseInt(xml.@zhanli);
			
			m_objID = UtilXML.attributeIntValue(xml, "objid");
			str = xml.@effect;
			if (null != str)
			{
				ar = str.split(":");
				for (i = 0; i < ar.length; i++)
				{
					subAr = ar[i].split("-");
					if (2 == subAr.length)
					{
						effItem = new t_ItemData();
						effItem.type = parseInt(subAr[0]);
						effItem.value = parseInt(subAr[1]);
						m_effect.push(effItem);
					}
				}
			}
			
			m_image = xml.@image;
			m_desc = xml.@desc;
		}
	}

}