package modulecommon.scene.godlyweapon 
{
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	/**
	 * ...
	 * @author ...
	 * 神兵技能
	 */
	public class SkillItem 
	{
		public var m_level:uint;	//等级
		public var m_explimit:uint;	//经验上限
		public var m_effect:Vector.<t_ItemData>;	//技能属性
		
		public function SkillItem() 
		{
			m_level = 0;
			m_explimit = 0;
			m_effect = new Vector.<t_ItemData>();
		}
		
		public function parseXml(xml:XML):void
		{
			var str:String;
			var ar:Array;
			var i:int;
			var subAr:Array;
			var effItem:t_ItemData;
			
			m_level = parseInt(xml.@id);
			m_explimit = parseInt(xml.@explimit);
			
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
			
		}
	}

}