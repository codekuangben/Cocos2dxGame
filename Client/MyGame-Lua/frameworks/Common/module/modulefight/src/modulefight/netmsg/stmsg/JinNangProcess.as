package modulefight.netmsg.stmsg 
{
	/**
	 * ...
	 * @author 
	 * 这是客户端自己定义的结构，stRound对象中的m_jinnangProcess可能会引用这个对象
	 * 如果引用，则表示本回合有锦囊需要处理
	 * 如果没有，则表示本回合没有锦囊需要处理
	 */
	public class JinNangProcess 
	{
		public var m_JNCastInfo:stJNCastInfo;
		public var m_battleArray:BattleArray;
		public var m_fightIdx:int;		// 战斗序列中,每一个战斗唯一标示
		
		public function JinNangProcess() 
		{
			
		}
	}
}