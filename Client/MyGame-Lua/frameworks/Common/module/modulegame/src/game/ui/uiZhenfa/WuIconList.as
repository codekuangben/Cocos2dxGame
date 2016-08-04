package game.ui.uiZhenfa
{
	import com.bit101.components.ButtonTabText;
	import com.bit101.components.Component;
	import com.bit101.components.controlList.ControlAlignmentParam;
	import com.bit101.components.controlList.ControlList;
	import com.bit101.components.controlList.CtrolComponent;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	import com.dnd.DragListener;
	import com.dnd.DragManager;
	import com.pblabs.engine.resource.SWFResource;
	import common.event.DragAndDropEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import flash.display.DisplayObjectContainer;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.scene.fight.ZhenfaMgr;
	import modulecommon.scene.wu.WuProperty;
	import flash.geom.Rectangle;
	import game.ui.uiZhenfa.xiayewulist.XiayeWuList;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class WuIconList extends PanelContainer implements DragListener
	{
		private static const HEIGHT:int = 360;
		
		private var m_gkContext:GkContext;
		private var m_dicBtn:Dictionary;
		private var m_curPage:uint;
		private var m_CountInPage:uint;
		
		private var m_inImagePanel:Panel; //未出战武将
		private var m_outImagePanel:Panel; //出战武将
		private var m_dragLPanel:Panel;
		private var m_fightWuList:ControlList;
		private var m_notFightWuList:ControlList;
		
		private var m_List:Panel;
		private var m_container:Panel;
		private var m_curPos:int;
		private var m_totalH:int; //总的高度
		private var m_preBtn:PushButton;
		private var m_nextBtn:PushButton;
		private var m_pageLabel:Label;
		private var m_uiZhenfa:UIZhenfa;
		
		public function WuIconList(parent:DisplayObjectContainer, gk:GkContext)
		{
			m_gkContext = gk;
			m_uiZhenfa = parent as UIZhenfa;
			super(parent);
			this.setDropTrigger(true);
			this.setSize(150, 400);
			
			m_List = new Panel(this);
			m_container = new Panel(m_List);
			var rect:Rectangle = new Rectangle(0, 0, 150, HEIGHT);
			m_List.scrollRect = rect;
			
			m_outImagePanel = new Panel(m_container, 22, 5);
			m_outImagePanel.setSize(75, 21);
			
			m_inImagePanel = new Panel(m_container, 20, 0);
			m_inImagePanel.setSize(75, 20);
			
			m_dragLPanel = new Panel(m_container, 86, 0);
			m_dragLPanel.setSize(65, 35);
			
			var obj:Object = new Object();
			obj["gk"] = m_gkContext;
			obj["uizhenfa"] = m_uiZhenfa;
			
			var param:ControlAlignmentParam = new ControlAlignmentParam();
			param.m_class = WuIconItem;
			param.m_width = WuProperty.SQUAREHEAD_WIDHT;
			param.m_height = WuProperty.SQUAREHEAD_HEIGHT;
			param.m_intervalH = 0;
			param.m_intervalV = 0;
			param.m_marginTop = 0;
			param.m_marginBottom = 0;
			param.m_marginLeft = 0;
			param.m_marginRight = 0;
			param.m_needScroll = false;
			param.m_numColumn = 2;
			param.m_bAutoHeight = true;
			param.m_dataParam = obj;
			
			m_fightWuList = new ControlList(m_container);
			m_fightWuList.setParam(param);
			m_notFightWuList = new ControlList(m_container);
			m_notFightWuList.setParam(param);
		}
		
		public function initData(res:SWFResource):void
		{
			var btn:ButtonTabText;
			var wuPro:WuProperty;
			//var arr:Array = m_gkContext.m_wuMgr.getAllWu();
			m_CountInPage = 6;
			
			m_outImagePanel.setPanelImageSkin("commoncontrol/panel/wuout.png");
			m_inImagePanel.setPanelImageSkin("commoncontrol/panel/wuin.png");
			m_inImagePanel.visible = false;
			m_dragLPanel.setPanelImageSkinBySWF(res, "zhenfa.dragL");
			m_dragLPanel.visible = false;
			
		}
		
		public function adjustPos():void
		{
			m_inImagePanel.visible = false;
			m_dragLPanel.visible = false;
			m_fightWuList.y = m_outImagePanel.y + m_outImagePanel.height + 5;
			var hidePage:Boolean = false;
			if (m_notFightWuList.height > 0)
			{
				m_inImagePanel.visible = true;
				m_dragLPanel.visible = true;
				m_inImagePanel.y = m_fightWuList.y + m_fightWuList.height + 18;
				if (m_fightWuList.height == 0)
				{
					m_inImagePanel.y += 72;
				}
				m_notFightWuList.y = m_inImagePanel.y + m_inImagePanel.height + 2;
				m_totalH = m_notFightWuList.y + m_notFightWuList.height;
				m_dragLPanel.y = m_inImagePanel.y - 10;
				
				if (m_totalH > HEIGHT)
				{
					
					if (m_preBtn == null)
					{
						m_preBtn = new PushButton(this, 15, 390, onPageBtnClick);
						m_preBtn.setPanelImageSkin("commoncontrol/button/leftArrow2.swf");
						m_preBtn.tag = 0;
						m_preBtn.m_musicType = PushButton.BNMPage;
						
						m_nextBtn = new PushButton(this, 81, 390, onPageBtnClick);
						m_nextBtn.setPanelImageSkinMirror("commoncontrol/button/leftArrow2.swf", Image.MirrorMode_HOR);
						m_nextBtn.tag = 1;
						m_nextBtn.m_musicType = PushButton.BNMPage;
						
						m_pageLabel = new Label(this, 57, 390);
						m_pageLabel.align = Component.CENTER;
						m_pageLabel.setBold(true);
						m_pageLabel.setLetterSpacing(3);
					}
					else
					{
						m_preBtn.visible = true;
						m_nextBtn.visible = true;
						m_pageLabel.visible = true;
					}
					
					if (m_curPos > 0)
					{
						m_preBtn.enabled = true;
					}
					else
					{
						m_preBtn.enabled = false;
					}
					
					if (m_curPos + HEIGHT >= m_totalH)
					{
						m_nextBtn.enabled = false;
					}
					else
					{
						m_nextBtn.enabled = true;
					}
					updatePage();
				}
				else
				{
					hidePage = true;
				}
			}
			else
			{
				hidePage = true;				
			}
			if (hidePage)
			{
				if (m_preBtn != null)
				{
					m_preBtn.visible = false;
					m_nextBtn.visible = false;
					m_pageLabel.visible = false;
				}
				m_curPos = 0;
				m_container.y = -m_curPos;
			}
		}
		
		public function build():void
		{
			var wuPro:WuProperty;
			var arFight:Array = m_gkContext.m_wuMgr.getFightWuList(true, false);
			var arNotFight:Array = m_gkContext.m_wuMgr.getFightWuList(false, false);
			
			m_fightWuList.setDatas(arFight);
			m_notFightWuList.setDatas(arNotFight);			
		}
		
		public function generate():void
		{
			build();
			adjustPos();
			m_uiZhenfa.updateAllWuZhanli();
		}
		
		public function showNewHandToWuList():void
		{
			var functype:int = m_gkContext.m_sysnewfeatures.m_nft;
			
			if (m_gkContext.m_newHandMgr.isVisible() && (SysNewFeatures.NFT_ZHENFA == functype || SysNewFeatures.NFT_FHLIMIT4 == functype))
			{
				var wuitem:WuIconItem;
				
				if (SysNewFeatures.NFT_ZHENFA == functype)
				{
					wuitem = getWuIconByHeroID(1010);	//1010 赵云
					if (null == wuitem)
					{
						wuitem = getWuIconByHeroID(1080);	//1080 公孙瓒
					}
				}
				else if (SysNewFeatures.NFT_FHLIMIT4 == functype)
				{
					wuitem = getWuIconByHeroID(1400); //1400 刘禅
				}
				
				if (wuitem && wuitem.wu.antiChuzhan)
				{
					m_gkContext.m_newHandMgr.setFocusFrame(-10, -10, 78, 92, 1);
					m_gkContext.m_newHandMgr.prompt(true, 0, 70, "左键拿起武将。", wuitem);
				}
				else
				{
					m_gkContext.m_newHandMgr.hide();
				}
			}
		}
		
		//通过heroid获得武将列表中某一武将Icon
		private function getWuIconByHeroID(heroid:uint):WuIconItem
		{
			var wuitem:WuIconItem;
			var com:CtrolComponent;
			
			for each(com in m_notFightWuList.controlList)
			{
				wuitem = (com as WuIconItem);
				if (wuitem.wu.m_uHeroID == heroid)
				{
					return wuitem;
				}
			}
			
			for each(com in m_fightWuList.controlList)
			{
				wuitem = (com as WuIconItem);
				if (wuitem.wu.m_uHeroID == heroid)
				{
					return wuitem;
				}
			}
			
			return null;
		}
		
		protected function updatePage():void
		{
			var str:String;
			var curPage:int = m_curPos / HEIGHT + 1;
			
			var totalPage:int = m_totalH / HEIGHT + 1;
			if (m_totalH % HEIGHT == 0)
			{
				totalPage--;
			}
			str = curPage.toString() + "/" + totalPage.toString();
			m_pageLabel.text = str;
			
			m_container.y = -m_curPos;
		}
		
		public function onPageBtnClick(e:MouseEvent):void
		{
			var btn:PushButton = e.target as PushButton;
			if (btn == null)
			{
				return;
			}
			
			switch (btn.tag)
			{
				case 0: 
				{
					m_curPos -= HEIGHT;
					if (m_curPos == 0)
					{
						m_preBtn.enabled = false;
					}
					if (m_nextBtn.enabled == false)
					{
						m_nextBtn.enabled = true;
					}
					break;
				}
				case 1: 
				{
					m_curPos += HEIGHT;
					if (m_curPos + HEIGHT >= m_totalH)
					{
						m_nextBtn.enabled = false;
					}
					
					if (m_preBtn.enabled == false)
					{
						m_preBtn.enabled = true;
					}
					break;
				}
			}
			updatePage();
		}
		
		public function onReadyDrop (e:DragAndDropEvent) : void
		{
			//
		}
		
		public function onDragDrop (e:DragAndDropEvent) : void
		{
			//
		}
		
		public function onDragEnter (e:DragAndDropEvent) : void{}
		
		public function onDragExit (e:DragAndDropEvent) : void{}
		
		public function onDragOverring (e:DragAndDropEvent) : void{}
		
		public function onDragStart (e:DragAndDropEvent) : void { }
	}

}