package modulecommon.uiinterface
{
	public interface IUIGZJJChallenge extends IUIBase
	{
		function addBtn(tmpid:uint, xpos:uint, ypos:uint, type:uint):void;
		function updateUIBtn():void;
		function removeBtn(tmpid:uint):void;
	}
}