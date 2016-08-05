package modulecommon.ui 
{
	
	import modulecommon.GkContext;	
	import flash.utils.Dictionary;
	import modulecommon.scene.prop.table.DataTable;	
	import modulecommon.logicinterface.ICBUIEvent;
	import modulecommon.ui.UIFormID;
	import modulecommon.ui.Form;
	import modulecommon.uiinterface.IUIFlyAni;
	import modulecommon.scene.beings.PlayerMain;	

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
			var key:String
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
			m_id2LoadedFunc[UIFormID.UIBackPack] = onLoadedDefault;
			m_id2FailedFunc[UIFormID.UIBackPack] = onFailedDefault;
			
			m_id2LoadedFunc[UIFormID.UIArenaLadder] = onArenaUILoaded;
			m_id2LoadedFunc[UIFormID.UIArenaInfomation] = onArenaUILoaded;
			//m_id2LoadedFunc[UIFormID.UIArenaBetialRank] = onArenaUILoaded;在竞技场外面也需要显示该界面
			m_id2LoadedFunc[UIFormID.UIArenaWeekReward] = onArenaUILoaded;
			m_id2LoadedFunc[UIFormID.UIArenaStarter] = onArenaUILoaded;
		}
		
		private function onArenaUILoaded(window:Form):void
		{
			if (m_gkcontext.m_mapInfo.m_bInArean == false)
			{
				window.exit();
			}
			else
			{
				onLoadedDefault(window);
			}
		}
		
		public function onLoadedDefault(window:Form):void
		{
			// 放在最前面,如果在这种状态下就
			if(UIFormID.UIChat == window.id || UIFormID.UIRadar == window.id)	// 聊天或者雷达要在角色选择后再显示
			{
				// 角色选择中不显示这个界面
				if(m_gkcontext.m_context.m_binHeroSel)
				{
					return;
				}
			}
			/*else if (UIFormID.UICGIntro == window.id)
			{
				if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIHeroSelectNew) == false)
				{
					window.show();
				}
				return;
			}*/

			if (window.hideOnCreate == false)
			{
				/*if (window.showAfterAllImageLoaded)
				{
					window.showOnAllImageLoaded();
				}
				else
				{
					m_gkcontext.m_UIMgr.showForm(window.id);
				}*/
				m_gkcontext.m_UIMgr.showForm(window.id);
			}
			
			if(UIFormID.UIFlyAni == window.id)
			{
				var playerMain:PlayerMain = this.m_gkcontext.m_playerManager.hero;
				// 隐藏主角
				//playerMain.hide();
				// 设置主角位置
				(window as IUIFlyAni).setFlyStartPt(playerMain.scene.convertToUIPos(playerMain.x, playerMain.y));
			}
			//else if (UIFormID.UICorpsCitySys == window.id)		// 军团城市争夺战默认打开的界面
			//{
			//	(window as IUICorpsCitySys).showCCSUI(UIFormID.UICorpsWorld);
			//}
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