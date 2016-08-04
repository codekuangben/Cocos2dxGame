package game.ui.uibackpack.watch 
{
	import com.bit101.components.Component;
	import com.bit101.components.label.LabelFormat;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.Label;
	import com.bit101.components.label.Label2;
	import com.bit101.components.PanelShowAndHide;
	import com.bit101.components.progressBar.BarInProgress2;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.appcontrol.DigitComponent;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.prop.object.ObjectIcon;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.Package;
	import modulecommon.scene.prop.object.stObjLocation;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import com.util.UtilColor;
	import game.ui.uibackpack.UIBackPack;
	import game.ui.uibackpack.wujiang.AttrItemOne;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import game.ui.uibackpack.wujiang.EquipBgShare;
	import game.ui.uibackpack.wujiang.SubEquip;
	/**
	 * ...
	 * @author 
	 */
	public class Watch_UIEquip extends PanelShowAndHide 
	{
		protected var m_wu:WuProperty;		
		protected var m_gkContext:GkContext;
		
		private var m_halfingBG:PanelContainer;
		private var m_nameLabel:Label2;
		private var m_jobLabel:Label2;
		private var m_vecPanel:Vector.<ObjectPanel>;
		private var m_vecLabel:Vector.<Label>;		
		public  var m_relationWu:Watch_WuRelationPanel;
		private var m_ui:UIWatchPlayer;
		
		private var m_zhanshu:AttrItemOne;
		private var m_jinnang:AttrItemOne;
		private var m_zhanliBar:BarInProgress2;			//战力评价条
		private var m_zhanliAssess:Panel;				//战力评价等级名称
		private var m_zhanliDC:DigitComponent;			//战力值	
		
		public function Watch_UIEquip(ui:UIWatchPlayer, parent:DisplayObjectContainer, gk:GkContext, wu:WuProperty) 
		{
			super(parent);
			m_gkContext = gk;
			m_ui = ui;
			m_wu = wu;
			m_halfingBG = new PanelContainer(this, 9, 10);			
			
			m_nameLabel = new Label2(this, 17, 20);
			m_jobLabel = new Label2(this, 217, 18);
			m_vecPanel = new Vector.<ObjectPanel>(ZObjectDef.EQUIP_MAX);
			m_vecLabel = new Vector.<Label>(ZObjectDef.EQUIP_MAX);
			
			var i:int = 0;
			var left:int = 17;
			var top:int = 45;
			var interval:int = 50;
			var panel:ObjectPanel;
			var label:Label;
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
					left = 197;
					top = 45;
				}
				panel = new ObjectPanel(gk, this, left, top);
				panel.setSize(ZObject.IconBgSize, ZObject.IconBgSize);				
				panel.gridY = i;
				panel.objLocation.location = loc;
				panel.objLocation.heroid = m_wu.m_uHeroID;	
				
				panel.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				panel.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);	
				panel.mouseChildren = false;
				m_vecPanel[i] = panel;				
				
				top += interval;
			}
			
			var halfingName:String;			
			halfingName = m_wu.halfingPathName;
			m_halfingBG.setPanelImageSkin(halfingName);
			
			var lf:LabelFormat = new LabelFormat();
			lf.fontName = "STXINWEI";
			lf.size = 20;			
			if (m_wu.isMain)
			{
				lf.color = 0xeeeeee;
			}
			else
			{
				lf.color = (m_wu as WuHeroProperty).colorValue;
			}
			lf.text = m_wu.fullName;
			m_nameLabel.labelFormat = lf;
			
			lf.color = UtilColor.WHITE_Yellow;
			lf.fontName = null;
			lf.size = 12;
			lf.text = PlayerResMgr.toJobName(m_wu.m_uJob);
			m_jobLabel.labelFormat = lf;
			
			//战力值
			m_zhanliDC = new DigitComponent(m_gkContext.m_context, this, 117, 285);	
			m_zhanliDC.setParam("commoncontrol/digit/digit01",10,18);
			m_zhanliDC.digit = m_wu.m_uZhanli;
			
			m_zhanliBar = new BarInProgress2(this, 62, 305);
			m_zhanliBar.setSize(168, 15);
			m_zhanliBar.setPanelImageSkin("commoncontrol/panel/backpack/bluebar.png");
			m_zhanliBar.maximum = 1;
			m_zhanliBar.initValue = m_wu.m_uZhanli / m_wu.zhanliLimit;
			
			m_zhanliAssess = new Panel(this, 117, 302);
			m_zhanliAssess.setSize(47, 25);
			m_zhanliAssess.setPanelImageSkin(SubEquip.setZhanLiHonour(m_wu.zhanliHonour));
			
			m_zhanshu = new AttrItemOne(this);
			m_zhanshu.setPos(71, 352);
			m_zhanshu.m_lableName.text = "技能：";
			m_zhanshu.m_lableValue.x = 38;
			m_zhanshu.m_lableValue.text = wu.zhanshuName;
			m_zhanshu.m_lableValue.setFontColor(0x59CD41);
			m_zhanshu.tag = wu.zhanshuID;
			m_zhanshu.addEventListener(MouseEvent.ROLL_OVER, this.onSkillMouseOver);
			m_zhanshu.addEventListener(MouseEvent.ROLL_OUT, this.onAttrMouseOut);
			
			if (wu is WuHeroProperty)
			{
				var wuHero:WuHeroProperty = wu as WuHeroProperty;	
				var skillPanel:Panel;
				var jinnang:uint = wuHero.m_wuPropertyBase.m_uJinnang1;
				if (jinnang != 0)
				{
					m_jinnang = new AttrItemOne(this);
					m_jinnang.setPos(71, 360);
					m_jinnang.m_lableName.text = "锦囊：";
					m_jinnang.m_lableValue.x = 34;
					m_jinnang.m_lableValue.text = m_gkContext.m_skillMgr.getName(jinnang);
					m_jinnang.m_lableValue.setFontColor(0x59CD41);
					m_jinnang.tag = jinnang;
					m_jinnang.addEventListener(MouseEvent.ROLL_OVER, this.onSkillMouseOver);
					m_jinnang.addEventListener(MouseEvent.ROLL_OUT, this.onAttrMouseOut);
					m_zhanshu.y = 342;					
				}
			}
			
			var pkage:Package = m_gkContext.m_watchMgr.getPakage(m_wu.m_uHeroID, loc);
			if (pkage != null)
			{
				pkage.execFun(initAddObject);
			}			
			
			
			if (m_wu is WuHeroProperty)
			{
				m_relationWu = new Watch_WuRelationPanel(m_gkContext, this, 7, 198);
				m_relationWu.setWu(m_wu as WuHeroProperty);
			}
		}
		protected function initAddObject(obj:ZObject, param:Object):void
		{
			addObject(obj);
		}
		public function addObject(obj:ZObject):void
		{			
			m_vecPanel[obj.m_object.m_loation.y].objectIcon.setZObject(obj);
		}
		
		
		protected function onMouseOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();		
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if (event.currentTarget is ObjectPanel)
			{
				var panel:ObjectPanel = event.currentTarget as ObjectPanel;
				var pt:Point = panel.localToScreen();
				
				var obj:ZObject = panel.objectIcon.zObject;
				if (obj != null)
				{
					m_gkContext.m_uiTip.hintObjectInfo(pt, obj);
				}				
			}
		
		}
		protected function onSkillMouseOver(event:MouseEvent):void
		{
			var panel:Component = event.currentTarget as Component;
			var pt:Point;
			if (event.currentTarget == m_zhanshu)
			{
				pt = panel.localToScreen(new Point(90, 0));
			}
			else
			{
				pt = panel.localToScreen(new Point(120, 0));
			}
			
			if (panel.tag)
			{
				m_gkContext.m_uiTip.hintSkillInfo(pt, panel.tag);
			}
		}
		
		protected function onAttrMouseOver(event:MouseEvent):void
		{
			var pt:Point
			if (event.currentTarget is Label)
			{
				var label:Label = event.currentTarget as Label;
				pt = label.localToScreen(new Point(label.width / 2, 0));
				
				var str:String = this.m_gkContext.m_commonData.getValue(label.tag);				
				if (str != null)
				{
					m_gkContext.m_uiTip.hintCondense(pt, str);
				}
			}
		}
		public function onShowThisWu():void
		{
			var sharBG:EquipBgShare = m_ui.equipBgShare;
			if (sharBG.parent != m_halfingBG)
			{
				m_halfingBG.addChild(sharBG);
			}
		}
		protected function onAttrMouseOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
		}
		
		public function get heroID():uint
		{
			return m_wu.m_uHeroID;
		}
	}

}