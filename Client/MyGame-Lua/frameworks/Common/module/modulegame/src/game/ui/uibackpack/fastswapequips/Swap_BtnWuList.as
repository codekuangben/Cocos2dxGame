package game.ui.uibackpack.fastswapequips 
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.dgrigg.image.Image;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import game.ui.uibackpack.btnlist.ButtonWuTab;
	/**
	 * ...
	 * @author ...
	 */
	public class Swap_BtnWuList extends PanelContainer
	{
		public static const INTERVAL:int = 3;
		public static const BUTTONH:int = 37;
		public static const BUTTONW:int = 130;
		
		private var m_gkContext:GkContext;
		private var m_ui:UIFastSwapEquips;
		
		private var m_wulist:PanelContainer;
		private var m_dicBtn:Dictionary;
		private var m_selectPanel:Panel;
		private var m_uCurHeroID:uint;		//当前选中武将
		
		private var m_inImagePanel:Panel; 	//未出战武将
		
		public function Swap_BtnWuList(gk:GkContext, ui:UIFastSwapEquips, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_ui = ui;
			
			m_inImagePanel = new Panel(this, 0, 0);
			m_inImagePanel.setPanelImageSkinMirror("commoncontrol/panel/glodflightsmall.png", Image.MirrorMode_LR);
			m_inImagePanel.visible = false;
			
			m_selectPanel = new Panel(this, 0, -1);
			m_selectPanel.mouseEnabled = false;
			
			m_wulist = new PanelContainer(this, 0, 20);
			m_dicBtn = new Dictionary();
		}
		
		//site:0左边  1右边
		public function initData(selectheroid:uint, site:uint):void
		{
			var btn:ButtonWuTab;
			var wuPro:WuProperty;
			var wulist:Array = m_gkContext.m_wuMgr.getNotXiayeWuList();
			
			for each (wuPro in wulist)
			{
				btn = new ButtonWuTab(m_wulist, 0, 0, onClick);
				btn.initBtnData(m_gkContext, wuPro);
				btn.setSize(BUTTONW, BUTTONH);
				btn.tag = site;
				m_dicBtn[wuPro.m_uHeroID] = btn;
			}
			
			if (m_dicBtn[selectheroid] != null)
			{
				(m_dicBtn[selectheroid] as ButtonWuTab).selected = true;
				m_uCurHeroID = selectheroid;
			}
			
			generateBtnList();
		}
		
		public function generateBtnList():void
		{
			var wuPro:WuProperty;
			var arOut:Array = m_gkContext.m_wuMgr.getFightWuList(true, true);
			var arIn:Array = m_gkContext.m_wuMgr.getFightWuList(false, true);
			
			var i:int;
			var top:int = 0;
			var btn:ButtonWuTab;
			for (i = 0; i < arOut.length; i++)
			{
				top += INTERVAL;
				btn = m_dicBtn[(arOut[i] as WuProperty).m_uHeroID];
				btn.y = top;
				top += BUTTONH;
			}
			
			if (arIn.length > 0)
			{
				top += 5;
				m_inImagePanel.visible = true;
				m_inImagePanel.y = top + 20;
				
				top += 7;
			}
			else
			{
				m_inImagePanel.visible = false;
			}
			
			for (i = 0; i < arIn.length; i++)
			{
				top += INTERVAL;
				btn = m_dicBtn[(arIn[i] as WuProperty).m_uHeroID];
				btn.y = top;
				top += BUTTONH;
			}
			
			if (m_dicBtn[m_uCurHeroID])
			{
				showSelectedPanel(m_dicBtn[m_uCurHeroID]);
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			var btn:ButtonWuTab = e.target as ButtonWuTab;
			if (btn != null)
			{
				m_ui.showPanel(btn.wuID, btn.tag);
				m_uCurHeroID = btn.wuID;
				
				showSelectedPanel(btn);
			}
		}
		
		public function showSelectedPanel(btn:ButtonWuTab):void
		{
			if (null == btn || (m_selectPanel.y == (btn.y - 3)))
			{
				return;
			}
			
			m_selectPanel.setPos(btn.x - 22, btn.y - 3);
			
			var res:String = "wubtnselect_green";
			var wuhero:WuHeroProperty = btn.wu as WuHeroProperty;
			if (wuhero)
			{
				switch(wuhero.color)
				{
					case WuProperty.COLOR_GREEN:
						res = "wubtnselect_green";
						break;
					case WuProperty.COLOR_BLUE:
						res = "wubtnselect_blue";
						break;
					case WuProperty.COLOR_PURPLE:
						res = "wubtnselect_purple";
						break;
				}
			}
			m_selectPanel.setPanelImageSkin("commoncontrol/button/buttonwutab/" + res + ".png");
		}
		
		public function get curSelectHeroID():uint
		{
			return m_uCurHeroID;
		}
	}

}