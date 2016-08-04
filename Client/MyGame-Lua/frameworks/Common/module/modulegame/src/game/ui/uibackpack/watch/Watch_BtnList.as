package game.ui.uibackpack.watch 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	import com.pblabs.engine.resource.SWFResource;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import flash.display.DisplayObjectContainer;
	import modulecommon.scene.wu.WuProperty;
	import game.ui.uibackpack.btnlist.ButtonWuTab;
	/**
	 * ...
	 * @author 
	 */
	public class Watch_BtnList extends Component 
	{
		private static const HEIGHT:int = 385;
		private static const INTERVAL:int = 3;
		private static const BUTTONH:int = 37;		
			
		private var m_gkContext:GkContext;
		private var m_dicBtn:Dictionary;
		private var m_uCurHeroID:uint;		
	
		private var m_outImagePanel:Panel; //出战武将
		private var m_ui:UIWatchPlayer;
		
		private var m_container:Panel;
		private var m_curPos:int;
		private var m_totalH:int; //总的高度	
		
		public function Watch_BtnList(parent:DisplayObjectContainer, ui:UIWatchPlayer, gk:GkContext)
		{
			m_gkContext = gk;
			m_ui = ui;
			super(parent);
		
			m_dicBtn = new Dictionary();			
			m_container = new Panel(this);
			m_outImagePanel = new Panel(m_container, 31, 8);
			m_outImagePanel.setPanelImageSkin("commoncontrol/panel/wuout.png");
		}
		private function clearAll():void
		{
			var btn:ButtonWuTab;
			for each(btn in m_dicBtn)
			{
				btn.dispose();
				if (btn.parent)
				{
					btn.parent.removeChild(btn);
				}
			}
			m_dicBtn = new Dictionary();
		}
		public function initData():void
		{
			clearAll();
			var btn:ButtonWuTab;
			var wuPro:WuProperty;			
			var top:int = 32;
			var list:Array = m_gkContext.m_watchMgr.getWuList();			
		
			for each (var item:*in list)
			{
				wuPro = (item as WuProperty);
				btn = new ButtonWuTab(m_container, 0, 0, onClick);
				btn.initBtnData(m_gkContext, wuPro);
				btn.setSize(130, 37);
				
				m_dicBtn[wuPro.m_uHeroID] = btn;
				btn.y = top;
				top += BUTTONH + INTERVAL;
			}
			if (m_dicBtn[WuProperty.MAINHERO_ID] != null)
			{
				(m_dicBtn[WuProperty.MAINHERO_ID] as ButtonWuTab).selected = true;
				m_uCurHeroID = WuProperty.MAINHERO_ID;
			}
			
		
		}	
		
		public function setSelected(heroID:uint):void
		{
			var btn:ButtonWuTab = m_dicBtn[heroID] as ButtonWuTab;
			if (btn == null)
			{
				return;
			}
			btn.selected = true;			
		}
		
		public function onClick(e:MouseEvent):void
		{		
			var btn:ButtonWuTab = e.target as ButtonWuTab;
			if (btn != null)
			{
				m_ui.showPanel(btn.wuID);
				m_uCurHeroID = btn.tag;
			}
		}
		
		public function get curHeroID():uint
		{
			return m_uCurHeroID;
		}
		
		public function get dicBtn():Dictionary
		{
			return m_dicBtn;
		}
	}

}