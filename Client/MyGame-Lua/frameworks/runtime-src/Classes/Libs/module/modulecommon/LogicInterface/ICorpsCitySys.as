package modulecommon.logicinterface
{
	/**
	 * @brief 军团城市系统
	 * */
	public interface ICorpsCitySys
	{
		function get inScene():Boolean;
		function set inScene(value:Boolean):void;
		//function inATime():Boolean;
		
		function get inActive():Boolean;
		function set inActive(value:Boolean):void;
	}
}