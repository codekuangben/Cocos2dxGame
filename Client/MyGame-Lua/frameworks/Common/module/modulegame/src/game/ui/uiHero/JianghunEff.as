package game.ui.uiHero
{
	import com.bit101.components.Ani;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.util.DebugBox;
	//import com.dgrigg.image.Image;
	import com.gskinner.motion.GTween;
	//import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	//import flash.geom.Rectangle;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.BeingProp;
	import flash.events.MouseEvent;
	import com.util.UtilHtml;
	
	/**
	 * ...
	 * @author
	 */
	public class JianghunEff extends PanelContainer
	{
		private var m_gkContext:GkContext;
		private var m_zhuParent:Panel;
		private var m_jianghunAni:Ani;
		private var m_jianghunMask:Sprite;
		private var m_zhuMask:Sprite;
		private var m_longzhuFlowAni:Ani;
		private var m_manAni:Ani; //将魂满了之后，播放这个特效
		
		private var m_gtWeen:GTween;
		private var m_curJianghun:int;
		private var m_valueForNext:int;
		private var m_ratio:Number;
		
		public function JianghunEff(gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			//this.setPanelImageSkin("commoncontrol/panel/emptylongzhu.png")		
			m_ratio = 0;
			
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, 36, 36);
			graphics.endFill();
			
			m_zhuParent = new Panel(this);
			
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		public function updateJianghun():void
		{
			m_curJianghun = m_gkContext.m_beingProp.getMoney(BeingProp.JIANG_HUN);
			m_valueForNext = m_gkContext.m_xingmaiMgr.jianghunForNextAttr;
			DebugBox.addLog("将魂值刷新 当前值/下一个将激活值=" + m_curJianghun.toString() + "/" + m_valueForNext.toString());
			
			if (m_valueForNext == 0)
			{
				ratio = 1;
				return;
			}
			
			if (m_jianghunAni == null)
			{
				m_jianghunAni = new Ani(m_gkContext.m_context);
				m_jianghunAni.setImageAni("ezhuzi.swf");
				m_jianghunAni.duration = 1;
				m_jianghunAni.repeatCount = 0;
				m_jianghunAni.setAutoStopWhenHide();
				m_jianghunAni.begin();
				m_zhuParent.addChild(m_jianghunAni);
				
				m_zhuMask = new Sprite();
				m_zhuMask.x = -2;
				m_zhuMask.graphics.beginFill(0, 1);
				m_zhuMask.graphics.drawRect(0, 0, 36, 36);
				m_zhuMask.graphics.endFill();
				m_jianghunAni.addChild(m_zhuMask);
				m_jianghunAni.mask = m_zhuMask;
				
				m_jianghunMask = new Sprite();
				m_jianghunMask.y = 1;
				m_jianghunMask.graphics.beginFill(0, 1);
				m_jianghunMask.graphics.drawCircle(16, 17, 16);
				m_jianghunMask.graphics.endFill();
				m_zhuParent.addChild(m_jianghunMask);
				m_zhuParent.mask = m_jianghunMask;
				
				m_longzhuFlowAni = new Ani(m_gkContext.m_context);
				m_longzhuFlowAni.setImageAni("e405jiefeng.swf");
				m_longzhuFlowAni.duration = 1;
				m_longzhuFlowAni.repeatCount = 0;
				m_longzhuFlowAni.begin();
				m_zhuParent.addChild(m_longzhuFlowAni);
				
				m_gtWeen = new GTween(this);
				m_gtWeen.target = this;
				m_gtWeen.paused = true;
				m_gtWeen.repeatCount = 1;
				
			}
			
			var r:Number;
			if (-1 == m_valueForNext)
			{
				r = 1;
			}
			else
			{
				var a:int;
				if (m_curJianghun > m_valueForNext)
				{
					a = m_valueForNext;
				}
				else
				{
					a = m_curJianghun;
				}
				
				r = a / m_valueForNext;
			}
			
			m_gtWeen.resetValues({ratio: r});
			m_gtWeen.duration = Math.abs(r - this.ratio);
			m_gtWeen.paused = false;
			
			//如果ratio与r相等，补件引擎不会调用set ratio。需要手工方式调用
			if (ratio == r)
			{
				ratio = r;
			}
		}
		
		public function set ratio(r:Number):void
		{
			m_ratio = r;
			
			if (m_jianghunAni)
			{
				m_zhuMask.y = 36 - (36 - 2) * m_ratio;
				m_longzhuFlowAni.y = m_zhuMask.y - 15;
			}
			
			if (m_ratio == 1)
			{
				if (m_manAni == null)
				{
					m_manAni = new Ani(m_gkContext.m_context);
					m_manAni.centerPlay = true;
					m_manAni.x = 17;
					m_manAni.y = 16;
					m_manAni.setImageAni("e100manzhu.swf");
					m_manAni.duration = 2.5;
					m_manAni.repeatCount = 0;
					m_manAni.begin();
					addChild(m_manAni);
				}
				if (this.contains(m_manAni) == false)
				{
					addChild(m_manAni);
				}
				
				if (contains(m_zhuParent))
				{
					this.removeChild(m_zhuParent);
				}
			}
			else
			{
				if (m_manAni != null && contains(m_manAni))
				{
					this.removeChild(m_manAni);
				}
				
				if (contains(m_zhuParent) == false)
				{
					addChild(m_zhuParent);
				}
			}
		}
		
		public function get ratio():Number
		{
			return m_ratio;
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			m_gkContext.m_uiTip.hideTip();
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			var str:String = "将魂  " + m_curJianghun.toString() + " / ";
			if (-1 == m_valueForNext || 0 == m_valueForNext)
			{
				str += "max";
			}
			else
			{
				str += m_valueForNext.toString();
			}
			
			UtilHtml.beginCompose();
			UtilHtml.add(str, 0xfbdda2, 14);
			UtilHtml.breakline();
			UtilHtml.add("消耗将魂能够大量提升主角属性，日常关卡和竞技场大量产出将魂。", 0xfbdda2, 14);
			
			var pt:Point = this.localToScreen(new Point(36, 0));
			m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent());
		}
		
		override public function dispose():void
		{
			//执行父类dispose之前，m_zhuParent和m_manAni加到显示列表中
			if (contains(m_zhuParent) == false)
			{
				addChild(m_zhuParent);
			}
			if (m_manAni&& this.contains(m_manAni) == false)
			{
				addChild(m_manAni);
			}
			super.dispose();
		}
	}

}