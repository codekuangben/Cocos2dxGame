package game.ui.uibackpack.relationwu.RelationMainWu 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.PanelPage;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import game.ui.uibackpack.UIBackPack;
	import modulecommon.commonfuntion.ConfirmDialogMgr;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneUserCmd.stActiveUserActRelationCmd;
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	import modulecommon.scene.wu.ActHerosGroup;
	import modulecommon.scene.wu.ItemActAttr;
	import modulecommon.scene.wu.WuHeroProperty;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	/**
	 * ...
	 * @author ...
	 * "我的三国关系"——激活属性、激活武将
	 */
	public class AttrActWus extends PanelPage
	{
		private var m_gkContext:GkContext;
		private var m_ui:UIBackPack;
		private var m_nameLabel:Label;
		private var m_curAttrTf:TextNoScroll;	//当前激活属性
		private var m_nextAttrTf:TextNoScroll;	//下级激活属性
		private var m_actBtn:PushButton;	//激活关系按钮
		private var m_vecActWu:Vector.<WuIconItem>;
		private var m_data:ActHerosGroup;
		private var m_actLevel:uint;		//激活等级: 0-未激活 1-普通武将激活 2-鬼武将激活 3-仙武将激活 4-神武将激活
		
		public function AttrActWus(gk:GkContext, ui:UIBackPack, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_ui = ui;
			
			m_nameLabel = new Label(this, 85, 6, "", UtilColor.YELLOW, 13);
			m_nameLabel.setBold(true);
			m_nameLabel.align = Component.CENTER;
			
			var label:Label;
			label = new Label(this, 10, 30, "当前激活属性：", UtilColor.YELLOW);
			label.mouseEnabled = true;
			label = new Label(this, 10, 116, "下级激活属性：", UtilColor.YELLOW);
			
			m_curAttrTf = new TextNoScroll(this, 30, 50);
			m_curAttrTf.setBodyCSS(UtilColor.WHITE_Yellow, 12, 2);
			
			m_nextAttrTf = new TextNoScroll(this, 30, 136);
			m_curAttrTf.setBodyCSS(UtilColor.WHITE_B, 12, 2);
			
			m_actBtn = new PushButton(this, 30, 202, onActBtnClick);
			m_actBtn.setSize(109, 28);
			m_actBtn.setSkinButton1Image("commoncontrol/panel/backpack/mainwurelation/relationBtn.png");
			
			m_vecActWu = new Vector.<WuIconItem>();
		}
		
		public function setData(groupid:uint):void
		{
			m_data = m_gkContext.m_wuMgr.getActHerosGroup(groupid);
			if (null == m_data)
			{
				return;
			}
			
			m_nameLabel.text = m_data.m_desc;
			
			var i:int;
			var wuid:uint;
			var wuicon:WuIconItem;
			
			for (i = 0; i < m_data.m_vecHeros.length; i++)
			{
				wuid = m_data.m_vecHeros[i];
				
				wuicon = new WuIconItem(m_gkContext, m_ui, this, 20 + Math.floor(i % 2) * 75, 238 + Math.floor(i / 2) * 78);
				wuicon.setData(wuid);
				m_vecActWu.push(wuicon);
			}
			
			updateData();
		}
		
		override public function onShow():void
		{
			super.onShow();
			
		}
		
		public function updateData():void
		{
			m_actLevel = m_gkContext.m_wuMgr.getUARData(m_data.m_groupID) % 10;
			
			var i:int;
			var heroid:uint;
			var wuicon:WuIconItem;
			
			for (i = 0; i < m_vecActWu.length; i++)
			{
				wuicon = m_vecActWu[i];
				if (wuicon)
				{
					heroid = wuicon.wuID * 10;
					if (RelationMainWuPanel.ActLevel_Max == m_actLevel)
					{
						heroid += m_actLevel - 1;
					}
					else if (RelationMainWuPanel.ActLevel_None < m_actLevel && m_actLevel < RelationMainWuPanel.ActLevel_Max)
					{
						heroid += m_actLevel;
					}
					
					wuicon.updateData(heroid);
				}
			}
			
			m_curAttrTf.htmlText = getActAttrStr(m_actLevel);
			m_nextAttrTf.htmlText = getActAttrStr(m_actLevel + 1, true);
			
			if (m_actLevel < RelationMainWuPanel.ActLevel_Max)
			{
				m_actBtn.visible = true;
				if (bAct)
				{
					m_actBtn.beginLiuguang();
				}
				else
				{
					m_actBtn.stopLiuguang();
				}
			}
			else
			{
				m_actBtn.visible = false;
				m_actBtn.stopLiuguang();
			}
		}
		
		//激活武将状态更新
		public function updateWuState(heroid:uint):void
		{
			var i:int;
			var wuicon:WuIconItem;
			var wuid:uint = heroid / 10;
			
			for (i = 0; i < m_vecActWu.length; i++)
			{
				wuicon = m_vecActWu[i];
				if (wuicon && (wuicon.wuID == wuid))
				{
					wuicon.updateWuState();
					break;
				}
			}
			
			if (bAct)
			{
				m_actBtn.beginLiuguang();
			}
			else
			{
				m_actBtn.stopLiuguang();
			}
		}
		
		//是否可激活
		public function get bAct():Boolean
		{
			var ret:Boolean = true;
			
			for each(var item:WuIconItem in m_vecActWu)
			{
				if (item && (false == item.bHaved))
				{
					ret = false;
					break;
				}
			}
			
			return ret;
		}
		
		public function get data():ActHerosGroup
		{
			return m_data;
		}
		
		public function get actLevel():uint
		{
			return m_actLevel;
		}
		
		//点击"激活关系"按钮
		private function onActBtnClick(event:MouseEvent):void
		{
			if (!bAct)
			{
				m_gkContext.m_systemPrompt.prompt("主角激活关系武将不足", null, UtilColor.RED);
				return;
			}
			
			UtilHtml.beginCompose();
			UtilHtml.add("确定要消耗掉", UtilColor.WHITE_Yellow, 14);
			
			var i:int = 0;
			var activeWu:WuHeroProperty;
			var needComma:Boolean;
			for (i = 0; i < m_vecActWu.length; i++)
			{
				activeWu = m_gkContext.m_wuMgr.getWuByHeroID(m_vecActWu[i].heroID) as WuHeroProperty;
				if (activeWu)
				{
					if (needComma)
					{
						UtilHtml.add("、", UtilColor.WHITE_Yellow, 14);
					}
					UtilHtml.add(" " + activeWu.fullName, activeWu.colorValue, 14);
					needComma = true;
				}
			}
			
			UtilHtml.add(" 激活 ", UtilColor.WHITE_Yellow, 14);
			UtilHtml.add(m_nameLabel.text, UtilColor.GREEN, 14);
			UtilHtml.add(" 关系？", UtilColor.WHITE_Yellow, 14);
			
			var param:Object = new Object();
			param[ConfirmDialogMgr.Param_YesConfirm] = true;
			
			m_gkContext.m_confirmDlgMgr.showMode1(m_ui.id, UtilHtml.getComposedContent(), onConfirmFn, null, "确定", "取消", null, false, null, param);
			
		}
		
		private function onConfirmFn():Boolean
		{
			var cmd:stActiveUserActRelationCmd = new stActiveUserActRelationCmd();
			cmd.m_group = m_data.m_groupID;
			m_gkContext.sendMsg(cmd);
			
			return true;
		}
		
		//获取属性加成
		private function getActAttrStr(actlevel:uint, bNext:Boolean = false):String
		{
			var color:uint = UtilColor.WHITE_Yellow;
			if (bNext)
			{
				color = UtilColor.WHITE_B;
			}
			
			UtilHtml.beginCompose();
			
			if (RelationMainWuPanel.ActLevel_None == actlevel)
			{
				UtilHtml.add("无", UtilColor.WHITE_B);
			}
			else if (actlevel <= RelationMainWuPanel.ActLevel_Max)
			{
				var t_item:t_ItemData;
				var itemactattr:ItemActAttr = m_data.m_dicAttrs[actlevel] as ItemActAttr;
				
				if (itemactattr)
				{
					for (var i:int = 0; i < itemactattr.m_vecProps.length; i++)
					{
						t_item = itemactattr.m_vecProps[i];
						UtilHtml.add(ItemActAttr.getAttrStr(t_item.type) + " +" + t_item.value.toString(), color);
						UtilHtml.breakline();
					}
				}
			}
			else
			{
				UtilHtml.add("已达最高等级", UtilColor.WHITE_B);
			}
			
			return UtilHtml.getComposedContent();
		}
	}

}