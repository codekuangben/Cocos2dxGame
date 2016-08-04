package game.process
{
	import flash.utils.ByteArray;
	import modulecommon.ui.UIFormID;
	import modulecommon.GkContext;
	import modulecommon.net.msg.equip.stRemakeEquipCmd;
	import modulecommon.uiinterface.IUIEquipSys;
	
	/**
	 * ...
	 * @author 
	 */
	public class EquipProcess 
	{
		public var m_gkcontext:GkContext;
		
		public function EquipProcess(cont:GkContext):void
		{
			m_gkcontext = cont;
		}
		
		public function destroy():void
		{
			m_gkcontext = null;
		}
		
		public function process(msg:ByteArray, param:uint):void
		{
			//装备强化倒计时，该消息登陆时发送
			if (stRemakeEquipCmd.RET_EQUIP_ENCHANCE_COLD_USERCMD == param)
			{
				m_gkcontext.m_equipSysMgr.processEquipEnchanceColdUserCmd(msg);
				return;
			}
			
			// 装备界面如果没有加载就不处理
			var uiequip:IUIEquipSys = m_gkcontext.m_UIMgr.getForm(UIFormID.UIEquipSys) as IUIEquipSys;
			if (uiequip)
			{
				uiequip.parseServerMsg(msg, param);
			}
		}
	}
}