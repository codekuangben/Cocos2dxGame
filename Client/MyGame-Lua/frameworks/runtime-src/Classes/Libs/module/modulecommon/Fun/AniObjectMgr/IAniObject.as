package modulecommon.fun.aniObjectMgr 
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IAniObject 
	{
		function set mgr(mgr:AniObjectMgr):void;	
		function hide():void;
		function get hasParent():Boolean;
		function dispose():void;
		function comeToBuffer():void;
	}
	
}