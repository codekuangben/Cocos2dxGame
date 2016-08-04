package modulefight.uicb
{
	//import com.pblabs.engine.debug.Logger;
	//import com.pblabs.engine.resource.SWFResource;
	
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	//import modulecommon.game.ConstValue;
	import modulecommon.logicinterface.ICBUIEvent;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	//import modulecommon.uiinterface.IUIBackPack;
	//import modulecommon.uiinterface.IUILogin;
	import modulecommon.uiinterface.IUITurnCard;
	
	//import modulefight.FightEn;
	
	/**
	 * ...
	 * @author
	 */
	public class CBUIEvent implements ICBUIEvent
	{
		public var m_gkcontext:GkContext;
		public var m_id2LoadedFunc:Dictionary;
		public var m_id2FailedFunc:Dictionary;
		
		public function CBUIEvent(cnt:GkContext)
		{
			m_gkcontext = cnt;
			m_id2LoadedFunc = new Dictionary();
			m_id2FailedFunc = new Dictionary();
			
			registerFunc();
		}
		
		public function init():void
		{
		
		}
		
		public function destroy():void
		{
			var key:String;
			for (key in m_id2LoadedFunc)
			{
				m_id2LoadedFunc[key] = null;
				delete m_id2LoadedFunc[key];
			}
			
			for (key in m_id2FailedFunc)
			{
				m_id2FailedFunc[key] = null;
				delete m_id2FailedFunc[key];
			}
			
			m_gkcontext = null;
		}
		
		public function getLoadedFunc(id:uint):Function
		{
			var funLocal:Function = m_id2LoadedFunc[id];
			if (funLocal == null)
			{
				return onLoadedDefault;
			}
			else
			{
				return funLocal;
			}
		
		}
		
		public function getFailedFunc(id:uint):Function
		{
			var funLocal:Function = m_id2FailedFunc[id];
			if (funLocal == null)
			{
				return onLoadedDefault;
			}
			else
			{
				return funLocal;
			}
		}
		
		public function registerFunc():void
		{
			//m_id2LoadedFunc[UIFormID.UIBackPack] = onLoadedDefault;
			//m_id2FailedFunc[UIFormID.UIBackPack] = onFailedDefault;
		}
		
		public function onLoadedDefault(window:Form):void
		{
			//m_gkcontext.m_UIMgr.showForm(window.id);
			
			// 日志窗口，输出所有的日志   
			if (UIFormID.UIBattleLog == window.id)
			{
				//m_gkcontext.m_fightControl.outputAll();
				window.show();
			}
			else if(UIFormID.UIFTurnCard == window.id)
			{
				(window as IUITurnCard).binFight = true;
				window.show();
			}
			else if(UIFormID.UICloud == window.id)		// 云在最底层
			{
				// UICloud 创建的时候是隐藏的,自己添加到最下层
				// 显示
				window.show();
				// 手工调整位置
				m_gkcontext.m_UIMgr.getLayer(UIFormID.BattleLayer).deskTop.addChildAt(window, 0);
			}			
			else if(!window.hideOnCreate)
			{
				window.show();
			}
		}
		
		public function onFailedDefault(ID:uint):void
		{
		
		}
		
		public function onShow(uiid:uint):void
		{
		
		}
		
		public function onClose(uiid:uint):void
		{
		
		}
	}
}