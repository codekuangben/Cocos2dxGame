package modulecommon.scene.benefithall.qiridenglu 
{
	/**
	 * ...
	 * @author 
	 */
	import com.util.UtilXML;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.activityCmd.stGetSevenLoginRewardCmd;
	import modulecommon.net.msg.activityCmd.stSevenLoginAwardInfoCmd;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.scene.benefithall.IBenefitSubSystem;
	
	public class QiridengluMgr implements IBenefitSubSystem
	{
		private var m_gkContext:GkContext;
		private var m_dicData:Dictionary;
		private var m_daysOfDenglu:int;	//当前是第几天登陆,从第一天开始索引
		private var m_awardflag:uint;
		public function QiridengluMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_awardflag = 0x76;
		}
		
		public function loadconfig():void
		{
			if (m_dicData != null)
			{
				return;
			}
			m_dicData = new Dictionary();
			var itemData:Qiri_DayData;
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Sevenloginaward);
			var xmlList:XMLList = UtilXML.getChildXmlList(xml, "award");
			var itemXml:XML;
			for each(itemXml in xmlList)
			{
				itemData = new Qiri_DayData();
				itemData.parseXML(itemXml);
				m_dicData[itemData.m_id] = itemData;				
			}
		}
		
		public function getQiri_DayDataByID(id:int):Qiri_DayData
		{
			if (m_dicData == null)
			{
				loadconfig();
			}
			return m_dicData[id];
		}
		
		//判断指定天的奖励是否已经领取了。id是配置文件中定义的id
		public function isLingqu(id:int):Boolean
		{
			return (m_awardflag & (1 << id)) != 0;
		}
		
		//返回值true-表示7日的奖励都领取了
		public function isAllLingqu():Boolean
		{
			//0x76表示7天的奖励都被领取了
			if (m_awardflag == 0x76)
			{
				return false;
			}
			return true;
		}
		
		public function process_stSevenLoginAwardInfoCmd(msg:ByteArray, param:uint):void
		{
			var rev:stSevenLoginAwardInfoCmd = new stSevenLoginAwardInfoCmd();
			rev.deserialize(msg);
			
			m_daysOfDenglu = rev.logindays;
			m_awardflag = rev.awardflag;
		}
		public function process_stGetSevenLoginRewardCmd(msg:ByteArray, param:uint):void
		{
			var rev:stGetSevenLoginRewardCmd = new stGetSevenLoginRewardCmd();
			rev.deserialize(msg);
			m_awardflag |= (1 << rev.day);
			
			if (m_gkContext.m_UIs.benefitHall)
			{
				m_gkContext.m_UIs.benefitHall.updateDataOnePage(BenefitHallMgr.BUTTON_QiriDenglu, rev.day);
			}
			
			if (!hasRewardEx())
			{
				notify_noReward(BenefitHallMgr.BUTTON_QiriDenglu);
			}
		}
		//零点登陆
		public function process0ClockUserCmd():void
		{
			m_daysOfDenglu++;
			if (m_daysOfDenglu >= 1 && m_daysOfDenglu <= 7)
			{
				if (m_gkContext.m_UIs.benefitHall)
				{
					m_gkContext.m_UIs.benefitHall.updateDataOnePage(BenefitHallMgr.BUTTON_QiriDenglu, m_daysOfDenglu);
				}
			}
			
			if (!m_gkContext.m_benefitHallMgr.hasRewardByID(BenefitHallMgr.BUTTON_QiriDenglu))
			{
				if (hasRewardEx())
				{
					notify_hasReward(BenefitHallMgr.BUTTON_QiriDenglu);
				}
			}
		}
		
		public function get daysOfDenglu():int
		{
			return m_daysOfDenglu;
		}
		
		public function hasRewardEx():Boolean
		{
			var maxDay:int = m_daysOfDenglu > 7?7:m_daysOfDenglu;
			var day:int = 1;
			for (; day <= maxDay; day++)
			{
				if (false == isLingqu(day))
				{
					return true;
				}
			}
			return false;
		}
		
		public function hasReward(id:int):Boolean
		{			
			return hasRewardEx();
		}
		
		public function notify_hasReward(id:int):void
		{
			m_gkContext.m_benefitHallMgr.onNotify_hasReward(id);
		}
		
		public function notify_noReward(id:int):void
		{
			m_gkContext.m_benefitHallMgr.onNotify_noReward(id);
		}
	}

}