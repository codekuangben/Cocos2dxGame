package modulecommon.logicinterface
{
	//import modulecommon.net.msg.copyUserCmd.UserDispatch;
	import modulecommon.net.msg.teamUserCmd.stTeamCmd;
	//import modulecommon.net.msg.copyUserCmd.DispatchHero;

	/**
	 * @brief 组队副本接口
	 * */
	public interface ITeamFBSys
	{
		function set buseNum(value:Boolean):void;
		function get buseNum():Boolean;

		function set bshowType(value:uint):void;
		function get bshowType():uint;
		
		function set clkBtn(value:Boolean):void;
		function get clkBtn():Boolean;
		
		function set teamMemInfo(value:stTeamCmd):void;
		function get teamMemInfo():stTeamCmd;
		
		function set inviterName(value:String):void;
		function get inviterName():String;
		
		function set copyname(value:String):void;
		function get copyname():String;
		
		function set copytempid(value:uint):void;
		function get copytempid():uint;
		
		function set teamid(value:uint):void;
		function get teamid():uint;
		
		function isGridOpen(gridNo:int):Boolean;
		
		function set bShowTip(value:Boolean):void;
		function get bShowTip():Boolean;
		
		function getGrids(NO:uint):uint;
		function enterIn():void;
		function leave():void;
		
		function get bInMap():Boolean;
		/*
		function set ud(value:Vector.<UserDispatch>):void;
		function get ud():Vector.<UserDispatch>;
		function psretChangeAssginHeroUserCmd(pos:uint, type:uint, dh:DispatchHero):int;
		function getRowWJCnt(row:int):int;
		function getAllWJCnt():int;
		*/
		
		function clearData():void;
		//function pickObj(serverX:uint, serverY:uint):void;
		function pickObj(thisid:uint):void;
		function psretUserProfitInCopyUserCmd(msg:Object):void;
		
		function set delMemID(value:uint):void;
		function get delMemID():uint;
		
		function get maxCountsFight():uint
		
		function set leftCounts(value:uint):void;
		function get leftCounts():uint;
		
		function get usecnt():int;
		function set usecnt(value:int):void;
		
		function getFBLevelByName(fbname:String):int;
		function get leftUseCnt():int;
		
		function get count():uint;
		function set count(value:uint):void;
		
		function get historyLayer_TeamBoss():int
		function set historyLayer_TeamBoss(value:int):void
		
		function get copyType():uint;
		function set copyType(value:uint):void;
		
		function isEqualCopyType(copytype:uint):Boolean;
		function get openHallMulMsg():Boolean;
		function set openHallMulMsg(value:Boolean):void;
		
		function get logCnt():int;
		function set logCnt(value:int):void;
	}
}