package base 
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IStart 
	{
		function set uncaughtErrorHandler(fun:Function):void
		function get versionAllInfo():IVersionAllInfo;
		function getLog():String
	}
	
}