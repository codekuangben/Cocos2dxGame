package game.ui.tongquetai.backstage 
{
	import com.bit101.components.Component;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.progressBar.BarInProgress2;
	import flash.display.DisplayObjectContainer;
	import com.bit101.components.PushButton;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.events.Event;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.scene.tongquetai.DancingWuNv;

	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.tongquetai.NormalDancer;
	import com.util.UtilColor;
	import modulecommon.uiObject.UIMBeing;
	import modulecommon.GkContext;
	import modulecommon.scene.tongquetai.DancerBase
	import flash.events.MouseEvent;
	import com.pblabs.engine.entity.EntityCValue;
	import game.ui.tongquetai.msg.stReqBeginWuNvDancingUserCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MidPage extends Component 
	{		
		private var m_wuBeing:UIMBeing;
		private var m_text:Label;
		private var m_incomeText:Label;
		private var m_dancerBg:PanelContainer;
		private var m_banquetBtn:PushButton;
		private var m_haoganBar:BarInProgress2;
		private var m_haoganText:Label;
		private var m_needHaoganText:Label;	//当前舞女跳舞所需要的好感值
		private var m_gkContext:GkContext;
		private var m_curDancer:DancerBase;
		private var m_haoganBtn:PushButton;
		private var m_dancerPos:int;
		public function MidPage(gk:GkContext,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_dancerBg = new PanelContainer(this,-22,-7);
			m_text = new Label(this, -12, 392);
			m_text.setFontColor(UtilColor.WHITE_Yellow);
			m_incomeText = new Label(this, -12, 420);
			m_incomeText.setFontColor(UtilColor.WHITE_Yellow);
			m_banquetBtn = new PushButton(this, 116, 410, banquetClick);
			m_banquetBtn.setSkinButton1Image("commoncontrol/panel/tongquetai/banquetbtn.png");
			
			var panel:Panel = new Panel(this, -8, 363);
			panel.setPanelImageSkin("commoncontrol/panel/tongquetai/barbg.png");
			m_haoganBar = new BarInProgress2(this, panel.x, panel.y);
			m_haoganBar.setSize(231, 17);
			m_haoganBar.setPanelImageSkin("commoncontrol/panel/tongquetai/bar.png");
			m_haoganBar.maximum = 1;
			m_haoganText = new Label(this, m_haoganBar.x + 80, m_haoganBar.y -1);
			m_haoganText.setFontColor(UtilColor.WHITE_Yellow);
			/*m_haoganBtn = new PushButton(this, panel.x + 232, panel.y );
			m_haoganBtn.setSkinButton1Image("commoncontrol/panel/tongquetai/haoganbtn.png");*/
			
			m_needHaoganText = new Label(this, 126, 392);
			m_needHaoganText.setFontColor(UtilColor.GREEN);
			updateHaogan();
		}
		
		public function updateHaogan():void
		{
			var haogan:int = m_gkContext.m_beingProp.getMoney(BeingProp.MONEY_WUNV);
			m_haoganBar.initValue = haogan / m_gkContext.m_tongquetaiMgr.haoganUpperLimit;
			m_haoganText.text = "好感:"+haogan;
		}
		
		
		public function setDancer(dancer:DancerBase):void
		{
			if (m_curDancer == dancer)
			{
				return;
			}
			m_curDancer = dancer;		
			
			var str:String;
			if (dancer.m_outputtype == BeingProp.SILVER_COIN)
			{
				str = "银币";
			}
			else if(dancer.m_outputtype == -1)
			{
				str = "经验";
			}
			else if (dancer.m_outputtype == BeingProp.JIANG_HUN)
			{
				str = "将魂";
			}
			else if (dancer.m_outputtype == BeingProp.GREEN_SHENHUN)
			{
				str = "绿色神魂";
			}
			else if (dancer.m_outputtype == BeingProp.BLUE_SHENHUN)
			{
				str = "蓝色神魂";
			}
			m_text.text = "持续跳舞 " + Math.floor(dancer.m_worktime/3600) + " 小时";
			
			m_incomeText.text = "收益 " + dancer.m_outputvalue + " " + str;
			if (m_curDancer.isNormal)
			{
				m_needHaoganText.text = "需要好感：" + (m_curDancer as NormalDancer).m_haogan;
				m_needHaoganText.visible = true;
			}
			else
			{
				m_needHaoganText.visible = false;
			}
			
			var bgname:String;
			if (dancer.m_worktime == 1)
			{
				bgname = "bg_a";
			}
			else if (dancer.m_worktime == 4)
			{
				bgname = "bg_b";
			}
			else
			{
				bgname = "bg_c";
			}
			m_dancerBg.setPanelImageSkin("commoncontrol/panel/tongquetai/" + bgname + ".png");
			if (m_wuBeing)
			{
				m_wuBeing.offawayContainerParent();
			}
			m_wuBeing = m_gkContext.m_context.m_uiObjMgr.createUIObject("tongquetai.backstage_MidPage" + dancer.m_id.toString(), dancer.m_model, UIMBeing) as UIMBeing;
			m_wuBeing.state = EntityCValue.TActStand;
			m_wuBeing.definition.dicAction[0].framerate = 8;
			//m_wuBeing.definition.dicAction[7].repeat = true;
			//m_wuBeing.definition.dicAction[7].framerate = 3;
			m_wuBeing.changeContainerParent(m_dancerBg);
			m_wuBeing.moveTo(126, 164, 0);
		}	
		
		public function banquetClick(e:MouseEvent):void
		{
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_newHandMgr.hide();
			}
			
			if (m_gkContext.m_tongquetaiMgr.getNumOfDancing()==3)
			{
				m_gkContext.m_systemPrompt.prompt("美女们跳舞的空间不够了亲!");
				return;
			}
			if (m_curDancer == null)
			{
				m_gkContext.m_systemPrompt.promptOnTopOfMousePos("先选中1个舞女！", UtilColor.RED);
				return;
			}
			
			if (m_curDancer.isNormal)
			{
				if ((m_curDancer as NormalDancer).m_haogan > m_gkContext.m_beingProp.getMoney(BeingProp.MONEY_WUNV))
				{
					m_gkContext.m_systemPrompt.promptOnTopOfMousePos("好感不够了", UtilColor.RED);
					return;
				}
			}
			var dancing:DancingWuNv = m_gkContext.m_tongquetaiMgr.getDancingByPos(m_dancerPos);
			if (dancing)
			{
				var i:int;
				for (i = 0; i < 3; i++)
				{
					if (m_gkContext.m_tongquetaiMgr.getDancingByPos(i) == null)
					{
						m_dancerPos = i;
						break;
					}
				}
				
			}
			var send:stReqBeginWuNvDancingUserCmd = new stReqBeginWuNvDancingUserCmd();
			send.m_id = m_curDancer.m_id;
			send.m_pos = m_dancerPos;
			m_gkContext.sendMsg(send);
		}
		
		public function setDancerPos(pos:int):void
		{
			m_dancerPos = pos;
		}
		
		public function getCunDancerID():int
		{
			if (m_curDancer)
			{
				return m_curDancer.m_id;
			}
			return 0;
		}
		
		//新手引导指向“宴客”按钮
		public function showNewHandToBanquetBtn():void
		{
			if (m_gkContext.m_newHandMgr.isVisible() && SysNewFeatures.NFT_TONGQUETAI == m_gkContext.m_sysnewfeatures.m_nft)
			{
				m_gkContext.m_newHandMgr.setFocusFrame(-10, -10, 124, 58, 1);
				m_gkContext.m_newHandMgr.prompt(false, 90, 48, "点击“宴客”，舞女开始舞蹈。", m_banquetBtn);
			}
		}
	}

}