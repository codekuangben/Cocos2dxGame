package game.ui.uibenefithall.subcom.jlzhaohui
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.msg.RewardBackValue;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilColor;

	/**
	 * @brief 一项奖励内容
	 */
	public class JLObj extends Component
	{
		private var m_pnlicon:ObjectPanel;	// 装备图标
		//private var m_pnlOther:Panel;		// 钱或者经验就在这里显示
		
		public var m_objData:RewardBackValue;
		private var m_lblFreeCap:Label;					// 免费找回名字
		private var m_lblFree:Label;					// 免费找回值
		private var m_pnlLbl:Panel;						// Lbl美术字
		private var m_lblMoney:Label;					// 金砖找回值
		private var m_dataBenefitHall:DataBenefitHall;

		public function JLObj(databenefithall:DataBenefitHall, data:RewardBackValue, parent:DisplayObjectContainer, xpos:Number, ypos:Number)
		{
			super(parent, xpos, ypos);
			m_dataBenefitHall = databenefithall;
			
			m_objData = data;
			
			// 设置物品面板
			m_pnlicon = new ObjectPanel(m_dataBenefitHall.m_gkContext, this);
			m_pnlicon.setPos(0, 0);
			m_pnlicon.setSize(ZObject.IconBgSize, ZObject.IconBgSize);
			m_pnlicon.autoSizeByImage = false;
			m_pnlicon.setPanelImageSkin(ZObject.IconBg);
			
			m_pnlicon.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			m_pnlicon.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			
			//m_pnlOther = new Panel(this);
			//m_pnlOther.addEventListener(MouseEvent.ROLL_OUT, onMouseOutOther);
			//m_pnlOther.addEventListener(MouseEvent.ROLL_OVER, onMouseOverOther);
			
			var obj:ZObject;
			var objid:uint;
			if (m_objData.type == uint.MAX_VALUE)	// -1 是经验
			{
				objid = m_dataBenefitHall.m_gkContext.m_beingProp.expObjID();
				obj = ZObject.createClientObject(objid);
			}
			else if (isMontyType(m_objData.type))		// 如果是钱类型
			{
				objid = m_dataBenefitHall.m_gkContext.m_beingProp.tokenIconIDByType(m_objData.type);
				obj = ZObject.createClientObject(objid);
			}
			else
			{
				obj = ZObject.createClientObject(m_objData.type);
			}
			m_pnlicon.objectIcon.setZObject(obj);
			m_pnlicon.objectIcon.showNum = false;
			
			m_lblFreeCap = new Label(this, 60, 0, "普通找回", UtilColor.COLOR2);
			m_lblFree = new Label(this, 130, 0, ": +" + m_objData.freeValue, UtilColor.COLOR2);
			
			m_pnlLbl = new Panel(this, 57, 14);
			m_pnlLbl.setPanelImageSkin("module/benefithall/jlzhaohui/yanbaozhaohui.png");
			m_lblMoney = new Label(this, 130, 20, ": +" +  + m_objData.ybValue, UtilColor.GREEN);
		}
		
		override public function dispose():void
		{
			if (m_pnlicon)
			{
				m_pnlicon.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				m_pnlicon.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			}
			//if (m_pnlOther)
			//{
			//	m_pnlOther.removeEventListener(MouseEvent.ROLL_OUT, onMouseOutOther);
			//	m_pnlOther.removeEventListener(MouseEvent.ROLL_OVER, onMouseOverOther);
			//}
			
			super.dispose();
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			m_dataBenefitHall.m_gkContext.m_uiTip.hideTip();
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			var pt:Point;
			//if (m_objData.type == uint.MAX_VALUE)	// -1 是经验
			//{
			//	pt = m_pnlicon.localToScreen();
			//	m_dataBenefitHall.m_gkContext.m_uiTip.hintCondense(pt, "经验");
			//}
			//else if (isMontyType(m_objData.type))		// 如果是钱类型
			//{
			//	pt = m_pnlicon.localToScreen();
			//	m_dataBenefitHall.m_gkContext.m_uiTip.hintCondense(pt, type2Str(m_objData.type));
			//}
			//else
			{
				if (event.currentTarget is ObjectPanel)
				{
					var panel:ObjectPanel = event.currentTarget as ObjectPanel;
					pt = panel.localToScreen();
					
					var obj:ZObject = panel.objectIcon.zObject;
					if (obj != null)
					{
						m_dataBenefitHall.m_gkContext.m_uiTip.hintObjectInfo(pt, obj);
					}
				}
			}
		}
		
		//protected function onMouseOutOther(event:MouseEvent):void
		//{
		//	m_dataBenefitHall.m_gkContext.m_uiTip.hideTip();
		//}
		
		//protected function onMouseOverOther(event:MouseEvent):void
		//{
		//	
		//}
		
		protected function isMontyType(type:uint):Boolean
		{
			if (1 <= type && type <= 10)
			{
				return true;
			}
			
			return false;
		}
		
		protected function type2Str(type:uint):String
		{
			var str:String;
			switch(type)
			{
				case BeingProp.SILVER_COIN: str = "银币"; break;
				case BeingProp.GOLD_COIN: str = "金币"; break;
				case BeingProp.YUAN_BAO: str = "元宝"; break;
				case BeingProp.LING_PAI: str = "令牌"; break;
				case BeingProp.RONGYU_PAI: str = "荣誉勋章"; break;
				case BeingProp.XINGYUN_BI: str = "幸运币"; break;
				
				case BeingProp.JIANG_HUN: str = "将魂"; break;
				case BeingProp.BING_HUN: str = "兵魂"; break;
				case BeingProp.GREEN_SHENHUN: str = "绿色神魂"; break;
				case BeingProp.BLUE_SHENHUN: str = "蓝色神魂"; break;
				case BeingProp.PURPLE_SHENHUN: str = "紫色神魂"; break;
				case BeingProp.MONEY_WUNV: str = "好感度"; break;
			}
			
			return str;
		}
	}
}