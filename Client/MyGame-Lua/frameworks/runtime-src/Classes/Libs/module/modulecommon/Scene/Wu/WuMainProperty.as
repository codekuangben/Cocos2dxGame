package modulecommon.scene.wu 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import modulecommon.net.msg.sceneUserCmd.stMainUserData;
	import modulecommon.net.msg.sceneUserCmd.stViewUserBaseData;
	//import modulecommon.net.msg.sceneUserCmd.stMainUserDataUserCmd;
	import modulecommon.GkContext;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.beings.PlayerMain;
	
	public class WuMainProperty extends WuProperty
	{		
		public var m_playerMain:PlayerMain;
		public var m_uZongZhanli:uint;	//总战力
		
		public function WuMainProperty(gk:GkContext):void
		{
			super(gk);
		}
		public function setByMainUserDataUserCmd(main:stMainUserData):void
		{
			s_setByMainUserDataUserCmd(this, main);
		}
		
		public static function s_setByMainUserDataUserCmd(wu:WuProperty, main:stMainUserData):void
		{
			wu.m_uHeroID = MAINHERO_ID;
			wu.m_uJob = main.job;
			wu.setChuzhan();
			wu.m_name = main.name;
			wu.m_uChief = main.chief;
			wu.m_uAttackSpeed = main.speed;
			//wu.m_uShiqi = main.shiqi;
			wu.m_uLevel = main.level;
			
			//wu.m_uBaoji = main.baoji;
			//wu.m_uBjDef = main.bjdef;
			//wu.m_uGedang = main.gedang;
			//wu.m_uFanji = main.strike_back;
			//wu.m_uBaoji = main.baoji;
			wu.m_uForce = main.force;
			wu.m_uIQ = main.iq;
			wu.m_uExp = main.exp;
			wu.m_uSoldierType = main.soldier_type;
			wu.m_uAttackSpeed = main.speed;
			//wu.m_uPoji = main.poji;
			wu.m_uHPLimit = main.soldierlimit;			
			wu.m_trainLevel = main.trainlevel;
			wu.m_trainPower = main.trainpower;
			wu.m_minor = main.minor;
		}
		public function setByMainUserDataUserCmdWatch(main:stViewUserBaseData):void
		{
			s_setByMainUserDataUserCmdWatch(this, main);
		}
		
		public static function s_setByMainUserDataUserCmdWatch(wu:WuProperty, main:stViewUserBaseData):void
		{
			wu.m_uHeroID = MAINHERO_ID;
			wu.m_uJob = main.job;
			wu.m_uLevel = main.level;
			wu.setChuzhan();
			wu.m_name = main.name;
			wu.m_uSoldierType = main.soldier_type;
		}
		
		override public function get zhanshuName():String
		{
			return m_gkContext.m_skillMgr.getName(zhanshuID);			
		}
		override public function get zhanshuID():uint
		{
			var ret:uint = m_gkContext.m_xingmaiMgr.curUsingXMSkillID;
			if (0 == ret)
			{
				ret = PlayerResMgr.toZhanshuID(m_uJob, m_playerMain.gender);
			}
			
			return ret;
		}
		
		override public function get halfingPathName():String
		{			
			return NpcBattleBaseMgr.composehalfingPathName(m_gkContext.m_context.m_playerResMgr.uiName(m_uJob, m_playerMain.gender));
		}	
	}

}