package modulecommon.scene.equipsys 
{
	import flash.utils.ByteArray;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.net.msg.equip.stReqSpeedEnchanceColdCmd;
	import modulecommon.net.msg.equip.stRetEquipEnchanceColdCmd;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.time.Daojishi;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIEquipSys;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	/**
	 * ...
	 * @author ...
	 */
	public class EquipSysMgr 
	{
		public static const eEquipStren:uint = 0;	// 装备强化	
		public static const eEquipXiangQian:uint = 1;	// 装备镶嵌
		public static const eEquipHeCheng:uint = 2;	// 装备合成
		public static const eEquipXiLian:uint = 3;	// 装备洗练
		public static const eEquipFenJie:uint = 4;	// 装备分解
		public static const eEquipCnt:uint = 4;		// 装备系统页签个数
		
		private var m_gkContext:GkContext;
		
		private var m_openPageID:uint = 0;//打开界面时，显示哪个页面
		public var m_openWuID:int = 0;	//打开界面时，显示指定武将的装备
		public var m_openEquipPos:int = ZObjectDef.EQUIP_MAX;	//打开界面时，显示指定位置的装备。见定义ZObjectDef.EQUIP_MAX
		
		private var m_leftsec:uint;			//(强化)冷却剩余时间
		private var m_speedcost:uint;		//(强化)加速花费元宝数
		private var m_daojishi:Daojishi;
		
		public var m_ui:IUIEquipSys;
		
		
		public function EquipSysMgr(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		
		//设置打开锻造界面时显示的标签页
		public function setOpenPage(pageID:uint = 0):void
		{
			m_openPageID = pageID;
		}
		
		public function openUIEquipSysPage(pageID:uint = 0):void
		{
			setOpenPage(pageID);
			
			if (m_ui)
			{
				m_ui.show();
			}
			else
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIEquipSys);
			}
		}
		
		public function get openPageID():uint
		{
			return m_openPageID;
		}
		
		public function processEquipEnchanceColdUserCmd(msg:ByteArray):void
		{
			var ret:stRetEquipEnchanceColdCmd = new stRetEquipEnchanceColdCmd();
			ret.deserialize(msg);
			
			m_leftsec = ret.leftsec;
			m_speedcost = ret.speedcost;				
			
			if (m_leftsec)
			{
				createColdTimeDaojishi();
			}
			else
			{
				if (m_daojishi)
				{
					m_daojishi.end();
				}
				
				uiUpdateEquipEnchanceCold();
			}
			
			if (ret.speedcost)
			{
				if (m_ui)
				{
					m_ui.showPromptEquipEnchanceCold();
				}
			}
		}
		
		private function createColdTimeDaojishi():void
		{
			if (null == m_daojishi)
			{
				m_daojishi = new Daojishi(m_gkContext.m_context);
				m_daojishi.funCallBack = updateDaojishi;
			}
			
			m_daojishi.initLastTime = m_leftsec * 1000;
			m_daojishi.begin();
		}
		
		private function updateDaojishi(t:Daojishi):void
		{
			if (m_daojishi.isStop())
			{
				m_leftsec = 0;
				m_speedcost = 0;
				m_daojishi.end();
			}
			
			uiUpdateEquipEnchanceCold();
		}
		
		//更新ui模块中的倒计时显示
		public function uiUpdateEquipEnchanceCold():void
		{			
			if (m_ui)
			{
				m_ui.updateEquipEnchanceCold();
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_EquipStren, leftsec, -1);
			}
		}
		
		//结束倒计时
		public function stopDaoJiShi():void
		{
			m_leftsec = 0;
			m_speedcost = 0;
			if (m_daojishi)
			{
				m_daojishi.end();
			}
			
			var send:stReqSpeedEnchanceColdCmd = new stReqSpeedEnchanceColdCmd();
			m_gkContext.sendMsg(send);
			
			uiUpdateEquipEnchanceCold();
		}
		
		public function get leftsec():uint
		{
			if (0 == m_leftsec)
			{
				return 0;
			}
			else
			{
				return m_daojishi.timeSecond;
			}
		}
		
		public function get speedcost():uint
		{
			return m_speedcost;
		}
		
		//通过SysNewFeatures中功能id，获得装备系统page页id
		public static function getPageIdByFuncID(funcid:int):uint
		{
			var ret:uint;
			switch(funcid)
			{
				case SysNewFeatures.NFT_GEMEMBED:
					ret = eEquipXiangQian;
					break;
				case SysNewFeatures.NFT_EQUIPXILIAN:
					ret = eEquipXiLian;
					break;
				case SysNewFeatures.NFT_EQUIPDECOMPOSE:
					ret = eEquipFenJie;
					break;
				case SysNewFeatures.NFT_EQUIPCOMPOSE:
					ret = eEquipHeCheng;
					break;
				case SysNewFeatures.NFT_EQUIPADVANCE:
				case SysNewFeatures.NFT_EQUIPLEVELUP:
				case SysNewFeatures.NFT_DAZAO:
					ret = eEquipStren;
					break;
			}
			
			return ret;
		}
		
		public static function getFuncIdByPageID(pageid:uint):int
		{
			var ret:int = 0;
			switch(pageid)
			{
				case eEquipXiangQian:
					ret = SysNewFeatures.NFT_GEMEMBED;
					break;
				case eEquipXiLian:
					ret = SysNewFeatures.NFT_EQUIPXILIAN;
					break;
				case eEquipFenJie:
					ret = SysNewFeatures.NFT_EQUIPDECOMPOSE;
					break;
				case eEquipHeCheng:
					ret = SysNewFeatures.NFT_GEMEMBED;// SysNewFeatures.NFT_EQUIPCOMPOSE; //合成，同“镶嵌”一起开启
					break;
				case eEquipStren:
					ret = SysNewFeatures.NFT_DAZAO;
					break;
			}
			
			return ret;
		}
		
		//通过SysNewFeatures中功能id，获得装备系统page页name
		public static function getPageNameByFuncID(funcid:int):String
		{
			var ret:String;
			switch(funcid)
			{
				case SysNewFeatures.NFT_GEMEMBED:
					ret = "镶嵌";
					break;
				case SysNewFeatures.NFT_EQUIPXILIAN:
					ret = "洗炼";
					break;
				case SysNewFeatures.NFT_EQUIPDECOMPOSE:
					ret = "分解";
					break;
				case SysNewFeatures.NFT_EQUIPCOMPOSE:
					ret = "合成";
					break;
				case SysNewFeatures.NFT_EQUIPADVANCE:
					ret = "进阶";
					break;
				case SysNewFeatures.NFT_EQUIPLEVELUP:
					ret = "升级";
					break;
				case SysNewFeatures.NFT_DAZAO:
					ret = "强化";
					break;
			}
			
			return ret;
		}
	}

}