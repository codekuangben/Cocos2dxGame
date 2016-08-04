package modulecommon.uiinterface
{
	import flash.utils.ByteArray;
	/**
	 * @brief 军团城市争夺战
	 */
	public interface IUICorpsCitySys extends IUIBase
	{
		function showCCSUI(formid:uint):void;
		function psnotifyBigMapDataUserCmd(byte:ByteArray):void;
		
		function psupdateFightJiFenDataUserCmd(msg:ByteArray):void;
		function psupdateCityDataUserCmd(msg:ByteArray):void;
		function psretOpenCityUserCmd(msg:ByteArray):void;
		function psnotifyZhanBaoUserCmd(msg:ByteArray):void;
		function psretAttackReviewListUserCmd(msg:ByteArray):void;
		function get bReady():Boolean;
		function toggleSceneUI(type:uint):void;
		function psnotifyRegCorpsFightUserCmd(msg:ByteArray):void;
		function psnotifyCorpsFightLastTimeUserCmd(msg:ByteArray):void;
	}
}