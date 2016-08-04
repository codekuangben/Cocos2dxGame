package game.ui.uiXingMai
{
	import com.ani.AniPosition;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.CommonImageManager;
	import com.dgrigg.image.Image;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import game.ui.uibackpack.subForm.fastZhuansheng.FastZhuanshengMgr;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.prop.BeingProp;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.FormStyleNine;
	import modulecommon.uiinterface.IUIXingMai;
	import game.ui.uiXingMai.subcom.MainPanel;
	import game.ui.uiXingMai.subcom.SkillsPanel;
	
	/*import art.xingmai.back; art.xingmai.back;
	import art.xingmai.attricon.iconbg; art.xingmai.attricon.iconbg;
	import art.xingmai.attricon.attr_1; art.xingmai.attricon.attr_1;
	import art.xingmai.attricon.attr_2; art.xingmai.attricon.attr_2;
	import art.xingmai.attricon.attr_3; art.xingmai.attricon.attr_3;
	import art.xingmai.attricon.attr_4; art.xingmai.attricon.attr_4;
	import art.xingmai.attricon.attr_5; art.xingmai.attricon.attr_5;
	import art.xingmai.attricon.attr_6; art.xingmai.attricon.attr_6;
	import art.xingmai.attricon.attr_7; art.xingmai.attricon.attr_7;
	import art.xingmai.title_word; art.xingmai.title_word;
	import art.xingmai.jianghun; art.xingmai.jianghun;
	import art.xingmai.smallback; art.xingmai.smallback;
	import art.xingmai.levelbg; art.xingmai.levelbg;
	import art.xingmai.pattern; art.xingmai.pattern;
	import art.xingmai.skillbg; art.xingmai.skillbg;
	import art.xingmai.skillform; art.xingmai.skillform;
	import art.xingmai.wucardform; art.xingmai.wucardform;
	import art.xingmai.using; art.xingmai.using;
	import art.xingmai.skillword; art.xingmai.skillword;
	import art.xingmai.usingword; art.xingmai.usingword;
	import art.xingmai.wujiangword; art.xingmai.wujiangword;*/
	
	/**
	 * ...
	 * @author 
	 * 觉醒功能（原星脉功能）
	 */
	
	public class UIXingMai extends FormStyleNine implements IUIXingMai
	{
		private var m_mainPanel:MainPanel;
		private var m_skillsPanel:SkillsPanel;
		private var m_indentBtn:PushButton;
		private var m_ani:AniPosition;
		
		public var m_bGuideOpenSkill:Boolean;	//激活第一个星脉技能，显示引导流程
		
		public var m_fastZhuangMgr:FastZhuanshengMgr;
		
		public function UIXingMai()
		{
			this.exitMode = EXITMODE_HIDE;
			setAniForm(70);
		}
		override public function setImageSWF(imageSWF:SWFResource):void 
		{
			super.setImageSWF(imageSWF);
			m_fastZhuangMgr = new FastZhuanshengMgr(m_gkcontext);
			var panel:Panel;
			var tf:TextField;
			beginPanelDrawBg(639, 567);
			panel = new Panel(null, 15, 33);
			panel.setSize(609, 514);
			m_bgPart.addDrawCom(panel, true);
			panel.setPanelImageSkinBySWF(imageSWF, "xingmai.back");
			
			panel = new Panel(this, 10, 26);
			m_bgPart.addDrawCom(panel, true);
			panel.setPanelImageSkinBySWF(imageSWF, "xingmai.jianghun");
			
			panel = new Panel(null, 205, 163);
			m_bgPart.addDrawCom(panel, true);
			panel.setPanelImageSkin(m_gkcontext.playerMain.halfingPathName);
			
			panel = new Panel(null, 220, 365);
			m_bgPart.addDrawCom(panel, true);
			panel.setPanelImageSkinBySWF(imageSWF, "xingmai.pattern");
			
			panel = new Panel(null, 30, 435);
			panel.setSize(370, 104);
			m_bgPart.addDrawCom(panel, true);
			panel.setSkinGrid9Image9(ResGrid9.StypeNine);
			
			tf = new TextField();
			tf.multiline = true;
			tf.wordWrap = true;
			tf.x = 50;
			tf.y = 450;
			tf.width = 360;
			tf.height = 90;
			
			var tformat:TextFormat = new TextFormat();
			tformat.color = UtilColor.WHITE_Yellow;			
			tformat.letterSpacing = 1;
			tformat.leading = 2;
			tf.defaultTextFormat = tformat;
			
			var str:String = "<body>";
			str += "规则：\n";
			str += "1、觉醒只增加主角属性；\n";
			str += "2、当所有属性觉醒到指定等级时，主角会领悟到特殊技能；\n";
			str += "3、觉醒技能消耗指定武将可以升级。";
			str += "</body>";
			tf.htmlText = str;
			m_bgPart.addDrawCom(tf, true);
			
			panel = new Panel(null, 420, 462);
			m_bgPart.addDrawCom(panel, true);
			panel.setPanelImageSkinBySWF(imageSWF, "xingmai.usingword");
			
			panel = new Panel(null, 488, 459);
			m_bgPart.addDrawCom(panel, true);
			panel.setPanelImageSkinBySWF(imageSWF, "xingmai.skillform");
			
			endPanelDraw();
			
			setTitleDraw(300, "xingmai.title_word", imageSWF, 65);
			
			m_mainPanel = new MainPanel(m_gkcontext, this, this, 20, 40);
			m_indentBtn = new PushButton(this, 565, 453, onIndentBtn);
		}
		override public function onShow():void
		{
			this.adjustPosWithAlign();
			updateXingLi(m_gkcontext.m_xingmaiMgr.xingli);
			updateJiangHun();
			
			if (m_gkcontext.m_newHandMgr.isVisible())
			{
				m_mainPanel.onShowNewHand();
			}
			
			if (m_skillsPanel)
			{
				m_skillsPanel.setPos(503, 27);
			}
			
			if (m_gkcontext.m_xingmaiMgr.m_bShowSkillList)
			{
				m_indentBtn.setSkinButton1Image("commoncontrol/button/leftArrow5.png");
				
				m_gkcontext.m_xingmaiMgr.m_bShowSkillList = false;
				showSkillPanel();
			}
			else
			{
				m_indentBtn.setSkinButton1ImageMirror("commoncontrol/button/leftArrow5.png", Image.MirrorMode_HOR);
			}
			
			if (!m_gkcontext.m_newHandMgr.isVisible())
			{
				super.onShow();
			}
			else
			{
				this.resetShowParam();
			}
		}
		override public function onStageReSize():void
		{
			super.onStageReSize();
		}
		
		//更新星力值
		public function updateXingLi(xingli:uint):void
		{
			//m_mainPanel.updateXingLi(xingli);
			if (m_mainPanel == null)
			{
				DebugBox.sendToDataBase("UIXingMai::updateXingLi m_mainPanel == null");
			}
		}
		
		//更新将魂值
		public function updateJiangHun():void
		{
			var jianghun:uint = m_gkcontext.m_beingProp.getMoney(BeingProp.JIANG_HUN);
			m_mainPanel.updateJiangHun(jianghun);
		}
		
		override public function dispose():void
		{
			m_gkcontext.m_xingmaiMgr.m_bShowSkillList = false;
			if (m_ani)
			{
				m_ani.dispose();
				m_ani = null;
			}
			super.dispose();
		}
		
		private function onIndentBtn(event:MouseEvent):void
		{
			showSkillPanel();
		}
		
		//显示星脉技能列表
		public function showSkillPanel():void
		{
			if (null == m_skillsPanel)
			{
				m_skillsPanel = new SkillsPanel(m_gkcontext, this, null, 503, 27);
				this.addChildAt(m_skillsPanel, 0);	//将技能列表界面放到主界面下边
				m_skillsPanel.initData();
			}
			
			if (m_ani == null)
			{
				m_ani = new AniPosition();
				m_ani.sprite = m_skillsPanel;
				m_ani.duration = 0.6;
			}
			
			if (m_ani.bRun)
			{
				return;
			}
			
			m_ani.setBeginPos(m_skillsPanel.x, m_skillsPanel.y);
			if (m_gkcontext.m_xingmaiMgr.m_bShowSkillList)
			{
				m_indentBtn.setSkinButton1ImageMirror("commoncontrol/button/leftArrow5.png", Image.MirrorMode_HOR);
				m_ani.setEndPos(m_skillsPanel.x - 136, m_skillsPanel.y);
				m_skillsPanel.onHide();
			}
			else
			{
				m_indentBtn.setSkinButton1Image("commoncontrol/button/leftArrow5.png");
				m_ani.setEndPos(m_skillsPanel.x + 136, m_skillsPanel.y);
			}
			m_ani.begin();
			
			m_gkcontext.m_xingmaiMgr.m_bShowSkillList = !m_gkcontext.m_xingmaiMgr.m_bShowSkillList;
		}
		public function hideNextRelationWuListByHeroID(heroid:uint):void
		{
			m_skillsPanel.hideNextRelationWuListByHeroID(heroid);
		}
		//技能Tips显示
		public function showTipsOfSkill(pt:Point, skillid:uint):void
		{
			m_gkcontext.m_uiTip.hintSkillInfo(pt, skillid, 50);
		}
		
		//属性等级更新
		public function updateAttrLevel(id:uint):void
		{
			m_mainPanel.updateAttrLevel(id);
		}
		
		//激活新技能
		public function openOneNewXMSkill():void
		{
			m_mainPanel.updateWillActSkill();
			
			if (m_skillsPanel)
			{
				m_skillsPanel.updateSkillsList();
			}
			
			if (!m_gkcontext.m_xingmaiMgr.m_bShowSkillList)
			{
				showSkillPanel();
			}
		}
		
		//更新激活武将状态显示
		public function updateActWuState(heroid:uint):void
		{
			if (m_skillsPanel)
			{
				m_skillsPanel.updateActWuState(heroid);
			}
		}
		
		//开启第一个星脉技能后，自动设置为使用
		public function reSetDefaultUsingSkill():void
		{
			if (m_skillsPanel)
			{
				m_skillsPanel.reSetDefaultUsingSkill();
			}
			
			m_bGuideOpenSkill = true;
		}
		
		//更新使用中觉醒技能
		public function updateUsingSkill():void
		{
			m_mainPanel.updateUsingSkill();
		}
		
		//星脉技能等级升级成功
		public function successSkillLevelUp(skillid:uint):void
		{
			if (m_skillsPanel)
			{
				m_skillsPanel.updateSkillsList();
				m_skillsPanel.skillLevelUp(skillid);
			}
			
			if (m_gkcontext.m_xingmaiMgr.m_curUsingSkillBaseID == skillid)
			{
				m_mainPanel.updateUsingSkill();
			}
		}
		
		override public function exit():void
		{
			m_gkcontext.m_xingmaiMgr.m_bShowSkillList = false;
			if (m_skillsPanel)
			{
				m_skillsPanel.onHide();
			}
			
			super.exit();
		}
		
		override public function getDestPosForHide():Point 
		{
			return new Point(285, 60);
		}
		
	}
}