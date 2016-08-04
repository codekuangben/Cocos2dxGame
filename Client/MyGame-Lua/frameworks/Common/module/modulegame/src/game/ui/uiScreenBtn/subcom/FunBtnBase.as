package game.ui.uiScreenBtn.subcom 
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.bit101.components.Ani;
	import com.bit101.components.ButtonAni;
	import com.bit101.components.Component;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.uiScreenBtn.moveAni.BtnHideMoveAni;
	import game.ui.uiScreenBtn.moveAni.BtnShowMoveAni;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import com.util.UtilColor;
	import game.ui.uiScreenBtn.UIScreenBtn;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	
	/**
	 * ...
	 * @author 
	 */
	public class FunBtnBase extends PanelContainer 
	{
		protected var m_id:int;
		protected var m_gkContext:GkContext;
		protected var m_btn:ButtonAni;
		protected var m_ui:UIScreenBtn;
		protected var m_effectAni:Ani;
		protected var m_bActing:Boolean;	// 有可领取奖励、或活动正在进行中
		protected var m_bNeedHide:Boolean;	// 在点击右侧“+”、“-”按钮时，是否收起隐藏
		protected var m_panel:Panel;		// 数字背景图
		protected var m_lblCnt:Label;		// 剩余宝箱个数
		protected var m_bShowBtn:Boolean;	// 该功能按钮是否显示(活动结束不需要再显示，如“扫荡”，领取奖励后，不再显示该按钮，此时m_bShowBtn=false)
		protected var m_btnHideMoveAni:BtnHideMoveAni;	//按钮收起隐藏动画
		protected var m_btnShowMoveAni:BtnShowMoveAni;	//按钮展开显示动画
		public var m_showPt:Point;
		
		public function FunBtnBase(id:int, parent:DisplayObjectContainer = null) 
		{
			m_id = id;
			super(parent);
			
			m_btn = new ButtonAni(this, 0, 0, onClick);
			m_btn.sizeAniCharge = ButtonAni.CHARGE_BIG;
			m_btn.m_musicType = PushButton.BNMOpen;
			
			m_bActing = false;
			m_bNeedHide = true;
			m_bShowBtn = true;
			
			m_showPt = new Point();
		}
		
		public function setGkUI(gk:GkContext, ui:UIScreenBtn):void
		{
			m_ui = ui;
			m_gkContext = gk;
		}
		
		public function initData(fileName:String):void
		{
			var str:String = "screenbtn/" + fileName +".png";
			m_btn.setSkinButton1Image(str);
		}
		
		public function onInit():void
		{
			
		}
		
		public function onClick(e:MouseEvent):void
		{
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_newHandMgr.hide();
			}
		}
		
		public function get id():int
		{
			return m_id;
		}
		
		public function get btn():ButtonAni
		{
			return m_btn;
		}
		
		public function get bActing():Boolean
		{
			return m_bActing;
		}
		
		public function get bNeedHide():Boolean
		{
			return m_bNeedHide;
		}
		
		public function get bShowBtn():Boolean
		{
			return m_bShowBtn;
		}
		
		public function set bShowBtn(bshow:Boolean):void
		{
			m_bShowBtn = bshow;
		}
		
		public function showEffectAni(path:String=null):void
		{
			if (null == m_effectAni)
			{
				m_effectAni = new Ani(m_gkContext.m_context);
				m_effectAni.centerPlay = true;
				m_effectAni.x = 37;
				m_effectAni.y = 44;
				if (path)
				{
					m_effectAni.setImageAni(path);
				}
				else
				{
					m_effectAni.setImageAni("ejhuodongjihuo.swf");
				}
				m_effectAni.duration = 1.5;
				m_effectAni.repeatCount = 0;
				m_effectAni.mouseEnabled = false;
			}
			m_effectAni.begin();
			
			if (!m_btn.contains(m_effectAni))
			{
				m_btn.addChild(m_effectAni);
			}
			
			m_bActing = true;
		}
		
		public function hideEffectAni():void
		{
			if (m_effectAni && m_btn.contains(m_effectAni))
			{
				m_btn.removeChild(m_effectAni);
				m_effectAni.stop();
			}
			
			m_bActing = false;
		}
		
		override public function dispose():void
		{
			if (m_effectAni && !m_btn.contains(m_effectAni))
			{
				m_effectAni.dispose();
			}
			
			if (m_btnHideMoveAni)
			{
				m_btnHideMoveAni.dispose();
			}
			
			m_bActing = false;
			
			super.dispose();
		}
		
		public function getCeneterPosInScreen():Point
		{
			return btn.localToScreen(new Point(btn.width / 2, btn.height / 2));
		}
		
		//按钮第一次显示时，提示特效
		public function setCreateBtnAni():void
		{
			var ani:Ani;
			ani = new Ani(m_gkContext.m_context);
			m_btn.addChild(ani);
			ani.centerPlay = true;
			ani.x = 41;
			ani.y = 41;
			ani.scaleX = 0.75;
			ani.scaleY = 0.75;
			ani.setImageAni("ejanniuhuodongchuxian.swf");
			ani.duration = 1.5;
			ani.repeatCount = 1;
			ani.mouseEnabled = false;
			ani.onCompleteFun = aniEnd;
			ani.begin();
		}
		
		private function aniEnd(ani:Ani):void
		{
			if (ani.parent)
			{
				ani.parent.removeChild(ani);
			}
			ani.dispose();
		}
		
		public function setLblCnt(num:uint, type:int = ScreenBtnMgr.LBLCNTBGTYPE_Red):void
		{
			if (null == m_panel)
			{
				m_panel = new Panel(m_btn, 50, 10);	
				
				m_panel.mouseEnabled = false;
				m_panel.visible = false;
				
				m_lblCnt = new Label(m_btn, 62, 15, "", UtilColor.WHITE);
				m_lblCnt.align = Component.CENTER;
			}
			
			if (ScreenBtnMgr.LBLCNTBGTYPE_Blue == type)
			{
				m_panel.setPanelImageSkin("commoncontrol/panel/numBg3.png");
				m_bActing = true;
			}
			else
			{
				m_panel.setPanelImageSkin("commoncontrol/panel/numBg2.png");
				m_bActing = false;
			}
			
			m_lblCnt.text = num.toString();
			if (num)
			{
				m_panel.visible = true;
				m_lblCnt.visible = true;
			}
			else
			{
				m_panel.visible = false;
				m_lblCnt.visible = false;
			}
		}
		
		//收起隐藏
		public function btnHideMove():void
		{
			if (null == m_ui.zoomBtn)
			{
				return;
			}
			
			if (null == m_btnHideMoveAni)
			{
				m_btnHideMoveAni = new BtnHideMoveAni();
				m_btnHideMoveAni.sprite = this;				
			}
			
			m_btnHideMoveAni.setDestPos(m_ui.zoomBtn.x, m_ui.zoomBtn.y);
			m_btnHideMoveAni.begin();
		}
		
		public function set funBtnHideMoveEndCallback(fun:Function):void
		{
			m_btnHideMoveAni.funEndCalback = fun;
		}
		
		//展开显示
		public function btnShowMove():void
		{
			if (null == m_ui.zoomBtn)
			{
				return;
			}
			
			if (null == m_btnShowMoveAni)
			{
				m_btnShowMoveAni = new BtnShowMoveAni();
				m_btnShowMoveAni.sprite = this;
			}
			
			m_btnShowMoveAni.setDestPos(m_showPt.x, m_showPt.y);
			m_btnShowMoveAni.begin();
		}
		
		public function set funBtnShowMoveEndCallback(fun:Function):void
		{
			m_btnShowMoveAni.funEndCalback = fun;
		}
		
	}

}