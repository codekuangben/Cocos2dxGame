package game.ui.uipaoshangsys.goods
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import flash.display.FrameLabel;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import game.ui.uipaoshangsys.DataPaoShang;
	import game.ui.uipaoshangsys.msg.GoodsInfo;
	import game.ui.uipaoshangsys.msg.stRetBusinessUiDataUserCmd;
	import modulecommon.commonfuntion.ConfirmDialogMgr;
	import modulecommon.scene.prop.BeingProp;
	import com.util.UtilHtml;
	import com.util.UtilTools;
	//import game.ui.uipaoshangsys.msg.notifyBusinessDataUserCmd;
	import game.ui.uipaoshangsys.msg.reqChangeBusinessUserCmd;
	import game.ui.uipaoshangsys.msg.reqStartBusinessUserCmd;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import com.bit101.components.Panel;
	import modulecommon.uiinterface.IUIPaoShangSys;
	
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * @brief
	 */
	public class UIGoods extends Form
	{
		public var m_DataPaoShang:DataPaoShang;
		
		protected var _exitBtn:PushButton;
		public var m_pnlBg:Panel;
		protected var m_lblJiaGe:Label;			// 需要20元宝
		protected var m_pnlRMB:Panel;			// 
		protected var m_btnChange:PushButton;	// 换货
		protected var m_btnOut:PushButton;		// 出车
		protected var m_ruleBtn:ButtonText;		// 规则提示
		
		private var m_lblSame:Vector.<Label>;			// 同色
		private var m_lblTotal:Label;					// 总价值
		private var m_lblTime:Label;					// 时间
		private var m_goodsLst:Vector.<ItemGoods>;		// 货物列表
		
		private var m_placeRoot:Component;
		private var m_placeGoodsLst:Vector.<ObjectPanel>;		// 滚动的时候活物
		private var m_bnoQuery:Boolean = false;					//用元宝换货，是否显示确认框
		
		protected var m_time:uint;			// 定时器
		protected var m_timecnt:uint;		// 定时器次数
		protected var m_curidx:uint;		// 转动的卡片 0 索引位置所在的实际可能的位置
		
		
		public function UIGoods()
		{
			this.id = UIFormID.UIGoods;
			this.setSize(827, 376);
		}
		
		override public function onReady():void 
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;

			m_pnlBg = new Panel(this);
			m_pnlBg.setPanelImageSkin("module/paoshang/goodsbg.png");
			
			_exitBtn = new PushButton(this, 787, 88);
			_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
			
			m_lblJiaGe = new Label(this, 642, 254, "需要20元宝", UtilColor.COLOR2);
			m_pnlRMB = new Panel(this, 740, 254);
			m_pnlRMB.setPanelImageSkin("commoncontrol/panel/rmb.png");
			if (m_DataPaoShang.m_basicInfo.free == 0)
			{
				m_lblJiaGe.visible = false;
				m_pnlRMB.visible = false;
			}
			else
			{
				m_lblJiaGe.visible = true;
				m_pnlRMB.visible = true;
				if (20 > m_DataPaoShang.m_gkcontext.m_beingProp.getMoney(BeingProp.YUAN_BAO))	// 如果钱不足
				{
					m_lblJiaGe.setFontColor(UtilColor.RED);
					m_lblJiaGe.text = "需要20";
				}
				else
				{
					m_lblJiaGe.setFontColor(UtilColor.COLOR2);
					m_lblJiaGe.text = "需要20";
				}
			}
			m_btnChange = new PushButton(this, 622, 274, onBtnChange);
			m_btnOut = new ButtonText(this, 760, 280, "出车", onBtnOut);
			m_btnOut.setSize(90, 40);
			m_btnOut.setGrid9ImageSkin("commoncontrol/button/button2.swf");
			
			m_ruleBtn = new ButtonText(this, 720, 90, "规则");
			m_ruleBtn.overColor = UtilColor.GREEN;
			m_ruleBtn.normalColor = UtilColor.GREEN;
			m_ruleBtn.setSize(60, 20);
			m_ruleBtn.addEventListener(MouseEvent.MOUSE_OVER, onRuleMouseEnter);
			m_ruleBtn.addEventListener(MouseEvent.MOUSE_OUT, m_DataPaoShang.m_gkcontext.hideTipOnMouseOut);
			
			m_lblSame = new Vector.<Label>(2, true);
			m_lblSame[0] = new Label(this, 460, 205, "3同色 +3000", UtilColor.GREEN);
			m_lblSame[1] = new Label(this, 638, 205, "3同色 +3000", UtilColor.GREEN);
			m_lblTotal = new Label(this, 406, 252, "本次货物总价值", UtilColor.COLOR2);
			m_lblTime = new Label(this, 406, 276, "跑商时间", UtilColor.COLOR2);
			
			m_goodsLst = new Vector.<ItemGoods>(5, true);
			var idx:uint = 0;
			while (idx < 5)
			{
				m_goodsLst[idx] = new ItemGoods(m_DataPaoShang, idx, this, 410 + idx * 75, 150);
				++idx;
			}
			
			// 默认不显示
			m_placeRoot = new Component(null, 410, 150);
			m_placeGoodsLst = new Vector.<ObjectPanel>(5, true);
			
			var obj:ZObject;
			var objid:uint;
			idx = 0;
			while (idx < 5)
			{
				m_placeGoodsLst[idx] = new ObjectPanel(m_DataPaoShang.m_gkcontext, m_placeRoot);
				m_placeGoodsLst[idx].setPos(idx * 75, 0);
				m_placeGoodsLst[idx].setSize(ZObject.IconBgSize, ZObject.IconBgSize);
				m_placeGoodsLst[idx].autoSizeByImage = false;
				m_placeGoodsLst[idx].setPanelImageSkin(ZObject.IconBg);
				
				obj = ZObject.createClientObject(m_DataPaoShang.m_xmlData.m_randGoodLst[idx]);
				m_placeGoodsLst[idx].objectIcon.setZObject(obj);
				m_placeGoodsLst[idx].objectIcon.showNum = false;
				
				++idx;
			}
			
			//m_time = setInterval(onTimer, 20);
			
			if ((m_DataPaoShang.m_form as IUIPaoShangSys).isResReady())
			{
				initRes();
			}
		}
		
		override public function dispose():void
		{
			clearInterval(m_time);
			m_time = 0;
			
			if (!this.contains(m_placeRoot))
			{
				m_placeRoot.dispose();
				m_placeRoot = null;
			}
			
			m_btnChange = null;
			
			super.dispose();
		}
		
		override public function exit():void
		{
			m_DataPaoShang.m_onUIClose(this.id);
			super.exit();
		}
		
		private function onBtnChange(event:MouseEvent):void
		{
			if ((1 == m_DataPaoShang.m_basicInfo.free) && !m_bnoQuery)
			{
				var radio:Object = new Object();
				radio[ConfirmDialogMgr.RADIOBUTTON_select] = false;
				radio[ConfirmDialogMgr.RADIOBUTTON_desc] = "不再询问";
				var desc:String = "点击“换货”需要消耗 20 元宝！";
				m_DataPaoShang.m_gkcontext.m_confirmDlgMgr.showMode1(this.id, desc, confirmFn, null, "确认", "取消", radio);
			}
			else
			{
				confirmFn();
			}
		}
		
		private function confirmFn():Boolean
		{
			if (m_DataPaoShang.m_gkcontext.m_confirmDlgMgr.isRadioButtonCheck())
			{
				m_bnoQuery = true;
			}
			
			m_btnChange.enabled = false;
			// 换货的时候显示
			m_time = setInterval(onTimer, 20);
			this.addChild(m_placeRoot);
			
			var cmd:reqChangeBusinessUserCmd = new reqChangeBusinessUserCmd();
			m_DataPaoShang.m_gkcontext.sendMsg(cmd);
			
			m_DataPaoShang.m_bChanging = true;
			if (m_DataPaoShang.m_basicInfo.free == 0)
			{
				m_DataPaoShang.m_basicInfo.free = 1;
				m_lblJiaGe.visible = true;
				m_pnlRMB.visible = true;
				updateResChangBtn();
			}
			
			if (20 > m_DataPaoShang.m_gkcontext.m_beingProp.getMoney(BeingProp.YUAN_BAO))	// 如果钱不足
			{
				m_lblJiaGe.setFontColor(UtilColor.RED);
				m_lblJiaGe.text = "需要20";
			}
			else
			{
				m_lblJiaGe.setFontColor(UtilColor.COLOR2);
				m_lblJiaGe.text = "需要20";
			}
			
			return true;
		}
		
		private function onBtnOut(event:MouseEvent):void
		{
			var cmd:reqStartBusinessUserCmd = new reqStartBusinessUserCmd();
			m_DataPaoShang.m_gkcontext.sendMsg(cmd);
			
			exit();
		}
		
		public function initRes():void
		{
			updateResChangBtn();
			if ((m_DataPaoShang.m_form as IUIPaoShangSys).isResReady())
			{
				updateGoodsRes();
			}
		}
		
		protected function updateResChangBtn():void
		{
			if ((m_DataPaoShang.m_form as IUIPaoShangSys).isResReady())
			{
				if (m_DataPaoShang.m_basicInfo.free == 0)	// 可以免费换货
				{
					m_btnChange.setPanelImageSkinBySWF(m_DataPaoShang.m_form.swfRes, "uipaoshang.btn3");
				}
				else
				{
					m_btnChange.setPanelImageSkinBySWF(m_DataPaoShang.m_form.swfRes, "uipaoshang.btn1");
				}
			}
		}
		
		private function onRuleMouseEnter(e:MouseEvent):void
		{
			UtilHtml.beginCompose();
			UtilHtml.add("规则:", UtilColor.COLOR2);
			UtilHtml.breakline();
			UtilHtml.add("1.每个人每天可以跑商两次", UtilColor.COLOR2);
			UtilHtml.breakline();
			UtilHtml.add("2.货物运到后奖励发放到邮件", UtilColor.COLOR2);
			UtilHtml.breakline();
			UtilHtml.add("3.抢夺别人货物可获得银币奖励", UtilColor.COLOR2);
			var str:String = UtilHtml.getComposedContent();
			if (str)
			{
				var pt:Point = m_ruleBtn.localToScreen();
				pt.x -= 5;
				pt.y += 20;
				m_gkcontext.m_uiTip.hintHtiml(pt.x, pt.y, str);
			}
		}
		
		public function updateGoodsRes():void
		{
			if ((m_DataPaoShang.m_form as IUIPaoShangSys).isResReady())
			{
				// 更新货物信息
				var idx:uint = 0;
				while (idx < 5)
				{
					m_goodsLst[idx].updateRes();
					++idx;
				}
			}
		}
		
		// 更新额外奖励图标
		public function updateExtraLbl():void
		{
			var cntlst:Vector.<uint> = new Vector.<uint>();	// 内容记录连续相同元素的个数
			var idx:uint = 0;
			var item:GoodsInfo;
			for each(item in m_DataPaoShang.m_basicInfo.m_goodsLst)
			{
				if (idx == 0)		// 第一个元素，直接入 1
				{
					cntlst.push(1);
				}
				else			// 不是第一个元素需要判断
				{
					if (m_DataPaoShang.m_basicInfo.m_goodsLst[idx - 1].m_goodsID == item.m_goodsID)	// 如果和前一个元素相等，就增加元素的值
					{
						++cntlst[cntlst.length - 1];
					}
					else
					{
						cntlst.push(1);
					}
				}
				
				++idx;
			}
			
			idx = 0;
			var lblidx:uint = 0;	// 记录至少连续连个在一起的元素的个数
			var bigidx:uint = 0;	// 相同的元素算是同一个元素
			
			while(idx < 5)
			{
				item = m_DataPaoShang.m_basicInfo.m_goodsLst[idx];
				if (cntlst[bigidx] > 1)	// 注意这些是大于 1 的
				{
					adjustExtraLbl(idx, cntlst[bigidx], lblidx);
					checkTopGood(idx, cntlst[bigidx]);					// 检查顶级货物
					checkGoodBG(idx, cntlst[bigidx], lblidx);		// 检查货物背景
					lblidx += 1;
					idx += (cntlst[bigidx] - 1);
				}
				else
				{
					checkTopGood(idx, 1);				// 检查顶级货物
					checkGoodBG(idx, 1, lblidx);	// 检查货物背景
				}
				
				++bigidx;
				++idx;
			}
			
			// 隐藏不用的 lbl
			while (lblidx < 2)
			{
				m_lblSame[lblidx].visible = false;
				++lblidx;
			}
		}
		
		protected function adjustExtraLbl(startidx:uint, cnt:uint, lblidx:uint):void
		{
			var startpos:uint = 410 + startidx * 75;

			if (cnt == 2)	// 2 连
			{
				startpos += 20;
			}
			else if (cnt == 3)	// 3 连
			{
				startpos += 60;
			}
			else if (cnt == 4)	// 4 连
			{
				startpos += 100;
			}
			else if (cnt == 5)	// 5 连
			{
				startpos += 130;
			}
			
			m_lblSame[lblidx].visible = true;
			m_lblSame[lblidx].x = startpos;
			// int(玩家等级/5+1)*货物系数
			//var extra:uint = (int(m_gkcontext.m_playerManager.hero.level/5 + 1)) * m_DataPaoShang.m_xmlData.extraAddValue(cnt);
			m_lblSame[lblidx].text = cnt + "同色 +" + m_DataPaoShang.m_xmlData.extraAddValue(cnt);
		}
		
		// 检查是否是顶级货物
		protected function checkTopGood(startidx:uint, cnt:uint):void
		{
			var idx:uint = 0;
			while (idx < cnt)
			{
				// 判断是否是顶级货物
				if (m_DataPaoShang.m_xmlData.isTopGood(m_DataPaoShang.m_basicInfo.m_goodsLst[idx + startidx].m_goodsID))
				{
					m_DataPaoShang.m_basicInfo.m_goodsLst[idx + startidx].m_bBest = true;
				}
				else
				{
					m_DataPaoShang.m_basicInfo.m_goodsLst[idx + startidx].m_bBest = false;
				}
				
				++idx;
			}
		}
		
		// 检查货物背景颜色
		protected function checkGoodBG(startidx:uint, cnt:uint, lblidx:uint):void
		{
			var idx:uint = 0;
			while (idx < cnt)
			{
				// 判断是否是顶级货物
				if (cnt > 1)	// 多余两个才显示背景
				{
					m_DataPaoShang.m_basicInfo.m_goodsLst[idx + startidx].m_bgType = lblidx + 1;
				}
				else
				{
					m_DataPaoShang.m_basicInfo.m_goodsLst[idx + startidx].m_bgType = 0;
				}
				
				++idx;
			}
		}
		
		protected function onTimer():void
		{
			++m_timecnt;
			
			var idx:uint = 0;
			while (idx < 5)
			{
				m_placeGoodsLst[idx].setPos((m_placeGoodsLst[idx].x + 75)%(5 * 75), 0);
				++idx;
			}
			
			// 判断是否实际所在位置的货物是顶级货物如果是顶级,就不显示了
			++m_curidx;
			m_curidx %= 5;
			idx = 0;
			var posidx:uint;
			while (idx < 5)
			{
				posidx = (idx + m_curidx) % 5;
				if (m_DataPaoShang.m_xmlData.isTopGood(m_DataPaoShang.m_basicInfo.m_goodsLst[posidx].m_goodsID))
				{
					m_placeGoodsLst[idx].visible = false;
				}
				else
				{
					m_placeGoodsLst[idx].visible = true;
				}
				++idx;
			}
			
			if (m_timecnt == 100)	// 如果2秒都没返回消息，就直接停止动画
			{
				stopAni();
			}
		}
		
		public function psnotifyBusinessDataUserCmd(msg:stRetBusinessUiDataUserCmd):void
		{
			m_lblTotal.text = "本次货物总价值: " + msg.value;
			m_lblTime.text = "跑商时间: " + UtilTools.formatTimeToString(msg.time, false);

			updateExtraLbl();
			updateGoodsRes();
		}
		
		// 停止动画
		public function stopAni():void
		{
			clearInterval(m_time);
			m_time = 0;
			m_timecnt = 0;
			
			if (m_placeRoot)
			{
				if (this.contains(m_placeRoot))
				{
					this.removeChild(m_placeRoot);
				}
			}
			
			m_DataPaoShang.m_bChanging = false;
			if (m_btnChange)
			{
				m_btnChange.enabled = true;
			}
		}
	}
}