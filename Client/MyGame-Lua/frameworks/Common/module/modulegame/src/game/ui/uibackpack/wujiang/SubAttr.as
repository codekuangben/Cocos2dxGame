package game.ui.uibackpack.wujiang
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.label.Label2;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import com.pblabs.engine.resource.SWFResource;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.prop.skill.SkillMgr;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuMgr;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	
	public class SubAttr extends SubBase
	{
		private var m_vecFirst:Vector.<AttrItemOne>;
		private var m_vecSec:Vector.<AttrItemOne>;
		private var m_vecThird:Vector.<AttrItemOne>;
		//private var m_relationWu:WuRelationPanel;
		private var m_zhanliIcon:Panel;
		private var m_zhanli:Label;
		
		public function SubAttr(allPanel:AllWuPanel, parent:DisplayObjectContainer, gk:GkContext, wu:WuProperty)
		{
			m_wu = wu;
			super(allPanel, parent, gk);
			
			m_vecFirst = new Vector.<AttrItemOne>(6);
			m_vecSec = new Vector.<AttrItemOne>(6);
			m_vecThird = new Vector.<AttrItemOne>(8);
			
			var marginLeft:int = 8;
			var left:int;
			var top:int;
			var intervalH:int = 120;
			var intervalV:int = 19;
			var xI:int;
			var yI:int;
			var kI:int;
			var arr:Array;
			var item:AttrItemOne;
			var panel:Panel;
			var str:String;
			
			//First部分
			kI = 0;
			top = 15;
			arr = ["姓名:", "职业:", "兵种:", "技能:", "锦囊:", "关系激活:"];
			for (yI = 0; yI < 3; yI++)
			{
				left = marginLeft;
				for (xI = 0; xI < 2; xI++)
				{
					if (kI == 5 && m_wu.isMain)
					{
						kI++;
						continue;
					} 
					item = new AttrItemOne(this);
					item.m_lableName.text = arr[kI] as String;
					item.m_lableName.setFontColor(0x906A5D);
					item.m_lableValue.x = 35;
					item.x = left;
					item.y = top;
					m_vecFirst[kI] = item;
					left += intervalH;
					kI++;
				}
				top += intervalV;
			}
			
			m_vecFirst[0].m_lableValue.text = m_wu.fullName;
			m_vecFirst[1].m_lableValue.text = PlayerResMgr.toJobName(m_wu.m_uJob);
			m_vecFirst[2].m_lableValue.text = m_wu.soldierName;
			
			item = m_vecFirst[3];
			item.tag = m_wu.zhanshuID;
			item.m_lableValue.text = m_wu.zhanshuName;	
			
			item.setSize(40, 20);
			item.drawRectBG();
			item.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			item.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			
			if (m_wu.isMain == false)
			{
				item = m_vecFirst[5];
				item.m_lableValue.x = 60;
				item.setSize(80, 20);
				item.drawRectBG();
				
				item.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				item.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			}
			//Second部分
			kI = 0;
			top = 104;
			arr = ["武力:", "智力:", "统率:", "兵力:", "等级:", "经验:"];
			
			for (yI = 0; yI < 3; yI++)
			{
				left = marginLeft;
				for (xI = 0; xI < 2; xI++)
				{
					item = new AttrItemOne(this);
					item.m_lableName.text = arr[kI] as String;
					item.m_lableName.setFontColor(0x906A5D);
					item.m_lableValue.x = 35;
					item.x = left;
					item.y = top;
					if (kI < 4)
					{
						item.m_lableName.tag = kI + 1;
						item.m_lableName.mouseEnabled = true;
						item.m_lableName.addEventListener(MouseEvent.MOUSE_OVER, this.onAttrMouseOver);
						item.m_lableName.addEventListener(MouseEvent.MOUSE_OUT, this.onAttrMouseOut);
					}
					m_vecSec[kI] = item;
					left += intervalH;
					kI++;
				}
				top += intervalV;
			}
			
			//Third部分
			kI = 0;
			top = 170;
			arr = ["攻击:", "物理防御:", "出手速度:", "策略防御:", "暴击:", "防暴击:", "破击:", "运气:"];
			var arrTag:Array = [5, 6, 7, 13, 8, 9, 10, 11, 12];//"通用配置.xlsx"中对应编号  5、6对应攻击，其他依序一一对应
			
			for (yI = 0; yI < 4; yI++)
			{
				left = marginLeft;
				for (xI = 0; xI < 2; xI++)
				{
					item = new AttrItemOne(this);
					item.m_lableName.text = arr[kI] as String;
					item.m_lableName.setFontColor(0x906A5D);
					item.m_lableValue.x = 61;
					item.y = top;
					item.x = left;
					
					item.m_lableName.tag = arrTag[kI + 1];
					item.m_lableName.mouseEnabled = true;
					item.m_lableName.addEventListener(MouseEvent.MOUSE_OVER, this.onAttrMouseOver);
					item.m_lableName.addEventListener(MouseEvent.MOUSE_OUT, this.onAttrMouseOut);
					
					m_vecThird[kI] = item;
					left += intervalH;
					kI++;
				}
				top += intervalV;
			}
			
			m_zhanliIcon = new Panel(this, 45, 80);
			m_zhanli = new Label(m_zhanliIcon, 40, -2);
			m_zhanli.setFontSize(16);
			m_zhanli.setBold(true);
			
			m_zhanliIcon.setSize(37, 17);
			m_zhanliIcon.setPanelImageSkin("backpage.zhanli");
			
			if (m_wu is WuHeroProperty)
			{
				var wuHero:WuHeroProperty = m_wu as WuHeroProperty;
				var uJinnang1:uint = wuHero.m_wuPropertyBase.m_uJinnang1;
				if ( uJinnang1 != 0)
				{
					panel = addSkillIcon(m_gkContext, m_gkContext.m_wuMgr.jinangIDLevel(uJinnang1).idLevel, onMouseOut, onMouseOver);
					panel.x = 35;
					m_vecFirst[4].addChild(panel);
				}			
				//m_relationWu = new WuRelationPanel(m_allWu, m_gkContext, this, 0, 188);
				//m_relationWu.setWu(wuHero);
			}
		}
		
		override public function draw():void
		{
			super.draw();
			update();
		}
		
		override public function update():void
		{
			m_vecSec[0].m_lableValue.text = m_wu.m_uForce.toString();
			m_vecSec[1].m_lableValue.text = m_wu.m_uIQ.toString();
			m_vecSec[2].m_lableValue.text = m_wu.m_uChief.toString();
			m_vecSec[3].m_lableValue.text = m_wu.m_uHPLimit.toString();
			m_vecSec[4].m_lableValue.text = m_wu.m_uLevel.toString();
			m_vecSec[5].m_lableValue.text = m_wu.m_uExp.toString();
			
			m_zhanli.text = m_wu.m_uZhanli.toString();
			
			var str:String;
			var name:String;
			var tag:int;
			if (PlayerResMgr.JOB_JUNSHI == m_wu.m_uJob)
			{
				str = m_wu.m_uStrategyDam.toString();
				name = "策略攻击:"; //军师
				tag = 6;	//"通用配置.xlsx"中对应编号 6 对应策略攻击
			}
			else
			{
				str = m_wu.m_uPhyDam.toString();
				name = "物理攻击:"; //猛将、弓将
				tag = 5;	//"通用配置.xlsx"中对应编号 7 对应物理攻击
			}
			m_vecThird[0].m_lableName.tag = tag;
			m_vecThird[0].m_lableName.text = name;
			m_vecThird[0].m_lableValue.text = str;
			m_vecThird[1].m_lableValue.text = m_wu.m_uPhyDef.toString();
			m_vecThird[2].m_lableValue.text = m_wu.m_uAttackSpeed.toString();
			m_vecThird[3].m_lableValue.text = m_wu.m_uStrategyDef.toString();
			m_vecThird[4].m_lableValue.text = m_wu.m_uBaoji.toString();
			m_vecThird[5].m_lableValue.text = m_wu.m_uBjDef.toString();
			m_vecThird[6].m_lableValue.text = m_wu.m_uPoji.toString();
			m_vecThird[7].m_lableValue.text = m_wu.m_uLuck.toString();
			
			if (m_wu is WuHeroProperty)
			{
				var wuHero:WuHeroProperty = m_wu as WuHeroProperty;	
				m_vecFirst[5].m_lableValue.text = wuHero.numWuActivated.toString() + "/" + wuHero.m_vecActiveHeros.length.toString();
				//m_relationWu.update();
			}
		
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			var panel:Component = event.currentTarget as Component;
			var localP:Point = new Point();
			var pt:Point;
			if (event.currentTarget == m_vecFirst[5])
			{
				localP.x = 90;
				pt = panel.localToScreen(localP);
				m_gkContext.m_uiTip.hintActiveWuRelation(pt, m_wu.m_uHeroID);
			}
			else if (event.currentTarget is Component)
			{				
				if (panel.tag == 0)
				{
					return;
				}				
				if (panel is Panel)
				{
					localP.x = SkillMgr.ICONSIZE_SMALL;
				}
				else
				{
					localP.x = 90;
				}
				pt = panel.localToScreen(localP);
				m_gkContext.m_uiTip.hintSkillInfo(pt, panel.tag);
			}
		
		}
		override public function onShow():void
		{
			if (m_wuPanel.m_relationWu&&m_wuPanel.m_relationWu.parent != this)
			{
				this.addChild(m_wuPanel.m_relationWu);
				m_wuPanel.m_relationWu.setPos(0, 295);
				m_wuPanel.m_relationWu.onAddToAttrPage();
			}
		}
		protected function onActiveHeroMouseOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
		}
		
		protected function onActiveHeroMouseOver(event:MouseEvent):void
		{
			if (event.currentTarget is Panel)
			{
				var panel:Panel = event.currentTarget as Panel;
				var localP:Point = new Point(WuProperty.SQUAREHEAD_WIDHT, 0);
				var pt:Point = panel.localToScreen(localP);
				m_gkContext.m_uiTip.hintActiveWu(pt, m_wu.m_uHeroID, panel.tag);
			}
		
		}
		protected function onAttrMouseOver(event:MouseEvent):void
		{			
			if (event.currentTarget is Label2)
			{
				var label:Label2 = event.currentTarget as Label2;
				var pt:Point = label.localToScreen(new Point(label.width/2, 0));
				
				var str:String = this.m_gkContext.m_commonData.getValue(label.tag);
				
				if (str != null)
				{
					m_gkContext.m_uiTip.hintCondense(pt, str);
				}
			}
		}
		protected function onAttrMouseOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
		}
		public static function addSkillIcon(gk:GkContext, skillID:uint,mouseOutFun:Function, mouseOverFun:Function):Panel
		{			
			var panel:Panel = new Panel(null, 0, 0);
			panel.tag = skillID;
			panel.autoSizeByImage = false;
			panel.addEventListener(MouseEvent.ROLL_OUT, mouseOutFun);
			panel.addEventListener(MouseEvent.ROLL_OVER, mouseOverFun);
			var resName:String = gk.m_skillMgr.iconResName(skillID);
			if (resName != null)
			{
				panel.setSize(SkillMgr.ICONSIZE_SMALL, SkillMgr.ICONSIZE_SMALL);
				panel.setPanelImageSkin(resName);
				trace(skillID);
			}
			return panel;
		}
	}

}