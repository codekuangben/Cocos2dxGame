package modulefight.scene.fight.rank
{
	import com.pblabs.engine.core.ITickedObject;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.scene.fight.FightGrid;
	
	/**
	 * ...
	 * @author 
	 * @brief 战斗过程中每一次动作 
	 */
	public interface IRankFightAction extends ITickedObject
	{
		// 开始动作 
		function onEnter():void;
		// 结束动作  
		function onEnd():void;
		// 返回这个动作的类型   
		function actType():uint;
		// 释放资源 
		function dispose():void;
		// 查看格子是否在当前动作中	
		function get battleArray():BattleArray;
	}
}