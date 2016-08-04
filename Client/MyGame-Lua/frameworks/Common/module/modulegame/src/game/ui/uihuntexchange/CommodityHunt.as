package game.ui.uihuntexchange 
{
	import com.bit101.components.controlList.CtrolComponent;
	import com.bit101.components.label.Label2;
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;
	import game.ui.uihuntexchange.msg.stTHScoreExchangeObjCmd;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.treasurehunt.huntExchangeItem;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class CommodityHunt extends CtrolComponent 
	{
		private var m_gkcontext:GkContext;
		private var m_nameLabel:Label2;
		private var m_buyBtn:PushButton;
		private var m_scoreLabel:Label2;
		private var m_itemData:huntExchangeItem;
		private var m_objPanel:ObjectPanel;
		public function CommodityHunt(param:Object=null) 
		{
			super(param);
			m_gkcontext = param.gk;
		}
		override public function init():void 
		{
			if (!m_buyBtn)
			{
				this.setPanelImageSkin("commoncontrol/panel/zhanxing/exchangeitembg.png");
				m_nameLabel = new Label2(this, 90, 15);		
				m_scoreLabel = new Label2(this, 90, 40);
				m_buyBtn = new PushButton(this, 144, 63, onBuyClick);
				m_buyBtn.setSkinButton1Image("commoncontrol/button/buyBtn_yellow.png");
				m_itemData = m_data as huntExchangeItem;
				var objZ:ZObject = ZObject.createClientObject(m_itemData.m_id, /*m_itemData.m_num*/1);
				m_objPanel = new ObjectPanel(m_gkcontext, this, 30, 14);
				m_objPanel.setPanelImageSkin(ZObject.IconBg);
				m_objPanel.showObjectTip = true;
				m_objPanel.objectIcon.setZObject(objZ);
				//m_objPanel.objectIcon.showNum = true;
				m_nameLabel.text = objZ.name;
				m_nameLabel.setFontColor(objZ.colorValue);
				m_scoreLabel.text = "积分：" + m_itemData.m_score.toString();
			}
		}
		override public function setData(_data:Object):void 
		{
			super.setData(_data);
		}
		private function onBuyClick(e:MouseEvent):void
		{
			if (m_gkcontext.m_treasurehuntMgr.score < m_itemData.m_score)
			{
				m_gkcontext.m_systemPrompt.promptOnTopOfMousePos("积分不足",UtilColor.RED,-20);
				return;
			}
			var send:stTHScoreExchangeObjCmd = new stTHScoreExchangeObjCmd();
			send.m_id = m_itemData.m_id;		
			m_gkcontext.sendMsg(send);
		}
	}

}