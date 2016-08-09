package modulecommon.uiinterface
{
	import modulecommon.scene.infotip.InfoTip;

	public interface IUIInfoTip extends IUIBase
	{
		function addBtn(item:InfoTip):void;
		function delBtn(eidx:uint):void;
	}
}