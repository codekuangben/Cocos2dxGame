package modulecommon.ui.uiprog
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import modulecommon.ui.Form;
	import com.util.UtilFilter;

	/**
	 * @brief 加载显示的背景
	 * */
	public class ProgLoadingBg extends Component
	{
		public var m_pnlBg:Panel;
		public var m_pnlLogo:Panel;
		public var m_pnlPlayer:Panel;
		
		public var m_bLogoLoaded:Boolean;		// logo 资源加载完成后，才显示黑色背景
		public var m_form:Form;					// form
		
		public var m_resLogo:SWFResource;
		public var m_resPlayer:SWFResource;
		protected var m_timeID:uint;				// 定时器 ID
		protected var m_modeAdd:Boolean = false;				// 0 减少 1 增加
		protected var m_curFilterValue:Number = 1;		// 当前过滤器的值
		protected var m_delta:Number = 0.01;				// 每一次改变的值
		
		public function ProgLoadingBg(form:Form, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_form = form;
			m_pnlBg = new Panel(this);
			m_pnlLogo = new Panel(this);
			m_pnlPlayer = new Panel(this);
			
			m_timeID = setInterval(timerCB, 20);
			
			//m_resLogo = m_form.gkcontext.m_context.m_resMgr.load("asset/uiimage/loadinglogo/uiloadinglogo.swf", SWFResource, onResLoaded, onResFailed) as SWFResource;
			//m_resPlayer = m_form.gkcontext.m_context.m_resMgr.load("asset/uiimage/loadinglogo/uiloadplayer.swf", SWFResource, onResPlayerLoaded, onResPlayerFailed) as SWFResource;
		}
		
		public function loadRes():void
		{
			m_resLogo = m_form.gkcontext.m_context.m_resMgr.load("asset/uiimage/loadinglogo/uiloadinglogo.swf", SWFResource, onResLoaded, onResFailed) as SWFResource;
			m_resPlayer = m_form.gkcontext.m_context.m_resMgr.load("asset/uiimage/loadinglogo/uiloadplayer.swf", SWFResource, onResPlayerLoaded, onResPlayerFailed) as SWFResource;			
		}
		
		public function onStageReSize():void
		{
			m_pnlBg.setPos((this.m_form.gkcontext.m_context.m_config.m_curWidth - 975)/2, (this.m_form.gkcontext.m_context.m_config.m_curHeight - 582)/2 - 50);
			m_pnlLogo.setPos((this.m_form.gkcontext.m_context.m_config.m_curWidth - 291)/2, (this.m_form.gkcontext.m_context.m_config.m_curHeight - 212)/2 - 145);
			m_pnlPlayer.setPos((this.m_form.gkcontext.m_context.m_config.m_curWidth - 664)/2, (this.m_form.gkcontext.m_context.m_config.m_curHeight - 382)/2 + 40);
		}
		
		protected function timerCB():void
		{
			/*
			if(m_pnlBg.filters && m_pnlBg.filters.length)
			{
				m_pnlBg.filters = null;
			}
			else
			{
				m_pnlBg.filters = [UtilFilter.createLuminanceFilter(0.6)];
			}
			*/
			
			if(m_modeAdd)
			{
				m_curFilterValue += m_delta;
				if(m_curFilterValue > 1)
				{
					m_curFilterValue = 1;
					m_modeAdd = false;
				}
			}
			else
			{
				m_curFilterValue -= m_delta;
				if(m_curFilterValue < 0.6)
				{
					m_curFilterValue = 0.6;
					m_modeAdd = true;
				}
			}
			
			m_pnlBg.filters = [UtilFilter.createLuminanceFilter(m_curFilterValue)];
		}
		
		override public function dispose():void
		{
			if(m_resLogo)
			{
				if(!m_resLogo.isLoaded)
				{
					m_resLogo.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
					m_resLogo.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
					
					this.m_form.gkcontext.m_context.m_resMgr.unload(m_resLogo.filename, SWFResource);
				}
				m_resLogo = null;
			}
			
			if(m_resPlayer)
			{
				if(!m_resPlayer.isLoaded)
				{
					m_resPlayer.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
					m_resPlayer.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
					
					this.m_form.gkcontext.m_context.m_resMgr.unload(m_resPlayer.filename, SWFResource);
				}
				m_resPlayer = null;
			}
			
			if(m_timeID)
			{
				clearInterval(m_timeID);
				m_timeID = 0;
			}
			
			super.dispose();
		}
		
		public function onResLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			Logger.info(null, null, event.resourceObject.filename + " loaded");
			
			this.m_pnlLogo.setPanelImageSkinBySWF(event.resourceObject as SWFResource, "uiloading.logo");
			this.m_form.gkcontext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
			m_bLogoLoaded = true;
			this.m_form.onStageReSize();
		}
		
		public function onResFailed(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			Logger.error(null, null, event.resourceObject.filename + " failed");
			this.m_form.gkcontext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
			m_resLogo = null;
		}
		
		public function onResPlayerLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResPlayerLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResPlayerFailed);
			Logger.info(null, null, event.resourceObject.filename + " loaded");
			
			this.m_pnlBg.setPanelImageSkinBySWF(event.resourceObject as SWFResource, "loading.bg");
			this.m_pnlPlayer.setPanelImageSkinBySWF(event.resourceObject as SWFResource, "loading.player");
			this.m_form.gkcontext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
		}
		
		public function onResPlayerFailed(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResPlayerLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResPlayerFailed);
			Logger.error(null, null, event.resourceObject.filename + " failed");
			this.m_form.gkcontext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
			m_resPlayer = null;
		}
	}
}