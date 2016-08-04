package game.ui.tongquetai.forestage.friendDancers 
{
	import adobe.utils.CustomActions;
	import com.bit101.components.AniZoom;
	import com.bit101.components.progressBar.BarInProgress2;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import com.sibirjak.asdpc.core.IDisplayObjectContainer;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import game.ui.tongquetai.forestage.DancerModelBase;
	import game.ui.tongquetai.forestage.mydancers.MyDancerModel;
	import game.ui.tongquetai.forestage.UITongQueWuHui;
	import game.ui.tongquetai.msg.FriendDancingWuNv;
	import game.ui.tongquetai.msg.stReqProcessFriendWuNvStateUserCmd;
	import game.ui.tongquetai.msg.stReqStealWuNvOutPutUserCmd;
	import modulecommon.GkContext;
	import com.util.UtilCommon;
	import modulecommon.scene.tongquetai.DancerBase;
	import modulecommon.time.Daojishi;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import com.util.UtilTools;
	import modulecommon.ui.UIFormID;
	import com.dgrigg.image.Image;
	import com.pblabs.engine.entity.EntityCValue;
	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author 
	 */
	public class FriendDancerModel extends DancerModelBase 
	{
		private var m_data:FriendDancingWuNv;
		private var m_stealBtn:PushButton;
		private var m_EventBtn:AniZoom;
		private var m_parent:DisplayObjectContainer;
		private var m_curEveState:int;
		private var m_chatTimer:Daojishi;
		public var m_timeLabel:TextNoScroll;
		private var m_showTime:int;
		public function FriendDancerModel(pos:int, gk:GkContext,parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(pos, gk, parent, xpos, ypos);
			m_parent = parent;
			
			m_timeLabel = new TextNoScroll((this.parent as FriendDancerPanel).m_parent.parent as UITongQueWuHui, this.x +54, this.y + 477);
			m_timeLabel.width = 211;
			var textFormat:TextFormat = new TextFormat();
			textFormat.leading = 4;
			textFormat.letterSpacing = 1;
			textFormat.align = TextFormatAlign.CENTER;
			m_timeLabel.defaultTextFormat = textFormat;
		}
		public function addDancing(data:FriendDancingWuNv):void
		{
			if (m_data == data)
			{
				return;
			}
			m_data = data;
			releaseUIMBeing();
			if (isDancing())
			{
				createUIMBeing(m_data.dancerBase.m_model,isDancing());
				hideStoleBtn();
			}
			else
			{
				createUIMBeing(m_data.dancerBase.m_model, isDancing());
				if (cansteal())
				{
					createStoleBtn();
				}else
				{
					hideStoleBtn();
				}
			}
			playEff(m_data.dancerBase.m_outputtype);
			updataState();
			addEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
			addEventListener(MouseEvent.ROLL_OVER, onMouseEnter);
			endChatAni();
			if (m_data.time == 0)
			{
				UtilHtml.beginCompose();
				UtilHtml.add(m_data.dancerBase.m_outputvalue + MyDancerModel.typeString(m_data.dancerBase.m_outputtype), UtilColor.YELLOW);
				m_timeLabel.htmlText = UtilHtml.getComposedContent();
			}
			else
			{
				startChatAni();
			}
			m_timeLabel.visible = true;
		}
		
		public function removeDancing():void
		{
			m_data = null;
			releaseUIMBeing();
			removeEff();
			hideEventBtn();
			hideStoleBtn();		
			this.filtersAttr(false);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
			removeEventListener(MouseEvent.ROLL_OVER, onMouseEnter);
			endChatAni();
			m_timeLabel.visible = false;
		}
	
		private function startChatAni():void
		{
			if (!m_chatTimer)
			{
				m_chatTimer = new Daojishi(m_gkContext.m_context);
				m_chatTimer.initLastTime_Second = m_data.time;
				m_chatTimer.funCallBack = timeUpdate;
				m_showTime = -1;
			}
			if (m_data.time != 0)
			{
				m_chatTimer.begin();
				m_chatTimer.onTimeUpdate();
			}
			
		}
		private function timeUpdate(d:Daojishi):void
		{
			if (m_chatTimer.isStop())
			{
				m_chatTimer.end();
				releaseUIMBeing();
				createUIMBeing(m_data.dancerBase.m_model, false);
				createStoleBtn();
				UtilHtml.beginCompose();
				UtilHtml.add(m_data.dancerBase.m_outputvalue + MyDancerModel.typeString(m_data.dancerBase.m_outputtype), UtilColor.YELLOW);
				m_timeLabel.htmlText = UtilHtml.getComposedContent();
			}
			else
			{
				UtilHtml.beginCompose();
				UtilHtml.add(m_data.dancerBase.m_outputvalue + MyDancerModel.typeString(m_data.dancerBase.m_outputtype), UtilColor.YELLOW);
				UtilHtml.breakline();
				UtilHtml.add("剩余时间：" + UtilTools.formatTimeToString(m_chatTimer.timeSecond), UtilColor.YELLOW);
				m_timeLabel.htmlText = UtilHtml.getComposedContent();
				
				if (m_showTime > 0)
				{
					m_showTime--;
				}
				else if (m_showTime < 0)
				{
					var timeAndStr:Object = m_gkContext.m_tongquetaiMgr.chatByRandom();
					m_showTime = timeAndStr.time;
				}
				else
				{
					timeAndStr = m_gkContext.m_tongquetaiMgr.chatByRandom();
					m_talkText.text = timeAndStr.str;
					m_showTime = timeAndStr.time;
					showChatAni();	
				}
			}
		}
		private function endChatAni():void
		{
			if (m_chatTimer)
			{
				m_chatTimer.dispose();
				m_chatTimer = null;
			}
			hideChatAni();
		}
		override public function dispose():void 
		{
			if (m_chatTimer)
			{
				m_chatTimer.dispose();
				m_chatTimer = null;
			}
			super.dispose();
		}
		private function updataState():void
		{
			var getstate:Boolean = false;
			for (var i:int = 0; i < 6; i++ )
			{
				if (UtilCommon.isSetUint(m_data.state, i))
				{
					m_curEveState = i;
					getstate = true;
					break;
				}
			}
			if (getstate)
			{
				createEventBtn();
			}
			else
			{
				hideEventBtn();
			}
		}
		private function isDancing():Boolean
		{
			return !UtilCommon.isSetUint(m_data.state, 6);
		}
		private function cansteal():Boolean
		{
			return UtilCommon.isSetUint(m_data.state, 7);
		}
		private function createStoleBtn():void
		{
			if (!m_stealBtn)
			{
				m_stealBtn = new PushButton(this, -2, -108, stealfunc);
				m_stealBtn.setSkinButton1Image("commoncontrol/panel/tongquetai/dancing.png");
			}
		}
		private function hideStoleBtn():void
		{
			if (m_stealBtn)
			{
				m_stealBtn.removeEventListener(MouseEvent.CLICK, stealfunc);
				this.removeChild(m_stealBtn);
				m_stealBtn.dispose();
				m_stealBtn = null;
			}
		}
		private function stealfunc(e:MouseEvent):void
		{
			var send:stReqStealWuNvOutPutUserCmd = new stReqStealWuNvOutPutUserCmd();
			send.m_tempid = m_data.tempid;
			send.m_friendid = (m_parent as FriendDancerPanel).m_curHaoYouId;
			m_gkContext.sendMsg(send);
			m_data.state = UtilCommon.clearStateUint(m_data.state, 7);
			(m_parent as FriendDancerPanel).setFriState();
			hideStoleBtn();
		}
		private function createEventBtn():void
		{
			if (!m_EventBtn)
			{
				m_EventBtn = new AniZoom(this, -89,-52);
				m_EventBtn.setPanelImageSkinMirror("commoncontrol/panel/tongquetai/eventsign.png",Image.MirrorMode_HOR);
				m_EventBtn.setParam(0.9, 1.1, 7.0, 107, 50, true);
				m_EventBtn.begin();
				m_EventBtn.buttonMode = true;
				m_EventBtn.addEventListener(MouseEvent.CLICK, Confirm);
			}
		}
		private function hideEventBtn():void
		{
			if (m_EventBtn)
			{
				m_EventBtn.removeEventListener(MouseEvent.CLICK, Confirm);
				m_EventBtn.stop();
				removeChild(m_EventBtn);
				m_EventBtn.dispose();
				m_EventBtn = null;
			}
		}
		private function Confirm(e:MouseEvent):void//这里特效啊按钮变化都是客户端未经服务端返回进行的
		{		
			m_data.state = UtilCommon.clearStateUint(m_data.state, m_curEveState);
			var send:stReqProcessFriendWuNvStateUserCmd= new stReqProcessFriendWuNvStateUserCmd();
			send.m_friendid =(m_parent as FriendDancerPanel).m_curHaoYouId;
			send.m_tempid = m_data.tempid;
			send.m_state = Math.pow(2, m_curEveState);
			m_gkContext.sendMsg(send);
			(m_parent as FriendDancerPanel).setFriState();
			
			var startpos:Point = new Point();
			var endpos:Point = new Point();
			if (m_EventBtn)
			{
				startpos = m_EventBtn.localToScreen();
			}
			
			if ((this.parent as FriendDancerPanel).m_parent.parent as UITongQueWuHui)
			{
				var bar:BarInProgress2 = ((this.parent as FriendDancerPanel).m_parent.parent as UITongQueWuHui).m_haoganBar;
				endpos = bar.localToScreen();
				endpos.x += bar.value * 231;
			}
			var shenhunParam:Object = new Object();
			shenhunParam["funtype"] = "shenhun";
			shenhunParam["aniname"] = "e40412.swf";
			shenhunParam["startpt"] = startpos;
			shenhunParam["endpt"] = endpos;
			shenhunParam["colortype"] = "blue";
			m_gkContext.m_hintMgr.addToUIZhanliAddAni(shenhunParam);
			
			updataState();
		}
		private function onMouseEnter(e:MouseEvent):void
		{
			var dic:Dictionary = new Dictionary();
			dic[EntityCValue.colorsb] = 0xf045ff;
			m_beingContainer.filtersAttr(true,dic);
		}
		private function onMouseLeave(e:MouseEvent):void
		{
			m_beingContainer.filtersAttr(false);
		}
		public function stealState():Boolean
		{
			if (!m_data)
			{
				return false;
			}
			return UtilCommon.isSetUint(m_data.state, 7);
		}
		public function eventState():Boolean
		{
			if (!m_data)
			{
				return false;
			}
			var getstate:Boolean = false;
			for (var i:int = 0; i < 6; i++ )
			{
				if (UtilCommon.isSetUint(m_data.state, i))
				{
					m_curEveState = i;
					getstate = true;
					break;
				}
			}
			return getstate;
		}
	}

}