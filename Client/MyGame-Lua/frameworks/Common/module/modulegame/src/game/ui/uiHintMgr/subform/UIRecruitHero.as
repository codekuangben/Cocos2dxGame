package game.ui.uiHintMgr.subform 
{
	import com.ani.AniPosition;
	import com.ani.AniPropertys;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.TextNoScroll;
	import com.dgrigg.image.Image;
	import common.event.UIEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import modulecommon.scene.wu.AttackRange;
	import modulecommon.scene.wu.WuHeroProperty;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import game.ui.uiHintMgr.UIHintMgr;
	/**
	 * ...
	 * @author ...
	 * 每次招募武将提示
	 */
	public class UIRecruitHero extends Form
	{
		private var m_uiMgr:UIHintMgr;
		private var m_timer:Timer;
		private var m_aniPos:AniPosition;
		private var m_wu:WuHeroProperty;
		private var m_wuHalfPanel:Panel;		//武将半身像
		private var m_clearAni:AniPropertys;	//界面消失
		private var m_tf:TextNoScroll;
		private var m_arPanel:Panel;			//攻击范围、辅助范围
		private var m_attackRange:Label;		//攻击目标范围
		private var m_targetBack:Panel;
		
		public function UIRecruitHero(mgr:UIHintMgr) 
		{
			m_uiMgr = mgr;
			
			this.draggable = false;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.setSize(621,269);
			this.setPanelImageSkin("commoncontrol/panel/recruitnewhero/addwuback.png");
			
			initData();
			
			this.alignHorizontal = Component.RIGHT;
			this.alignVertial = Component.BOTTOM;
			this.marginRight = -30;
			this.marginBottom = 90;
		}
		
		private function initData():void
		{
			m_timer = new Timer(5000);
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			m_timer.repeatCount = 1;
			m_timer.start();
			
			m_wuHalfPanel = new Panel(this, 20, -40);
			
			m_clearAni = new AniPropertys();
			m_clearAni.sprite = this;
			m_clearAni.resetValues({alpha: 0});
			m_clearAni.duration = 1;
			m_clearAni.onEnd = clearAniEnd;
			
			m_tf = new TextNoScroll();
			m_tf.mouseEnabled = true;
			this.addChild(m_tf);
			m_tf.width = 350;
			m_tf.x = 280;
			m_tf.y = 80;
			m_tf.setCSS("body", { leading:3, color:"#fbdda2" } );
			
			var panel:Panel;
			
			panel = new Panel(this, 298, 0);
			panel.setPanelImageSkin("commoncontrol/panel/recruitnewhero/wujoin.png");
			
			m_arPanel = new Panel(this, 280, 120);
			
			m_attackRange = new Label(this, 320, 160, "", UtilColor.WHITE_Yellow);
			m_attackRange.mouseEnabled = true;
			
			m_targetBack = new Panel(this, 430, 115);
			m_targetBack.setPanelImageSkin("commoncontrol/panel/recruitnewhero/targetback.png");
		}
		
		override protected function onAllImageLoaded(e:UIEvent):void 
		{
			super.onAllImageLoaded(e);
			
			m_aniPos = new AniPosition();
			m_aniPos.sprite = this;
			m_aniPos.duration = 0.8;
			m_aniPos.setEndPos(this.x, this.y);
			m_aniPos.setBeginPos(this.x + this.width + this._marginRight, this.y);
			m_aniPos.begin();
		}
		override public function onReady():void 
		{
			super.onReady();
			this.showOnAllImageLoaded();
		}		
		
		public function addWuHero(wu:WuHeroProperty):void
		{
			m_wu = wu;
			m_wuHalfPanel.setPanelImageSkin(m_wu.halfingPathName);
			
			var str:String = "";
			UtilHtml.beginCompose();
			UtilHtml.add(m_wu.fullName, m_wu.colorValue, 14);
			UtilHtml.addStringNoFormat(" 加入你的部队，实力大增。");
			str = UtilHtml.getComposedContent();
			m_tf.htmlText = "<body>" + str + "</body>";
			
			setAttackRange(m_wu.m_wuPropertyBase.m_attackRange);
		}
		
		private function setAttackRange(attackrange:AttackRange):void
		{
			var panel:Panel;
			var colorstr:String;
			var i:int;
			
			m_attackRange.text = AttackRange.getRangeStr(attackrange.m_range) + AttackRange.getTypeStr(attackrange.m_type);
			
			if (AttackRange.ASSIST == attackrange.m_type)
			{
				m_arPanel.setPanelImageSkin("commoncontrol/panel/recruitnewhero/assistrange.png");
				colorstr = "blue";
			}
			else
			{
				m_arPanel.setPanelImageSkin("commoncontrol/panel/recruitnewhero/attackrange.png");
				colorstr = "orange";
			}
			
			if (AttackRange.ATTACKTYPE_Dan == attackrange.m_range)
			{
				panel = new Panel(m_targetBack, 3, 27);
				panel.setPanelImageSkin("commoncontrol/panel/recruitnewhero/target2" + colorstr + ".png");
			}
			else if (AttackRange.ATTACKTYPE_Qian == attackrange.m_range)
			{
				panel = new Panel(m_targetBack, 3, 4);
				panel.setPanelImageSkin("commoncontrol/panel/recruitnewhero/target1" + colorstr + ".png");
			}
			else if (AttackRange.ATTACKTYPE_Zhong == attackrange.m_range)
			{
				panel = new Panel(m_targetBack, 27, 4);
				panel.setPanelImageSkin("commoncontrol/panel/recruitnewhero/target1" + colorstr + ".png");
			}
			else if (AttackRange.ATTACKTYPE_Hou == attackrange.m_range)
			{
				panel = new Panel(m_targetBack, 50, 4);
				panel.setPanelImageSkin("commoncontrol/panel/recruitnewhero/target1" + colorstr + ".png");
			}
			else if (AttackRange.ATTACKTYPE_Zhixian == attackrange.m_range)
			{
				panel = new Panel(m_targetBack, 3, 27);
				panel.setPanelImageSkinMirror("commoncontrol/panel/recruitnewhero/target1" + colorstr + ".png", Image.MirrorMode_ClockwiseRotation90);
			}
			else if (AttackRange.ATTACKTYPE_Shizi == attackrange.m_range)
			{
				panel = new Panel(m_targetBack, 27, 4);
				panel.setPanelImageSkin("commoncontrol/panel/recruitnewhero/target1" + colorstr + ".png");
				panel = new Panel(m_targetBack, 3, 27);
				panel.setPanelImageSkinMirror("commoncontrol/panel/recruitnewhero/target1" + colorstr + ".png", Image.MirrorMode_ClockwiseRotation90);
			}
			else if (AttackRange.ATTACKTYPE_Quan == attackrange.m_range)
			{
				for (i = 0; i < 3; i++)
				{
					panel = new Panel(m_targetBack, 3 + i * 24, 3);
					panel.setPanelImageSkin("commoncontrol/panel/recruitnewhero/target1" + colorstr + ".png");
				}
				
				for (i = 0; i < 3; i++)
				{
					panel = new Panel(m_targetBack, 3, 4 + i * 23);
					panel.setPanelImageSkinMirror("commoncontrol/panel/recruitnewhero/target1" + colorstr + ".png", Image.MirrorMode_ClockwiseRotation90);
				}
			}
			
		}
		
		override public function onDestroy():void 
		{
			super.onDestroy();
			
			m_uiMgr.onUIHintDestroy(this);
			
			if(m_timer)
			{
				m_timer.stop();
				m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
				m_timer = null;
			}
		}
		
		private function onTimer(e:TimerEvent):void
		{
			m_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			
			m_clearAni.begin();
		}
		
		private function clearAniEnd():void
		{
			m_clearAni.dispose();
			m_clearAni = null;
			
			this.exit();
		}
		
		override public function dispose():void
		{
			if (m_clearAni)
			{
				m_clearAni.dispose();
				m_clearAni = null;
			}
			
			if (m_aniPos)
			{
				m_aniPos.dispose();
				m_aniPos = null;
			}
			
			super.dispose();
		}
	}

}