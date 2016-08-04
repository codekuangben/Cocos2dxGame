package game.ui.uiXingMai.subcom 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import game.ui.uiXingMai.UIXingMai;
	import modulecommon.appcontrol.PanelDisposeEx;
	import modulecommon.GkContext;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.table.TWuPropertyItem;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author 
	 */
	public class XMrelationWuList extends Component 
	{
		private var m_gkcontext:GkContext;
		private var m_ui:UIXingMai;
		private var m_vecWuCard:Vector.<XMrelationWuCard>;
		private var m_mainHeroID:uint;
		private var m_zhuanBtn:PushButton;
		private var m_ani:Ani;
		private var m_arrowPanel:Panel;
		private var m_selectPanel:PanelDisposeEx;
		private var m_selectRelationHeroID:uint;			//选中关系武将id
		private var m_nextRelationWuList:XMrelationWuList;	//某武将低一加数级关系武将列表
		private var m_bCanZhuanSheng:Boolean;
		public function XMrelationWuList(gk:GkContext, ui:UIXingMai, /*relationwupanel:ActWuPanel,*/parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkcontext = gk;
			m_ui = ui;
			this.setSize(130, 540);
			this.setSkinForm("form9.swf");
			
			var panel:Panel;
			panel = new Panel(this, 15, 15);
			panel.autoSizeByImage = false;
			panel.setSize(100, 505);
			panel.setPanelImageSkinMirror("commoncontrol/panel/xingmai/smallback.png", Image.MirrorMode_LR);
			
			panel = new Panel(this, 28, 24);
			panel.setPanelImageSkin("commoncontrol/panel/xingmai/wujiangword.png");
			
			m_vecWuCard = new Vector.<XMrelationWuCard>();
			
		}
		public function setData(heroid:uint):void
		{
			m_mainHeroID = heroid;
			
			var i:int;
			for (i = 0; i < m_vecWuCard.length; i++)
			{
				m_vecWuCard[i].dispose();
			}
			m_vecWuCard.length = 0;
			
			var wucard:XMrelationWuCard;
			var vecActWuHeroid:Vector.<uint> = getActiveWuHeroID(m_mainHeroID);
			for (i = 0; i < vecActWuHeroid.length; i++)
			{
				wucard = new XMrelationWuCard(m_gkcontext, this, 36, 56 + 95 * i);
				wucard.setData(m_mainHeroID, vecActWuHeroid[i]);
				m_vecWuCard.push(wucard);
			}
			
			update();
		}
		private function getActiveWuHeroID(heroid:uint):Vector.<uint>
		{
			var i:int;
			var ret:Vector.<uint> = new Vector.<uint>();
			var wutableid:uint = heroid / 10;
			var npcBase:TNpcBattleItem = m_gkcontext.m_npcBattleBaseMgr.getTNpcBattleItem(wutableid);
			var wuProID:uint = wutableid * 10 + npcBase.m_uColor;
			var wuProItem:TWuPropertyItem = m_gkcontext.m_dataTable.getItem(DataTable.TABLE_WUPROPERTY, wuProID) as TWuPropertyItem;
			var vecAtiveWu:Vector.<uint> = wuProItem.getVecAtiveWu();
			
			for (i = 0; i < vecAtiveWu.length; i++)
			{
				ret.push(vecAtiveWu[i] * 10 + heroid % 10);
			}
			
			return ret;
		}
		
		public function update():void
		{
			if (m_nextRelationWuList)
			{
				m_nextRelationWuList.update();
			}
			
			m_bCanZhuanSheng = true;
			
			for each(var wucard:XMrelationWuCard in m_vecWuCard)
			{
				wucard.update();
				
				if (false == wucard.bOwned)
				{
					m_bCanZhuanSheng = false;
				}
			}
			
			if ((m_mainHeroID % 10) >= WuHeroProperty.MaxZhuanshengLevel)
			{
				if (m_zhuanBtn)
				{
					m_zhuanBtn.visible = false;
					if (m_ani && this.contains(m_ani))
					{
						this.removeChild(m_ani);
						m_ani.stop();
					}
				}
				
				m_bCanZhuanSheng = false;
			}
			else
			{
				if (null == m_zhuanBtn)
				{
					m_zhuanBtn = new PushButton(this, 10, 470, onZhuanBtnClick);
					m_zhuanBtn.setSize(111, 45);
					m_zhuanBtn.setSkinButton1Image("commoncontrol/button/zhuanshengBtn.png");
				}
				
				if (m_bCanZhuanSheng)
				{
					if (null == m_ani)
					{
						m_ani = new Ani(m_gkcontext.m_context);
						m_ani.duration = 2;
						m_ani.repeatCount = 0;
						m_ani.setImageAni("ejjianjiaosejianru.swf");
						m_ani.centerPlay = true;
						m_ani.mouseEnabled = false;
						m_ani.x = 65;
						m_ani.y = 488;
						m_ani.scaleX = 0.48;
						m_ani.scaleY = 0.56;
					}
					this.addChild(m_ani);
					m_ani.begin();
				}
				else
				{
					if (m_ani)
					{
						if (this.contains(m_ani))
						{
							this.removeChild(m_ani);
						}
						m_ani.stop();
					}
				}
				
				m_zhuanBtn.visible = true;
			}
		}
		
		//点击“转生”按钮
		private function onZhuanBtnClick(event:MouseEvent):void
		{
			if (event.target is PushButton)
			{
				if (false == m_bCanZhuanSheng)
				{
					var wu:WuHeroProperty = m_gkcontext.m_wuMgr.getWuByHeroID(m_mainHeroID) as WuHeroProperty;
					m_ui.m_fastZhuangMgr.zhuansheng(wu);
					return;
				}
				
				var info:Object = new Object();
				info["heroid"] = m_mainHeroID;
				m_gkcontext.m_contentBuffer.addContent("uiwuzhuansheng_info", info);
				
				var form:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIWuZhuansheng);
				if (form)
				{
					form.updateData(info);
				}
				else
				{
					m_gkcontext.m_UIMgr.showFormEx(UIFormID.UIWuZhuansheng);
				}
			}
		}
		
		public function hideNextList():void
		{
			if (m_arrowPanel && this.contains(m_arrowPanel))
			{
				this.removeChild(m_arrowPanel);
				m_arrowPanel.dispose();
				m_arrowPanel = null;
			}
			
			if (m_nextRelationWuList)
			{
				m_nextRelationWuList.hideNextList();
				this.removeChild(m_nextRelationWuList);
				m_nextRelationWuList.dispose();
				m_nextRelationWuList = null;
			}
		}
		
		//隐藏下一关系武将列表（即关系武将显示第2列(含)以后）
		public function hideNextRelationWuListByHeroID(heroid:uint):void
		{
			if (m_nextRelationWuList)
			{
				m_nextRelationWuList.hideNextRelationWuListByHeroID(heroid);
				if (m_nextRelationWuList.heroID == heroid)
				{
					hideNextList();
				}
			}
		}
		
		override public function dispose():void
		{
			if (m_ani && !m_ani.parent)
			{
				m_ani.dispose();
			}
			
			super.dispose();
		}
		
		public function get heroID():uint
		{
			return m_mainHeroID;
		}
		
		//***显示关系武将下一加数的关系武将列表**********************************/
		public function showNextRelationWuList(nextheroid:uint):void
		{
			if (null == m_nextRelationWuList)
			{
				m_nextRelationWuList = new XMrelationWuList(m_gkcontext, m_ui,/* m_relationWuPanel,*/ this, 130, 0);
			}
			m_nextRelationWuList.hideNextList();
			m_nextRelationWuList.setData(nextheroid);
			
			if (m_arrowPanel)
			{
				m_arrowPanel.visible = false;
			}
			
			if (null == m_arrowPanel)
			{
				m_arrowPanel = new Panel(this, 100, 65);
				m_arrowPanel.setPanelImageSkin("commoncontrol/panel/backpack/arrow.png");
				m_arrowPanel.visible = false;
				m_arrowPanel.mouseChildren = false;
				m_arrowPanel.mouseEnabled = false;
				
				m_selectPanel = new PanelDisposeEx();
				m_selectPanel.setSize(78, 90);
				m_selectPanel.setSkinGrid9Image9(ResGrid9.StypeCardSelect);
				m_selectPanel.setPos(-74, -18);
				m_selectPanel.show(m_arrowPanel);
			}
			
			for (var i:int = 0; i < m_vecWuCard.length; i++)
			{
				if (selectRelationHeroID == m_vecWuCard[i].activeHeroID)
				{
					m_arrowPanel.y = 65 + i * 95;
					m_arrowPanel.visible = true;
					break;
				}
			}
		}
		
		public function get selectRelationHeroID():uint
		{
			return m_selectRelationHeroID;
		}
		
		public function set selectRelationHeroID(heroid:uint):void
		{
			m_selectRelationHeroID = heroid;
		}
		
	}

}