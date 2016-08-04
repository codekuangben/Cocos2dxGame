package game.ui.uihuntexchange 
{
	import com.bit101.components.controlList.ControlAlignmentParam_ForPageMode;
	import com.bit101.components.controlList.ControlList;
	import com.bit101.components.label.Label2;
	import com.bit101.components.pageturn.PageTurn;
	import com.bit101.components.Panel;
	import com.util.UtilColor;
	import modulecommon.ui.FormStyleExitBtn;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIHuntExchange;
	
	/**
	 * ...
	 * @author 
	 */
	public class UIHuntExchange extends FormStyleExitBtn implements IUIHuntExchange
	{
		private var m_turnPageBtn:PageTurn;
		private var m_list:ControlList;
		private var m_exchangeWord:Label2;
		public function UIHuntExchange()
		{
			super();
			this.id = UIFormID.UIHuntExchange;
			this._hitYMax = 75;
			setFade();
		}
		override public function onReady():void 
		{
			super.onReady();
			
			setSize(586, 478);
			setPanelImageSkin("commoncontrol/panel/zhanxing/exchangebg.png");
			var wordpanel:Panel = new Panel(this, 244, 27);
			wordpanel.mouseEnabled = false;
			wordpanel.setPanelImageSkin("commoncontrol/panel/treasurehunt/exchangeword.png");
			m_exitBtn.setPos(556,30);
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			
			m_turnPageBtn = new PageTurn(this, 244, 427);			
			m_turnPageBtn.setBtnNameHorizontal_Mirror("leftArrow2.swf");
			m_turnPageBtn.setBtnPos(0, 0, 75, 0, 0, 18);
			m_turnPageBtn.setParam(onPageTurn);	
			m_list = new ControlList(this,34,65);	
			m_list.bInitSubCtrlOnShow = true;
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkcontext;
			var param:ControlAlignmentParam_ForPageMode = new ControlAlignmentParam_ForPageMode();
			param.m_class = CommodityHunt;
			param.m_height = 94;
			param.m_width = 226;
			param.m_numColumn = 2;
			param.m_numRow = 3;
			param.m_intervalV = 16;
			param.m_intervalH = 42;
			param.m_marginLeft = 10;
			param.m_marginRight = 10;
			param.m_dataParam = dataParam;
			m_list.setParamForPageMode(param);
			m_list.setDatas(m_gkcontext.m_treasurehuntMgr.huntExchangeList);	
			m_turnPageBtn.pageCount = m_list.pageCount;
			m_exchangeWord = new Label2(this, 50, 413);
			var tipword:Label2 = new Label2(this, 50, 437);
			tipword.text = "使用元宝寻宝可得寻宝积分";
			tipword.setFontColor(UtilColor.RED);
			refreshScore();
		}
		private function onPageTurn(pre:Boolean):void
		{
			if (pre)
			{
				m_list.toPreLine();
			}
			else
			{
				m_list.toNextLine();
			}
		}
		public function refreshScore():void
		{
			m_exchangeWord.text = "寻宝积分：" + m_gkcontext.m_treasurehuntMgr.score.toString();
		}
	}

}