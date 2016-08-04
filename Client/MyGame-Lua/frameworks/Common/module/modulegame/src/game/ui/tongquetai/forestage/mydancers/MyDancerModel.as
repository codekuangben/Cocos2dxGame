package game.ui.tongquetai.forestage.mydancers 
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import flash.display.DisplayObjectContainer;	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import game.ui.tongquetai.backstage.UITongQueTai;
	import game.ui.tongquetai.forestage.DancerModelBase;
	import game.ui.tongquetai.msg.stReqGetWuNvOutPutUserCmd;
	import modulecommon.GkContext;
	import modulecommon.scene.tongquetai.DancingWuNv;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import flash.geom.Point;
	import com.util.UtilHtml;
	import com.util.UtilColor;
	import com.util.UtilTools;
	import modulecommon.scene.prop.BeingProp;
	import com.pblabs.engine.entity.EntityCValue;
	import game.ui.tongquetai.forestage.UITongQueWuHui
	/**
	 * ...
	 * @author 
	 */
	public class MyDancerModel extends DancerModelBase 
	{
		private var m_emptyBtn:PushButton;
		private var m_harvestBtn:PushButton;
		private var m_dancer:DancingWuNv;
		public var m_timeLabel:TextNoScroll;
		
		public function MyDancerModel(pos:int, gk:GkContext,parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(pos, gk, parent, xpos, ypos);
			
		}
		
		public function init():void
		{
			m_timeLabel = new TextNoScroll((this.parent as MyDancerPanel).m_parent.parent as UITongQueWuHui, this.x +54, this.y + 477);
			m_timeLabel.width = 211;
			var textFormat:TextFormat = new TextFormat();
			textFormat.leading = 4;
			textFormat.letterSpacing = 1;
			textFormat.align = TextFormatAlign.CENTER;
			m_timeLabel.defaultTextFormat = textFormat;
			
			
			var dancing:DancingWuNv = m_gkContext.m_tongquetaiMgr.getDancingByPos(m_pos);
			if (dancing)
			{
				addDancing(dancing);
			}
			else
			{
				createEmptyBtn();
			}
		}
		public function addDancing(dancer:DancingWuNv):void
		{
			if (m_dancer == dancer)
			{
				return;
			}
			m_dancer = dancer;
			releaseUIMBeing();
			hideEmptyBtn();
			if (dancer.isDancing)
			{
				createUIMBeing(m_dancer.m_dancerBase.m_model, m_dancer.isDancing);
				hideHarvestBtn();
			}
			else
			{
				createUIMBeing(m_dancer.m_dancerBase.m_model, m_dancer.isDancing);
				createHarvestBtn();
			}
			playEff(m_dancer.m_dancerBase.m_outputtype);
			addEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
			addEventListener(MouseEvent.ROLL_OVER, onMouseEnter);
			m_timeLabel.visible = true;
			updataTimeLabel();
		}
		
		public function removeDancing():void
		{
			releaseUIMBeing();
			createEmptyBtn();
			hideHarvestBtn();
			removeEff();
			this.filtersAttr(false);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
			removeEventListener(MouseEvent.ROLL_OVER, onMouseEnter);
			m_timeLabel.visible = false;
		}
		public function updataTimeLabel():void
		{
			if (m_dancer.remainingTime > 0)
			{
				UtilHtml.beginCompose();
				UtilHtml.add(m_dancer.m_dancerBase.m_outputvalue + typeString(m_dancer.m_dancerBase.m_outputtype), UtilColor.YELLOW);
				UtilHtml.breakline();
				UtilHtml.add("剩余时间：" + hourTime(m_dancer.remainingTime), UtilColor.YELLOW);
				m_timeLabel.htmlText = UtilHtml.getComposedContent();
			}
			else
			{
				UtilHtml.beginCompose();
				var stolennum:int;
				var list:Array = m_dancer.stolenList;
				for (var i:uint = 0; i < list.length; i++ )
				{
					stolennum += list[i].m_value;
				}
				UtilHtml.add((m_dancer.m_dancerBase.m_outputvalue-stolennum) + typeString(m_dancer.m_dancerBase.m_outputtype), UtilColor.YELLOW);
				for (i = 0; i < list.length; i++)
				{
					UtilHtml.breakline();
					UtilHtml.add(list[i].m_name + "到此一游 盗走" + list[i].m_value + typeString(m_dancer.m_dancerBase.m_outputtype), UtilColor.YELLOW);
				}
				m_timeLabel.htmlText = UtilHtml.getComposedContent();
			}
		}
		public function showChat(str:String):void
		{
			m_talkText.text = str;
			showChatAni();
		}
		private function hourTime(time:int):String
		{
			return UtilTools.formatTimeToString(time);
		}
		public function becomeOver():void
		{
			releaseUIMBeing();
			createUIMBeing(m_dancer.m_dancerBase.m_model, m_dancer.isDancing);
			createHarvestBtn();
		}
		private function createEmptyBtn():void
		{
			if (m_emptyBtn == null)
			{
				m_emptyBtn = new PushButton(this, -63, 93, emptyfunc);
				m_emptyBtn.setSkinButton1Image("commoncontrol/panel/tongquetai/empty.png");
			}			
		}
		private function hideEmptyBtn():void
		{
			if (m_emptyBtn)
			{
				m_emptyBtn.removeEventListener(MouseEvent.CLICK, emptyfunc);
				this.removeChild(m_emptyBtn);
				m_emptyBtn.dispose();
				m_emptyBtn = null;
			}
		}
		
		private function createHarvestBtn():void
		{
			if (m_harvestBtn == null)
			{
				m_harvestBtn = new PushButton(this, -2, -108, harvestfunc);
				m_harvestBtn.setSkinButton1Image("commoncontrol/panel/tongquetai/finish.png");
			}			
		}
		private function hideHarvestBtn():void
		{
			if (m_harvestBtn)
			{
				m_harvestBtn.removeEventListener(MouseEvent.CLICK, harvestfunc);
				this.removeChild(m_harvestBtn);
				m_harvestBtn.dispose();
				m_harvestBtn = null;
			}
		}
		private function emptyfunc(e:MouseEvent):void
		{
			var formTongQueTai:UITongQueTai = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UITongQueTai) as UITongQueTai
			formTongQueTai.show();
			formTongQueTai.setDancerPos(m_pos);
		}
		private function harvestfunc(e:MouseEvent):void
		{
			var send:stReqGetWuNvOutPutUserCmd = new stReqGetWuNvOutPutUserCmd();
			send.m_tempid = m_dancer.m_dancingMsg.tempid;
			m_gkContext.sendMsg(send);
		}
		private function onMouseEnter(e:MouseEvent):void
		{
			if (m_dancer.isDancing)
			{
				var pt:Point = this.localToScreen();
				pt.x -= 200;
				pt.y -= 150;
				UtilHtml.beginCompose();
				UtilHtml.add("您还能欣赏" + UtilTools.formatTimeToString(m_dancer.remainingTime, false, false, true)+ "的绝伦舞姿", UtilColor.WHITE_Yellow, 14);
				UtilHtml.breakline();
				UtilHtml.add("宴客结束后，您将获得" + m_dancer.m_dancerBase.m_outputvalue+typeString(m_dancer.m_dancerBase.m_outputtype), UtilColor.YELLOW, 14);
				
				m_gkContext.m_uiTip.hintHtiml(pt.x+95, pt.y+135, UtilHtml.getComposedContent(), 296, true, 8);
			}
			var dic:Dictionary = new Dictionary();
			dic[EntityCValue.colorsb] = 0xf045ff;
			m_beingContainer.filtersAttr(true,dic);
		}
		private function onMouseLeave(e:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
			m_beingContainer.filtersAttr(false);
		}
		public static function typeString(type:int):String
		{
			var str:String
			if (type == BeingProp.SILVER_COIN)
			{
				str=" 银币"
			}
			else if(type == -1)
			{
				str=" 经验"
			}
			else if (type == BeingProp.JIANG_HUN)
			{
				str = "将魂";
			}
			else if (type == BeingProp.GREEN_SHENHUN)
			{
				str = "绿色神魂";
			}
			else if (type == BeingProp.BLUE_SHENHUN)
			{
				str = "蓝色神魂";
			}
			return str;
		}
		public function unAttachTickMgr():void
		{
			if (m_wuBeing)
			{
				m_gkContext.m_context.m_uiObjMgr.unAttachFromTickMgr(m_wuBeing);
			}
		}
		
		public function atachTickMgr():void
		{
			if (m_wuBeing)
			{
				m_gkContext.m_context.m_uiObjMgr.attachToTickMgr(m_wuBeing);
			}
		}
	}

}