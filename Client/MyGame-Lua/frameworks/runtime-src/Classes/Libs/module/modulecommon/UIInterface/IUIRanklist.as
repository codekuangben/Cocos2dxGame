package modulecommon.uiinterface
{
	import modulecommon.net.msg.rankcmd.stRetCorpsLevelRankListUserCmd;
	import modulecommon.net.msg.rankcmd.stRetCorpsCombatPowerRankListUserCmd;
	import modulecommon.net.msg.rankcmd.stPersonlLevelRankListCmd;
	import modulecommon.net.msg.rankcmd.stPersonalZhanLiRankListCmd;

	/**
	 * @brief 排行榜
	 */
	public interface IUIRanklist extends IUIBase
	{
		function isResReady():Boolean;
		function psstRetCorpsLevelRankListUserCmd(msg:stRetCorpsLevelRankListUserCmd):void;
		function psstRetCorpsCombatPowerRankListUserCmd(msg:stRetCorpsCombatPowerRankListUserCmd):void;
		function psstPersonlLevelRankListCmd(msg:stPersonlLevelRankListCmd):void;
		function psstPersonalZhanLiRankListCmd(msg:stPersonalZhanLiRankListCmd):void;
		function openRankAndToggleToPage(page:int):void;
	}
}