package modulecommon.uiinterface 
{
	
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public interface IUISanguoZhangchang  extends IUIBase
	{
		function processCmd(msg:ByteArray, param:uint):void	
		function updateAutoBtn():void		
	}
	
}