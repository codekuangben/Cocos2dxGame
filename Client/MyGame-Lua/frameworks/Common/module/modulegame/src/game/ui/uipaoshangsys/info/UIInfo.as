package game.ui.uipaoshangsys.info
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.TextNoScroll;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.uipaoshangsys.DataPaoShang;
	import game.ui.uipaoshangsys.msg.BusinessUser;
	import game.ui.uipaoshangsys.start.UIStart;
	import modulecommon.time.Daojishi;
	import com.util.UtilTools;
	//import game.ui.uipaoshangsys.msg.notifyBusinessDataUserCmd;
	import game.ui.uipaoshangsys.msg.stRetBusinessUiDataUserCmd;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import com.bit101.components.Panel;
	import modulecommon.uiinterface.IUIPaoShangSys;
	
	/**
	 * @brief
	 */
	public class UIInfo extends Form
	{
		public var m_DataPaoShang:DataPaoShang;
		public var m_pnlBg:Panel;
		public var m_pnlBeiJie:Panel;	// 被劫信息
		
		//private var m_lblGoods:Label;					// 货物
		private var m_goodsRoot:Component;
		private var m_goodsLst:Vector.<ObjectPanel>;		// 滚动的时候活物
		private var m_lblJiaZhi:Label;					// 价值
		private var m_lblTime:Label;					// 时间
		
		private var m_textRule:TextNoScroll;			// 规则
		private var m_textLog:TextNoScroll;				// 被劫信息
		
		private var m_daojishi:Daojishi;
		private var m_LastTime:uint;	// 礼包倒计时
		
		public function UIInfo()
		{
			this.id = UIFormID.UIInfo;
			this.setSize(246, 228);
		}
		
		override public function onReady():void 
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			
			alignHorizontal = Component.LEFT;
			m_pnlBg = new Panel(this);
			m_pnlBg.setPanelImageSkin("module/paoshang/infobg.png");
			
			m_pnlBeiJie = new Panel(this, 80, 140);
			m_pnlBeiJie.visible = false;
			m_goodsRoot = new Component(this, 70, 52);
			m_goodsRoot.visible = false;
			m_goodsLst = new Vector.<ObjectPanel>(5, true);
			
			var idx:uint = 0;
			while (idx < 5)
			{
				m_goodsLst[idx] = new ObjectPanel(m_DataPaoShang.m_gkcontext, m_goodsRoot);
				m_goodsLst[idx].scaleX = 0.5;
				m_goodsLst[idx].scaleY = 0.5;
				m_goodsLst[idx].setPos(idx * ZObject.IconBgSize/2, 0);
				m_goodsLst[idx].setSize(ZObject.IconBgSize, ZObject.IconBgSize);
				m_goodsLst[idx].autoSizeByImage = false;
				m_goodsLst[idx].setPanelImageSkin(ZObject.IconBg);
				
				m_goodsLst[idx].addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				m_goodsLst[idx].addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				
				++idx;
			}
			
			//m_lblGoods = new Label(this, 76, 62, "货物", UtilColor.COLOR2);
			m_lblJiaZhi = new Label(this, 76, 82, "0 银币", UtilColor.COLOR2);
			m_lblTime = new Label(this, 110, 110, "00:00", UtilColor.COLOR2);
			
			m_textRule = new TextNoScroll(this, 20, 135);		
			m_textRule.width = 210;
			m_textRule.height = 230;
			m_textRule.setBodyCSS(UtilColor.COLOR2, 12);
			m_textRule.setCSS("body", {leading: 3, letterSpacing: 1});
			m_textRule.setMiaobian();
			
			UtilHtml.beginCompose();
			UtilHtml.add("规则:", UtilColor.COLOR2);
			UtilHtml.breakline();
			UtilHtml.add("1，每日可跑商时间为12:00~23:59", UtilColor.COLOR2);
			UtilHtml.breakline();
			UtilHtml.add("2，每人每日可跑商两次", UtilColor.COLOR2);
			UtilHtml.breakline();
			UtilHtml.add("3，每日可成功抢夺他人货物两次", UtilColor.COLOR2);
			UtilHtml.breakline();
			UtilHtml.add("4，抢夺他人货物可获得银两", UtilColor.COLOR2);
			m_textRule.htmlText = UtilHtml.getComposedContent();
			
			m_textLog = new TextNoScroll(this, 20,  160);		
			m_textLog.width = 210;
			m_textLog.height = 230;
			m_textLog.setBodyCSS(UtilColor.COLOR2, 12);	
			m_textLog.setCSS("body", {leading: 3, letterSpacing: 1});
			m_textLog.setMiaobian();
			m_textLog.visible = false;
			
			m_daojishi = new Daojishi(m_DataPaoShang.m_gkcontext.m_context);
			
			if ((m_DataPaoShang.m_form as IUIPaoShangSys).isResReady())
			{
				initRes();
			}
		}
		
		override public function dispose():void
		{
			m_daojishi.end();
			var idx:uint = 0;
			while (idx < 5)
			{	
				m_goodsLst[idx].removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				m_goodsLst[idx].removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				
				++idx;
			}
			super.dispose();
		}
		
		override public function exit():void
		{
			m_DataPaoShang.m_onUIClose(this.id);
			super.exit();
		}
		
		public function initRes():void
		{
			m_pnlBeiJie.setPanelImageSkinBySWF(m_DataPaoShang.m_form.swfRes, "uipaoshang.beijiexinxi");
		}
		
		// 更新大部分数据
		//public function psnotifyBusinessDataUserCmd(msg:notifyBusinessDataUserCmd):void
		//{
		//	// 货物信息
		//	updateGoods();
		//	// 打劫信息
		//	updateRob();
		//}
		
		// 更新大部分数据
		public function psnotifyBusinessDataUserCmd(msg:stRetBusinessUiDataUserCmd):void
		{
			// 货物信息
			if (m_DataPaoShang.m_basicInfo.shop[0])	// 如果第0个有货，就是有货
			{
				updateGoods();
			}
			// 打劫信息
			updateRob();
			updateLbl();
		}
		
		// 更新货物信息
		public function updateGoods():void
		{
			m_goodsRoot.visible = true;
			
			var msg:stRetBusinessUiDataUserCmd = m_DataPaoShang.m_basicInfo;
			
			var obj:ZObject;
			var idx:uint = 0;
			while (idx < 5)
			{
				//obj = ZObject.createClientObject(msg.shop[idx]);
				obj = ZObject.createClientObject(msg.m_goodsLst[idx].m_goodsID);
				m_goodsLst[idx].objectIcon.setZObject(obj);
				m_goodsLst[idx].objectIcon.showNum = false;
				
				++idx;
			}
		}
		
		// 更新抢劫信息
		public function updateRob():void
		{
			var msg:stRetBusinessUiDataUserCmd = m_DataPaoShang.m_basicInfo;
			// 打劫信息
			var str:String = "";
			if (msg.rob[0].time)
			{
				m_textLog.visible = true;
				m_pnlBeiJie.visible = true;
				m_textRule.visible = false;
				
				var idx:uint = 0;
				while (idx < 2)
				{
					if (msg.rob[idx].time)
					{
						UtilHtml.beginCompose();
						UtilHtml.add(msg.rob[idx].name + "抢劫你的货物,损失" + msg.rob[idx].lost + "银币", UtilColor.GREEN, 12);
						UtilHtml.breakline();
						str += UtilHtml.getComposedContent();
					}
					++idx;
				}
				
				m_textLog.htmlText = str;
			}
			else
			{
				m_textLog.visible = false;
				m_pnlBeiJie.visible = false;
				m_textRule.visible = true;
			}
		}
		
		public function updateLbl():void
		{
			m_LastTime = m_DataPaoShang.m_basicInfo.getLeftTime();
			m_lblTime.text = UtilTools.formatTimeToString(m_LastTime, false);
			
			if (m_DataPaoShang.m_basicInfo.bTime || m_DataPaoShang.m_basicInfo.brun)
			{
				beginDaojishi();
			}
			m_lblJiaZhi.text = m_DataPaoShang.m_basicInfo.value + " 银币";
		}
		
		private function beginDaojishi():void
		{
			m_daojishi.end();
			m_daojishi.funCallBack = updateDaojishi;
			m_daojishi.initLastTime = 1000 * m_LastTime;

			if(m_LastTime > 0)
			{
				m_daojishi.begin();
			}
		}
		
		private function updateDaojishi(d:Daojishi):void
		{
			// 记录时间
			m_LastTime = m_daojishi.timeSecond;
			m_lblTime.text = UtilTools.formatTimeToString(m_LastTime, false);

			if (m_daojishi.isStop())
			{
				m_daojishi.end();
				endPaoShang();
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			m_DataPaoShang.m_gkcontext.m_uiTip.hideTip();
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			var pt:Point;
			if (event.currentTarget is ObjectPanel)
			{
				var panel:ObjectPanel = event.currentTarget as ObjectPanel;
				pt = panel.localToScreen();
				
				var obj:ZObject = panel.objectIcon.zObject;
				if (obj != null)
				{
					m_DataPaoShang.m_gkcontext.m_uiTip.hintObjectInfo(pt, obj);
				}
			}
		}
		
		// 一次跑商结束处理
		protected function endPaoShang():void
		{
			if (m_DataPaoShang.m_basicInfo.times < 2)		// 如果还有跑商次数
			{
				var item:BusinessUser = m_DataPaoShang.m_basicInfo.delAndRetUser(0);	// 删除自己的信息
				// 清除打劫信息
				m_DataPaoShang.m_basicInfo.clearInfo();
				if (item)
				{
					m_DataPaoShang.m_markData.clearHero(item);		// 清除跑商标示
				}
				
				// 重置显示
				m_goodsRoot.visible = false;
				m_lblJiaZhi.text = "0 银币";
				m_lblTime.text = "00:00";
				
				// 显示开始跑商界面
				(m_DataPaoShang.m_form as IUIPaoShangSys).openUI(UIFormID.UIStart);
				var uistart:UIStart = m_DataPaoShang.m_gkcontext.m_UIMgr.getForm(UIFormID.UIStart) as UIStart;
				if(uistart)
				{
					uistart.psstRetBusinessUiDataUserCmd(m_DataPaoShang.m_basicInfo);		// 更新一下次数显示
				}
			}
		}
	}
}