package game.ui.uiScreenBtn.subcom
{
	//import com.bit101.components.Label;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.copyUserCmd.stReqCreateCopyUserCmd;
	//import modulecommon.scene.prop.relation;
	//import modulecommon.scene.prop.relation.RelArmy;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUICorpsCitySys;

	/**
	 * @brief 军团城市系统
	 */
	public class CorpsCitySys extends FunBtnBase
	{
		//private var m_TimeLable:Label;
		
		public function CorpsCitySys(parent:DisplayObjectContainer=null)
		{
			super(ScreenBtnMgr.Btn_CorpsCitySys, parent);
			//m_TimeLable	= new Label(this, 15, 73, "00:00:00");		
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			//m_gkContext.m_corpsMgr.processNotifyCorpsNameUserCmd
			if(m_gkContext.m_corpsCitySys.inActive)	// 只有活动开始才能看到这个图标
			{
				if(m_gkContext.m_corpsMgr.m_reg)
				{
					var cmd:stReqCreateCopyUserCmd = new stReqCreateCopyUserCmd();
					cmd.copyid = stReqCreateCopyUserCmd.COPYID_CorpsCitySys;
					m_gkContext.sendMsg(cmd);
				}
				else
				{
					m_gkContext.m_systemPrompt.prompt("本团未报名，请团长或副团明日报名后再参战");
				}
				
				//m_gkContext.m_screenbtnMgr.moveToNpcOfCorpsCitySys();
				//hideEffectAni();
			}
			else if (m_gkContext.m_corpsMgr.m_reg)	// 活动没有开始已经报名
			{
				m_gkContext.m_systemPrompt.prompt("本团已经报名，请等待活动开始");
			}
			else if(m_gkContext.m_corpsMgr.isTuanzhangOrFuTuanzhang)	// 如果没有在活动期间，并且团长或者副团长没有报名，就弹出报名通知
			{
				var ui:IUICorpsCitySys = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
				if (ui && ui.bReady)
				{
					ui.psnotifyRegCorpsFightUserCmd(null);
				}
				else
				{
					m_gkContext.m_contentBuffer.addContent("notifyRegCorpsFightUserCmd", new ByteArray());
					m_gkContext.m_UIMgr.loadForm(UIFormID.UICorpsCitySys);
				}
			}
			else	// 团员或者没有入团
			{
				m_gkContext.m_systemPrompt.prompt("本团未报名，请团长或副团明日报名后再参战");
			}
		}
		
		override public function initData(fileName:String):void
		{
			super.initData(fileName);
		}
		
		/*
		public function updateTimeLabel(time:uint):void
		{
			if (time > 0)
			{
				// 如果不可见
				if (m_TimeLable.visible == false)
				{
					m_TimeLable.visible = true;
				}
				m_TimeLable.text = UtilTools.formatTimeToString(time);
				hideEffectAni();
			}
			else
			{
				m_TimeLable.visible = false;
				showEffectAni();
			}
		}
		*/
	}
}