package modulecommon.uiinterface
{
	public interface IUIChatSystem extends IUIBase
	{
		function get psnChat():IPersonChat;
		function isUIReady():Boolean;
	}
}