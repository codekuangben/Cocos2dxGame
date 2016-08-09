package modulecommon.logicinterface
{
	import modulecommon.net.msg.rankcmd.stRetCorpsLevelRankListUserCmd;
	import modulecommon.net.msg.rankcmd.stRetCorpsCombatPowerRankListUserCmd;
	import modulecommon.net.msg.rankcmd.stPersonlLevelRankListCmd;
	import modulecommon.net.msg.rankcmd.stPersonalZhanLiRankListCmd;

	/**
	 * @brief 排行榜系统
	 */
	public interface IRankSys 
	{
		function set corpsLevelRank(value:stRetCorpsLevelRankListUserCmd):void;
		function get corpsLevelRank():stRetCorpsLevelRankListUserCmd;
		function get corpsCombatRank():stRetCorpsCombatPowerRankListUserCmd;
		function set corpsCombatRank(value:stRetCorpsCombatPowerRankListUserCmd):void;
		
		function get personLevelRank():stPersonlLevelRankListCmd;
		function set personLevelRank(value:stPersonlLevelRankListCmd):void;
		function get personCombatRank():stPersonalZhanLiRankListCmd;
		function set personCombatRank(value:stPersonalZhanLiRankListCmd):void;
		
		function get corpsLevelRankLst():Array;
		function get corpsCombatRankLst():Array;
		
		function get personLevelRankList():Array;
		function get personCombatRankList():Array;
		function openRankAndToggleToPage(page:int):void;
		function get page():int;
		function set page(value:int):void;
		
		// 共享数据接口
		function get msbNoQuery():Boolean;		// 神秘商店获取是否询问消费元宝
		function set msbNoQuery(value:Boolean):void;	// 神秘商店设置
		
		function get objlist():Array;
		function set objlist(value:Array):void;
		
		function get bOpenPaoShang():Boolean;
		function set bOpenPaoShang(value:Boolean):void;
	}
}