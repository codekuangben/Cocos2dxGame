package game.ui.uibackpack.sale 
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.controlList.CtrolComponentBase;
	import com.bit101.components.Label;
	import com.bit101.components.PanelDraw;
	import com.bit101.components.PanelShowAndHide;
	import com.dgrigg.image.CommonImageManager;
	import com.dgrigg.image.ImageForm;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	import com.pblabs.engine.resource.SWFResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import modulecommon.GkContext;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilColor;
	import modulecommon.ui.UIFormID;
	import org.ffilmation.engine.datatypes.IntPoint;
	import game.ui.uibackpack.backpack.BackPack;
	import game.ui.uibackpack.msg.stObjSaleInfo;
	import game.ui.uibackpack.msg.stSaleObjPropertyUserCmd;
	
	/**
	 * ...
	 * @author ...
	 * 为了显示同步，只有当saleobject.swf下载后，才显示此界面。为此加了变量m_bInitiated
	 */
	public class SalePart extends PanelShowAndHide 
	{
		private var m_gkContext:GkContext;
		private var m_bgPart:PanelDraw;
		protected var m_bInitiated:Boolean = false;		//已经初始化
		
		private var m_list:ControlListVHeight;
		private var m_backPack:BackPack;
		protected var m_exitBtn:PushButton;
		protected var m_saleBtn:ButtonText;
		protected var m_cancelBtn:ButtonText;
		private var m_moneyLabel:Label;
		public function SalePart(gk:GkContext, backPack:BackPack, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_backPack = backPack;
			m_bgPart = new PanelDraw(this);
			
			m_list = new ControlListVHeight(this, 30, 77);
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkContext;
			dataParam["SalePart"] = this;
			
			var m_param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			m_param.m_class = SaleItem;
			m_param.m_marginTop = 0;
			m_param.m_marginBottom = 0;
			m_param.m_intervalV = 0;
			m_param.m_width = 166;
			m_param.m_heightList = 26 * 10;
			m_param.m_lineSize = 26;
			//m_param.m_scrollType = 1;
			m_param.m_bCreateScrollBar = true;
			m_param.m_dataParam = dataParam;
			m_list.setParam(m_param);			
			
			m_list.setParam(m_param);
			
			m_gkContext.m_context.m_resMgr.load(IMAGESWF(), SWFResource, onImageSwfLoaded, onImageSwfFailed);				
		}
		public static function IMAGESWF():String
		{
			return CommonImageManager.toPathString("module/saleobject.swf");
		}
		private function onImageSwfLoaded(event:ResourceEvent):void
		{
			var resource:SWFResource = event.resourceObject as SWFResource;
			createImage(resource);
			m_gkContext.m_context.m_resMgr.unload(IMAGESWF(), SWFResource);			
		}
		
		private function createImage(res:SWFResource):void
		{
			var size:IntPoint = ImageForm.s_round(250, 474);
			this.setSize(size.x, size.y);
			m_bgPart.setSize(this.width, this.height);
			m_bgPart.addContainer();
			
			var panelContainer:PanelContainer = new PanelContainer();
			panelContainer.setSize(this.width, this.height);
			m_bgPart.addDrawCom(panelContainer, true);
			panelContainer.setSkinForm("form4.swf");
			
			panelContainer = new PanelContainer();
			panelContainer.setPos(23, 23);
			panelContainer.setSize(194, 416);
			panelContainer.setSkinGrid9Image9(ResGrid9.StypeOne);
			
			var panel:Panel = new Panel(panelContainer,3,3);
			panel.setPanelImageSkinMirrorBySWF(res, "saleobject.leftback", Image.MirrorMode_LR);
			
			panel = new Panel(panelContainer,67,9);
			panel.setPanelImageSkinBySWF(res, "saleobject.word_salelist");
			
			panel = new Panel(panelContainer,33,327);
			panel.setPanelImageSkinBySWF(res, "saleobject.word_saleprice");
			
			panel = new Panel(panelContainer,93,327);
			panel.setPanelImageSkin("commoncontrol/panel/gamemoney.png");
			
			var label:Label;
			label = new Label(panelContainer, 10, 33, "物品名称", UtilColor.GRAY);	label.miaobian = false; label.flush();
			label = new Label(panelContainer, 110, 33, "数量", UtilColor.GRAY);	label.miaobian = false; label.flush();
			label = new Label(panelContainer, 150, 33, "取消", UtilColor.GRAY);	label.miaobian = false; label.flush();
			m_bgPart.addDrawCom(panelContainer);
			m_bgPart.drawPanel();
			
			m_exitBtn = new PushButton(this,this.width-55,4);
			m_exitBtn.m_musicType = PushButton.BNMClose;
			m_exitBtn.setPanelImageSkin("commoncontrol/button/exitbtn.swf");
			m_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
				
			m_saleBtn = new ButtonText(this, 41, 400, "出售", onFunBtnClick);
			m_saleBtn.setSkinButton1ImageMirror("commoncontrol/button/button9.png", Image.MirrorMode_LR);
			
			m_cancelBtn = new ButtonText(this, 130, 400, "取消", onFunBtnClick);
			m_cancelBtn.setSkinButton1ImageMirror("commoncontrol/button/button10.png", Image.MirrorMode_LR);
			m_cancelBtn.tag = 1;
			
			m_moneyLabel = new Label(this, 140, 350);
			m_bInitiated = true;
			updatemoney();
			show();
		}
		protected function onImageSwfFailed(event:ResourceEvent):void
		{
		
		}
		
		public function deleteItem(obj:ZObject):void
		{
			m_list.deleteDataByData(obj);
			m_backPack.onRemoveToSale(obj);
			updatemoney();
		}
		
		public function addObject(obj:ZObject):void
		{
			if (hasObject(obj))
			{
				return;
			}
			m_list.insertData( -1, obj);
			m_backPack.onAddToSale(obj);
			updatemoney();
		}
		
		public function get isInitiated():Boolean
		{
			return m_bInitiated;
		}
		protected function onFunBtnClick(e:MouseEvent):void
		{
			var btn:ButtonText = e.currentTarget as ButtonText;
			var iTag:int = btn.tag;
			if (iTag == 0)
			{
				
				var sendSale:stSaleObjPropertyUserCmd = new stSaleObjPropertyUserCmd();
				
				var list:Vector.<CtrolComponentBase> = m_list.controlList;
				var item:SaleItem;
				var obj:ZObject;
				var n:int;
								
				for each(item in list)
				{
					obj = item.obj;
					n = item.num;
					if (n > 0 && n <= obj.m_object.num)
					{
						var sale:stObjSaleInfo = new stObjSaleInfo();
						sale.num = n;
						sale.thisid = obj.thisID;
						sendSale.m_list.push(sale);
					}
				}
				if (sendSale.m_list.length > 0)
				{
					m_gkContext.m_confirmDlgMgr.tempData = sendSale;
					var str:String = "出售 "+ sendSale.m_list.length+" 种道具，可获得 "+ m_moneyLabel.text+ " 银币\n是否出售?"
					m_gkContext.m_confirmDlgMgr.showMode1(UIFormID.UIBackPack, str, onConfirm, null);					
				}		
				else
				{
					m_gkContext.m_systemPrompt.prompt("没有要出售的道具");
				}
			}
			else
			{
				exit();
			}
		}
		
		private function onConfirm():Boolean
		{
			var send:stSaleObjPropertyUserCmd = m_gkContext.m_confirmDlgMgr.tempData as stSaleObjPropertyUserCmd;
			m_gkContext.sendMsg(send);
			exit();
			return true;
		}
		protected function onExitBtnClick(e:MouseEvent):void
		{
			exit();
		}
		public function exit():void
		{
			var list:Vector.<CtrolComponentBase> = m_list.controlList;
			var item:SaleItem;
			var ojb:ZObject;
			for each(item in list)
			{
				ojb = item.obj;
				m_backPack.onRemoveToSale(ojb);
			}
			m_list.clear();
			hide();
		}
		private function hasObject(obj:ZObject):Boolean
		{
			var list:Vector.<CtrolComponentBase> = m_list.controlList;
			var item:SaleItem;			
			for each(item in list)
			{
				if (obj == item.obj)
				{
					return true;
				}
			}
			return false;
		}
		public function updatemoney():void
		{
			if (m_moneyLabel == null)
			{
				return;
			}
			var nMoney:int = 0;
			var list:Vector.<CtrolComponentBase> = m_list.controlList;
			var item:SaleItem;
			var obj:ZObject;
			for each(item in list)
			{
				obj = item.obj;
				nMoney += obj.price_GameMoney * item.num;
				
			}
			m_moneyLabel.text = nMoney.toString();
		}
		
		override public function onShow():void 
		{
			super.onShow();
			m_backPack.onSalePartShow();
		}
		override public function onHide():void 
		{
			super.onHide();
			m_backPack.onSalePartHide();
		}
		
	}

}