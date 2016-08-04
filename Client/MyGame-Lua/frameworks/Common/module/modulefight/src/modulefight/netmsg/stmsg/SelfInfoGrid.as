package modulefight.netmsg.stmsg 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public class SelfInfoGrid 
	{
		public var gridNO:int;
		public var curHP:int;
		public var curShiqi:int;
		public var hpList:Dictionary;
		public var buffer:stEntryState;		
		
		public function addDef(def:DefList):void
		{
			curHP = def.curHp;
			curShiqi = def.curShi;
			if (def.bufferPart.m_list.length)
			{
				buffer = def.bufferPart.m_list[0];
			}
			
			if (hpList == null)
			{
				hpList = new Dictionary();
			}
			
			var i:int;
			var pv:PkValue;
			var pvThis:PkValue;
			for (i = 0; i < def.pvPart.m_list.length; i++)
			{
				pv = def.pvPart.m_list[i];
				pvThis = hpList[pv.type];
				if (pvThis == null)
				{
					pvThis = new PkValue();
					pvThis.type = pv.type;
					pvThis.value = pv.value;
					hpList[pvThis.type] = pvThis;
				}
				else
				{
					pvThis.value += pv.value;
				}				
			}						
		}
	
	}

}