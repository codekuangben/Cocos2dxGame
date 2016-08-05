package modulecommon.scene.saodang
{
	import modulecommon.GkContext;
	import modulecommon.time.Daojishi;
	import com.util.UtilTools;
	import modulecommon.uiinterface.IUIScreenBtn;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	
	/**
	 * ...
	 * @author panqiangqiang  20130725
	 */
	public class SaodangMgr
	{
		public static const DAN_REN_FU_BEN:uint = 0;
		public static const GUO_GUAN_ZHAN_JIANG:uint = 1;
		public static const _FREE:uint = 1;
		public static const _ING:uint = 2;
		public static const _REWARD:uint = 3;
		
		public static const SAODANGTYPE_fuben:int = 0;
		public static const SAODANGTYPE_guoguanzhanjiang:int = 1;
		
		private var m_Type:uint; //0:普通副本 1:过关斩将
		private var m_CopyName:String;
		private var m_Cishu:uint;
		private var m_LastTime:uint;
		private var m_State:uint;
		private var m_gkContext:GkContext;
		
		private var m_daojishi:Daojishi;
		
		public function SaodangMgr(gk:GkContext)
		{
			m_gkContext = gk;
			clear();
		}
		
		public function nextState():void
		{
			switch (m_State)
			{
				case _FREE: 
					m_State = _ING;
					break;
				case _ING: 
					m_State = _REWARD;
					break;
				case _REWARD: 
					m_State = _FREE;
					break;
			}
		}
		
		public function get state():uint
		{
			return m_State;
		}
		
		public function get type():uint
		{
			return m_Type;
		}
		
		public function isInGgzjSaodang():Boolean
		{
			if (m_State != _FREE && m_Type == SAODANGTYPE_guoguanzhanjiang)
			{
				return true;
			}
			return false;
		}
		
		public function clear():void
		{
			m_Type = m_Cishu = m_LastTime = 0;
			m_State = _FREE;
		
		}
		
		public function updateData(cn:String, cishu:uint, time:uint):void
		{
			m_CopyName = cn;
			m_Cishu = cishu;
			m_LastTime = time;
		}
		
		public function setData(type:uint, cn:String, cishu:uint, time:uint):void
		{
			
			
			updateData(cn, cishu, time);
			m_Type = type;
			if (0 == time)
			{
				m_State = _REWARD;
			}
			else
			{
				nextState();
			}
			
			if (null == m_daojishi)
			{
				m_daojishi = new Daojishi(m_gkContext.m_context);
			}
			beginDaojishi();	
			
			if (m_State == _REWARD &&m_gkContext.m_UIMgr.isFormVisible(UIFormID.UISaoDangIngInfo))
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UISaoDangReward);				
			}
		}
		
		private function beginDaojishi():void
		{
			m_daojishi.funCallBack = updateDaojishi;
			
			m_daojishi.initLastTime = 1000 * m_LastTime;
			m_daojishi.begin();
		}
		
		private function updateDaojishi(d:Daojishi):void
		{
			if (_FREE == state)
				return;
			/*if (m_daojishi.isStop())
			   {
			   nextState();
			   return;
			 }*/
			
			if (m_daojishi.isStop())
			{
				m_daojishi.end();
			}
			
			var time:String = UtilTools.formatTimeToString(m_daojishi.timeSecond);
			var ui:IUIScreenBtn = m_gkContext.m_UIs.screenBtn;
			if (ui != null)
			{
				ui.updateSaoDangTime(m_daojishi.timeSecond);
			}
			var ui2:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UISaoDangIngInfo) as IForm;
			if (ui2 != null)
			{
				ui2.updateData(time);
			}
		}
		
		public function get name():String
		{
			return m_CopyName;
		}
		
		public function openSaodangInfoForm():void
		{
			if (m_State == _FREE)
			{
				return;
			}
			var formID:uint = 0;
			if (SaodangMgr._REWARD == m_gkContext.m_saodangMgr.state)
			{
				formID = UIFormID.UISaoDangReward;
			}
			else if (SaodangMgr._ING == m_gkContext.m_saodangMgr.state)
			{
				formID = UIFormID.UISaoDangIngInfo;
			}
			m_gkContext.m_UIMgr.showFormEx(formID);
		}
	}
}