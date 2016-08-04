package modulefight.scene.fight
{
	import modulefight.digitani.BBNameMgr;

	/**
	 * @brief 战斗所需要的全局数据
	 * */
	public interface IFightDB
	{
		function get moveVel():uint;		
		function get effVel():uint;
		function get bbNameMgr():BBNameMgr;
	}
}