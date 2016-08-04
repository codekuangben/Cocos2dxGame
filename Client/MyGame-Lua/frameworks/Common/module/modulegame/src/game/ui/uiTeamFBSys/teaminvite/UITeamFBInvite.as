package game.ui.uiTeamFBSys.teaminvite
{
	import com.bit101.components.ButtonTabText;
	import com.bit101.components.ButtonText;
	import com.bit101.components.ButtonTextFormat;
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.util.UtilFilter;
	
	import flash.events.MouseEvent;
	
	import modulecommon.res.ResGrid9;
	import modulecommon.ui.FormStyleNine;
	import modulecommon.ui.UIFormID;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.msg.quickInviteOtherAddMultiCopyUserCmd;
	import game.ui.uiTeamFBSys.msg.reqInviteOtherAddMultiCopyUserCmd;
	import game.ui.uiTeamFBSys.msg.reqOpenInviteAddMultiCopyUiUserCmd;
	import game.ui.uiTeamFBSys.msg.retInviteAddMultiCopyUiUserCmd;
	import game.ui.uiTeamFBSys.teaminvite.TWBase;

	/**
	 * @brief 组队成员邀请
	 * */
	public class UITeamFBInvite extends FormStyleNine
	{
		public var m_TFBSysData:UITFBSysData;
		protected var m_rootCnter:Component;
		protected var m_btnQTQ:PushButton;		// 快速邀请按钮
		protected var m_btnYQ:PushButton;		// 邀请按钮
		
		protected var m_listTabBtn:Vector.<ButtonTabText>;	// 标签按钮
		protected var m_listTabWidget:Vector.<TWBase>;		// 标签窗口
		protected var m_onlineLst:Vector.<Array>;			// 在线好友和军团
		
		protected var m_overPanel:Panel;
		protected var m_selectPanel:Panel;
		protected var m_userNameEdit:InputText;	// 输入框
		protected var m_btnSearch:PushButton;
		protected var m_pnlBtm:Panel;			// 最底下的地图
		protected var m_pnlFnd:Panel;			// 好友图标
		//protected var m_comboBox:ComboBox;

		protected var m_InviteCurIdx:int = -1;	// 这个是 tab 索引
		protected var m_itemIdx:Vector.<int>;	// 这个是点击军团或者好友列表中的索引

		public function UITeamFBInvite()
		{
			this.id = UIFormID.UITeamFBInvite;
		}
		
		override public function onReady():void
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			
			this.setSize(352, 388);
			//this.setFormSkin("form1", 250);
			//this.title = "邀请";
			
			beginPanelDrawBg(this.width, this.height);			
			endPanelDraw();
			
			//setTitleDraw(282, "jiuguan.title", this.swfRes, 71);
			
			m_TFBSysData.m_inviteClkCB = inviteClkCB;
			
			m_rootCnter = new Component(this);
			
			m_pnlBtm = new Panel(m_rootCnter, 17, 306);
			m_pnlBtm.autoSizeByImage = false;
			m_pnlBtm.setSize(318, 60);
			m_pnlBtm.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsysinvite.decorationbottom");
			
			m_listTabBtn = new Vector.<ButtonTabText>(3, true);
			
			var idx:int;
			var btn:ButtonTabText;
			var left:int = 51;
			var lst:Vector.<String> = new Vector.<String>();
			lst.push("军团");
			lst.push("好友");
			
			var fomat:ButtonTextFormat = new ButtonTextFormat();
			fomat.m_seletedColor = 0xFEF5D3;
			fomat.m_normalColor = 0xaaaaaa;
			fomat.m_miaobianColor = 0x202020;
			fomat.m_bold = true;
			fomat.m_size = 14;
			fomat.m_handler = onTabBtnClick;
			
			while(idx < 2)
			{
				btn = new ButtonTabText(m_rootCnter, left + idx * 80, 70);
				m_listTabBtn[idx] = btn;
				btn.autoSizeByImage = false;
				//btn.setSize(60, 29);
				//btn.setPanelImageSkin("commoncontrol/button/buttonTab1.swf");
				
				btn.setSize(80, 23);
				btn.setPanelImageSkin("commoncontrol/button/buttonTab2.swf");
				
				btn.setParamByFormat(fomat);		
				btn.tag = idx;				
				btn.label = lst[idx];
				
				++idx;
			}
			
			// 调整第二个按钮的文字内容
			
			// 好友 tab 按钮上的好友图标
			m_pnlFnd = new Panel(m_listTabBtn[1], 3, 2);
			m_pnlFnd.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsysinvite.icon");
			
			m_listTabWidget = new Vector.<TWBase>(3, true);
			m_listTabWidget[0] = new TWCorps(ItemCorps, m_TFBSysData, null, 20, 93);
			m_listTabWidget[1] = new TWFnd(ItemFnd, m_TFBSysData, null, 20, 93);
			
			// 共用一个底图
			m_overPanel = new Panel();
			m_overPanel.setSize(308, 20);
			m_overPanel.autoSizeByImage = false;
			m_overPanel.mouseEnabled = false;
			m_overPanel.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsysinvite.itemback");
			m_overPanel.filters = [UtilFilter.createLuminanceFilter(1.65)];
			m_selectPanel = new Panel();
			m_selectPanel.setSize(308, 20);
			m_selectPanel.autoSizeByImage = false;
			m_selectPanel.mouseEnabled = false;
			m_selectPanel.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsysinvite.itemback");
			m_selectPanel.filters = [UtilFilter.createLuminanceFilter(1.65)];
			
			m_TFBSysData.m_overPanel = m_overPanel;
			m_TFBSysData.m_selectPanel = m_selectPanel;
			
			// 输入框
			m_userNameEdit = new InputText(m_rootCnter, 35, 35);
			m_userNameEdit.setSize(256, 35);
			m_userNameEdit.marginLeft = 5;
			m_userNameEdit.setSkinGrid9Image9(ResGrid9.StypeFour);
			m_userNameEdit.setTextFormat(0xbbbbbb, 12, true);
			
			m_btnSearch = new PushButton(this, 292, 39, onBtnClickSearch);
			m_btnSearch.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsysinvite.search");
			
			//m_comboBox = new ComboBox(this, 35, 35);
			//m_comboBox.setSize(160, 20);
			//m_comboBox.addEventListener(Event.SELECT, onSelect);
			
			//var param:ComboBoxParam = new ComboBoxParam();
			//param.m_listItemClass = FBInviteComboBoxItem;
			//m_comboBox.setParam(param);
			
			m_btnQTQ = new ButtonText(m_rootCnter, 30, 324, "快速邀请", onBtnClickQTQ);
			m_btnQTQ.setSize(60, 26);
			m_btnQTQ.autoSizeByImage = false;
			m_btnQTQ.setSkinButton1Image("commoncontrol/button/button8.png");
			
			m_btnYQ = new ButtonText(m_rootCnter, 100, 324, "邀请", onBtnClickYQ);
			m_btnYQ.setSize(60, 26);
			m_btnYQ.autoSizeByImage = false;
			m_btnYQ.setSkinButton1Image("commoncontrol/button/button8.png");
			
			m_onlineLst = new Vector.<Array>(2, true);
			m_itemIdx = new Vector.<int>(2, true);
			m_itemIdx[0] = -1;
			m_itemIdx[1] = -1;

			// 点击默认的按钮
			m_InviteCurIdx = 0;
			m_listTabBtn[m_InviteCurIdx].selected = true;
			toggleByTag(m_InviteCurIdx);
			
			/*
			// test
			idx = 0;
			var item:InviteUiData;
			m_onlineLst[0] = [];
			m_onlineLst[1] = [];
			while(idx < 20)
			{
				item = new InviteUiData();
				item.name = "军团" + idx;
				m_onlineLst[0][m_onlineLst[0].length] = item;
				item = new InviteUiData();
				item.name = "好友" + idx;
				m_onlineLst[1][m_onlineLst[1].length] = item;
				++idx;
			}
			
			m_listTabWidget[0].setDatas(m_onlineLst[0]);
			m_listTabWidget[1].setDatas(m_onlineLst[1]);
			*/
		}
		
		override public function exit():void
		{
			m_TFBSysData.m_onUIClose(this.id);
			super.exit();
		}
		
		// 事件切换
		public function onTabBtnClick(e:MouseEvent):void
		{
			if (e.target is ButtonTabText)
			{
				var tag:int = (e.target as ButtonTabText).tag;
				toggleByTag(tag);
			}
		}
		
		public function toggleByTag(tag:uint):void
		{
			if(m_rootCnter.contains(m_listTabWidget[m_InviteCurIdx]))
			{
				m_rootCnter.removeChild(m_listTabWidget[m_InviteCurIdx]);
			}
			
			m_InviteCurIdx = tag;
			if(!m_listTabWidget[m_InviteCurIdx].m_binit)
			{
				m_listTabWidget[m_InviteCurIdx].m_binit = true;
				var cmd:reqOpenInviteAddMultiCopyUiUserCmd = new reqOpenInviteAddMultiCopyUiUserCmd();
				cmd.type = 1 - m_InviteCurIdx;
				m_TFBSysData.m_gkcontext.sendMsg(cmd);
				
				//m_listTabWidget[m_InviteCurIdx].setDatas(m_onlineLst[m_InviteCurIdx]);
			}
			m_rootCnter.addChild(m_listTabWidget[m_InviteCurIdx])
		}
		
		//protected function onSelect(event:Event):void
		//{
		//	var index:int = m_comboBox.selectedIndex;
		//}
		
		protected function onBtnClickQTQ(e:MouseEvent):void
		{
			var uT:Number = 30 - (m_TFBSysData.m_gkcontext.m_context.m_timeMgr.getCalendarTimeSecond() - m_TFBSysData.m_preClickTime);
			if (m_TFBSysData.m_preClickTime > 0 && uT > 0)
			{
				m_TFBSysData.m_gkcontext.m_systemPrompt.prompt("请在 " + Math.ceil(uT) + "秒 后再进行邀请");
			}
			else
			{
				var cmd:quickInviteOtherAddMultiCopyUserCmd = new quickInviteOtherAddMultiCopyUserCmd();
				m_TFBSysData.m_gkcontext.sendMsg(cmd);
				
				m_TFBSysData.m_preClickTime = m_TFBSysData.m_gkcontext.m_context.m_timeMgr.getCalendarTimeSecond();
			}
		}
		
		protected function onBtnClickYQ(e:MouseEvent):void
		{
			//if(m_TFBSysData.m_curFB[m_TFBSysData.m_curPageIdx].m_level[m_TFBSysData.m_curFBIdx[m_TFBSysData.m_curPageIdx]] <= m_onlineLst[m_itemIdx[m_InviteCurIdx]].level)
			//{
				if(m_userNameEdit.text.length)
				{
					var cmd:reqInviteOtherAddMultiCopyUserCmd = new reqInviteOtherAddMultiCopyUserCmd();
					cmd.name = m_userNameEdit.text;
					m_TFBSysData.m_gkcontext.sendMsg(cmd);
				}
				else
				{
					m_TFBSysData.m_gkcontext.m_systemPrompt.prompt("名字不能为空");
				}
			//}
			//else
			//{
			//	m_TFBSysData.m_gkcontext.m_systemPrompt.prompt("该玩家等级不足无法邀请");
			//}
		}
		
		public function inviteClkCB(idx:uint):void
		{
			m_itemIdx[m_InviteCurIdx] = idx;
			m_userNameEdit.text = m_onlineLst[m_InviteCurIdx][idx].name;
		}
		
		public function psretInviteAddMultiCopyUiUserCmd(msg:retInviteAddMultiCopyUiUserCmd):void
		{
			m_onlineLst[1 - msg.type] = msg.data;
			m_listTabWidget[1 - msg.type].setDatas(m_onlineLst[1 - msg.type]);
		}
		
		private function onBtnClickSearch(event:MouseEvent):void
		{
			
		}
	}
}