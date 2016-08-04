package game.ui.uimysteryshop
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.CtrolComponent;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import game.ui.uimysteryshop.CommodityBase;
	import game.ui.uimysteryshop.CommodityHero;
	import game.ui.uimysteryshop.CommodityMoney;
	import game.ui.uimysteryshop.CommodityWuxue;
	import game.ui.uimysteryshop.CommodityObject;
	import com.bit101.components.Panel;
	import modulecommon.uiinterface.IUIMysteryShop;
	
	
	/**
	 * ...
	 * @author 
	 */
	public class ControlPanel extends Component 
	{
		protected var m_dataShop:DataShop;
		protected var m_bg:Panel;
		public var vippanel:Panel;		// 这个是折扣
		private var m_commondityPanel:CommodityPanel;
		public var m_gkContext:GkContext;
		public var m_vipbg:Panel;
		public var m_vippanel:Panel;
		
		public var m_idx:uint = 0;
		
		public function ControlPanel(data:DataShop, parent:DisplayObjectContainer=null,gk:GkContext=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_dataShop = data;
			m_gkContext = gk as GkContext;
			
			m_bg = new Panel(this);
		}
		
		public function setData(data:Object):void 
		{
			//this.setPanelImageSkin("commoncontrol/panel/yizhelibao/vipbg.png");
			
			if (m_commondityPanel)
			{
				this.removeChild(m_commondityPanel);
				m_commondityPanel.dispose();
				m_commondityPanel = null;
			}

			if(data is CommodityHero)
			{
				m_commondityPanel = new CommodityPanel_WuJiang(m_dataShop, this, m_gkContext, 0, -8);
				m_commondityPanel.m_idx = m_idx;
				m_commondityPanel.setData(data as CommodityHero);
			}
			else if(data is CommodityMoney)
			{
				m_commondityPanel = new CommodityPanel_Money(m_dataShop, this, m_gkContext, 0, -8);
				m_commondityPanel.m_idx = m_idx;
				m_commondityPanel.setData(data as CommodityMoney);
			}
			else if(data is CommodityWuxue)
			{
				m_commondityPanel = new CommodityPanel_Wuxue(m_dataShop, this, m_gkContext, 0, -8);
				m_commondityPanel.m_idx = m_idx;
				m_commondityPanel.setData(data as CommodityWuxue);
			}
			else if(data is CommodityObject)
			{
				m_commondityPanel = new CommodityPanel_Object(m_dataShop, this, m_gkContext, 0, -8);
				m_commondityPanel.m_idx = m_idx;
				m_commondityPanel.setData(data as CommodityObject);
			}
			
			if (m_vipbg)
			{
				this.removeChild(m_vipbg);
				m_vipbg.dispose();
				m_vipbg = null;
			}
			
			if (m_vippanel)
			{
				this.removeChild(m_vippanel);
				m_vippanel.dispose();
				m_vippanel = null;
			}
			
			m_vipbg = new Panel(this, 168, 2);
			m_vippanel = new Panel(this, 168, 2);
			
			//switch(data.m_discountlevel)
			//{
			///	case 1:{m_vippanel.setPanelImageSkin("commoncontrol/panel/yizhelibao/vip1.png"); break;}
			//	case 2:{m_vippanel.setPanelImageSkin("commoncontrol/panel/yizhelibao/vip2.png"); break;}
			//	case 3:{m_vippanel.setPanelImageSkin("commoncontrol/panel/yizhelibao/vip3.png"); break;}
			//	case 4:{m_vippanel.setPanelImageSkin("commoncontrol/panel/yizhelibao/vip4.png"); break;}
			//	case 5:{m_vippanel.setPanelImageSkin("commoncontrol/panel/yizhelibao/vip5.png"); break;}
			//	case 6:{m_vippanel.setPanelImageSkin("commoncontrol/panel/yizhelibao/vip6.png"); break;}
			//	default: break;
			//}
			
			initRes();
		}
		
		public static function s_compare(data:Object, param:Object):Boolean
		{
			if ((data as CommodityBase).m_id == param)
			{
				return true;
			}
			return false;
		}
		
		public function update():void 
		{
			m_commondityPanel.upDataBtnandPanel();
		}
		
		public function initRes():void
		{
			if ((m_dataShop.m_mainForm as IUIMysteryShop).isResReady())
			{
				this.m_bg.setPanelImageSkinBySWF(m_dataShop.m_mainForm.swfRes, "uimysteryshop.gridbg");
				if (this.m_vipbg)
				{
					this.m_vipbg.setPanelImageSkinBySWF(m_dataShop.m_mainForm.swfRes, "uimysteryshop.red");
				}
				if (m_vippanel)
				{
					switch(m_commondityPanel.m_commodityData.m_discountlevel)
					{
						case 1:{m_vippanel.setPanelImageSkinBySWF(m_dataShop.m_mainForm.swfRes, "uimysteryshop.1f"); break;}
						case 2:{m_vippanel.setPanelImageSkinBySWF(m_dataShop.m_mainForm.swfRes, "uimysteryshop.2f"); break;}
						case 3:{m_vippanel.setPanelImageSkinBySWF(m_dataShop.m_mainForm.swfRes, "uimysteryshop.3f"); break;}
						case 4:{m_vippanel.setPanelImageSkinBySWF(m_dataShop.m_mainForm.swfRes, "uimysteryshop.4f"); break;}
						case 5:{m_vippanel.setPanelImageSkinBySWF(m_dataShop.m_mainForm.swfRes, "uimysteryshop.5f"); break;}
						case 6:{m_vippanel.setPanelImageSkinBySWF(m_dataShop.m_mainForm.swfRes, "uimysteryshop.6f"); break;}
						case 7:{m_vippanel.setPanelImageSkinBySWF(m_dataShop.m_mainForm.swfRes, "uimysteryshop.7f"); break;}
						case 8:{m_vippanel.setPanelImageSkinBySWF(m_dataShop.m_mainForm.swfRes, "uimysteryshop.8f"); break;}
						case 9:{m_vippanel.setPanelImageSkinBySWF(m_dataShop.m_mainForm.swfRes, "uimysteryshop.9f"); break;}
						default: break;
					}
				}
				
				if (m_commondityPanel)
				{
					m_commondityPanel.initRes();
				}
			}
		}
	}
}