package modulecommon.net.msg.xingMaiCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stXingMaiUIInfoXMCmd extends stXingMaiCmd
	{
		public var m_xingli:uint;		//星力
		public var m_curSkillID:uint;	//当前使用中技能id
		public var m_attrList:Vector.<stAttrInfo>;	//属性列表  总共有6个属性
		public var m_skillsList:Array;				//激活技能列表
		
		public function stXingMaiUIInfoXMCmd() 
		{
			byParam = PARA_XINGMAI_UIINFO_XMCMD;
			m_attrList = new Vector.<stAttrInfo>(6);
			m_skillsList = new Array();
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_xingli = byte.readUnsignedInt();
			m_curSkillID = byte.readUnsignedInt();
			
			var i:int;
			for (i = 0; i < 6; i++)
			{
				m_attrList[i] = new stAttrInfo();
				m_attrList[i].deserialize(byte);
			}
			
			var num:int = byte.readUnsignedShort();
			var skillItem:stSkillActive;
			for (i = 0; i < num; i++)
			{
				skillItem = new stSkillActive();
				skillItem.deserialize(byte);
				
				m_skillsList.push(skillItem);
			}
		}
	}

}

/*
	//上线发送觉醒界面数据
	const BYTE PARA_XINGMAI_UIINFO_XMCMD = 1;
	struct stXingMaiUIInfoXMCmd : public stXingMaiCmd
	{
		stXingMaiUIInfoCmd()
		{
			byParam = PARA_XINGMAI_UIINFO_XMCMD;
			xingli = curskillid = 0;
			bzero(attrlist,sizeof(attrlist));
			num = 0;
		}
		DWORD xingli;
		DWORD curskillid;	//当前使用的skillid
		stAttrInfo attrlist[6];
		WORD num;
		stSkillActive skills[0];
	};
*/