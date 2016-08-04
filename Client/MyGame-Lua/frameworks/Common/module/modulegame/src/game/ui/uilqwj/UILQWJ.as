package game.ui.uilqwj
{	
	import com.bit101.components.AniZoom;
	import com.bit101.components.ButtonText;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.pblabs.engine.entity.EntityCValue;
	import flash.events.MouseEvent;
	import game.ui.uilqwj.msg.stReqQuickCoolOnlineGiftCmd;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.net.msg.giftCmd.reqGetOnlineGiftUserCmd;
	import com.util.UtilColor;
	import com.util.UtilTools;
	import modulecommon.ui.Form;
	import modulecommon.uiinterface.IUILQWJ;
	import modulecommon.ui.UIFormID;
	
	/**
	 * @brief 领取武将
	 */
	public class UILQWJ extends Form implements IUILQWJ
	{
		protected var m_id:uint;	// 武将的 id
		protected var m_pnlBG:Panel;	// 背景面板
		protected var _exitBtn:PushButton;
		protected var m_pnlAni:AniZoom;	// 这个图片要做动画
		protected var m_btnLQ:PushButton;	// 领取按钮
		protected var m_btnSpeed:PushButton;	// 加速按钮
		//private var m_zhanliDC:DigitComponent;
		protected var m_TimeLable:Label;
		
		public function UILQWJ()
		{
			this.id = UIFormID.UILQWJ;
		}
		
		override public function onReady():void
		{
			super.onReady();
			this.setSize(900, 530);
			//this.setFormSkin("form1", 250);
			//this.title = "武将领取";
			
			m_pnlBG = new Panel(this);
			this.addBackgroundChild(m_pnlBG);
			
			_exitBtn = new PushButton(this, 837, 88);
			_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
			
			m_pnlAni = new AniZoom(this, 340 + 253, 280 + 59);
			//m_pnlAni.setImageAni("module/lqwj/roudun.png");
			m_pnlAni.setParam(0.9, 1.1, 11, 253, 59, true);
			m_pnlAni.begin();
			
			m_btnLQ = new PushButton(this, 678, 412, onBtnLQ);
			m_btnLQ.setPanelImageSkin("module/lqwj/uilqwjbtn.swf");
			
			// 加速
			m_btnSpeed = new ButtonText(this, 638, 234, "加速", onBtnSpeed);
			m_btnSpeed.setSkinButton1Image("commoncontrol/button/redbtn.png");
			
			//m_zhanliDC = new DigitComponent(m_gkcontext.m_context, this, 554, 240);
			//m_zhanliDC.setParam("commoncontrol/digit/digit01", 10, 18);
			//m_zhanliDC.digit = 123689;
			
			m_TimeLable = new Label(this, 554, 240, "00000", UtilColor.GREEN, 16);
			
			//setData(EntityCValue.NPCBattleWUJIANG2f);
		}
		
		override public function onShow():void
		{
			super.onShow();
			
			if (m_gkcontext.m_giftPackMgr.lastTime <= 0)	// 如果没有倒计时
			{
				m_btnLQ.visible = true;
				m_TimeLable.visible = false;
			}
			else
			{
				m_btnLQ.visible = false;
				m_TimeLable.visible = true;				
			}
		}
		
		public function setData(wuID:uint):void
		{
			m_id = wuID;

			if (EntityCValue.NPCBattleWUJIANG == m_id)	// 张辽
			{
				m_pnlBG.setPanelImageSkin("module/lqwj/zhangliao.png");
				m_pnlAni.setImageAni("module/lqwj/zhangliaodesc.png");
				
				m_btnLQ.setPos(678, 412);
				m_btnSpeed.setPos(638, 234);
				m_TimeLable.setPos(554, 240);
			}
			else if (EntityCValue.NPCBattleWUJIANG1f == m_id)	// 黄忠
			{
				m_pnlBG.setPanelImageSkin("module/lqwj/huangzhong.png");
				m_pnlAni.setImageAni("module/lqwj/huangzhongdesc.png");
				
				m_btnLQ.setPos(678, 412 + 8);
				m_btnSpeed.setPos(638, 234 + 8);
				m_TimeLable.setPos(554, 240 + 8);
			}
			else if (EntityCValue.NPCBattleWUJIANG2f == m_id)	// 关羽
			{
				m_pnlBG.setPanelImageSkin("module/lqwj/guanyu.png");
				m_pnlAni.setImageAni("module/lqwj/guanyudesc.png");
				
				m_btnLQ.setPos(678 + 20, 412 - 4);
				m_btnSpeed.setPos(638 + 20, 234 - 4);
				m_TimeLable.setPos(554 + 20, 240 - 4);
			}
		}
		
		private function onBtnLQ(event:MouseEvent):void
		{
			var cmd:reqGetOnlineGiftUserCmd = new reqGetOnlineGiftUserCmd();
			cmd.id = m_gkcontext.m_giftPackMgr.id;
			m_gkcontext.sendMsg(cmd);
			this.exit();
		}
		
		public function updateTimeLabel(time:uint):void
		{
			m_TimeLable.text = UtilTools.formatTimeToString(time);
			
			if (time <= 0)	// 如果没有倒计时
			{
				m_btnLQ.visible = true;
				m_TimeLable.visible = false;
			}
			else if(!m_TimeLable.visible)
			{
				m_btnLQ.visible = false;
				m_TimeLable.visible = true;
			}
		}
		
		private function onBtnSpeed(event:MouseEvent):void
		{
			var t:int;
			if (m_gkcontext.m_giftPackMgr.lastTime % 60)
			{
				t = m_gkcontext.m_giftPackMgr.lastTime / 60 + 1;
			}
			else
			{
				t = m_gkcontext.m_giftPackMgr.lastTime / 60;
			}
			var str:String = "消除冷却需要消耗 " + t + " 元宝，确认消除冷却吗？";
			m_gkcontext.m_confirmDlgMgr.showMode1(UIFormID.UIDaoJiShiWuJiang, str, onConfirm, null);
		}
		
		private function onConfirm():Boolean
		{
			var cmd:stReqQuickCoolOnlineGiftCmd = new stReqQuickCoolOnlineGiftCmd();
			m_gkcontext.sendMsg(cmd);
			return true;
		}
	}
}