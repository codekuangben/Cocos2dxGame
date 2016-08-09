package modulecommon.scene.watch 
{
	import modulecommon.net.msg.sceneUserCmd.stViewUserBaseData;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.wu.WuMainProperty;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author 
	 */
	public class WuMainProperty_Watch extends WuProperty 
	{
 		public var m_uGender:uint;
		public var m_uZongZhanli:uint;	//总战力
		public var m_userSkillID:uint;	//技能
		
		public function WuMainProperty_Watch(gk:GkContext) 
		{
			super(gk);
		}
		public function setByMainUserDataUserCmd(main:stViewUserBaseData):void
		{
			WuMainProperty.s_setByMainUserDataUserCmdWatch(this, main);
			m_uGender = main.sex;
		}
		override public function get zhanshuName():String
		{
			return m_gkContext.m_skillMgr.getName(zhanshuID);			
		}
		override public function get zhanshuID():uint
		{
			return m_userSkillID;
		}
		
		override public function get halfingPathName():String
		{			
			return NpcBattleBaseMgr.composehalfingPathName(m_gkContext.m_context.m_playerResMgr.uiName(m_uJob, m_uGender));
		}
	}

}