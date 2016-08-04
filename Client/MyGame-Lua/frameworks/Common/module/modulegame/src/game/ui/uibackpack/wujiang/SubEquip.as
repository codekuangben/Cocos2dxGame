package game.ui.uibackpack.wujiang
{
	import com.bit101.components.ButtonTabText;
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.label.Label2;
	import com.bit101.components.label.LabelFormat;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.progressBar.BarInProgress2;
	import com.bit101.components.PushButton;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.GkContext;
	import flash.display.DisplayObjectContainer;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.prop.object.ObjectIcon;	
	import modulecommon.scene.prop.object.Package;
	import modulecommon.scene.prop.object.stObjLocation;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	import flash.events.MouseEvent;
	import com.dnd.DragManager;
	import com.dnd.DragListener;
	import common.event.DragAndDropEvent;
	import modulecommon.net.msg.propertyUserCmd.stSwapObjectPropertyUserCmd;
	import flash.geom.Point;
	import modulecommon.scene.prop.skill.SkillMgr;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import flash.display.DisplayObjectContainer;
	import modulecommon.scene.prop.job.Soldier;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	import game.ui.uibackpack.backpack.OPInCommonPack;
	import game.ui.uibackpack.tips.WuJinnangTip;
	import game.ui.uibackpack.UIBackPack;
	import modulecommon.uiinterface.IUIFastSwapEquips;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class SubEquip extends SubBase
	{		
		private var m_halfingBG:PanelContainer;
		private var m_nameLabel:Label2;
		private var m_zhenweiLabel:Label2;
		private var m_vecPanel:Vector.<EquipPanelInSubEquip>;		
		//private var m_vecAttr:Vector.<AttrItemBase>;
		//private var m_relationWu:WuRelationPanel;
		private var m_zhanshu:AttrItemOne;
		private var m_jinnang:AttrItemOne;
		private var m_zhanliBar:BarInProgress2;			//战力评价条
		private var m_zhanliAssess:Panel;				//战力评价等级名称
		private var m_zhanliDC:DigitComponent;			//战力值
		private var m_zhanliupgrade:PushButton;
		private var m_changeBtn:ButtonText;
		private var m_jinnangTip:WuJinnangTip;
		private var m_fastswapBtn:ButtonText;
		private var m_vecTianfu:Vector.<TianfuItem>;	//天赋技能
		
		public function SubEquip(allPanel:AllWuPanel, parent:DisplayObjectContainer, gk:GkContext, wu:WuProperty)
		{		
			super(allPanel, parent, gk);
			m_wu = wu;
			m_halfingBG = new PanelContainer(this, 2, 0);
			//m_halfingBG.setSize(240, 260);
			
			m_nameLabel = new Label2(this, 10, 2);
			m_zhenweiLabel = new Label2(this, 200, 8);
			m_vecPanel = new Vector.<EquipPanelInSubEquip>(ZObjectDef.EQUIP_MAX);		
			
			var i:int = 0;
			var left:int = 10;
			var top:int = 35;
			var interval:int = 50;
			var panel:EquipPanelInSubEquip;
			var loc:int;
			if (m_wu.isMain)
			{
				loc = stObjLocation.OBJECTCELLTYPE_UEQUIP;
			}
			else
			{
				loc = stObjLocation.OBJECTCELLTYPE_HEQUIP;
			}
			
			for (i = 0; i < ZObjectDef.EQUIP_MAX; i++)
			{
				if (i == ZObjectDef.NECKLACE)
				{
					left = 190;
					top = 35;
				}
				panel = new EquipPanelInSubEquip(allPanel,i, loc, m_wu.m_uHeroID, gk, this, left, top);
				m_vecPanel[i] = panel;				
				top += interval;
			}
			
			var halfingName:String;			
			halfingName = m_wu.halfingPathName;
			m_halfingBG.setPanelImageSkin(halfingName);
			
			var zhenweiname:String = "";
			var lf:LabelFormat = new LabelFormat();
			lf.fontName = "STXINWEI";
			lf.size = 20;
			//lf.size = 14;
			if (m_wu.isMain)
			{
				lf.color = 0xeeeeee;
			}
			else
			{
				lf.color = (m_wu as WuHeroProperty).colorValue;
				zhenweiname = (m_wu as WuHeroProperty).zhenweiName;
			}
			lf.text = m_wu.fullName;
			m_nameLabel.labelFormat = lf;
			
			lf.color = UtilColor.WHITE_Yellow;
			lf.fontName = null;
			lf.size = 12;
			lf.text = zhenweiname;
			m_zhenweiLabel.labelFormat = lf;
			
			//战力值
			m_zhanliDC = new DigitComponent(m_gkContext.m_context, this, 110, 275);	
			m_zhanliDC.setParam("commoncontrol/digit/digit01",10,18);

			
			m_zhanliBar = new BarInProgress2(this, 55, 297);
			m_zhanliBar.setSize(168, 15);
			m_zhanliBar.setPanelImageSkin("commoncontrol/panel/backpack/bluebar.png");
			m_zhanliBar.maximum = 1;
			m_zhanliBar.initValue = m_wu.m_uZhanli / m_wu.zhanliLimit;
			
			m_zhanliAssess = new Panel(this, 110, 292);
			m_zhanliAssess.setSize(47, 25);
			m_zhanliAssess.setPanelImageSkin(setZhanLiHonour(m_wu.zhanliHonour));
			
			m_zhanshu = new AttrItemOne(this);
			m_zhanshu.setPos(56, 342);
			m_zhanshu.m_lableName.text = "技能：";
			m_zhanshu.m_lableValue.x = 36;
			m_zhanshu.m_lableValue.text = wu.zhanshuName;
			m_zhanshu.m_lableValue.setFontColor(UtilColor.GREEN);
			m_zhanshu.m_lableValue.miaobian = false;
			m_zhanshu.tag = wu.zhanshuID;
			m_zhanshu.addEventListener(MouseEvent.ROLL_OVER, this.onSkillMouseOver);
			m_zhanshu.addEventListener(MouseEvent.ROLL_OUT, this.m_gkContext.hideTipOnMouseOut);
			
			if (wu is WuHeroProperty)
			{
				var wuHero:WuHeroProperty = wu as WuHeroProperty;	
				var skillPanel:Panel;
				var jinnang:uint = wuHero.m_wuPropertyBase.m_uJinnang1;
				if (jinnang != 0)
				{
					m_jinnang = new AttrItemOne(this);
					m_jinnang.setPos(56, 350);
					m_jinnang.m_lableName.text = "锦囊：";
					m_jinnang.m_lableValue.x = 32;
					m_jinnang.m_lableValue.text = m_gkContext.m_skillMgr.getName(jinnang + wuHero.add);
					m_jinnang.m_lableValue.setFontColor(UtilColor.GREEN);
					m_jinnang.m_lableValue.miaobian = false;
					m_jinnang.tag = jinnang;
					m_jinnang.addEventListener(MouseEvent.ROLL_OVER, this.onSkillMouseOver);
					m_jinnang.addEventListener(MouseEvent.ROLL_OUT, this.m_gkContext.hideTipOnMouseOut);
					m_zhanshu.y = 332;
					
					//skillPanel = SubAttr.addSkillIcon(m_gkContext, wuHero.m_wuPropertyBase.m_uJinnang1, onMouseOut, onSkillMouseOver);
					//skillPanel.setSize( 20, 20);
					//skillPanel.x = 43;
					//m_vecAttr[6].addChild(skillPanel);
					//m_jinnang.addChild(skillPanel);
					
				}
				
				
				//m_relationWu = new WuRelationPanel(m_allWu, m_gkContext, this, 0, 188);
				//m_relationWu.setWu(wuHero);
			}
			
			var pkage:Package = m_gkContext.m_objMgr.getPakage(m_wu.m_uHeroID, loc);
			if (pkage != null)
			{
				pkage.execFun(initAddObject);
			}
			initBuyBtns();
			
			m_zhanliupgrade = new PushButton(this, 70, 275, onClickUpgradeBtn);
			m_zhanliupgrade.setSkinButton1Image("commoncontrol/panel/upgradeBtn.png");
			m_zhanliupgrade.visible = false;
			
			m_changeBtn = new ButtonText(this, 180, 339, "更换", onClickChangeBtn);
			m_changeBtn.setSize(49, 26);
			m_changeBtn.setSkinButton1Image("commoncontrol/button/button8.png");
			if (m_wu.isMain)
			{
				m_changeBtn.visible = true;
			}
			else
			{
				m_changeBtn.visible = false;
			}
			
			m_fastswapBtn = new ButtonText(this, 178, 270, "换装", onClickFastSwapBtn);
			m_fastswapBtn.setSize(49, 26);
			m_fastswapBtn.setSkinButton1Image("commoncontrol/button/button8.png");
			
			if (!m_wu.isMain)
			{
				m_vecTianfu = new Vector.<TianfuItem>();
				var item:TianfuItem;
				var tianfu:Vector.<uint> = (m_wu as WuHeroProperty).getTianfu();
				left = 150 - 26 * tianfu.length;
				for (i = 0; i < tianfu.length; i++)
				{
					item = new TianfuItem(m_gkContext, this, left + 52 * i, 390);
					m_vecTianfu.push(item);
				}
			}
		}
		protected function initBuyBtns():void
		{
			var item:EquipPanelInSubEquip;
			for each(item in m_vecPanel)
			{
				item.initBuyEquip();
			}
		}
		protected function initAddObject(obj:ZObject, param:Object):void
		{
			addObject(obj);
		}
		
		
		
		override public function draw():void
		{
			super.draw();
			update();
		}
		public function onEquipDrag(obj:ZObject):void
		{
			var panel:EquipPanelInSubEquip = m_vecPanel[obj.equipPos];
			m_allWu.showEquipAni(this, panel.x, panel.y);
		}
		
		override public function onUIBackPackShow():void 
		{
			if (!m_gkContext.m_jiuguanMgr.m_hasRequest)
			{
				m_gkContext.m_jiuguanMgr.loadConfig();
			}
						
		}
		override public function onShowThisWu():void
		{
			if (m_allWu.equipBgShare.parent != m_halfingBG)
			{
				m_halfingBG.addChild(m_allWu.equipBgShare);
			}			
			m_allWu.m_wuDecorate.show(m_halfingBG);			
		}
		
		override public function onShow():void
		{
			/*
			if (m_wuPanel.m_relationWu&&m_wuPanel.m_relationWu.parent != this)
			{
				this.addChild(m_wuPanel.m_relationWu);
				m_wuPanel.m_relationWu.setPos(0, 188);
				m_wuPanel.m_relationWu.onAddToEquipPage();
			}
			*/
		}
		
		override public function update():void
		{
			if (m_wu == null)
			{
				return;
			}
			/*
			(m_vecAttr[0] as AttrItemTwo).m_lableValue.text = m_wu.m_uForce.toString();
			(m_vecAttr[1] as AttrItemTwo).m_lableValue.text = m_wu.m_uIQ.toString();
			(m_vecAttr[2] as AttrItemTwo).m_lableValue.text = m_wu.m_uChief.toString();
			(m_vecAttr[3] as AttrItemTwo).m_lableValue.text = m_wu.m_uHPLimit.toString();
			(m_vecAttr[4] as AttrItemTwo).m_lableValue.text = this.m_gkContext.m_Solder.toSoldierName(m_wu.m_uSoldierType);
			(m_vecAttr[7] as AttrItemTwo).m_lableValue.text = m_wu.m_uZhanli.toString();
			*/
			if (m_wu is WuHeroProperty)
			{
				var wuHero:WuHeroProperty = m_wu as WuHeroProperty;
				var skillItem:TSkillBaseItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_SKILL, wuHero.m_wuPropertyBase.m_uZhanshu) as TSkillBaseItem;
				if (skillItem != null)
				{
					//(m_vecAttr[5] as AttrItemTwo).m_lableValue.text = skillItem.m_name;
					m_zhanshu.m_lableValue.text = skillItem.m_name;
				}
				//m_relationWu.update();
				updateTianfuList();
			}
			
			m_zhanliDC.digit = m_wu.m_uZhanli;
			var v:Number = m_wu.m_uZhanli / m_wu.zhanliLimit;
			if (m_zhanliBar.value != v)
			{
				m_zhanliBar.value = v;
				var str:String = setZhanLiHonour(m_wu.zhanliHonour);
				if (str != m_zhanliAssess.imageName)
				{
					m_zhanliAssess.setPanelImageSkin(str);
				}
			}
		}
		
		//更新天赋技能显示
		private function updateTianfuList():void
		{
			var i:int;
			var level:int;
			var add:int = (m_wu as WuHeroProperty).add;
			var actNums:int = (m_wu as WuHeroProperty).numWuActivated;
			var tianfu:Vector.<uint> = (m_wu as WuHeroProperty).getTianfu();
			var tianfuNum:int = tianfu.length;
			for (i = 0; i < tianfuNum; i++)
			{
				level = add;
				if (i < actNums)
				{
					level += 1;
				}
				
				m_vecTianfu[i].setSkillID(tianfu[i], level, add + 1, i + 1);
			}
		}
		
		//战力评价等级
		public static function setZhanLiHonour(zhanliHonour:int):String
		{
			var str:String = "";
			switch(zhanliHonour)
			{
				case WuProperty.ZHANLI_Putong:
					str = "commoncontrol/panel/backpack/putong.png";
					break;
				case WuProperty.ZHANLI_Jingying:
					str = "commoncontrol/panel/backpack/jingying.png";
					break;
				case WuProperty.ZHANLI_Zhuoyue:
					str = "commoncontrol/panel/backpack/zhuoyue.png";
					break;
				case WuProperty.ZHANLI_Shenji:
					str = "commoncontrol/panel/backpack/shenji.png";
					break;
				case WuProperty.ZHANLI_Nitian:
					str = "commoncontrol/panel/backpack/nitian.png";
					break;
			}
			return str;
		}
		
		public function onEquipDrop(obj:ZObject):void
		{
			m_allWu.hideEquipAni(this);	
		}
		
		public function addObject(obj:ZObject):void
		{			
			var panel:EquipPanelInSubEquip = m_vecPanel[obj.m_object.m_loation.y];
			panel.setZObject(obj);			
		}
		
		public function removeObject(obj:ZObject):void
		{
			var panel:EquipPanelInSubEquip = m_vecPanel[obj.m_object.m_loation.y];
			panel.removeZObject();			
		}
		
		public function updateObject(obj:ZObject):void
		{
			var panel:EquipPanelInSubEquip = m_vecPanel[obj.m_object.m_loation.y];
			panel.freshIcon();			
		}
		
		protected function onSkillMouseOver(event:MouseEvent):void
		{
			var panel:Component = event.currentTarget as Component;
			var pt:Point;
			if (event.currentTarget == m_zhanshu)
			{
				pt = panel.localToScreen(new Point(90, 0));
				m_gkContext.m_uiTip.hintSkillInfo(pt, panel.tag);
			}
			else
			{
				if (null == m_jinnangTip)
				{
					m_jinnangTip = new WuJinnangTip(m_gkContext);
				}
				m_jinnangTip.showTip(panel.tag, (m_wu as WuHeroProperty).add);
				
				pt = panel.localToScreen(new Point(120, 0));
				m_gkContext.m_uiTip.hintComponent(pt, m_jinnangTip);
			}
		}
		
		protected function onAttrMouseOver(event:MouseEvent):void
		{
			var pt:Point;
			if (event.currentTarget is Label)
			{
				var label:Label = event.currentTarget as Label;
				pt = label.localToScreen(new Point(label.width / 2, 0));
				
				var str:String = this.m_gkContext.m_commonData.getValue(label.tag);
				trace(label.tag);
				if (str != null)
				{
					m_gkContext.m_uiTip.hintCondense(pt, str);
				}
			}
		}
		
		protected function onClickUpgradeBtn(event:MouseEvent):void
		{
			if (event.currentTarget == m_zhanliupgrade)
			{
				if (m_gkContext.m_zhanliupgradeMgr.hasRequest() == false)
				{
					m_gkContext.m_zhanliupgradeMgr.loadConfig();
				}
				
				if(m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIZhanliUpgrade) == true)
				{
					m_gkContext.m_UIMgr.destroyForm(UIFormID.UIZhanliUpgrade);
				}
				else
				{
					m_gkContext.m_UIMgr.loadForm(UIFormID.UIZhanliUpgrade);
				}
			}
		}
		
		private function onClickChangeBtn(event:MouseEvent):void
		{
			if (event.currentTarget == m_changeBtn)
			{
				m_gkContext.m_xingmaiMgr.m_bShowSkillList = true;
				m_gkContext.m_UIMgr.showFormWidthProgress(UIFormID.UIXingMai);				
			}
		}
		
		private function onClickFastSwapBtn(event:MouseEvent):void
		{
			if (event.currentTarget == m_fastswapBtn)
			{
				var form:IUIFastSwapEquips = m_gkContext.m_UIMgr.showFormInGame(UIFormID.UIFastSwapEquips) as IUIFastSwapEquips;
				var ui:UIBackPack = m_gkContext.m_UIMgr.getForm(UIFormID.UIBackPack) as UIBackPack;
				form.initData(ui.curHeroID);		
			}
		}
		
		//更新主角技能
		public function updateZhanshu():void
		{
			if (m_wu.isMain)
			{
				m_zhanshu.m_lableValue.text = m_wu.zhanshuName;
				m_zhanshu.tag = m_wu.zhanshuID
			}
		}
		
		override public function dispose():void
		{
			if (m_jinnangTip != null)
			{
				if (m_jinnangTip.parent)
				{
					m_jinnangTip.parent.removeChild(m_jinnangTip);
				}
				
				m_jinnangTip.dispose();
				m_jinnangTip = null;
			}
			super.dispose();
		}
	}

}