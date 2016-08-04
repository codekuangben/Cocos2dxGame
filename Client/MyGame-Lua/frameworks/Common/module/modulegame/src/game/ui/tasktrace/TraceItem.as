package game.ui.tasktrace
{
	import com.bit101.components.Panel;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.CmdParse;
	import com.util.UtilFont;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import game.ui.tasktrace.rewardtip.TipTaskTrace;
	import modulecommon.commonfuntion.ConfirmInputRelevantData;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.net.msg.questUserCmd.stAbandonQuestUserCmd;
	import com.util.UtilColor;
	import modulecommon.uiinterface.IUIGmPlayerAttributes;
	
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.SysNewFeatures;
	
	import modulecommon.net.msg.questUserCmd.stReqOpenXuanShangQuestUserCmd;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.task.TaskItem;
	import modulecommon.scene.task.TaskManager;
	import com.util.UtilHtml;
	import modulecommon.ui.UIFormID;
	import modulecommon.time.Daojishi;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class TraceItem extends CtrolVHeightComponent
	{
		public static const WEITUO:String = "weituo";
		public static const CANCEL:String = "concel";
		
		public static const WIDTH:uint = 192;
		private var m_tf:TextNoScroll;
		private var m_taskItem:TaskItem;
		private var m_gkContext:GkContext;
		private var m_tc:TraceContent;
		private var m_newIcon:Panel;
		private var m_ui:UITaskTrace;
		private var m_cancelBtn:PushButton;
		
		protected var m_daojishi:Daojishi; // 倒计时
		
		public function TraceItem(param:Object)
		{
			m_gkContext = param["gk"] as GkContext;
			m_tc = param["tc"] as TraceContent;
			m_ui = param["ui"] as UITaskTrace;
			
			m_tf = new TextNoScroll();
			this.addChild(m_tf);
			m_tf.mouseEnabled = false;
			m_tf.width = WIDTH;
			m_tf.setCSS("trace", {fontFamily: UtilFont.NAME_Songti, leading: 5, color: "#ffff00", fontSize: 12, letterSpacing: 1});
			
			var filter:GlowFilter = new GlowFilter(0, 1, 2, 2, 16);
			m_tf.filters = [filter];
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.buttonMode = true;
			
			m_daojishi = new Daojishi(m_gkContext.m_context);
		}
		
		override public function setData(data:Object):void
		{
			super.setData(data);
			m_taskItem = data as TaskItem;
			
			if (m_taskItem.taskType == TaskManager.TASKTYPE_XunHuan)
			{
				showCancelBtn();
				//m_tf.addEventListener(TextEvent.LINK, clickLinkHandler);
			}
			else
			{
				hideCancelBtn();
			}
			updateData();
		}
		
		private function showCancelBtn():void
		{
			if (m_cancelBtn==null)
			{
				m_cancelBtn = new PushButton(this, 160, 15, onCancelBtnClick);
				m_cancelBtn.setSkinButton1Image("commoncontrol/button/cancel.png");
			}
			m_cancelBtn.visible = true;
		}
		
		private function hideCancelBtn():void
		{
			if (m_cancelBtn)
			{
				m_cancelBtn.visible = false;
			}
		}
		
		private function onCancelBtnClick(e:MouseEvent):void
		{
			m_gkContext.m_confirmDlgMgr.showMode1(UIFormID.UITaskTrace, "你要取消本次循环任务吗?", onCanelConfirm, null);
		}
		protected function clickLinkHandler(e:TextEvent):void
		{			
			if (e.text == WEITUO)
			{
				UtilHtml.beginCompose();
				UtilHtml.addStringNoFormat("你是否要委托    次循环任务?");
				UtilHtml.breakline();
				
				var n:int = m_gkContext.m_taskMgr.cycleQuestMax - m_gkContext.m_taskMgr.cycleQuestIndex;
				var rect:Rectangle = new Rectangle(124, -2, 36, 24);
				var labelRelevantData:ConfirmInputRelevantData = new ConfirmInputRelevantData(new Point(60, 18), getWeituoMoney, UtilColor.GREEN);
				
				m_gkContext.m_confirmDlgMgr.showModeInput(UIFormID.UITaskTrace, "委托任务", UtilHtml.getComposedContent(), onWeituoConfirm, null, null, null, rect, 1, n, 1, labelRelevantData);
			}
			else if (e.text == CANCEL)
			{
				m_gkContext.m_confirmDlgMgr.showMode1(UIFormID.UITaskTrace, "你要取消本次循环任务吗?", onCanelConfirm, null);
				
			}
		}
		private function getWeituoMoney(value:uint):int
		{
			var ret:int;
			var level:int = 0;
			if (m_gkContext.playerMain)
			{
				level = m_gkContext.playerMain.level;
			}
			
			ret = value*2;
			
			return ret;
		}
		
		private function onWeituoConfirm():Boolean
		{
			return true;
		}
		
		//放弃任务确认函数
		private function onCanelConfirm():Boolean
		{
			var cmd:stAbandonQuestUserCmd = new stAbandonQuestUserCmd();
			cmd.id = m_taskItem.m_ID;
			m_gkContext.sendMsg(cmd);
			return true;
		}
		
		override public function draw():void
		{
		
		}
		
		override public function dispose():void
		{
			super.dispose();
			if (m_daojishi)
			{
				m_daojishi.dispose();
				m_daojishi = null;
			}
			m_tf.removeEventListener(TextEvent.LINK, clickLinkHandler);
		}
		
		public function updateData():void
		{
			var str:String;
			var text:String = UtilHtml.formatFont(getTaskTypeName(m_taskItem.taskType), 0x00ff00, 12);
			if (m_taskItem.taskType == TaskManager.TASKTYPE_XunHuan)
			{
				str = " (" + (m_gkContext.m_taskMgr.cycleQuestIndex) + "/" + m_gkContext.m_taskMgr.cycleQuestMax + ")";
				UtilHtml.beginCompose();
				UtilHtml.add(m_taskItem.m_strName+str, UtilColor.WHITE, 12);
				//UtilHtml.addHypertextLink("委托", WEITUO);
				UtilHtml.breakline();
				var tempGoal:String = m_gkContext.m_taskMgr.processTaskDesc(m_taskItem, m_taskItem.m_strGoalItem);
				UtilHtml.addStringNoFormat(UtilHtml.formatUnderline(tempGoal));				
				
				text += UtilHtml.getComposedContent();
			}
			else
			{
				if (m_taskItem.finished)
				{
					str = m_taskItem.m_strName + "(交付)";
					str = UtilHtml.formatFont(str, 0x00ff00, 12);
					text += str;
				}
				else
				{
					tempGoal = m_gkContext.m_taskMgr.processTaskDesc(m_taskItem, m_taskItem.m_strGoalItem);
					var goal:String = "<u>" + tempGoal + "</u>";
					text += goal;
				}
			}
			m_tf.htmlText = "<trace>" + text + "</trace>";
			
			if (m_cancelBtn && m_cancelBtn.visible)
			{
				m_cancelBtn.y = m_tf.height - 18;
			}
			this.height = m_tf.height;
		}
		
		override public function onOver():void
		{
			m_tc.showOverPanel(this, -9, -7, m_tf.width + 18, this.height + 14);
			
			if (m_taskItem.m_rewardList.length == 0)
			{
				return;
			}
			var tip:TipTaskTrace = m_tc.getTip();
			tip.setTask(m_taskItem);
			var pt:Point = this.localToScreen();
			pt.x -= tip.width;
			pt.y -= 3;
			m_gkContext.m_uiTip.hintComponent(pt, tip);
		}
		
		override public function onOut():void
		{
			m_tc.hideOverPanel(this);
			m_gkContext.m_uiTip.hideTip();
		}
		
		public function onClick(e:MouseEvent):void
		{
			if (m_gkContext.m_localMgr.isSet(LocalDataMgr.LOCAL_GM_showTaskInfo))
			{
				var iFormGM:IUIGmPlayerAttributes = m_gkContext.m_UIMgr.getForm(UIFormID.UIGmPlayerAttributes) as IUIGmPlayerAttributes;
				if (iFormGM)
				{
					iFormGM.showTaskInfo(m_taskItem);
					return;
				}
			}
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_sysnewfeatures.m_nft = SysNewFeatures.NFT_NONE;
				m_gkContext.m_newHandMgr.hide();
			}
			if (e.target == m_cancelBtn)
			{
				return;
			}
			var xml:XML = new XML(m_taskItem.m_strGoalItem);
			
			if (m_taskItem.finished)
			{
				var taskType:int = m_taskItem.taskType;
				if (taskType == TaskManager.TASKTYPE_Xuanshang)
				{
					if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIXuanShangRenWu) == false)
					{
						var send:stReqOpenXuanShangQuestUserCmd = new stReqOpenXuanShangQuestUserCmd();
						m_gkContext.sendMsg(send);
					}
					
				}
				else
				{
					m_taskItem.submitTask(m_gkContext);
				}
				
				return;
			}
			
			m_ui.execTaskGoal(m_taskItem);
		
		}
		
		public function get taskitem():TaskItem
		{
			return m_taskItem;
		}
		
		public function showNewIcon(value:Panel):void
		{
			m_newIcon ||= new Panel(this, -40, -10);
			
			m_newIcon.visible = true;
			// 公用一个图像,不要改变图象内容
			m_newIcon.setPanelImageSkinByImage(value.skin.imageNoOR);
			beginDaojishi(10000); // 10 秒结束
		}
		
		//单位毫秒
		public function beginDaojishi(leftTime:int):void
		{
			m_daojishi.funCallBack = updateDaojishi;
			m_daojishi.initLastTime = leftTime;
			m_daojishi.begin();
			updateDaojishi(m_daojishi);
		}
		
		public function updateDaojishi(d:Daojishi):void
		{
			if (m_daojishi.isStop())
			{
				m_daojishi.end();
				m_newIcon.visible = false;
			}
		}
		
		public static function getTaskTypeName(type:int):String
		{
			var ret:String;
			switch (type)
			{
				case TaskManager.TASKTYPE_JuQing: 
					ret = "剧情";
					break;
				case TaskManager.TASKTYPE_Fenzhi: 
					ret = "支线";
					break;
				case TaskManager.TASKTYPE_XunHuan: 
					ret = "循环";
					break;
				case TaskManager.TASKTYPE_HuoDong: 
					ret = "活动";
					break;
				case TaskManager.TASKTYPE_Xuanshang: 
					ret = "悬赏";
					break;
				case TaskManager.TASKTYPE_Corps: 
					ret = "军团";
					break;
			}
			return "[" + ret + "]";
		}
	}
}