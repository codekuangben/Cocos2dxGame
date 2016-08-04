package game.ui.uiTeamFBSys.teamfbsel
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	
	import flash.events.MouseEvent;
	
	import modulecommon.res.ResGrid9;
	import com.util.UtilColor;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.msg.clickMultiCopyUiUserCmd;
	import game.ui.uiTeamFBSys.xmldata.XmlFBItem;

	/**
	 * @brief 副本选择中的一项
	 * */
	public class FBSelFBItem extends CtrolVHeightComponent
	{
		public var m_TFBSysData:UITFBSysData;
		protected var m_XmlFBItem:XmlFBItem;

		protected var m_rootCnter:Vector.<Component>
		protected var m_framePanel:Vector.<Panel>;
		protected var m_imagePanel:Vector.<Panel>;
		protected var m_lblName:Vector.<Label>;
		protected var m_lbllevel:Vector.<Label>;
		protected var m_SelectedPanel:Panel;
		private var m_overPanel:Panel;
		
		protected var m_lblDesc:Vector.<Label>;		// XX级开启
		protected var m_LQPanel:Vector.<Panel>;		// 领取资源

		public function FBSelFBItem(param:Object)
		{
			super();
			m_TFBSysData = param["data"] as UITFBSysData;
			
			this.setSize(372, 100);
			
			// 初始化 UI
			m_rootCnter = new Vector.<Component>(2, true);
			m_framePanel = new Vector.<Panel>(2, true);
			m_imagePanel = new Vector.<Panel>(2, true);
			m_lblName = new Vector.<Label>(2, true);
			m_lbllevel = new Vector.<Label>(2, true);
			m_lblDesc = new Vector.<Label>(2, true);
			m_LQPanel = new Vector.<Panel>(2, true);
			
			var idx:uint = 0;
			while(idx < 2)
			{
				m_rootCnter[idx] = new Component(null, 190 * idx, 0);
				m_rootCnter[idx].buttonMode = true;
				m_rootCnter[idx].setSize(180, 100);
				m_rootCnter[idx].drawRectBG();
				
				m_imagePanel[idx] = new Panel(this, 10 + 190 * idx, 9);
				m_imagePanel[idx].visible = false;
				m_framePanel[idx] = new Panel(this, 190 * idx, 0);
				m_framePanel[idx].setSize(180, 100);
				m_framePanel[idx].autoSizeByImage = false;
				m_framePanel[idx].setSkinGrid9Image9("commoncontrol/grid9/grid9card.swf");
				
				m_lblName[idx] = new Label(m_rootCnter[idx], 80, 70, "", UtilColor.WHITE_Yellow);
				m_lblName[idx].align = Component.CENTER;
				m_lbllevel[idx] = new Label(m_rootCnter[idx], 140, 70, "", UtilColor.WHITE_Yellow);
				m_lbllevel[idx].align = Component.CENTER;
				
				m_lblDesc[idx] = new Label(null, 90 + idx * 190, 70, "", UtilColor.WHITE_Yellow);
				m_lblDesc[idx].align = Component.CENTER; 
				
				m_LQPanel[idx] = new Panel(m_rootCnter[idx], 132, 4);
				m_LQPanel[idx].setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsysrd.yiling");
				m_LQPanel[idx].visible = false;
				
				++idx;
			}

			m_SelectedPanel = new Panel(this);
			m_SelectedPanel.setPos(-6, -3);
			m_SelectedPanel.setSize(this.width/2 + 6, this.height + 6);
			m_SelectedPanel.setSkinGrid9Image9(ResGrid9.StypeCardSelect);
			m_SelectedPanel.mouseEnabled = false;
			m_SelectedPanel.visible = false;
			
			m_overPanel = new Panel(this);
			m_overPanel.setPos(-4, -3);
			m_overPanel.setSize(this.width/2 + 2, this.height + 5);
			m_overPanel.setSkinGrid9Image9(ResGrid9.StypeCardSelect);
			m_overPanel.mouseEnabled = false;
			m_overPanel.visible = false;
			m_overPanel.alpha = 0.5;

			m_rootCnter[0].addEventListener(MouseEvent.CLICK, onClickL);
			m_rootCnter[1].addEventListener(MouseEvent.CLICK, onClickR);
			m_rootCnter[0].addEventListener(MouseEvent.ROLL_OVER, onOverL);
			m_rootCnter[1].addEventListener(MouseEvent.ROLL_OVER, onOverR);
		}

		// 设置数据
		override public function setData(data:Object):void
		{
			super.setData(data);
			m_XmlFBItem = data as XmlFBItem;

			var idx:uint = 0;
			while(idx < 2)
			{
				if(m_XmlFBItem.m_id[idx])	//如果配置
				{
					m_framePanel[idx].visible = true;
					if(m_TFBSysData.m_gkcontext.m_playerManager.hero.level >= m_XmlFBItem.m_level[idx])
					{
						if(this.contains(m_lblDesc[idx]))
						{
							this.removeChild(m_lblDesc[idx]);
						}
						
						if(!this.contains(m_rootCnter[idx]))
						{
							this.addChild(m_rootCnter[idx]);
							m_imagePanel[idx].visible = true;
						}
	
						if(m_XmlFBItem.m_id[idx])
						{	
							m_imagePanel[idx].setPanelImageSkin("teamfbsys/" + m_XmlFBItem.m_picname[idx] + ".png");
							
							m_lblName[idx].text = m_XmlFBItem.m_name[idx] + "";
							m_lbllevel[idx].text = m_XmlFBItem.m_level[idx] + "级";
						}
					}
					else
					{
						if(this.contains(m_rootCnter[idx]))
						{
							this.removeChild(m_rootCnter[idx]);
							 //m_imagePanel[idx].visible = false;	// 这个需要一直都在，因为需要显示一个没有开启的地图
						}
						
						if(!this.contains(m_lblDesc[idx]))
						{
							this.addChild(m_lblDesc[idx]);
						}
						
						m_imagePanel[idx].visible = true;
						m_imagePanel[idx].setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsysrd.notopenbg");
						m_lblDesc[idx].text = m_XmlFBItem.m_level[idx] + "级开启";
					}
				}
				else	// 没有配置，都不显示了
				{
					if(this.contains(m_rootCnter[idx]))
					{
						this.removeChild(m_rootCnter[idx]);
						m_imagePanel[idx].visible = false;
					}
					
					if(this.contains(m_lblDesc[idx]))
					{
						this.removeChild(m_lblDesc[idx]);
					}
					
					m_framePanel[idx].visible = false;
				}
				++idx;
			}
		}
		
		override public function dispose():void
		{
			m_rootCnter[0].removeEventListener(MouseEvent.CLICK, onClickL);
			m_rootCnter[1].removeEventListener(MouseEvent.CLICK, onClickR);
			m_rootCnter[0].removeEventListener(MouseEvent.ROLL_OVER, onOverL);
			m_rootCnter[1].removeEventListener(MouseEvent.ROLL_OVER, onOverR);
			super.dispose();
		}
		
		private function onClickL(event:MouseEvent):void
		{
			if(m_TFBSysData.m_curUIFB[m_TFBSysData.m_curPageIdx] && m_TFBSysData.m_curUIFB[m_TFBSysData.m_curPageIdx] != this)
			{
				m_TFBSysData.m_curUIFB[m_TFBSysData.m_curPageIdx].hideSel();
			}
			
			m_SelectedPanel.visible = true;
			m_SelectedPanel.setPos(-6, -3);
			
			m_TFBSysData.m_curUIFB[m_TFBSysData.m_curPageIdx] = this;
			m_TFBSysData.m_curFB[m_TFBSysData.m_curPageIdx] = m_XmlFBItem;
			m_TFBSysData.m_curFBIdx[m_TFBSysData.m_curPageIdx] = 0;

			m_TFBSysData.m_clkFBItemCB();
			if(m_TFBSysData.m_clkFBObjCB != null)
			{
				m_TFBSysData.m_clkFBObjCB();
			}
			if(m_TFBSysData.m_clkFBOpenedCB != null)
			{
				m_TFBSysData.m_clkFBOpenedCB();
			}
			
			var cmd:clickMultiCopyUiUserCmd = new clickMultiCopyUiUserCmd();
			cmd.copyid = m_XmlFBItem.m_id[0];
			cmd.type = m_TFBSysData.m_gkcontext.m_teamFBSys.bshowType;
			m_TFBSysData.m_gkcontext.sendMsg(cmd);
		}
		
		private function onClickR(event:MouseEvent):void
		{
			if(m_TFBSysData.m_curUIFB[m_TFBSysData.m_curPageIdx] && m_TFBSysData.m_curUIFB[m_TFBSysData.m_curPageIdx] != this)
			{
				m_TFBSysData.m_curUIFB[m_TFBSysData.m_curPageIdx].hideSel();
			}
			
			m_SelectedPanel.visible = true;
			m_SelectedPanel.setPos(-6 + 190, -3);
			
			m_TFBSysData.m_curUIFB[m_TFBSysData.m_curPageIdx] = this;
			m_TFBSysData.m_curFB[m_TFBSysData.m_curPageIdx] = m_XmlFBItem;
			m_TFBSysData.m_curFBIdx[m_TFBSysData.m_curPageIdx] = 1;

			m_TFBSysData.m_clkFBItemCB();
			if(m_TFBSysData.m_clkFBObjCB != null)
			{
				m_TFBSysData.m_clkFBObjCB();
			}
			if(m_TFBSysData.m_clkFBOpenedCB != null)
			{
				m_TFBSysData.m_clkFBOpenedCB();
			}
			
			var cmd:clickMultiCopyUiUserCmd = new clickMultiCopyUiUserCmd();
			cmd.copyid = m_XmlFBItem.m_id[1];
			cmd.type = m_TFBSysData.m_gkcontext.m_teamFBSys.bshowType;
			m_TFBSysData.m_gkcontext.sendMsg(cmd);
		}
		private function onOverL(e:MouseEvent):void
		{
			m_overPanel.visible = true;
			m_overPanel.setPos(-4, -3);
		}
		private function onOverR(e:MouseEvent):void
		{
			m_overPanel.visible = true;
			m_overPanel.setPos(-4 + 190, -3);
		}
		override public function onOut():void 
		{
			m_overPanel.visible = false;
		}
		
		public function hideSel():void
		{
			m_SelectedPanel.visible = false;
		}
		
		public function updateLQFlags(copyid:uint):void
		{
			var idx:uint = 0;
			while(idx < 2)
			{
				if (copyid == m_XmlFBItem.m_id[idx])
				{
					m_LQPanel[idx].visible = true;
				}
				
				++idx;
			}
		}
	}
}