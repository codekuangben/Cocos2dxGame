package game.ui.uibenefithall.subcom.jlzhaohui 
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.msg.reqRewardBackCmd;
	import game.ui.uibenefithall.subcom.PageBase;
	import game.ui.uibenefithall.xml.XmlData;
	import game.ui.uibenefithall.xml.XmlParse;
	import modulecommon.scene.prop.xml.DataXml;
	import com.util.UtilColor;
	import game.ui.uibenefithall.msg.updateRewardBackCmd;
	
	/**
	 * @brief 奖励找回
	 */
	public class JLZhaoHuiPage extends PageBase
	{
		private var m_JLZHLstPanel:JLZHLstPanel;	// 列表面板
		private var m_textLabel:Label;
		private var m_btnFree:PushButton;
		private var m_btnMoney:PushButton;
		
		public function JLZhaoHuiPage(data:DataBenefitHall, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0)
		{
			super(data, parent, xpos, ypos);
			
			m_dataBenefitHall.m_xmlData = new XmlData();
			var parsexml:XmlParse = new XmlParse(m_dataBenefitHall.m_xmlData);
			parsexml.parseXml(m_dataBenefitHall.m_gkContext.m_dataXml.getXML(DataXml.XML_Jianglizhaohui));
			initData();
			
			var msg:ByteArray = m_dataBenefitHall.m_gkContext.m_contentBuffer.getContent("updateRewardBackCmd", false) as ByteArray;
			if (msg)
			{
				psupdateRewardBackCmd(msg);
			}
		}
		
		private function initData():void
		{
			this.setPanelImageSkin("module/benefithall/jlzhaohuibg.png");
			
			m_JLZHLstPanel = new JLZHLstPanel(m_dataBenefitHall, this, 5, 0);
			
			m_btnFree = new PushButton(this, 20, 450, onBtnFree);
			m_btnFree.setPanelImageSkin("module/benefithall/jlzhaohui/jlzhaohuibtn3.swf");
			
			m_btnMoney = new PushButton(this, 170, 450, onBtnMoney);
			m_btnMoney.setPanelImageSkin("module/benefithall/jlzhaohui/jlzhaohuibtn4.swf");
			
			m_btnMoney.addEventListener(MouseEvent.ROLL_OUT, onMouseOutMoney);
			m_btnMoney.addEventListener(MouseEvent.ROLL_OVER, onMouseOverMoney);
			
			m_textLabel = new Label(this, 330, 465, "根据你七天内错过的活动为您找回经验和奖励", UtilColor.COLOR2);
		}
		
		override public function dispose():void
		{
			m_btnMoney.removeEventListener(MouseEvent.ROLL_OUT, onMouseOutMoney);
			m_btnMoney.removeEventListener(MouseEvent.ROLL_OVER, onMouseOverMoney);
			super.dispose();
		}
		
		private function onBtnFree(event:MouseEvent):void
		{
			var cmd:reqRewardBackCmd = new reqRewardBackCmd();
			cmd.type = 0;
			cmd.gtype = 0;
			m_dataBenefitHall.m_gkContext.sendMsg(cmd);
		}
		
		private function onBtnMoney(event:MouseEvent):void
		{
			var cmd:reqRewardBackCmd = new reqRewardBackCmd();
			cmd.type = 1;
			cmd.gtype = 0;
			m_dataBenefitHall.m_gkContext.sendMsg(cmd);
		}
		
		public function psupdateRewardBackCmd(msg:ByteArray):void
		{
			var cmd:updateRewardBackCmd = new updateRewardBackCmd();
			cmd.deserialize(msg);
			
			m_JLZHLstPanel.setDatas(cmd.data);
		}
		
		protected function onMouseOutMoney(event:MouseEvent):void
		{
			m_dataBenefitHall.m_gkContext.m_uiTip.hideTip();
		}
		
		protected function onMouseOverMoney(event:MouseEvent):void
		{
			var pt:Point;
			pt = m_btnMoney.localToScreen();
			m_dataBenefitHall.m_gkContext.m_uiTip.hintCondense(pt, "一键元宝找回所有未找回的活动奖励");
		}
	}
}