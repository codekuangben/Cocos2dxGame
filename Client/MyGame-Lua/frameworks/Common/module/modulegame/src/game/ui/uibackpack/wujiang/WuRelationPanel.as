package game.ui.uibackpack.wujiang
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.commonfuntion.ConfirmDialogMgr;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.commonfuntion.SysOptions;
	import modulecommon.net.msg.sceneHeroCmd.stReqRebirthCmd;
	import modulecommon.net.msg.sceneHeroCmd.stTakeDownFromMatrixCmd;
	import modulecommon.scene.prop.object.Package;
	import modulecommon.scene.prop.object.stObjLocation;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.GkContext;
	import flash.display.DisplayObjectContainer;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.wu.WuProperty;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import game.ui.uibackpack.UIBackPack;
	
	/**
	 * ...
	 * @author
	 */
	public class WuRelationPanel extends WuRelationPanelBase
	{
		protected var m_allPanel:AllWuPanel;
		private var m_grayZhuanshengPanel:Panel;
		private var m_newhandObj:WuCard;
		protected var m_cardList:Vector.<WuCard>;
		private var m_bForEquipPage:Boolean;
		
		public function WuRelationPanel(all:AllWuPanel, gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			m_allPanel = all;
			super(gk, parent, xpos, ypos);
			m_cardList = new Vector.<WuCard>();
			m_cardParent.addEventListener(MouseEvent.CLICK, onZhuanshengClick);
		}
		
		public function setWu(wu:WuHeroProperty):void
		{
			m_wu = wu;
			var i:int;
			var wuCard:WuCard;
			var left:int = m_cardList.length * WuProperty.SQUAREHEAD_WIDHT;
			for (i = 0; i < m_wu.m_vecActiveHeros.length; i++)
			{
				wuCard = new WuCard(this, m_gkContext, m_cardParent, left);
				wuCard.setIDs(m_wu, m_wu.m_vecActiveHeros[i]);
				m_cardList.push(wuCard);
				left += WuProperty.SQUAREHEAD_WIDHT;
			}
			
			m_cardParent.x = (245 - wu.m_vecActiveHeros.length * WuProperty.SQUAREHEAD_WIDHT) / 2;
		}
		
		/*
		 * 灰色"转":当拥有1个用于转生的关系武将时
		 * 动画"转"：当拥所有用于转生的关系武将时
		 * 火动画:全部激活
		 */
		public function update():void
		{
			var i:int;
			for (i = 0; i < m_wu.m_vecActiveHeros.length; i++)
			{
				m_cardList[i].update();
				if (m_cardList[i].wutableIDCard == 102) //马云禄
				{
					m_newhandObj = m_cardList[i];
				}
			}
			
			var bAllActived:Boolean = false; //是否全部激活
			var bCanZhuansheng:Boolean = false; //能否转生
			var bOwnRalationWuForZhuansheng:Boolean = false; //转生所需武将至少拥有1个，但没有全部 拥有
			
			if (!m_wu.isMaxZhuanshengLevel)
			{
				if (m_wu.isActive)
				{
					bAllActived = true;
					if (m_wu.add < WuHeroProperty.MaxZhuanshengLevel)
					{
						bCanZhuansheng = true;
					}
				}
				else
				{
					if (m_wu.canZhuansheng())
					{
						bCanZhuansheng = true;
					}
				}
				
				if (bCanZhuansheng == false)
				{
					if (m_wu.numWuRecruited > 0)
					{
						bOwnRalationWuForZhuansheng = true;
					}
				}
			}
			
			if (bOwnRalationWuForZhuansheng)
			{
				if (m_grayZhuanshengPanel == null)
				{
					m_grayZhuanshengPanel = new Panel(null, 0, -65);
					if (m_bForEquipPage)
					{
						m_cardParent.addChild(m_grayZhuanshengPanel);
					}
					m_grayZhuanshengPanel.setPanelImageSkin("commoncontrol/panel/zhuansheng.png");
					m_grayZhuanshengPanel.becomeGray();
					m_grayZhuanshengPanel.addEventListener(MouseEvent.ROLL_OUT, onZhuanshengMouseOut);
					m_grayZhuanshengPanel.addEventListener(MouseEvent.ROLL_OVER, onZhuanshengMouseOver);
					m_grayZhuanshengPanel.x = (WuProperty.SQUAREHEAD_WIDHT * m_wu.m_vecActiveHeros.length - 106) / 2;
				}
				m_grayZhuanshengPanel.visible = true;
			}
			else
			{
				if (m_grayZhuanshengPanel)
				{
					m_grayZhuanshengPanel.visible = false;
				}
			}
			
			if (m_allPanel.curHeroID == m_wu.m_uHeroID)
			{
				if (bCanZhuansheng)
				{
					m_allPanel.zhuanshengAni.showZhuanAni(m_cardParent, m_wu.m_vecActiveHeros.length);
					setCardParentButtonMode(true);
				}
				else
				{
					m_allPanel.zhuanshengAni.hideZhuanAni();
					setCardParentButtonMode(false);
				}
				
				if (bAllActived)
				{
					m_allPanel.zhuanshengAni.showHuoAni(m_cardParent, m_wu.m_vecActiveHeros.length);
				}
				else
				{
					m_allPanel.zhuanshengAni.hideHuoAni();
				}
			}
		}
		
		public function setCardParentButtonMode(b:Boolean):void
		{
			if (m_bForEquipPage)
			{
				m_cardParent.buttonMode = b;
			}
			else
			{
				m_cardParent.buttonMode = false;
			}
		}
		
		protected function onZhuanshengMouseOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
		}
		
		//在属性界面，转生文字及转生文字特效不显示，所以添加了onAddToEquipPage，onAddToAttrPage
		public function onAddToEquipPage():void
		{
			m_bForEquipPage = true;
			if (m_grayZhuanshengPanel && m_grayZhuanshengPanel.parent == null)
			{
				m_cardParent.addChild(m_grayZhuanshengPanel);
			}
			
			update();
		}
		
		public function onAddToAttrPage():void
		{
			m_bForEquipPage = false;
			if (m_grayZhuanshengPanel && m_grayZhuanshengPanel.parent)
			{
				m_grayZhuanshengPanel.parent.removeChild(m_grayZhuanshengPanel);
			}
			
			setCardParentButtonMode(false);
		}
		
		protected function onZhuanshengMouseOver(event:MouseEvent):void
		{
			var wu:WuHeroProperty = m_gkContext.m_wuMgr.getWuByHeroID(m_wu.m_uHeroID) as WuHeroProperty;
			var activeWu:WuHeroProperty;
			var npcBase:TNpcBattleItem;
			var activeTableID:uint;
			var i:int;
			var str:String;
			
			UtilHtml.beginCompose();
			UtilHtml.add("转生", UtilColor.WHITE_B, 14);
			UtilHtml.add("<b>" + wu.fullName + "</b>", wu.colorValue, 14);
			UtilHtml.add("还需要", UtilColor.WHITE_B, 14);
			UtilHtml.breakline();
			
			var needComma:Boolean = false;
			for (i = 0; i < wu.m_vecActiveHeros.length; i++)
			{
				activeTableID = wu.m_vecActiveHeros[i].tableID;
				activeWu = m_gkContext.m_wuMgr.getWuByHeroID(wu.m_vecActiveHeros[i].id) as WuHeroProperty;
				if (activeWu == null)
				{
					npcBase = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(activeTableID); //m_gkContext.m_wuMgr.getLowestWuByTableID(activeTableID);
					if (npcBase)
					{
						if (needComma)
						{
							//UtilHtml.add(", ", UtilColor.WHITE_B, 14);
							UtilHtml.breakline();
						}
						str = WuHeroProperty.s_fullName(wu.add, npcBase.m_name);
						str = "\t " + str;
						UtilHtml.add(str, NpcBattleBaseMgr.colorValue(npcBase.m_uColor), 14);
						needComma = true;
					}
				}
				
			}
			
			var pt:Point = m_grayZhuanshengPanel.localToScreen();
			m_gkContext.m_uiTip.hintHtiml(pt.x + 80, pt.y + 20, UtilHtml.getComposedContent());
		}
		
		protected function onZhuanshengClick(e:MouseEvent):void
		{
			if (m_bForEquipPage == false)
			{
				return;
			}
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_newHandMgr.hide();
			}
			
			if (e.target is PushButton == false)
			{
				if (false == m_wu.canZhuansheng())
				{
					return;
				}
				
				var info:Object = new Object();
				info["heroid"] = m_wu.m_uHeroID;
				m_gkContext.m_contentBuffer.addContent("uiwuzhuansheng_info", info);
				
				var form:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIWuZhuansheng);
				if (form)
				{
					form.updateData(info);
				}
				else
				{
					m_gkContext.m_UIMgr.showFormEx(UIFormID.UIWuZhuansheng);
				}
				
				/*
				if ((m_wu.add >= 1) && (m_gkContext.playerMain.level < 40))
				{
					m_gkContext.m_confirmDlgMgr.showMode2(UIFormID.UIBackPack, "只有达到40级方可进行仙将转生", null, "关闭");
					return;
				}
				
				var bProcessForMateng:Boolean = false;
				if (m_wu.tableID == WuHeroProperty.WUID_MaTeng && false == m_gkContext.m_sysOptions.isSet(SysOptions.COMMONSET_HEROFIRSTREBIRTH))
				{
					bProcessForMateng = true;
				}
				if (bProcessForMateng == false)
				{
					var wuListForZhenfa:Vector.<WuHeroProperty> = getWuListForTakingOffFromZhenfa();
					if (wuListForZhenfa.length > 0)
					{
						//此次转生将消耗掉阵上武将 XXXX， 请手动将他拖下阵位，并妥善安置接替武将。
						UtilHtml.beginCompose();
						UtilHtml.addStringNoFormat("此次转生将消耗掉阵上武将 ");
						for each (activeWu in wuListForZhenfa)
						{
							UtilHtml.add(activeWu.fullName, activeWu.colorValue, 14);
							UtilHtml.addStringNoFormat(", ");
						}
						UtilHtml.addStringNoFormat("请手动将他拖下阵位，并妥善安置接替武将");
						m_gkContext.m_confirmDlgMgr.showMode2(UIFormID.UIBackPack, UtilHtml.getComposedContent(), null,"离开");
						return;
					}
				}
				
				UtilHtml.beginCompose();
				UtilHtml.add("确定要消耗掉", UtilColor.WHITE_Yellow, 14);
				var i:int = 0;
				var add:int = m_wu.add;
				var hID:uint;
				var activeWu:WuHeroProperty;
				var needComma:Boolean;
				var showYesConfirm:Boolean = false;
				for (i = 0; i < m_wu.m_vecActiveHeros.length; i++)
				{
					activeWu = m_gkContext.m_wuMgr.getWuByHeroID(m_wu.m_vecActiveHeros[i].id) as WuHeroProperty;
					if (activeWu)
					{
						if (needComma)
						{
							UtilHtml.add("、", UtilColor.WHITE_B, 14);
						}
						UtilHtml.add(" " + activeWu.fullName, activeWu.colorValue, 14);
						needComma = true;
						
						if (activeWu.color >= WuProperty.COLOR_PURPLE || activeWu.add >= WuHeroProperty.Add_Gui)
						{
							showYesConfirm = true;
						}
					}
				}
				UtilHtml.add(" ", UtilColor.WHITE_Yellow, 14);
				UtilHtml.add("将 ", UtilColor.WHITE_Yellow, 14);
				UtilHtml.add(m_wu.fullName, m_wu.colorValue, 14);
				UtilHtml.add(" 转生为 ", UtilColor.WHITE_Yellow, 14);
				UtilHtml.add(WuHeroProperty.s_fullName(add + 1, m_wu.m_name), m_wu.colorValue, 14);
				UtilHtml.add(" 吗?", UtilColor.WHITE_Yellow, 14);
				UtilHtml.breakline();
				UtilHtml.add("转生效果 ：", UtilColor.WHITE_Yellow, 14);
				UtilHtml.add("武将属性大幅提升。", UtilColor.GREEN, 14);
				
				var param:Object;
				if (showYesConfirm)
				{
					param = new Object();
					param[ConfirmDialogMgr.Param_YesConfirm] = true;
				}
				
				m_gkContext.m_confirmDlgMgr.showMode1(UIFormID.UIBackPack, UtilHtml.getComposedContent(), onConfirmZhuansheng, null, "确定", "取消", null, false, null, param);
				*/
			}
		}
		
		override public function dispose():void
		{
			if (m_allPanel.zhuanshengAni.isInParent(m_cardParent))
			{
				m_allPanel.zhuanshengAni.hideAni();
			}
			super.dispose();
		}
		
		protected function onConfirmZhuansheng():Boolean
		{
			
			var wuListForEquip:Vector.<WuHeroProperty> = new Vector.<WuHeroProperty>();
			var numGridsForWuEquip:int = getWuListForEquipTakingOff(wuListForEquip);
			var wuListForZhenfa:Vector.<WuHeroProperty> = getWuListForTakingOffFromZhenfa();
			
			var bZhuansheng:Boolean = false;
			var bProcessForMateng:Boolean = false;
			if (wuListForEquip.length == 0 && wuListForZhenfa.length == 0)
			{
				bZhuansheng = true;
			}
			
			if (m_wu.tableID == WuHeroProperty.WUID_MaTeng && false == m_gkContext.m_sysOptions.isSet(SysOptions.COMMONSET_HEROFIRSTREBIRTH))
			{
				bProcessForMateng = true;
			}
			if (bProcessForMateng)
			{
				if (numGridsForWuEquip == 0)
				{
					bZhuansheng = true;
				}
			}
			if (bZhuansheng)
			{
				var send:stReqRebirthCmd = new stReqRebirthCmd();
				send.m_heroid = m_wu.m_uHeroID;
				m_gkContext.sendMsg(send);
				return true;
			}
			/*var i:int;
			   var str:String;
			   UtilHtml.beginCompose();
			   if (wuListForEquip.length && wuListForZhenfa.length)
			   {
			   i = 2;
			   }
			   else
			   {
			   i = 1;
			   }
			   str = "请注意：本次转生后:";
			   UtilHtml.addStringNoFormat(str);
			   UtilHtml.breakline();
			
			   var firstPart:String = UtilHtml.getComposedContent();
			
			   var needComma:Boolean;
			   var wu:WuHeroProperty;
			   var iPart:int = 0;
			   if (wuListForEquip.length)
			   {
			   iPart++;
			   UtilHtml.beginCompose();
			   UtilHtml.addStringNoFormat("1. ");
			
			   for (i = 0; i < wuListForEquip.length; i++)
			   {
			   wu = wuListForEquip[i];
			   if (needComma)
			   {
			   UtilHtml.add("、", UtilColor.WHITE_B, 14);
			   }
			   UtilHtml.add(" " + wu.fullName, wu.colorValue, 14);
			   needComma = true;
			   }
			   UtilHtml.addStringNoFormat("的所有装备自动放回包裹中");
			   UtilHtml.breakline();
			
			   firstPart += UtilHtml.formatBlockindent(UtilHtml.getComposedContent(), 14);
			   }
			   if (wuListForZhenfa.length)
			   {
			   iPart++;
			   UtilHtml.beginCompose();
			   UtilHtml.addStringNoFormat(iPart.toString()+ ". ");
			   needComma = false;
			   for (i = 0; i < wuListForZhenfa.length; i++)
			   {
			   wu = wuListForZhenfa[i];
			   if (needComma)
			   {
			   UtilHtml.add("、", UtilColor.WHITE_B, 14);
			   }
			   UtilHtml.add(" " + wu.fullName, wu.colorValue, 14);
			   needComma = true;
			   }
			   UtilHtml.addStringNoFormat("自动从阵法中移除。");
			   firstPart += UtilHtml.formatBlockindent(UtilHtml.getComposedContent(), 14);
			 }*/
			var firstPart:String = "转生时武将会下阵，身上的装备会自动放到包裹中。"
			var bCanSwap:Boolean = true;
			if (numGridsForWuEquip > 0)
			{
				var numOfFreeGrids:int = m_gkContext.m_objMgr.computeNumOfFreeGridsInCommonPackage();
				if (numOfFreeGrids < numGridsForWuEquip)
				{
					bCanSwap = false;
				}
			}
			if (bCanSwap)
			{
				var param:Object = new Object();
				param["wuListForEquip"] = wuListForEquip;
				param["wuListForZhenfa"] = wuListForZhenfa;
				m_gkContext.m_confirmDlgMgr.tempData = param;
				if (bProcessForMateng)
				{
					var index:int = wuListForZhenfa.indexOf(m_wu);
					if (index != -1)
					{
						wuListForZhenfa.splice(index, 1);
					}
					onConfirmZhuansheng2();
				}
				else
				{
					m_gkContext.m_confirmDlgMgr.showMode1(UIFormID.UIBackPack, firstPart, onConfirmZhuansheng2, null, "确定", "取消");
				}
			}
			else
			{
				UtilHtml.beginCompose();
				UtilHtml.breakline();
				UtilHtml.add("可是,你的包裹没有足够的空间用于放置上述武将的所有装备，请先整理包裹", UtilColor.RED, 14);
				firstPart += UtilHtml.getComposedContent();
				m_gkContext.m_confirmDlgMgr.showMode2(UIFormID.UIBackPack, firstPart, null, "关闭");
			}
			return true;
		}
		
		protected function onConfirmZhuansheng2():Boolean
		{
			var param:Object = m_gkContext.m_confirmDlgMgr.tempData;
			var wuListForEquip:Vector.<WuHeroProperty> = param["wuListForEquip"];
			var wuListForZhenfa:Vector.<WuHeroProperty> = param["wuListForZhenfa"];
			
			var wuIDList:Array = new Array();
			var wu:WuHeroProperty;
			if (wuListForEquip.length)
			{
				for each (wu in wuListForEquip)
				{
					wuIDList.push(wu.m_uHeroID);
				}
				
				m_gkContext.m_objMgr.moveWuEquipsToCommonPackage(wuIDList);
			}
			if (wuListForZhenfa.length)
			{
				wuIDList.length = 0;
				var sendTakeDown:stTakeDownFromMatrixCmd;
				for each (wu in wuListForZhenfa)
				{
					sendTakeDown = new stTakeDownFromMatrixCmd();
					sendTakeDown.heroid = wu.m_uHeroID;
					m_gkContext.sendMsg(sendTakeDown);
				}
				m_gkContext.m_zhenfaMgr.takeDowHeros(wuIDList);
			}
			
			var send:stReqRebirthCmd = new stReqRebirthCmd();
			send.m_heroid = m_wu.m_uHeroID;
			m_gkContext.sendMsg(send);
			return true;
		}
		
		private function swapEquipsForWu():void
		{
		/*var wuListForEquip:Vector.<WuHeroProperty> = new Vector.<WuHeroProperty>();
		   var numGridsForWuEquip:int = getWuListForEquipTakingOff(wuListForEquip);
		
		   var freeGridsList:Vector.<stObjLocation> = new Vector.<stObjLocation>();
		   var freeGridsParam:Object = new Object();
		   freeGridsParam["num"] = numGridsForWuEquip;
		 freeGridsParam["list"] = freeGridsList;*/
		
		}
		
		private function getWuListForEquipTakingOff(list:Vector.<WuHeroProperty>):int
		{
			var ret:int = 0;
			var pac:Package;
			var hID:uint;
			if (m_wu.m_num == 1)
			{
				pac = m_gkContext.m_objMgr.getEquipPakage(m_wu.m_uHeroID);
				num = pac.numOfObjects;
				if (num > 0)
				{
					list.push(m_wu);
					ret += num;
				}
			}
			var activeWu:WuHeroProperty;
			var i:int = 0;
			var add:int = m_wu.add;
			var num:int;
			
			for (i = 0; i < m_wu.m_vecActiveHeros.length; i++)
			{
				activeWu = m_gkContext.m_wuMgr.getWuByHeroID(m_wu.m_vecActiveHeros[i].id) as WuHeroProperty;
				if (activeWu.m_num == 1)
				{
					pac = m_gkContext.m_objMgr.getEquipPakage(activeWu.m_uHeroID);
					
					num = pac.numOfObjects;
					if (num > 0)
					{
						list.push(activeWu);
						ret += num;
					}
				}
			}
			return ret;
		}
		
		private function getWuListForTakingOffFromZhenfa():Vector.<WuHeroProperty>
		{
			var ret:Vector.<WuHeroProperty> = new Vector.<WuHeroProperty>();
			
			var hID:uint;
			if (m_wu.m_num == 1)
			{
				if (-1 != m_gkContext.m_zhenfaMgr.heroToPos(m_wu.m_uHeroID))
				{
					ret.push(m_wu);
				}
			}
			var activeWu:WuHeroProperty;
			var i:int = 0;
			var add:int = m_wu.add;
			
			for (i = 0; i < m_wu.m_vecActiveHeros.length; i++)
			{
				activeWu = m_gkContext.m_wuMgr.getWuByHeroID(m_wu.m_vecActiveHeros[i].id) as WuHeroProperty;
				if (activeWu.m_num == 1)
				{
					if (-1 != m_gkContext.m_zhenfaMgr.heroToPos(activeWu.m_uHeroID))
					{
						ret.push(activeWu);
					}
				}
			}
			return ret;
		}
		
		public function newHnadMoveToCard():void
		{
			if (m_gkContext.m_newHandMgr.isVisible() && m_gkContext.m_newHandMgr.m_bMoveToNext)
			{
				m_gkContext.m_newHandMgr.m_bMoveToNext = false;
				if (m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_HEROREBIRTH)
				{
					m_gkContext.m_newHandMgr.setFocusFrame(16, -54, 80, 54, 1);
					m_gkContext.m_newHandMgr.prompt(true, 30, 0, "左键点击转生，武将属性大幅提升。", m_cardParent);
				}
				else if (m_newhandObj && (m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_WUJIANGJIHUO))
				{
					m_gkContext.m_newHandMgr.setFocusFrame(-10, -10, 78, 92, 1);
					m_gkContext.m_newHandMgr.prompt(true, 0, 72, "马云禄已招募，马腾属性强化。", m_newhandObj);
					m_newhandObj.showTip();
				}
			}
		}
		
		public function newHandMoveToOtherCards():void
		{
			if (m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_WUJIANGJIHUO)
			{
				m_gkContext.m_newHandMgr.setFocusFrame(-10, -10, 78, 92, 1);
				m_gkContext.m_newHandMgr.prompt(true, 0, 72, "激活其它关系武将，属性将得到更多提升。", m_cardList[1]);
				
				m_cardList[1].showTip();
			}
		}
		
		public function switchToActionHero(heroID:uint):void
		{
			m_allPanel.switchToPanel(heroID);
		}
	}
}