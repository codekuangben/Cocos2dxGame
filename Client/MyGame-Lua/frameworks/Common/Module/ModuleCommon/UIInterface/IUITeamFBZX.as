package modulecommon.uiinterface
{
	import com.bit101.components.Component;

	public interface IUITeamFBZX
	{
		function get id():uint;
		function updateAllWuZhanli():void;
		function get zhenfa():Component;
		
		function onLoadAllWuPropty():void;
		function onLoadZhenfaData():void;
		function get tip():Object;
	}
}