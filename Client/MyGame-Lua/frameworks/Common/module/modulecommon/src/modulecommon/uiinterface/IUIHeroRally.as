package modulecommon.uiinterface 
{
	import modulecommon.scene.herorally.FieldData;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IUIHeroRally extends IUIBase
	{
		function addDingshiqi():void
		function upDataBox(fieldnum:uint, bracketnum:uint):void
		function updataRecord(ispush:Boolean, arr:FieldData):void
		function upDataGroup():void
		function updataHalfImage():void
	}
	
}