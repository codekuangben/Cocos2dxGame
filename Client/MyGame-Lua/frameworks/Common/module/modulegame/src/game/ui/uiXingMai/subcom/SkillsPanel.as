package game.ui.uiXingMai.subcom 
{
	import com.ani.AniPosition;
	import com.bit101.components.Ani;
	import com.bit101.components.controlList.ControlAlignmentParam;
	import com.bit101.components.controlList.ControlList;
	import com.bit101.components.pageturn.PageTurn;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.dgrigg.image.Image;
	import modulecommon.net.msg.xingMaiCmd.stChangeUserSkillXMCmd;
	import modulecommon.scene.xingmai.ItemSkill;
	
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.res.ResGrid9;
	import modulecommon.ui.Form;
	import game.ui.uiXingMai.UIXingMai;
	/**
	 * ...
	 * @author ...
	 * 觉醒激活技能列表
	 */
	public class SkillsPanel extends PanelContainer
	{
		private var m_gkContext:GkContext;
		private var m_uiXingMai:UIXingMai;
		private var m_pageTurn:PageTurn;
		private var m_list:ControlList;
		private var m_usingPanel:Panel;
		private var m_arrowPanel:Panel;
		private var m_actWuPanel:ActWuPanel;
		private var m_levelUpAni:Ani;				//技能等级提升特效
		private var m_curSelectSkillItem:SkillItem;	//当前选中技能(该技能的激活武将列表在显示ing)
		
		public function SkillsPanel(gk:GkContext, ui:UIXingMai, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_uiXingMai = ui;
			m_gkContext = gk;
			this.setSize(130, 540);
			this.setSkinForm("form9.swf");
			
			var panel:Panel;
			panel = new Panel(this, 15, 15);
			panel.autoSizeByImage = false;
			panel.setSize(100, 505);
			panel.setPanelImageSkinMirror("commoncontrol/panel/xingmai/smallback.png", Image.MirrorMode_LR);
			
			panel = new Panel(this, 41, 24);
			panel.setPanelImageSkin("commoncontrol/panel/xingmai/skillword.png");
			
			for (var i:int = 0; i < 5; i++)
			{
				panel = new Panel(this, 20, 45 + i*90);
				panel.setPanelImageSkin("commoncontrol/panel/xingmai/skillbg.png");
			}
			
			m_list = new ControlList(this, 20, 45);
			var param:ControlAlignmentParam = new ControlAlignmentParam();
			param.m_class = SkillItem;
			param.m_width = 120;
			param.m_height = 90;
			param.m_intervalH = 0;
			param.m_intervalV = 0;
			param.m_marginTop = 0;
			param.m_marginBottom = 0;
			param.m_marginLeft = 0;
			param.m_marginRight = 0;
			param.m_lineSize = param.m_marginTop + param.m_marginBottom + (param.m_height + param.m_intervalV) * 4 + param.m_height;
			param.m_needScroll = false;
			param.m_scrollType = 1;
			param.m_numColumn = 1;
			param.m_parentHeight = param.m_lineSize;
			m_list.setParam(param);
			
			m_pageTurn = new PageTurn(this, 26, 498);
			m_pageTurn.setBtnPos(0, 0, 60, 0, 0, 18);
			m_pageTurn.setParam(onPageTurn);
			m_pageTurn.setBtnNameHorizontal_Mirror("leftArrow2.swf");
			m_pageTurn.curPage = 0;
			
		}
		
		public function initData():void
		{
			updateSkillsList();
		}
		
		public function updateSkillsList():void
		{
			var list:Array = m_gkContext.m_xingmaiMgr.actSkillsList;
			var param:Object = new Object();
			param["gk"] = m_gkContext;
			param["ui"] = m_uiXingMai;
			param["skillspanel"] = this;
			m_list.setDatas(list, param);
			
			m_pageTurn.pageCount = Math.ceil(list.length / 5);
		}
		
		private function onPageTurn(pre:Boolean):void
		{
			if (pre)
			{
				m_list.toPreLine();
			}
			else
			{
				m_list.toNextLine();
			}
		}
		
		//请求更换使用中技能
		public function changeUserSkill(parent:DisplayObjectContainer, skillid:uint):void
		{
			if (skillid != m_gkContext.m_xingmaiMgr.m_curUsingSkillBaseID)
			{
				var cmd:stChangeUserSkillXMCmd = new stChangeUserSkillXMCmd();
				cmd.m_skillid = skillid;
				m_gkContext.sendMsg(cmd);
			}
			
			setUsingPanel(parent);
		}
		
		//显示"使用中"标签
		public function setUsingPanel(parent:DisplayObjectContainer):void
		{
			if (null == m_usingPanel)
			{
				m_usingPanel = new Panel(this, -3, -2);
				m_usingPanel.setPanelImageSkin("commoncontrol/panel/xingmai/using.png");
				m_usingPanel.mouseEnabled = false;
			}
			
			if (m_usingPanel.parent && m_usingPanel.parent != parent)
			{
				m_usingPanel.parent.removeChild(m_usingPanel);
			}
			parent.addChild(m_usingPanel);
		}
		
		//显示激活武将列表
		public function showActWuPanel(parent:DisplayObjectContainer, skillid:uint):void
		{
			if (m_actWuPanel && skillid == m_actWuPanel.skillBaseID)
			{
				return;
			}
			
			m_curSelectSkillItem = (parent as SkillItem);
			
			//指向激活武将的箭头
			if (null == m_arrowPanel)
			{
				m_arrowPanel = new Panel(null, 78, 13);
				m_arrowPanel.setPanelImageSkin("commoncontrol/panel/backpack/arrow.png");
				m_arrowPanel.mouseEnabled = false;
			}
			
			if (m_arrowPanel.parent && m_arrowPanel.parent != parent)
			{
				m_arrowPanel.parent.removeChild(m_arrowPanel);
			}
			parent.addChild(m_arrowPanel);
			
			if (null == m_actWuPanel)
			{
				m_actWuPanel = new ActWuPanel(m_gkContext, m_uiXingMai, null, this.width, 0);
				this.addChildAt(m_actWuPanel, 0);
			}
			
			m_actWuPanel.setData(skillid);
		}
		
		//更新激活武将状态显示
		public function updateActWuState(heroid:uint):void
		{
			if (m_actWuPanel)
			{
				m_actWuPanel.updateActWuState(heroid);
			}
		}
		public function hideNextRelationWuListByHeroID(heroid:uint):void
		{
			m_actWuPanel.hideNextRelationWuListByHeroID(heroid);
		}
		
		//激活第一个觉醒技能时，默认设置为使用中
		public function reSetDefaultUsingSkill():void
		{
			var skillitem:SkillItem = m_list.getControlByIndex(0) as SkillItem;
			if (skillitem)
			{
				skillitem.setUsingSkill();
			}
		}
		
		//觉醒技能等级提升
		public function skillLevelUp(skillid:uint):void
		{
			if (null == m_levelUpAni)
			{
				m_levelUpAni = new Ani(m_gkContext.m_context);
				m_levelUpAni.duration = 1;
				m_levelUpAni.repeatCount = 1;
				m_levelUpAni.centerPlay = true;
				m_levelUpAni.setImageAni("e406101.swf");
				m_levelUpAni.x = 45;
				m_levelUpAni.y = 35;
				m_levelUpAni.mouseEnabled = false;
				m_levelUpAni.m_fcomp = skillAniEnd;
			}
			
			if (m_levelUpAni.parent)
			{
				m_levelUpAni.parent.removeChild(m_levelUpAni);
			}
			
			if (m_curSelectSkillItem)
			{
				m_curSelectSkillItem.addChildAt(m_levelUpAni, m_curSelectSkillItem.numChildren);
				
				m_levelUpAni.visible = true;
				m_levelUpAni.begin();
			}
			
			var skillitem:ItemSkill = m_gkContext.m_xingmaiMgr.getItemSkill(skillid);
			m_gkContext.m_systemPrompt.prompt(skillitem.m_name + " 等级+1");
		}
		
		private function skillAniEnd(ani:Ani):void
		{
			if (m_levelUpAni && m_levelUpAni.parent)
			{
				m_levelUpAni.parent.removeChild(m_levelUpAni);
			}
		}
		
		//技能列表在隐藏时，删除激活武将列表
		public function onHide():void
		{
			if (m_arrowPanel)
			{
				if (m_arrowPanel.parent)
				{
					m_arrowPanel.parent.removeChild(m_arrowPanel);
				}
				m_arrowPanel.dispose();
				m_arrowPanel = null;
			}
			
			if (m_actWuPanel)
			{
				m_actWuPanel.dispose();
				m_actWuPanel = null;
			}
			
			m_curSelectSkillItem = null;
			
			if (m_levelUpAni)
			{
				if (m_levelUpAni.parent)
				{
					m_levelUpAni.parent.removeChild(m_levelUpAni);
				}
				m_levelUpAni.dispose();
				m_levelUpAni = null;
			}
		}
		
		override public function dispose():void
		{
			if (m_arrowPanel && null == m_arrowPanel.parent)
			{
				m_arrowPanel.dispose();
			}
			
			super.dispose();
		}
	}

}