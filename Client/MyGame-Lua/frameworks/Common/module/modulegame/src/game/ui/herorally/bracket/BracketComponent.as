package game.ui.herorally.bracket 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.Label;
	import com.bit101.components.pageturn.PageTurn2;
	import com.bit101.components.Panel;
	import com.bit101.components.TextNoScroll;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import game.ui.herorally.msg.QYHRankItem;
	import game.ui.herorally.msg.stReqQunYingHuiRankCmd;
	import game.ui.herorally.msg.stRetQunYingHuiRankCmd;
	import modulecommon.GkContext;
	import modulecommon.scene.herorally.groupInfo;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class BracketComponent extends Component 
	{
		private var m_list:ControlListVHeight;
		private var m_myRankLabel:Label;
		private var m_rank:Label;
		private var m_myScoreLabel:Label;
		private var m_score:Label;
		private var m_myGroupLabel:Label;
		private var m_listTittle:Panel;
		private var m_pageBtn:PageTurn2;
		private var m_ruleText:TextNoScroll;
		private var m_gkcontext:GkContext;
		public var m_curGroupInfo:groupInfo;
		private var m_grouparr:Array;
		public function BracketComponent(gk:GkContext,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			setPanelImageSkin("commoncontrol/panel/herorally/bracketbg.png");
			setSize(280, 400);
			m_gkcontext = gk;
			m_myRankLabel = new Label(this, 21, 106, "我的排名：", UtilColor.WHITE_Yellow);
			m_myRankLabel.setLetterSpacing(1);
			m_rank = new Label(this, 85, 107);
			m_myScoreLabel = new Label(this, 163, 106, "我的积分：", UtilColor.WHITE_Yellow);
			m_myScoreLabel.setLetterSpacing(1);
			m_score = new Label(this, 224, 107);
			m_listTittle = new Panel(this, 9, 129);
			m_listTittle.setPanelImageSkin("commoncontrol/panel/herorally/listtittle.png");
			m_myGroupLabel = new Label(this, 131, 81, "", UtilColor.YELLOW, 14);
			m_myGroupLabel.align = CENTER;
			m_list = new ControlListVHeight(this, 0, 153);
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			param.m_class = RankItem;
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkcontext;
			dataParam["parent"] = this;
			param.m_dataParam = dataParam;
			param.m_width = 244;
			param.m_height = 28;
			param.m_marginLeft = 5;
			param.m_marginRight = 5;
			param.m_heightList = 168;
			param.m_lineSize = param.m_heightList;
			param.m_scrollType = 0;
			param.m_bCreateScrollBar = true;
			m_list.setParam(param);
			
			m_ruleText = new TextNoScroll(this, 35, 328);
			m_ruleText.width = 216;
			m_ruleText.textColor = UtilColor.WHITE_Yellow;
			var textFormat:TextFormat = new TextFormat();
			textFormat.leading = 4;
			textFormat.letterSpacing = 1;
			m_ruleText.defaultTextFormat = textFormat;
			m_ruleText.text = m_gkcontext.m_heroRallyMgr.rule;
			
			m_pageBtn = new PageTurn2(this, 70, 80);
			m_pageBtn.setBtnPos(0, 0, 114, 0);
			m_pageBtn.setParam(onPageTurn);	
			m_pageBtn.setBtnNameHorizontal_Mirror("leftArrow2.swf");
			m_pageBtn.setTurnState(false, false);
			m_grouparr = m_gkcontext.m_heroRallyMgr.grouparr;
		}
		private function onPageTurn(pre:Boolean):void
		{
			if (pre)
			{
				var id:uint = m_grouparr[m_grouparr.indexOf(m_curGroupInfo.m_id) - 1];
				var send:stReqQunYingHuiRankCmd = new stReqQunYingHuiRankCmd();
				send.m_rankNo = id;
				m_gkcontext.sendMsg(send);
			}
			else
			{
				id = m_grouparr[m_grouparr.indexOf(m_curGroupInfo.m_id) + 1];
				send = new stReqQunYingHuiRankCmd();
				send.m_rankNo = id;
				m_gkcontext.sendMsg(send);
			}
		}
		public function upDataGroup():void
		{
			if (!m_curGroupInfo)
			{
				if (m_gkcontext.m_heroRallyMgr.groupIfor())
				{
					var send:stReqQunYingHuiRankCmd = new stReqQunYingHuiRankCmd();
					send.m_rankNo = m_gkcontext.m_heroRallyMgr.groupIfor().m_id;
					m_gkcontext.sendMsg(send);
				}
			}
			else
			{
				send = new stReqQunYingHuiRankCmd();
				send.m_rankNo = m_curGroupInfo.m_id;
				m_gkcontext.sendMsg(send);
			}
		}
		public function process_stRetQunYingHuiRankCmd(byte:ByteArray, param:uint):void
		{
			var rev:stRetQunYingHuiRankCmd = new stRetQunYingHuiRankCmd();
			rev.deserialize(byte);
			m_curGroupInfo = m_gkcontext.m_heroRallyMgr.groupIfor(rev.m_rankNo);
			if (!m_curGroupInfo)
			{
				return;
			}
			m_myGroupLabel.text = m_curGroupInfo.m_rankText;
			m_list.setDatas(rev.m_rankList);
			if (rev.m_rankNo == m_gkcontext.m_heroRallyMgr.curgroupid)
			{
				m_score.visible = true;
				m_myRankLabel.visible = true;
				m_myScoreLabel.visible = true;
				m_rank.visible = true;
				m_score.text = m_gkcontext.m_heroRallyMgr.score;
				setRank(m_gkcontext.m_heroRallyMgr.rank);
			}
			else
			{
				m_score.visible = false;
				m_myRankLabel.visible = false;
				m_myScoreLabel.visible = false;
				m_rank.visible = false;
			}
			if (m_grouparr.indexOf(rev.m_rankNo) == 0)
			{
				m_pageBtn.setTurnState(false, true);
			}
			else if(m_grouparr.indexOf(rev.m_rankNo) == (m_grouparr.length-1))
			{
				m_pageBtn.setTurnState(true, false);
			}
			else
			{
				m_pageBtn.setTurnState(true, true);
			}
		}
		private function setRank(rank:uint):void
		{
			if (rank == 0)
			{
				m_rank.text = "未上榜";
			}
			else
			{
				m_rank.text = rank + "名";
			}
		}
	}

}