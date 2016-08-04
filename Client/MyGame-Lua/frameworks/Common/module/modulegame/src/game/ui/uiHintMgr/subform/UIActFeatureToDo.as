package game.ui.uiHintMgr.subform 
{
	import com.bit101.components.Panel;
	import flash.events.MouseEvent;
	import modulecommon.commonfuntion.HintMgr;
	import modulecommon.net.msg.copyUserCmd.stReqCreateCopyUserCmd;
	import com.util.UtilHtml;
	import game.ui.uiHintMgr.UIHintMgr;
	/**
	 * ...
	 * @author ...
	 * 活动开始：军团争霸、三国战场、世界BOSS、军团烤火
	 */
	public class UIActFeatureToDo extends UIHint
	{
		private var m_iconPanel:Panel;
		private var m_actFuncType:int;		//活动功能类型
		
		public function UIActFeatureToDo(mgr:UIHintMgr) 
		{
			super(mgr);
		}
		
		override public function onReady():void 
		{
			super.onReady();
			
			m_timer.reset();
			m_timer.delay = 600000;	//10分钟
			m_timer.start();
			
			m_tf.width = 135;
			m_tf.x = 100;
			
			m_iconPanel = new Panel(this, 20, 28);
		}
		
		public function addDesc(type:int):void
		{
			m_actFuncType = type;
			
			var image:String;
			var desc:String;
			
			switch(m_actFuncType)
			{
				case HintMgr.ACTFUNC_CITYBATTLE:
					image = "corpscitysys1f";
					break;
				case HintMgr.ACTFUNC_SANGUOZHANCHANG:
					image = "sanguozhanchang";
					break;
				case HintMgr.ACTFUNC_WORLDBOSS:
					image = "shijieboss";
					break;
				case HintMgr.ACTFUNC_CORPSFIRE:
					image = "juntuankaohuo";
					break;
				case HintMgr.ACTFUNC_CORPSTREASURE:
					image = "corpstreasure";
					break;
				default:
					image = "";
			}
			m_iconPanel.setPanelImageSkin("screenbtn/" + image + ".png");
			
			desc = m_gkcontext.m_hintMgr.getActFuncDesc(m_actFuncType);
			if (null == desc)
			{
				desc = "活动开始啦 ！！！";
			}
			
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat(desc);
			this.setText(UtilHtml.getComposedContent());
			m_funBtn.label = "立刻加入";
		}
		
		override protected function onFunBtnClick(event:MouseEvent):void 
		{
			var str:String;
			switch(m_actFuncType)
			{
				case HintMgr.ACTFUNC_CITYBATTLE:
					if(m_gkcontext.m_corpsMgr.m_reg)
					{
						var cmdCCS:stReqCreateCopyUserCmd = new stReqCreateCopyUserCmd();
						cmdCCS.copyid = stReqCreateCopyUserCmd.COPYID_CorpsCitySys;
						m_gkcontext.sendMsg(cmdCCS);
					}
					else
					{
						m_gkcontext.m_systemPrompt.prompt("本团未报名，请团长或副团明日报名后再参战");
					}
					break;
				case HintMgr.ACTFUNC_SANGUOZHANCHANG:
					var cmdSGZC:stReqCreateCopyUserCmd = new stReqCreateCopyUserCmd();
					cmdSGZC.copyid = stReqCreateCopyUserCmd.COPYID_SanguoZhanchang;
					m_gkcontext.sendMsg(cmdSGZC);
					break;
				case HintMgr.ACTFUNC_WORLDBOSS:
					m_gkcontext.m_worldBossMgr.reqEnterWorldBoss();
					break;
				case HintMgr.ACTFUNC_CORPSFIRE:
					m_gkcontext.m_corpsMgr.onConfirmFun();
					break;
				case HintMgr.ACTFUNC_CORPSTREASURE:
					m_gkcontext.m_CorpsDuobaoMgr.reqIntoCorpsTreasure();
					break;
			}
			
			exit();
		}
	}

}