package game.ui.uiXingMai.subcom 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.util.DebugBox;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.net.msg.xingMaiCmd.stLevelUpXMAttrXMCmd;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.xingmai.AttrData;
	import modulecommon.scene.xingmai.XingmaiMgr;
	import game.ui.uiXingMai.tip.TipAttr;
	import game.ui.uiXingMai.UIXingMai;
	/**
	 * ...
	 * @author ...
	 * 属性图标显示
	 */
	public class AttrItem extends Component
	{
		private var m_gkContext:GkContext;
		private var m_uiXingmai:UIXingMai;
		private var m_iconPanel:Panel;
		private var m_attrLevel:Label;
		private var m_attrData:AttrData;
		private var m_tipAttr:TipAttr;		//tips显示
		private var m_levelUpAni:Ani;
		private var m_bAniEnd:Boolean = true;		//特效是否播放结束
		private var m_circleAni:Ani;				//属性等级可提升特效
		
		public function AttrItem(gk:GkContext, ui:UIXingMai, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_uiXingmai = ui;
			
			var panel:Panel;
			panel = new Panel(this, -9, -9);
			panel.setPanelImageSkin("commoncontrol/panel/xingmai/attricon/iconbg.png");
			
			m_iconPanel = new Panel(this, 0, 0);
			
			panel = new Panel(this, 50, 45);
			panel.setPanelImageSkin( "commoncontrol/panel/xingmai/levelbg.png");
			
			m_attrLevel = new Label(this, 63, 50);
			m_attrLevel.align = Component.CENTER;
			
			this.setSize(64, 64);
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);
		}
		
		public function setData(attr:AttrData):void
		{
			m_attrData = attr;
			
			m_iconPanel.setPanelImageSkin("commoncontrol/panel/xingmai/attricon/attr_" + m_attrData.m_id.toString()+".png");
			m_attrLevel.text = m_attrData.m_level.toString();
		}
		
		public function updateData():void
		{
			var bcircleani:Boolean;
			if (needJiangHun > m_gkContext.m_beingProp.getMoney(BeingProp.JIANG_HUN))
			{
				bcircleani = false;
			}
			else
			{
				bcircleani = true;
			}
			
			showCircleAni(bcircleani);
		}
		
		public function updateLevel():void
		{
			m_attrLevel.text = m_attrData.m_level.toString();
			//播放升级特效
			
			if (null == m_levelUpAni)
			{
				m_levelUpAni = new Ani(m_gkContext.m_context);
				m_levelUpAni.duration = 0.6;
				m_levelUpAni.repeatCount = 1;
				m_levelUpAni.setImageAni("ejkaijuntunabaoxiang.swf");
				m_levelUpAni.centerPlay = true;
				m_levelUpAni.mouseEnabled = false;
				m_levelUpAni.onCompleteFun = onLevelUpAniEnd;
			}
			m_levelUpAni.x = 31;
			m_levelUpAni.y = 31;
			this.addChild(m_levelUpAni);
			m_levelUpAni.begin();
			
			m_bAniEnd = false;
		}
		
		private function onLevelUpAniEnd(ani:Ani):void
		{
			m_bAniEnd = true;
			
			if(m_levelUpAni)
			{
				if (this.contains(m_levelUpAni))
				{
					this.removeChild(m_levelUpAni);
				}
				m_levelUpAni.dispose();
				m_levelUpAni = null;
			}
		}
		
		//属性等级可提升时，显示特效
		public function showCircleAni(bool:Boolean):void
		{
			if (bool)
			{
				if (null == m_circleAni)
				{
					m_circleAni = new Ani(m_gkContext.m_context);
					m_circleAni.scaleX = 1.2;
					m_circleAni.scaleY = 1.2;
					m_circleAni.duration = 0.8;
					m_circleAni.repeatCount = 0;
					m_circleAni.setImageAni("ejhuodongxiaojihuo.swf");
					m_circleAni.centerPlay = true;
					m_circleAni.mouseEnabled = false;
				}
				m_circleAni.x = 31;
				m_circleAni.y = 34;
				this.addChild(m_circleAni);
				m_circleAni.begin();
			}
			else
			{
				if (m_circleAni && this.contains(m_circleAni))
				{
					this.removeChild(m_circleAni);
					m_circleAni.stop();
				}
			}
		}
		
		private function onClick(event:MouseEvent):void
		{
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_newHandMgr.hide();
			}
			
			if (m_bAniEnd)
			{
				var cmd:stLevelUpXMAttrXMCmd = new stLevelUpXMAttrXMCmd();
				cmd.m_attrno = m_attrData.m_id;
				m_gkContext.sendMsg(cmd);
				DebugBox.addLog("觉醒属性：" + TipAttr.propName(m_attrData.m_id) + "(" + m_attrData.m_id + ")  请求升级" );
			}
		}
		
		private function onMouseRollOver(event:MouseEvent):void
		{
			var pt:Point;
			if (null == m_tipAttr)
			{
				m_tipAttr = new TipAttr(m_gkContext);
			}
			
			m_tipAttr.showTip(m_attrData);
			pt = this.localToScreen(new Point(80, 0));
			m_gkContext.m_uiTip.hintComponent(pt, m_tipAttr);
		}
		
		//编号
		public function get id():uint
		{
			return m_attrData.m_id;
		}
		
		//属性升级所需将魂值
		public function get needJiangHun():uint
		{
			return (XingmaiMgr.getPayValue(m_attrData.m_level + 1));
		}
		
		override public function dispose():void
		{
			if (m_tipAttr)
			{
				m_tipAttr.dispose();
			}
			
			if(m_levelUpAni && !this.contains(m_levelUpAni))
			{
				m_levelUpAni.dispose();
				m_levelUpAni = null;
			}
			
			if(m_circleAni && !this.contains(m_circleAni))
			{
				m_circleAni.dispose();
				m_circleAni = null;
			}
			
			super.dispose();
		}
	}

}