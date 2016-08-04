package game.ui.market 
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Label;
	import com.bit101.components.label.Label2;
	import com.bit101.components.label.LabelFormat;
	import com.bit101.components.numberchange.NumberChangeCtrl;
	import flash.events.MouseEvent;
	import modulecommon.net.msg.shoppingCmd.stBuyMarketObjCmd;
	import modulecommon.scene.market.stMarket;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.ui.Form;
	import modulecommon.ui.FormStyleExitBtn;
	
	/**
	 * ...
	 * @author 
	 */
	public class UIMarketBuy_Base_Base extends FormStyleExitBtn 
	{
		
		protected var m_obj:ZObject;		
		
		protected var m_objPanel:ObjectPanel;
		protected var m_nameLabel:Label;	
		protected var m_numLabel:Label2;
		protected var m_numberCtrl:NumberChangeCtrl;
		
		protected var m_buyBtn:ButtonText;
		public function UIMarketBuy_Base_Base()
		{
			super();
			exitMode = EXITMODE_HIDE;
		}
		protected function setPanelAndName(id:uint):void
		{
			m_obj = ZObject.createClientObject(id);
			m_objPanel.objectIcon.setZObject(m_obj);
			m_nameLabel.text = m_obj.name;
			m_nameLabel.setFontColor(m_obj.colorValue);
		}
		override public function onReady():void 
		{
			
			m_exitBtn.setPos(262, 6);
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			
			m_objPanel = new ObjectPanel(m_gkcontext, this, 36, 59);
			
			m_objPanel.setPanelImageSkin(ZObject.IconBg);
			m_objPanel.showObjectTip = true;
			m_objPanel.objectIcon.showNum = false;
			
			m_nameLabel = new Label(this, 100, 72);
			
			m_numLabel = new Label2(this, 52, 160);
			m_numLabel.text = "购买数量";
			
		
			
			m_numberCtrl = new NumberChangeCtrl(this, 117, 159);
			m_numberCtrl.setSurface(80, 105, 0, 75);
			m_numberCtrl.funOnNumberChange = numOnChange;
			
			m_buyBtn = new ButtonText(this, 92, 196, "确认购买", onBuyBtnClick);
			m_buyBtn.setSize(100, 42);
			m_buyBtn.setGrid9ImageSkin("commoncontrol/button/button2.swf");
	
			m_bInitiated = true;
			this.draggable = false;
			this.darkOthers();
			timeForTimingClose = 10;
		}			
		
	
		protected function numOnChange(n:int):void
		{			
			
		}
		
		protected function onBuyBtnClick(e:MouseEvent):void
		{
			
		}
		
	}

}