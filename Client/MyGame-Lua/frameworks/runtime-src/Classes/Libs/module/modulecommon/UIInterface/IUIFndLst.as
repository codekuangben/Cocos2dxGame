package modulecommon.uiinterface
{
	import flash.utils.ByteArray;
	public interface IUIFndLst extends IUIBase
	{
		function updateUI():void;
		function updateLst(type:uint):void;
		function updateSelfMood():void;
		function updateItemFndOnline(type:uint, idx:uint):void;
		function updateItemFndLvl(type:uint, idx:uint):void;
		function updateItemFndMood(type:uint, idx:uint):void;
		function updateItemFocus(type:uint, idx:uint):void;
		function delOne(type:uint, idx:uint):void;
		function addOne(type:uint, idx:int, data:Object):void;
		function process_stHelpFriendQBFriendCmd(msg:ByteArray):void
		function process_stRetHasHelpStateFriendListFriendCmd(msg:ByteArray):void
	}
}