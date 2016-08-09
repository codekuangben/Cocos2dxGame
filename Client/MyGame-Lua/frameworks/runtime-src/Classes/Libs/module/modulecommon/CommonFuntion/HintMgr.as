package modulecommon.commonfuntion 
{
	import com.util.UtilXML;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	/**
	 * ...
	 * @author 
	 * 右下角的提示信息界面管理器
	 */
	public class HintMgr 
	{
		public static const HINTTYPE:String = "HINTTYPE";	//提示类型
		public static const HINTTYPE_AddObject:int = 0;	//增加道具
		public static const HINTTYPE_AddWu:int = 1;	//增加武将
		public static const HINTTYPE_AddSlave:int = 2;		//加奴隶
		public static const HINTTYPE_FGFail:int = 3;		//战斗失败
		public static const HINTTYPE_ZhenfaAddGrid:int = 4;	//阵法开启新阵位
		public static const HINTTYPE_JnLevelUp:int = 5;		//锦囊等级提升
		public static const HINTTYPE_ActFeature:int = 6;	//活动功能开始
		public static const HINTTYPE_QAsys:int = 7;	//答题系统
		
		//加武将UI提示信息类型
		public static const ADDHEROACTION:String = "ADDHEROACTION";	
		public static const ADDHERO_RECRUITNEWWU:int = 0;	//新武将加入
		public static const ADDHERO_REFRESHNUM:int = 1;	//刷新武将数量
		public static const ADDHERO_CHANGMATRIX:int = 2;	//变换阵型
		public static const ADDHERO_HEROACTIVE:int = 3;	//武将激活
		public static const ADDHERO_REBIRTH:int	= 4;	//武将转生
		
		//活动功能开始时提示类型
		public static const ACTFUNC_CITYBATTLE:int = 1;			//军团争霸
		public static const ACTFUNC_SANGUOZHANCHANG:int = 2;	//三国战场
		public static const ACTFUNC_WORLDBOSS:int = 3;			//世界BOSS
		public static const ACTFUNC_CORPSFIRE:int = 4;			//军团烤火
		public static const ACTFUNC_CORPSTREASURE:int = 5;		//军团夺宝
		
		private var m_gkContext:GkContext;
		private var m_uiHintMgr:IForm;
		private var m_dicActFuncDesc:Dictionary;
		
		public function HintMgr(gk:GkContext)
		{
			m_gkContext = gk;
		}
		
		public function hint(param:Object):void
		{
			loadConfig();
			m_uiHintMgr = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIHintMgr);
			if (m_uiHintMgr)
			{
				m_uiHintMgr.updateData(param);
			}
		}
		
		public function set uiHintMgr(ui:IForm):void
		{
			m_uiHintMgr = ui;
		}
		
		public function addToUIZhanliAddAni(param:Object):void
		{
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIZhanliAddAni) as IForm;
			if (ui)
			{
				ui.updateData(param);
			}
			else
			{
				m_gkContext.m_contentBuffer.addContent("uiZhanliAddAni_type", param);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIZhanliAddAni);
			}
		}
		
		private function loadConfig():void
		{
			if (null != m_dicActFuncDesc)
			{
				return;
			}
			
			m_dicActFuncDesc = new Dictionary();
			
			var xml:XML = m_gkContext.m_commonXML.getItem(9);
			var xmlList:XMLList = xml.child("item");
			var itemXML:XML;
			var desc:String;
			var id:int;
			
			for each(itemXML in xmlList)
			{
				id = UtilXML.attributeIntValue(itemXML, "func");
				m_dicActFuncDesc[id] = itemXML.attribute("desc");
			}
			
			m_gkContext.m_commonXML.deleteItem(9);
		}
		
		public function getActFuncDesc(id:int):String
		{
			var ret:String;
			
			if (m_dicActFuncDesc[id] != undefined)
			{
				ret = m_dicActFuncDesc[id];
			}
			
			return ret;
		}
	}

}