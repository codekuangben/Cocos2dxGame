package modulecommon.game
{
	/**
	 * ...
	 * @author 
	 */
	
	import flash.utils.ByteArray;
	public interface IMFight
	{
		function init():void
		function handleFightUserCmd(msg:ByteArray, param:uint = 0):void
		function onBattleMapLoaded():void
		function leave():void
		function resetFight():void
		function get step():int
	}
}