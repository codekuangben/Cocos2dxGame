package game.ui.uimysteryshop
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.CommonImageManager;
	import com.pblabs.engine.resource.SWFResource;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.uimysteryshop.msg.stReqRefreshSecretStoreObjListCmd;
	import game.ui.uimysteryshop.msg.stReqSecretStoreObjListCmd;
	import game.ui.uimysteryshop.xml.XmlData;
	import game.ui.uimysteryshop.xml.XmlParse;
	import modulecommon.commonfuntion.imloader.ModuleResLoader;
	import modulecommon.commonfuntion.imloader.ModuleResLoadingItem;
	import modulecommon.scene.prop.xml.DataXml;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIMysteryShop;
	import modulecommon.commonfuntion.ConfirmDialogMgr;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;

	/**
	 * @brief 神秘商店
	 */
	public class UIMysteryShop extends Form implements IUIMysteryShop
	{
		protected var m_dataShop:DataShop;
		protected var m_pnlBg:Panel;
		protected var _exitBtn:PushButton;
		protected var m_uiroot:Component;
		protected var m_objLst:Vector.<ControlPanel>;
		protected var m_XmlData:XmlData;
		protected var m_btnRefresh:PushButton; 	// 添加好友按钮
		protected var m_nameLabel:Label;		// 早晚7点自动刷新

		public function UIMysteryShop()
		{
			this.id = UIFormID.UIMysteryShop;
			this._hitYMax = 75;
			
			setAniForm(70);
		}
		
		override public function onReady():void
		{
			super.onReady();
			
			this.setSize(586, 478);
			
			//beginPanelDrawBg(458, 450);
			//endPanelDraw();
			
			m_dataShop = new DataShop();
			m_dataShop.m_mainForm = this;
			
			m_dataShop.m_resLoader = new ModuleResLoader(m_gkcontext);
			var item:ModuleResLoadingItem = new ModuleResLoadingItem();
			item.m_path = CommonImageManager.toPathString("module/uimysteryshop.swf");
			item.m_classType = SWFResource;
			
			m_dataShop.m_resLoader.addResName(item);
			m_dataShop.m_resLoader.addEventListener(ModuleResLoader.EventLoadEnd, onResReady);
			
			m_pnlBg = new Panel();
			this.addBackgroundChild(m_pnlBg);
			
			_exitBtn = new PushButton(this, 556, 30);
			_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
			
			m_uiroot = new Component(this, 15, 40);
			m_objLst = new Vector.<ControlPanel>(6, true);
			
			// 解析 xml
			m_XmlData = new XmlData();
			var parseXml:XmlParse = new XmlParse(m_XmlData);
			parseXml.parse(m_gkcontext.m_dataXml.getXML(DataXml.XML_Secretstore));
			
			m_btnRefresh = new PushButton(this, 236, 418, onBtnRefresh);
			//m_btnRefresh.setSize(90, 40);
			//m_btnRefresh.setGrid9ImageSkin("commoncontrol/button/button2.swf");
			
			// test
			//var objinfo:CommodityObject;
			var y:int = 0;
			var x:int = 0;
			while (y < 3)
			{
				x = 0;
				while(x < 2)
				{
					m_objLst[y * 2 + x] = new ControlPanel(m_dataShop, m_uiroot, m_gkcontext, 30 + x * 270, 30 + y * 110);
					m_objLst[y * 2 + x].m_idx = y * 2 + x;
					
					//objinfo = new CommodityObject();
					//objinfo.m_name = "物品";
					//objinfo.m_namecolor = 1;
					//objinfo.m_discountprice = 122;
					//objinfo.m_price = 500;
					//objinfo.m_id = 10000;
					//objinfo.m_viplevel = 2;
					//objinfo.m_discountlevel = 2;
					
					//objinfo.m_objid = 10101;
					//objinfo.m_num = 2;
					//objinfo.m_upgrade = 2;
					
					//m_objLst[y * 2 + x].setData(objinfo);
					++x;
				}
				++y;
			}
			
			m_nameLabel = new Label(this, 442, 426, "早晚7点自动刷新", UtilColor.COLOR2);
			
			if (m_gkcontext.m_rankSys.objlist && m_gkcontext.m_rankSys.objlist.length)
			{
				psstRetSecretStoreObjListCmd();
			}
			else
			{
				var cmd:stReqSecretStoreObjListCmd = new stReqSecretStoreObjListCmd();
				m_gkcontext.sendMsg(cmd);
			}
			
			m_dataShop.m_resLoader.loadRes();
		}
		
		public function onResReady(event:Event):void
		{
			this.swfRes = m_dataShop.m_resLoader.m_resLoadedDic["asset/uiimage/module/uimysteryshop.swf"];
			initRes();
		}
		
		public function initRes():void
		{
			if (isResReady())
			{
				m_pnlBg.setPanelImageSkinBySWF(m_dataShop.m_mainForm.swfRes, "uimysteryshop.formbg");
				m_btnRefresh.setPanelImageSkinBySWF(m_dataShop.m_mainForm.swfRes, "uimysteryshop.refresh");
				
				var y:int = 0;
				var x:int = 0;
				while (y < 3)
				{
					x = 0;
					while(x < 2)
					{
						m_objLst[y * 2 + x].initRes();

						++x;
					}
					++y;
				}
			}
		}
		
		override public function dispose():void
		{
			m_dataShop.m_resLoader.removeEventListener(ModuleResLoader.EventLoadEnd, onResReady);
			m_dataShop.dispose();
			super.dispose();
		}
		
		private function onBtnRefresh(event:MouseEvent):void
		{
			if (!m_gkcontext.m_rankSys.msbNoQuery)	// 如果没有设置不查询
			{
				var radio:Object = new Object();
				radio[ConfirmDialogMgr.RADIOBUTTON_select] = false;
				radio[ConfirmDialogMgr.RADIOBUTTON_desc] = "不再询问";
				var desc:String = '点击"立即刷新"需要扣除 50 元宝';
				m_gkcontext.m_confirmDlgMgr.showMode1(UIFormID.UIMysteryShop, desc, ConfirmBringBtnFn, null, "确认", "取消", radio);
			}
			else			// 如果确认了直接花钱
			{
				var cmd:stReqRefreshSecretStoreObjListCmd = new stReqRefreshSecretStoreObjListCmd();
				m_gkcontext.sendMsg(cmd);
			}
		}

		private function ConfirmBringBtnFn():Boolean
		{
			if (m_gkcontext.m_confirmDlgMgr.isRadioButtonCheck())
			{
				m_gkcontext.m_rankSys.msbNoQuery = true;
			}
			
			var cmd:stReqRefreshSecretStoreObjListCmd = new stReqRefreshSecretStoreObjListCmd();
			m_gkcontext.sendMsg(cmd);
			
			return true;
		}
		
		public function psstRetSecretStoreObjListCmd():void
		{
			if (m_gkcontext.m_rankSys.objlist && m_gkcontext.m_rankSys.objlist.length)
			{
				var y:int = 0;
				var x:int = 0;
				while (y < 3)
				{
					x = 0;
					while(x < 2)
					{
						m_objLst[y * 2 + x].setData(m_XmlData.getDataByLvlID(m_gkcontext.m_rankSys.objlist[y * 2 + x]));
						++x;
					}
					++y;
				}
			}
		}
		
		public function updateUI():void
		{
			var y:int = 0;
			var x:int = 0;
			while (y < 3)
			{
				x = 0;
				while(x < 2)
				{
					m_objLst[y * 2 + x].update();
					++x;
				}
				++y;
			}
		}
		
		public function isResReady():Boolean
		{
			return m_dataShop.m_resLoader.m_resLoaded;
		}
		
		override public function getDestPosForHide():Point 
		{
			if (m_gkcontext.m_UIs.screenBtn)
			{
				var pt:Point = m_gkcontext.m_UIs.screenBtn.getBtnPosInScreen(ScreenBtnMgr.Btn_MysteryShop);
				if (pt)
				{
					pt.x -= 10;
					return pt;
				}
			}
			return null;
		}
	}
}