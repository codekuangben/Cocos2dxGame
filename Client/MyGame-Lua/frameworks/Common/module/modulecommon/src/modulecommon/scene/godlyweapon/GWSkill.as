package modulecommon.scene.godlyweapon 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 * 神兵技能——天下号令
	 */
	public class GWSkill 
	{
		public static const GWSP_FRONTHPLIMIT:int = 1;	//前军兵力
		public static const GWSP_CENTERHPLIMIT:int = 2;	//中军兵力
		public static const GWSP_BACKHPLIMIT:int = 3;	//后军兵力
		/*enum eGodlyWeaponSkillProp
		{
			GWSP_FRONTHPLIMIT = 1,  //前军兵力
			GWSP_CENTERHPLIMIT = 2, //中军兵力
			GWSP_BACKHPLIMIT = 3,   //后军兵力
			GWSP_MAX,
		};*/
		
		public var m_greenbjper:uint;	//绿魂培养暴击率
		public var m_bluebjper:uint;	//蓝魂培养暴击率
		public var m_ybbjper:uint;	//元宝培养暴击率
		public var m_dicSkill:Dictionary;
		public var m_maxLevel:uint;
		
		public function GWSkill() 
		{
			m_dicSkill = new Dictionary();
			m_maxLevel = 0;
		}
		
		public function parseXml(xml:XML):void
		{
			m_greenbjper = parseInt(xml.@greenbjper);
			m_bluebjper = parseInt(xml.@bluebjper);
			m_ybbjper = parseInt(xml.@ybbjper);
			
			var xmlList:XMLList = xml.child("level");
			var itemXml:XML;
			var skillitem:SkillItem;
			
			for each(itemXml in xmlList)
			{
				skillitem = new SkillItem();
				skillitem.parseXml(itemXml);
				m_dicSkill[skillitem.m_level] = skillitem;
				
				m_maxLevel++;
			}
		}
		
		public function getSkillItemByLevel(level:uint):SkillItem
		{
			return m_dicSkill[level];
		}
		
		public static function getAttrStr(type:int):String
		{
			var ret:String;
			
			switch(type)
			{
				case GWSP_FRONTHPLIMIT:
					ret = "前军兵力";
					break;
				case GWSP_CENTERHPLIMIT:
					ret = "中军兵力";
					break;
				case GWSP_BACKHPLIMIT:
					ret = "后军兵力";
					break;
				default:
					ret = "";
			}
			
			return ret;
		}
	}

}