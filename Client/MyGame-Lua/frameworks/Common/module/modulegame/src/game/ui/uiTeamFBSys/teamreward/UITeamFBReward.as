package game.ui.uiTeamFBSys.teamreward
{
	import com.ani.AniPropertys;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.gskinner.motion.easing.Linear;
	
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import ui.player.PlayerResMgr;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.FormStyleOne;
	import modulecommon.ui.UIFormID;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.msg.reqUserProfitGetExpUserCmd;
	import com.gskinner.motion.easing.Exponential;

	/**
	 * @brief 副本奖励
	 * */
	public class UITeamFBReward extends FormStyleOne
	{
		protected var m_pnlRoot:Panel;
		protected var m_pnlFlag:Panel;
		protected var m_lblExp:Label;
		protected var m_btnLQ:PushButton;	// 领取按钮
		
		protected var m_pnlGold1f:Panel;	// 顺利通关后面的光
		protected var m_aniRot1f:AniPropertys;	// 旋转特效
		protected var m_param1f:Number = 0;
		protected var m_pnlSLTG:Panel;		// 顺利通关
		
		protected var m_pnlGold2f:Panel;	// 角色后面的光
		protected var m_aniRot2f:AniPropertys;	// 旋转特效
		protected var m_param2f:Number = 0;
		protected var m_pnlRole:Panel;		// 角色
		
		protected var m_aniFlyLeft:AniPropertys;
		protected var m_aniFlyRight:AniPropertys;
		
		public var m_TFBSysData:UITFBSysData;
		
		public function UITeamFBReward()
		{
			this.id = UIFormID.UITeamFBReward;
		}
		
		override public function onReady():void
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			
			this.setSize(400, 350);
			this.setFormSkin("form1", 250);
			this.title = "领奖结算";
			
			m_pnlRoot = new Panel(this);
			m_pnlFlag = new Panel(m_pnlRoot);
			
			m_pnlGold1f = new Panel(this, 103, -211);
			m_pnlGold1f.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsysrd.wordgold");
			m_pnlSLTG = new Panel(this, 76, -76);
			m_pnlSLTG.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsysrd.tongguan");
			
			m_pnlGold2f = new Panel(this, -300, -120);
			m_pnlGold2f.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsysrd.rolegold");
			m_pnlRole = new Panel(this, -340, -120);
			m_pnlRole.setPanelImageSkin(m_gkcontext.m_context.m_playerResMgr.roundHeadPathName(m_gkcontext.playerMain.job, m_gkcontext.playerMain.gender, PlayerResMgr.HDHeroHalf1f));
			
			m_lblExp = new Label(m_pnlRoot, 340, 240, "经验奖励: " + m_TFBSysData.m_exp +　"", 0xff0000);
			
			m_btnLQ = new PushButton(this, 330, 270, onBtnClkLQ);
			m_btnLQ.setSkinButton1ImageBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsysrd.btn");
			
			m_aniRot1f = new AniPropertys();
			m_aniRot1f.duration = 180;
			m_aniRot1f.repeatCount = uint.MAX_VALUE;
			m_aniRot1f.ease = Linear.easeNone;
			
			m_aniRot1f.resetValues({param1f:360});
			m_aniRot1f.sprite = this;
			//m_aniRot1f.onEnd = onAniRot1f;
			//m_aniRot1f.begin();
			
			m_aniRot2f = new AniPropertys();
			m_aniRot2f.duration = 180;
			m_aniRot2f.repeatCount = uint.MAX_VALUE;
			m_aniRot2f.ease = Linear.easeNone;
			
			m_aniRot2f.resetValues({param2f:360});
			m_aniRot2f.sprite = this;
			//m_aniRot2f.onEnd = onAniRot2f;
			//m_aniRot2f.begin();
			
			m_aniFlyLeft = new AniPropertys();
			m_aniFlyLeft.duration = 0.5;
			m_aniFlyLeft.repeatCount = 1;
			m_aniFlyLeft.ease = Exponential.easeIn;
			
			m_pnlRole.x = -1000;
			m_aniFlyLeft.resetValues({x:-340});
			m_aniFlyLeft.sprite = m_pnlRole;
			m_aniFlyLeft.onEnd = onAniFlyLeft;
			m_aniFlyLeft.begin();
			
			m_aniFlyRight = new AniPropertys();
			m_aniFlyRight.duration = 0.5;
			m_aniFlyRight.repeatCount = 1;
			m_aniFlyRight.ease = Exponential.easeIn;
			
			m_pnlSLTG.x = 1000;
			m_aniFlyRight.resetValues({x:76});
			m_aniFlyRight.sprite = m_pnlSLTG;
			m_aniFlyRight.onEnd = onAniFlyRight;
			m_aniFlyRight.begin();
		}
		
		override public function onShow():void
		{
			super.onShow();
			if(m_TFBSysData.m_gkcontext.m_teamFBSys.buseNum)
			{
				 //m_btnLQ.label = "离开";
			}
			else
			{
				//m_btnLQ.label = "领取奖励";
			}
		}
		
		override public function dispose():void
		{
			if(m_aniRot1f)
			{
				m_aniRot1f.dispose();
				m_aniRot1f = null;
			}
			
			if(m_aniRot2f)
			{
				m_aniRot2f.dispose();
				m_aniRot2f = null;
			}
			
			if(m_aniFlyRight)
			{
				m_aniFlyRight.dispose();
				m_aniFlyRight = null;				
			}
			
			if(m_aniFlyLeft)
			{
				m_aniFlyLeft.dispose();
				m_aniFlyLeft = null;				
			}
			
			super.dispose();
		}
		
		private function onBtnClkLQ(event:MouseEvent):void
		{
			if(m_TFBSysData.m_gkcontext.m_teamFBSys.buseNum)
			{
				// 直接关闭
				exit();
			}
			else
			{
				// 需要通知服务器使用奖励次数
				UtilHtml.beginCompose();
				UtilHtml.add("当前副本您还未使用今日领奖次数，请问您要使用吗?\n    今日领奖次数:" + m_TFBSysData.m_usecnt + "/2", UtilColor.WHITE_Yellow, 14);
				m_TFBSysData.m_gkcontext.m_confirmDlgMgr.showMode1(m_TFBSysData.m_form.id, UtilHtml.getComposedContent(), OkCB, CancleCB, "直接离开", " 使用奖励次数");
			}
		}
		
		private function OkCB():Boolean
		{
			exit();
			return true;
		}
		
		private function CancleCB():Boolean
		{
			var cmd:reqUserProfitGetExpUserCmd = new reqUserProfitGetExpUserCmd();
			m_TFBSysData.m_gkcontext.sendMsg(cmd);
			
			exit();
			return true;
		}
		
		override public function exit():void
		{
			m_TFBSysData.m_onUIClose(this.id);
			super.exit();
		}
		
		/*
		protected function onAniRot1f():void
		{
			
		}
		
		protected function onAniRot2f():void
		{
			
		}
		*/
		
		public function get param1f():Number
		{
			return m_param1f;
		}
		
		public function set param1f(t:Number):void
		{
			m_param1f = t;
			var mat:Matrix = m_pnlGold1f.transform.matrix;
			mat.identity();
			mat.translate(-m_pnlGold1f.width/2, -m_pnlGold1f.height/2);
			mat.rotate(m_param1f);
			mat.translate(m_pnlGold1f.width/2, m_pnlGold1f.height/2);
			mat.translate(103, -211);
			m_pnlGold1f.transform.matrix = mat;
		}
		
		
		public function get param2f():Number
		{
			return m_param2f;
		}
		
		public function set param2f(t:Number):void
		{
			m_param2f = t;
			var mat:Matrix = m_pnlGold2f.transform.matrix;
			mat.identity();
			mat.translate(-m_pnlGold2f.width/2, -m_pnlGold2f.height/2);
			mat.rotate(m_param2f);
			mat.translate(m_pnlGold2f.width/2, m_pnlGold2f.height/2);
			mat.translate(-300, -120);
			m_pnlGold2f.transform.matrix = mat;
		}
		
		protected function onAniFlyLeft():void
		{
			m_aniRot2f.begin();
		}
		
		protected function onAniFlyRight():void
		{
			m_aniRot1f.begin();
		}
	}
}