package modulecommon.uiinterface 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.teamUserCmd.synUserTeamStateCmd;

	/**
	 * ...
	 * @author ...
	 */
	public interface IUITeamFBSys extends IUIBase
	{
		function psretOpenMultiCopyUiUserCmd(msg:ByteArray):void;
		function psretClickMultiCopyUiUserCmd(msg:ByteArray):void;
		function psstNotifyTeamMemberListUserCmd():void;
		function openUI(formid:uint):void;
		function psnotifyTeamMemberLeaderChangeUserCmd():void;
		function psretInviteAddMultiCopyUiUserCmd(msg:ByteArray):void;
		function pssynUserTeamStateCmd(msg:synUserTeamStateCmd):void;
		function pstakeOffTeamMemberUserCmd():void;
		function psretOpenAssginHeroUiCopyUserCmd(msg:ByteArray):void;
		function psretChangeAssginHeroUserCmd(msg:ByteArray):void;
		function psretChangeUserPosUserCmd(msg:ByteArray):void;
		function addParam(strEventID:String, questID:uint, embranchmentId:uint):void;
		function psretFightHeroDataUserCmd(msg:ByteArray):void;
		function psretUserProfitInCopyUserCmd(type:int):void;
		function pssynCopyRewardExpUserCmd(msg:ByteArray):void;
		function psretTeamBossRankUserCmd(msg:ByteArray):void;
		function isUIReady():Boolean;
		function psstGainTeamAssistGiftUserCmd(msg:ByteArray):void;
		function psstRetTeamAssistInfoUserCmd(msg:ByteArray):void;
	}
}