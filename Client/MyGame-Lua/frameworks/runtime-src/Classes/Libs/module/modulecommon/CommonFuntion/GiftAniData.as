package modulecommon.commonfuntion
{
	import flash.utils.Dictionary;

	/**
	 * 礼包播放飞行的动画的数据,藏宝库动画数据
	 * */
	public class GiftAniData
	{
		// 藏宝库开箱子的时候,如果没有间隔限制可能会有我呢体,但是现在有间隔限制,因此还是可以放在这里面
		// 这些位置都是点击的时候记录的，这样比较方便
		public var m_dicObj:Dictionary;	// 存放每一个包裹的物品，以便领取奖励的时候飞行物品
		public var m_dicPos:Dictionary;	// 存放背包的位置信息
		public var m_giftState:uint;		// 礼包状态 0 : 不在领取状态 1 在领取状态中
		public var m_cbkState:uint;		// 藏宝库领取奖励状态	0 : 不在领取状态 1 在领取状态中 
		
		public function GiftAniData()
		{
			m_dicObj = new Dictionary();
			m_dicPos = new Dictionary();
		}
		
		public function clearData(lst:Vector.<String>):void
		{
			var key:String;
			for each(key in lst)
			{
				m_dicObj[key].length = 0;
				m_dicObj[key] = null;
				delete m_dicObj[key];
				
				m_dicPos[key].length = 0;
				m_dicPos[key] = null;
				delete m_dicPos[key];
			}
			lst.length = 0;
		}
	}
}