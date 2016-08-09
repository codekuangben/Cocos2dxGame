package modulecommon.scene.benefithall.dailyactivities 
{
	/**
	 * ...
	 * @author ...
	 * 奖励
	 */
	public class Rewards 
	{
		public var m_value:uint;	//活跃度值、签到次数
		public var m_vecProps:Vector.<ItemProps>;	//道具
		public var m_bReceive:Boolean;	//是否已领取奖励 true已领取 false未领取
		
		public function Rewards() 
		{
			m_vecProps = new Vector.<ItemProps>();
			m_bReceive = false;
		}
		
		public function setDatas(value:uint, vec:Vector.<ItemProps>):void
		{
			m_value = value;
			for (var i:int = 0; i < vec.length; i++)
			{
				m_vecProps.push(vec[i]);
			}
		}
		
	}

}