package game.ui.uiTeamFBSys.teamfbsel
{
	import com.bit101.components.ButtonTabText;
	import com.bit101.components.ButtonTextFormat;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.appcontrol.PanelCombine1;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.FormStyleNine;
	import modulecommon.ui.UIFormID;
	
	import game.ui.uiTeamFBSys.UITFBSysData;

	/**
	 * @brief 组队副本选择
	 * */
	public class UITeamFBSel extends FormStyleNine
	{
		public var m_TFBSysData:UITFBSysData;
		protected var m_pnlRoot:Component;
		
		protected var m_panelComLeft:PanelCombine1;
		protected var m_pnlMid:Panel;
		protected var m_pnlMidImage:Panel;
		protected var m_pnlMidObj:Panel;
		protected var m_pnlMidFrame:Panel;
		
		protected var m_vecTabsBtn:Vector.<ButtonTabText>;
		public var m_pageLst:Vector.<FBSelPage>;
		public var m_pageOpened:FBSelOpenedPage;

		public function UITeamFBSel()
		{
			this.id = UIFormID.UITeamFBSel;
			//setAniForm(70);
		}
		
		override public function onReady():void
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			//this.setSize(760, 500);
			//this.setFormSkin("form1", 250);
			//this.title = "副本选择功能";
			beginPanelDrawBg(760, 500);			
			endPanelDraw();
			
			m_TFBSysData.m_clkFBItemCB = onFBItemClkCB;
			
			setTitleDraw(282, "uiteamfbsys.title_word", m_TFBSysData.m_form.swfRes, 91);
			
			// 全部购建出来
			m_pnlRoot = new Component(this);

			var panelCom:PanelCombine1;
			m_panelComLeft = new PanelCombine1(m_pnlRoot, 54, 42);
			m_panelComLeft.setSize(404, 440);
			m_panelComLeft.setParam(ResGrid9.StypeOne, "commoncontrol/panel/wallbg.png", 3, 3);
			
			m_pnlMidFrame = new Panel(m_pnlRoot, 460, 42);
			m_pnlMidFrame.setSize(268, 440);
			m_pnlMidFrame.setSkinGrid9Image9(ResGrid9.StypeOne);
			
			m_pnlMid = new Panel(m_pnlMidFrame, 3, 3);	// 262 * 434
			m_pnlMid.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsys.rightback1");
			
			m_pnlMidImage = new Panel(m_pnlMid, 3, 38);
			m_pnlMidImage.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsys.rightbackimage");
			
			m_pnlMidObj = new Panel(m_pnlMid, 3, 194);
			m_pnlMidObj.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsys.rightbackobj");
			
			// 竖排 3个 按钮
			m_vecTabsBtn = new Vector.<ButtonTabText>(3, true);
			var btn:ButtonTabText;
			var i:int;
			
			var caplst:Vector.<String> = new Vector.<String>(3, true);
			caplst[0] = m_TFBSysData.m_pageLst[0].m_name;
			caplst[1] = m_TFBSysData.m_pageLst[1].m_name;
			caplst[2] = m_TFBSysData.m_pageLst[2].m_name;
			
			var fomat:ButtonTextFormat = new ButtonTextFormat();
			fomat.m_seletedColor = 0xFEF5D3;
			fomat.m_normalColor = 0xaaaaaa;
			fomat.m_miaobianColor = 0x202020;
			fomat.m_bold = true;
			fomat.m_size = 14;
			fomat.m_handler = onClickTabsBtn;
			fomat.m_vertical = true;
			
			for (i = 0; i < 3; i++)
			{
				if(m_TFBSysData.m_gkcontext.m_playerManager.hero.level >= m_TFBSysData.m_pageLst[i].m_lvl)
				{
					btn = new ButtonTabText(m_pnlRoot, 25, 70 + i * 110, caplst[i]);
				}
				else
				{
					btn = new ButtonTabText(null, 25, 70 + i * 110, caplst[i]);
				}
				btn.tag = i;
				btn.setSize(32, 100);
				btn.setParamByFormat(fomat);
				btn.setVerticalImageSkin("commoncontrol/button/buttonTabVertical.swf");
				m_vecTabsBtn[i] = btn;
			}
			
			m_pageLst = new Vector.<FBSelPage>(3, true);
			m_pageLst[0] = new FBSelPage(m_TFBSysData, null, 0, 15);
			m_pageLst[0].m_xmlPage = m_TFBSysData.m_pageLst[0];
			m_pageLst[0].initComp();
			m_pageLst[1] = new FBSelPage(m_TFBSysData, null, 0, 15);
			m_pageLst[1].m_xmlPage = m_TFBSysData.m_pageLst[1];
			m_pageLst[1].initComp();
			m_pageLst[2] = new FBSelPage(m_TFBSysData, null, 0, 15);
			m_pageLst[2].m_xmlPage = m_TFBSysData.m_pageLst[2];
			m_pageLst[2].initComp();
			
			// 默认不显示,只有点击的时候才显示
			m_pageOpened = new FBSelOpenedPage(m_TFBSysData, null, 755, -3);
			
			// 默认选择第一页
			m_TFBSysData.m_curPageIdx = 0;
			m_vecTabsBtn[m_TFBSysData.m_curPageIdx].selected = true;
			togglePage(m_TFBSysData.m_curPageIdx);
		}
		
		override public function dispose():void
		{
			var idx:uint = 0;
			while(idx < 3)
			{
				if(idx != m_TFBSysData.m_curPageIdx)
				{
					if(m_TFBSysData.m_curPageIdx >= 0)
					{
						m_pageLst[m_TFBSysData.m_curPageIdx].dispose();
					}
				}
				++idx;
			}
			
			super.dispose();
		}
		
		private function onClickTabsBtn(event:MouseEvent):void
		{
			var idx:uint = 0;
			var btn:ButtonTabText;
			for each(btn in m_vecTabsBtn)
			{
				if(event.target == btn)
				{
					break;
				}
				
				++idx;
			}
			
			togglePage(idx);
		}
		
		public function togglePage(pageid:uint):void
		{
			// 移出之前的,添加最新的
			if(m_TFBSysData.m_curPageIdx >= 0)
			{
				if(m_pnlRoot.contains(m_pageLst[m_TFBSysData.m_curPageIdx]))
				{
					m_pnlRoot.removeChild(m_pageLst[m_TFBSysData.m_curPageIdx]);
				}
			}
			m_TFBSysData.m_curPageIdx = pageid;
			m_pnlRoot.addChild(m_pageLst[m_TFBSysData.m_curPageIdx]);
			
			m_TFBSysData.m_clkFBObjCB = m_pageLst[m_TFBSysData.m_curPageIdx].updateObj;
			
			// 默认点选第一个副本
			if(!m_TFBSysData.m_curFBIdx[m_TFBSysData.m_curPageIdx])
			{
				m_TFBSysData.m_curFB[m_TFBSysData.m_curPageIdx] = m_pageLst[m_TFBSysData.m_curPageIdx].m_xmlPage.m_itemLst[0];
				m_TFBSysData.m_curFBIdx[m_TFBSysData.m_curPageIdx] = 0;
			}
			
			// 更新开启的副本内容
			if(m_TFBSysData.m_clkFBObjCB != null)
			{
				m_TFBSysData.m_clkFBObjCB();
			}
			
			if(m_TFBSysData.m_clkFBOpenedCB != null)
			{
				m_TFBSysData.m_clkFBOpenedCB();
			}
		}
		
		override public function exit():void
		{
			m_TFBSysData.m_onUIClose(this.id);
			super.exit();
		}
		
		public function onFBItemClkCB():void
		{
			if(!m_pageOpened.parent)
			{
				m_pnlRoot.addChild(m_pageOpened);
			}
		}
		
		public function psretUserProfitInCopyUserCmd(type:int):void
		{
			m_pageLst[0].psretUserProfitInCopyUserCmd(type);
			m_pageLst[1].psretUserProfitInCopyUserCmd(type);
			m_pageLst[2].psretUserProfitInCopyUserCmd(type);
		}
		
		override public function getDestPosForHide():Point 
		{
			if (m_gkcontext.m_UIs.screenBtn)
			{
				var pt:Point = m_gkcontext.m_UIs.screenBtn.getBtnPosInScreen(ScreenBtnMgr.Btn_TeamFB);
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