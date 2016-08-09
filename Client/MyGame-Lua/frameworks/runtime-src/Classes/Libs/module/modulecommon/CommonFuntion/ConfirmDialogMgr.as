package modulecommon.commonfuntion 
{
	//import flash.geom.Point;
	import com.util.IDAllocator;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import modulecommon.commonfuntion.confirmdlg.subform.UIConfirm_Common;
	import modulecommon.commonfuntion.confirmdlg.subform.UIConfirm_Input;
	import modulecommon.commonfuntion.confirmdlg.subform.UIConfirm_YES;
	import modulecommon.commonfuntion.confirmdlg.subform.UIConfirmBase;
	
	import modulecommon.GkContext;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIConfirmDlg;
	/**
	 * ...
	 * @author 
	 * 实例
	 * m_gkContext.m_confirmDlgMgr.showMode1("除了美来的最高水平；", a, b);
	 */
	public class ConfirmDialogMgr 
	{
		public static const FUNCTIONID_EquipStrenLengque:int = 1;	//装备强化冷却
		public static const FUNCTIONID_CangbaokuLengque:int = 2;	//藏宝库冷却
		
		public static const MODE1:int = 0;
		public static const MODE2:int = 1;
		public static const MODE_INPUT:int = 3;
		public static const MODE_INPUT_YSE:int = 4;
		
		public static var RADIOBUTTON_desc:String = "RADIOBUTTON_desc";		//单选按钮后面的文字描述
		public static var RADIOBUTTON_clickFuntion:String="RADIOBUTTON_clickFuntion";	//单击单选按钮后，要调用的函数
		public static var RADIOBUTTON_select:String = "RADIOBUTTON_select";		//初始值，true- 表示被选中，false-表示未被选中
		public static var RADIOBUTTON_panelType:String = "RADIOBUTTON_panelType";		//一个moneypanel的type类型对应beingprop中的type
		public static var RADIOBUTTON_panelPos:String = "RADIOBUTTON_panelPos";		//为moneypanel指定位置
		
		public static var Param_YesConfirm:String = "Param_YesConfirm";		//单选按钮后面的文字描述
		
		private var m_gkContext:GkContext;
		private var m_functionID:int;
		
		private var m_tempData:Object;
		

		private var m_data:Object;
		private var m_formID:uint;	//打开确认对话框的form的ID
			
		
		private var m_latestUI:UIConfirmBase;	//最新显示的对话框
		private var m_listCommonDlg:Vector.<UIConfirm_Common>;
		private var m_inputDlg:UIConfirm_Input;
		private var m_inputYesDlg:UIConfirm_YES;
	
		protected var m_dicFun:Dictionary;
	
		public function ConfirmDialogMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			
			m_listCommonDlg = new Vector.<UIConfirm_Common>();
			
			m_dicFun = new Dictionary();
			m_dicFun[ConfirmDialogMgr.MODE1] = processCommonDlg;
			m_dicFun[ConfirmDialogMgr.MODE2] = processCommonDlg;
			m_dicFun[ConfirmDialogMgr.MODE_INPUT] = processInputDlg;
			m_dicFun[ConfirmDialogMgr.MODE_INPUT_YSE] = processInputYESDlg;
		}
		
		public function showMode1(formID:uint, desc:String, funConfirm:Function, funConcel:Function, nameConfirm:String = null, nameConcel:String = null, radioButton:Object = null, showExitBtn:Boolean=false, funExit:Function = null, param:Object = null):void
		{
			resetData();
			
			m_formID = formID;
			m_data["mode"] = MODE1;
			m_data["desc"] = desc;
			m_data["funConfirm"] = funConfirm;
			m_data["funConcel"] = funConcel;
			if (nameConfirm != null)
			{
				m_data["nameConfirm"] = nameConfirm;
			}
			if (nameConcel != null)
			{
				m_data["nameConcel"] = nameConcel;
			}
			if (radioButton != null)
			{
				m_data["radioButton"] = radioButton;
			}
			
			if (showExitBtn)
			{
				m_data["exitBtn"] = true;
				if (funExit != null)
				{
					m_data["funExit"] = funExit;
				}
			}
			
			var key:String;
			for(key in param)
			{
				m_data[key] = param[key];
			}
			
			callDlg();			
		}
		
		//只有1个按钮
		public function showMode2(formID:uint, desc:String, funConfirm:Function, nameConfirm:String = null):void
		{
			resetData();
			
			m_formID = formID;
			m_data["mode"] = MODE2;
			m_data["desc"] = desc;
			m_data["funConfirm"] = funConfirm;
			if (nameConfirm != null)
			{
				m_data["nameConfirm"] = nameConfirm;
			}
			
			callDlg();
		}
		public function showModeInput(formID:uint, title:String, desc:String, funConfirm:Function, funConcel:Function, nameConfirm:String, nameConcel:String,
			rectInput:Rectangle, minValue:int, maxValue:int, defaultValue:int, 
			labelRelevantData:ConfirmInputRelevantData, label2RelevantData:ConfirmInputRelevantData = null):void
		{
			resetData();
			m_formID = formID;
			m_data["mode"] = MODE_INPUT;		
			m_data["desc"] = desc;
			m_data["funConfirm"] = funConfirm;
			m_data["funConcel"] = funConcel;
			
			if (title != null)
			{
				m_data["title"] = title;
			}
			
			if (nameConfirm != null)
			{
				m_data["nameConfirm"] = nameConfirm;
			}
			if (nameConcel != null)
			{
				m_data["nameConcel"] = nameConcel;
			}
			m_data["rectInput"] = rectInput;
			
			m_data["minValue"] = minValue;			
			m_data["maxValue"] = maxValue;
			m_data["defaultValue"] = defaultValue;
			
			if (labelRelevantData != null)
			{
				m_data["labelRelevantData"] = labelRelevantData;
			}
			if (label2RelevantData != null)
			{
				m_data["label2RelevantData"] = label2RelevantData;
			}
			
			callDlg();
		}
		
		public function showModeInputYes(formID:uint, title:String, desc:String, funConfirm:Function, nameConfirm:String, nameConcel:String):void
		{
			resetData();
			m_formID = formID;
			m_data["mode"] = MODE_INPUT_YSE;		
			m_data["desc"] = desc;
			m_data["funConfirm"] = funConfirm;
			m_data["funConcel"] = null;
			
			if (title != null)
			{
				m_data["title"] = title;
			}
			
			if (nameConfirm != null)
			{
				m_data["nameConfirm"] = nameConfirm;
			}
			if (nameConcel != null)
			{
				m_data["nameConcel"] = nameConcel;
			}
			
			callDlg();
		}
	
		protected function callDlg():void
		{
			m_dicFun[m_data["mode"]](m_data);
		}
		
		public function resetData():void
		{
			m_functionID = 0;
			m_data = new Object();			
		}	
		
		public function clearOnFormID(formID:uint):void
		{
			if (m_formID != formID)
			{
				return;
			}
			m_formID = 0;
			resetData();
			if (m_tempData != null)
			{
				m_tempData = null;
			}
		}
		
		public function getFormID():uint
		{
			return m_formID;
		}
		
		public function hide():void
		{			
			if (m_latestUI&&m_latestUI.isVisible())
			{
				m_latestUI.exit();
			}
		}	
			
		public function set tempData(data:Object):void
		{
			m_tempData = data;
		}
		
		public function get tempData():Object
		{
			return m_tempData;
		}		
		
		public function getCommonDlg():UIConfirm_Common
		{
			var i:int;
			var ui:UIConfirm_Common;
			for (i = 0; i< m_listCommonDlg.length; i++)
			{
				ui = m_listCommonDlg[i];
				if (ui.isVisible() == false)
				{
					break;
				}
			}
			
			if (i < m_listCommonDlg.length)
			{
				return ui;
			}
			
			ui = new UIConfirm_Common();
			m_listCommonDlg.push(ui);
			ui.id = m_gkContext.m_dynamicFormIDAllocator.allocate();
			m_gkContext.m_UIMgr.addForm(ui);
			return ui;
		}
		
		/*public function getCurVisibleForm():UIConfirmBase
		{		
			var i:int;
			for (i = 0; i< m_listCommonDlg.length; i++)
			{
				if (m_listCommonDlg[i].isVisible())
				{
					return m_listCommonDlg[i];
				}
			}
			return null;
		}*/
		public function processCommonDlg(dataLocal:Object):void
		{
			var ui:UIConfirm_Common = getCommonDlg();
			m_latestUI = ui;
			ui.process(dataLocal);
			ui.show();
		}
		public function processInputDlg(dataLocal:Object):void
		{
			if (m_inputDlg == null)
			{
				m_inputDlg = new UIConfirm_Input();
				m_inputDlg.id = m_gkContext.m_dynamicFormIDAllocator.allocate();
				m_gkContext.m_UIMgr.addForm(m_inputDlg);
			}
			
			m_latestUI = m_inputDlg;
			m_inputDlg.process(dataLocal);
			m_inputDlg.show();
		}
		
		public function processInputYESDlg(dataLocal:Object):void
		{
			if (m_inputYesDlg == null)
			{
				m_inputYesDlg = new UIConfirm_YES();
				m_inputYesDlg.id = m_gkContext.m_dynamicFormIDAllocator.allocate();
				m_gkContext.m_UIMgr.addForm(m_inputYesDlg);
			}
			
			m_latestUI = m_inputYesDlg;
			m_inputYesDlg.process(dataLocal);
			m_inputYesDlg.show();
		}
	
		public function isRadioButtonCheck():Boolean
		{
			if (m_latestUI&&m_latestUI is UIConfirm_Common)
			{
				return (m_latestUI as UIConfirm_Common).isRadioButtonCheck();
			}
			return false;
		}
		
		public function isVisible():Boolean 
		{
			if (m_latestUI)
			{
				return m_latestUI.isVisible();
			}
			return false;			
		}
		public function getInputNumber():int
		{
			if (m_latestUI && m_latestUI is UIConfirm_Input)
			{
				return (m_latestUI as UIConfirm_Input).getInputNumber();
			}
			return 0;
		}
		
		public function updateDesc(desc:String):void
		{
			if (m_latestUI)
			{
				m_latestUI.updateDesc(desc);
			}
		}
		
		public function set functionID(funID:int):void
		{
			m_functionID = funID;
		}
		
		public function get functionID():int
		{
			return m_functionID;
		}
	}

}