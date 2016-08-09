package modulecommon.scene.dazuo 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import modulecommon.commonfuntion.ConfirmInputRelevantData;
	import modulecommon.GkContext;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author ...
	 */
	public class UIBuyFuyouExp 
	{
		private var m_gkContext:GkContext;
		private var m_dazuoMgr:DaZuoMgr;
		private var m_tempID:uint;	//购买浮游经验晚间tempid
		private var m_buyTime:uint;	//确认购买浮游时间
		
		public function UIBuyFuyouExp(gk:GkContext, mgr:DaZuoMgr) 
		{
			m_gkContext = gk;
			m_dazuoMgr = mgr;
		}
		
		public function showOtherPlayerList(list:Array):void
		{
			
		}
		
		public function showBuyFuyouExpPromp(id:uint, t:uint):void
		{
			m_tempID = id;
			
			var leftbuycounts:uint = m_dazuoMgr.leftBuyTimeCounts;
			var time:uint = Math.floor(t / 60);
			time = (time < leftbuycounts)? time: leftbuycounts;
			
			var desc:String = "您可购买浮游经验     小时，\n获得        经验，需要花费    元宝。";
			desc += "\n(今日";
			if (m_gkContext.m_dazuoMgr.m_buyCounts)
			{
				desc += "还";
			}
			desc += "可购买 " + leftbuycounts + " 小时)";
			
			var rect:Rectangle = new Rectangle(124, -2, 36, 24);
			var labelRelevantData:ConfirmInputRelevantData = new ConfirmInputRelevantData(new Point(60, 23), getBuyExp, UtilColor.GREEN);
			var label2RelevantData:ConfirmInputRelevantData = new ConfirmInputRelevantData(new Point(213, 23), getPayYuanbao, UtilColor.GREEN);
			var confirmText:String = "确认购买";
			
			if (0 == m_gkContext.m_beingProp.vipLevel)
			{
				desc += "Vip1可购买";
				confirmText = "成为Vip1";
				time = 0;
			}
			
			m_gkContext.m_confirmDlgMgr.showModeInput(0, "浮游经验购买", desc, cancelFn, confirmFn, "离开", confirmText, rect, 1, time, time, labelRelevantData, label2RelevantData);
		}
		
		//经验 =（等级*等级+等级*10）/10*挂机分钟
		private function getBuyExp(value:uint):int
		{
			var ret:int;
			var level:int = 0;
			if (m_gkContext.playerMain)
			{
				level = m_gkContext.playerMain.level;
			}
			
			ret = (level * level + level * 10) / 10 * value * 60;
			
			return ret;
		}
		
		//收购经验的价格（元宝） = (今日购买次数 * 2 + 1 + 时间) * 时间 * 5  //value 输入时间(h)
		private function getPayYuanbao(value:uint):uint
		{
			return (m_gkContext.m_dazuoMgr.m_buyCounts * 2 + 1 + value) * value * 5;
		}
		
		private function cancelFn():Boolean
		{
			return true;
		}
		
		private function confirmFn():Boolean
		{
			if (0 == m_gkContext.m_beingProp.vipLevel)
			{
				m_gkContext.m_context.m_platformMgr.openRechargeWeb();
			}
			else
			{
				var time:uint = m_gkContext.m_confirmDlgMgr.getInputNumber();
				m_dazuoMgr.buyFuyouExp(m_tempID, time);
			}
			
			return true;
		}
		
	}

}