package datast.reuse 
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IObjectForReuse 
	{
		function set funReserveSelf(fun:Function):void
		function initData(param:Object = null):void
		function dispose():void
	}
	
}