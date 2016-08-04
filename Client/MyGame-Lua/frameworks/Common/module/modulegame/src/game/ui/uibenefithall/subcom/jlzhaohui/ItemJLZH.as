package game.ui.uibenefithall.subcom.jlzhaohui 
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.msg.RewardBackItem;
	import game.ui.uibenefithall.xml.XmlJLZHActiveIteam;
	import modulecommon.GkContext;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import game.ui.uibenefithall.msg.reqRewardBackCmd;
	
	/**
	 * @brief 奖励的一行，一行中有两个 JLObj
	 */
	public class ItemJLZH extends CtrolVHeightComponent
	{
		private var m_dataBenefitHall:DataBenefitHall;
		private var m_itemData:RewardBackItem;
		
		private var m_backPanel:Panel;					//背景
		private var m_iconPanel:Panel;					//图标
		//private var m_namePanel:Panel;					//名称

		private var m_descLabel:Label;					//描述
		private var m_textLabel:Label;					//可找回的奖励的内容
		
		private var m_btnFree:PushButton;
		private var m_btnMoney:PushButton;
		private var m_pnlBtn:Panel;					// 按钮美术字
		
		private var m_objLst:Vector.<JLObj>;			// 显示的奖励
		private var m_pnlLine:Panel;					// 分割线
		
		public function ItemJLZH(param:Object) 
		{
			m_dataBenefitHall = param["data"] as DataBenefitHall;
			
			m_backPanel = new Panel(this, 0, 8);
			m_backPanel.setPanelImageSkin("module/benefithall/jlzhaohui/itembg.png");
			
			m_iconPanel = new Panel(this, 28, 30);
			//m_iconPanel.autoSizeByImage = false;
			
			//m_namePanel = new Panel(this, 0, 30);
			//m_namePanel.autoSizeByImage = false;
			
			m_descLabel = new Label(this, 144, 125, "累计未完成奖励次数", UtilColor.WHITE_Yellow);
			m_descLabel.align = Component.CENTER;
			m_descLabel.mouseEnabled = true;
			
			m_textLabel = new Label(this, 65, 14, "可找回的奖励内容:", UtilColor.WHITE_Yellow);
			m_textLabel.align = Component.CENTER;
			m_textLabel.mouseEnabled = true;
			
			m_btnFree = new ButtonText(this, 386, 113, "免费找回", onBtnFree);
			m_btnFree.setPanelImageSkin("module/benefithall/jlzhaohui/jlzhaohuibtn1.swf");
			
			//m_btnFree.addEventListener(MouseEvent.ROLL_OUT, onMouseOutFree);
			//m_btnFree.addEventListener(MouseEvent.ROLL_OVER, onMouseOverFree);
			
			m_btnMoney = new PushButton(this, 503, 113, onBtnMoney);
			m_btnMoney.setPanelImageSkin("module/benefithall/jlzhaohui/jlzhaohuibtn2.swf");
			
			m_btnMoney.addEventListener(MouseEvent.ROLL_OUT, onMouseOutMoney);
			m_btnMoney.addEventListener(MouseEvent.ROLL_OVER, onMouseOverMoney);
			
			m_pnlBtn = new Panel(this, 520, 113);
			m_pnlBtn.setPanelImageSkin("module/benefithall/jlzhaohui/yanbaozhaohui.png");
			m_pnlBtn.mouseEnabled = false;
			
			m_objLst = new Vector.<JLObj>();
			//m_objLst.push(new JLObj(m_dataBenefitHall, this, 90, 40));		// 如果少于三个，就从 90 40 开始，如果大于两个，就从 90 10  90 74 
			
			m_pnlLine = new Panel(this, 0, 149);
			m_pnlLine.setPanelImageSkin("module/benefithall/jlzhaohui/seperateline.png");
			
			this.setSize(662, 147);
		}
		
		override public function dispose():void
		{
			//m_btnFree.removeEventListener(MouseEvent.ROLL_OUT, onMouseOutFree);
			//m_btnFree.removeEventListener(MouseEvent.ROLL_OVER, onMouseOverFree);
			
			m_btnMoney.removeEventListener(MouseEvent.ROLL_OUT, onMouseOutMoney);
			m_btnMoney.removeEventListener(MouseEvent.ROLL_OVER, onMouseOverMoney);
			
			super.dispose();
		}
		
		override public function setData(data:Object):void
		{
			super.setData(data);
			m_itemData = data as RewardBackItem;
			
			update();
		}
		
		private function onBtnFree(event:MouseEvent):void
		{
			var cmd:reqRewardBackCmd = new reqRewardBackCmd();
			cmd.type = 0;
			cmd.gtype = m_itemData.type;
			m_dataBenefitHall.m_gkContext.sendMsg(cmd);
		}
		
		private function onBtnMoney(event:MouseEvent):void
		{
			var cmd:reqRewardBackCmd = new reqRewardBackCmd();
			cmd.type = 1;
			cmd.gtype = m_itemData.type;
			m_dataBenefitHall.m_gkContext.sendMsg(cmd);
		}
		
		override public function update():void
		{
			var activeitem:XmlJLZHActiveIteam = m_dataBenefitHall.m_xmlData.findActiveItemByID(m_itemData.type);
			if (activeitem)
			{
				m_iconPanel.setPanelImageSkin(activeitem.m_picPath);
			}
			
			m_descLabel.text = "累计未完成奖励次数: " + m_itemData.count;
			
			var posLst:Vector.<Point> = new Vector.<Point>();
			if (m_itemData.size < 3)
			{
				posLst.push(new Point(135, 40));
				posLst.push(new Point(390, 40));
			}
			else
			{
				posLst.push(new Point(135, 15));
				posLst.push(new Point(390, 15));
				posLst.push(new Point(135, 65));
				posLst.push(new Point(390, 65));
			}

			var idx:int = 0;
			if (m_objLst.length)
			{
				while (idx < m_objLst.length)
				{
					this.removeChild(m_objLst[idx]);
					++idx;
				}
				m_objLst.length = 0;
			}
			idx = 0;
			while (idx < m_itemData.size)
			{
				m_objLst.push(new JLObj(m_dataBenefitHall, m_itemData.data[idx], this, posLst[idx].x, posLst[idx].y));
				++idx;
			}
		}
		
		//protected function onMouseOutFree(event:MouseEvent):void
		//{
		//	m_dataBenefitHall.m_gkContext.m_uiTip.hideTip();
		//}
		
		//protected function onMouseOverFree(event:MouseEvent):void
		//{
		//	
		//}
		
		protected function onMouseOutMoney(event:MouseEvent):void
		{
			m_dataBenefitHall.m_gkContext.m_uiTip.hideTip();
		}
		
		protected function onMouseOverMoney(event:MouseEvent):void
		{
			var pt:Point;
			pt = m_btnMoney.localToScreen();
			m_dataBenefitHall.m_gkContext.m_uiTip.hintCondense(pt, "消耗" + m_itemData.yuanbao + "元宝");
		}
	}
}