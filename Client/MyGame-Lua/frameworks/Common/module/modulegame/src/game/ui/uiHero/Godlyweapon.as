package game.ui.uiHero 
{
	import com.ani.AniMiaobian;
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.progressBar.BarInProgress2;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	import modulecommon.scene.beings.MountsAttr;
	import modulecommon.scene.godlyweapon.GodlyWeaponMgr;
	import modulecommon.scene.godlyweapon.GWSkill;
	import modulecommon.scene.godlyweapon.SkillItem;
	import modulecommon.scene.godlyweapon.WeaponItem;
	import modulecommon.time.Daojishi;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import com.util.UtilTools;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * 神兵Icon
	 */
	public class Godlyweapon extends Component
	{
		private var m_gkContext:GkContext;
		private var m_weapon:Panel;
		private var m_bladeBlack:Panel;		//剑刃-黑
		private var m_bladeRed:Panel;		//剑刃-红
		private var m_leftTimeBar:BarInProgress2;
		private var m_aniCP:Component;
		private var m_fireAni:Ani;			//燃烧的火
		private var m_daojishi:Daojishi;
		private var m_curWeapon:WeaponItem;	//当前显示的神兵
		private var m_leftTimes:uint;		//剩余时间
		private var m_aniMiaobian:AniMiaobian;		//第二天以后，获得新神兵时显示
		private var m_bSmallIcon:Boolean;	//是否显示小图标
		private var m_leftTimeLabel:Label;	//剩余激活时间
		
		public function Godlyweapon(gk:GkContext, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			
			m_aniCP = new Component(this, 0, 0);
			m_aniCP.mouseEnabled = false;
			m_aniCP.mouseChildren = false;
			
			m_weapon = new Panel(this, 0, 0);
			m_weapon.buttonMode = true;
			m_weapon.addEventListener(MouseEvent.CLICK, onWeaponClick);
			m_weapon.addEventListener(MouseEvent.ROLL_OVER, onWeaponRollOver);
			m_weapon.addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);
			
			initData();
		}
		
		private function initData():void
		{
			m_curWeapon = m_gkContext.m_godlyWeaponMgr.curWearingWeapon;
			
			if (m_gkContext.m_godlyWeaponMgr.bActGwId(m_curWeapon.m_id) || (m_curWeapon.m_onlineTime && (m_gkContext.m_godlyWeaponMgr.m_onlineTime >= m_curWeapon.m_onlineTime)))
			{
				m_weapon.setPanelImageSkin("commoncontrol/panel/herobottom/shenbingicon.png");
				this.setSize(25, 27);
				m_bSmallIcon = true;
				
				updateGodlyIconFlashing(m_gkContext.m_godlyWeaponMgr.m_leftTrainTimes > 0);
			}
			else
			{
				initFireAniIcon();
				
				m_leftTimeBar.initValue = 1 - ((m_curWeapon.m_onlineTime - m_gkContext.m_godlyWeaponMgr.m_onlineTime) / m_curWeapon.m_onlineTime);
				showDaoJiShi(m_curWeapon.m_onlineTime - m_gkContext.m_godlyWeaponMgr.m_onlineTime);
				m_weapon.setPanelImageSkin("commoncontrol/panel/herobottom/shenbing.png");
				this.setSize(131, 30);
				m_bSmallIcon = false;
			}
		}
		
		private function initFireAniIcon():void
		{
			m_fireAni = new Ani(m_gkContext.m_context, m_aniCP, 64, 6);
			m_fireAni.duration = 1;
			m_fireAni.repeatCount = 0;
			m_fireAni.setImageAni("ejshenbinxiaojian.swf");
			m_fireAni.centerPlay = true;
			m_fireAni.mouseEnabled = false;
			m_fireAni.begin();
			
			m_bladeBlack = new Panel(m_aniCP, 42, 10);
			m_bladeBlack.setPanelImageSkin("commoncontrol/panel/herobottom/shenbing_black.png");
			
			m_leftTimeBar = new BarInProgress2(m_aniCP, 42, 10);
			m_leftTimeBar.setSize(86, 9);
			m_leftTimeBar.setPanelImageSkin("commoncontrol/panel/herobottom/shenbing_red.png");
			m_leftTimeBar.maximum = 1;
			
			m_leftTimeLabel = new Label(this, 66, 6, "");
		}
		
		public function updateGodlyWeapon(id:uint, type:uint):void
		{
			if (GodlyWeaponMgr.TYPE_Wear == type)
			{
				m_curWeapon = m_gkContext.m_godlyWeaponMgr.getWeaponDataByID(id);
			}
			else if (GodlyWeaponMgr.TYPE_Add == type)
			{
				if (m_leftTimeLabel)
				{
					m_leftTimeLabel.visible = false;
				}
			}
		}
		
		//leftTime 单位(秒)
		public function showDaoJiShi(leftTime:uint):void
		{
			if (null == m_daojishi)
			{
				m_daojishi = new Daojishi(m_gkContext.m_context);
				m_daojishi.timeMode = Daojishi.TIMEMODE_1Minute;
			}
			
			beginDaojishi(leftTime * 1000);
		}
		
		//time 单位为毫秒
		private function beginDaojishi(time:int):void
		{ 
			m_daojishi.funCallBack = updateDaojishi;
			m_daojishi.initLastTime = time;
			m_daojishi.begin();
			updateDaojishi(m_daojishi);
		}
		
		private function updateDaojishi(t:Daojishi):void
		{
			var minute:uint = t.timeSecond / 60;
			var seconds:uint = t.timeSecond % 60;
			var rectW:uint;
			
			m_leftTimes = t.timeSecond;
			
			if (m_daojishi.isStop())
			{
				rectW = 111;
				m_leftTimeBar.value = 1;
				m_leftTimes = 0;
			}
			else
			{
				m_leftTimeBar.value = (m_curWeapon.m_onlineTime - t.timeSecond) / m_curWeapon.m_onlineTime;
				rectW = m_leftTimeBar.value * 83;
			}
			
			m_leftTimeLabel.text = UtilTools.formatTimeToString(m_leftTimes, true, false);
		}
		
		private function onWeaponClick(event:MouseEvent):void
		{
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_newHandMgr.hide();
			}
			
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIGodlyWeapon))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIGodlyWeapon);
			}
			else
			{
				m_gkContext.m_UIMgr.showFormEx(UIFormID.UIGodlyWeapon);
			}
		}
		
		private function onWeaponRollOver(event:MouseEvent):void
		{
			var str:String;
			var tipW:uint = 200;
			
			UtilHtml.beginCompose();
			UtilHtml.add(UtilHtml.formatBold(m_curWeapon.m_name), UtilColor.BLUE, 14);
			
			if (m_gkContext.m_godlyWeaponMgr.m_curWearGWId == m_curWeapon.m_id)
			{
				str = " (佩戴中)";
			}
			else if (m_leftTimes)
			{
				str = " (" + UtilTools.formatTimeToString(m_leftTimes, true, false, true) + "后激活)";
				tipW = 240;
			}
			else
			{
				str = " (未佩戴)";
			}
			UtilHtml.add(str, UtilColor.GRAY, 12);
			
			UtilHtml.breakline();
			UtilHtml.add("战力", 0xD78E03, 12);
			UtilHtml.add("  +" + m_curWeapon.m_zhanli.toString(), 0x23C911, 12);
			
			UtilHtml.breakline();
			UtilHtml.add("属性加成：", UtilColor.WHITE_Yellow, 12);
			
			var i:int;
			var attrData:t_ItemData;
			for (i = 0; i < m_curWeapon.m_effect.length; i++)
			{
				attrData = m_curWeapon.m_effect[i];
				UtilHtml.breakline();
				UtilHtml.add(MountsAttr.m_tblAttrId2Name[attrData.type], 0xD78E03, 12);
				UtilHtml.add("  +" + attrData.value.toString(), 0x23C911, 12);
			}
			
			UtilHtml.breakline();
			UtilHtml.add("号令天下（" + m_gkContext.m_godlyWeaponMgr.m_gwsCurLevel.toString() + "级）", UtilColor.WHITE_Yellow, 12);
			var skillitem:SkillItem = m_gkContext.m_godlyWeaponMgr.getCurGWSkillItem();
			if (skillitem)
			{
				for (i = 0; i < skillitem.m_effect.length; i++)
				{
					attrData = skillitem.m_effect[i];
					UtilHtml.breakline();
					UtilHtml.add(GWSkill.getAttrStr(attrData.type), 0xD78E03, 12);
					UtilHtml.add("  +" + attrData.value.toString(), 0x23C911, 12);
				}
			}
			
			var pt:Point = this.localToScreen(new Point(this.width, 0));
			m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent(), tipW);
		}
		
		public function get bSmallIcon():Boolean
		{
			return m_bSmallIcon;
		}
		
		public function updateGodlyIconFlashing(bflash:Boolean):void
		{
			if (bflash)
			{
				if (null == m_aniMiaobian)
				{
					m_aniMiaobian = new AniMiaobian();
					m_aniMiaobian.sprite = m_weapon;
					m_aniMiaobian.setParam(6, UtilColor.GOLD, 1, 5);
				}
				m_aniMiaobian.begin();
			}
			else
			{
				if (m_aniMiaobian)
				{
					m_aniMiaobian.stop();
					m_aniMiaobian.dispose();
					m_aniMiaobian = null;
				}
			}
		}
		
		override public function dispose():void
		{
			if (m_daojishi)
			{
				m_daojishi.dispose();
			}
			
			if (m_aniMiaobian)
			{
				m_aniMiaobian.dispose();
			}
			
			super.dispose();
		}
	}

}