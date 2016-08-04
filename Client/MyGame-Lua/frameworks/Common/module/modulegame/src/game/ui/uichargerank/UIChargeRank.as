package game.ui.uichargerank 
{
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import flash.utils.ByteArray;
	import modulecommon.net.msg.rankcmd.st7DayRechargeRankListCmd;
	import modulecommon.net.msg.rankcmd.stRechargeRankItem;
	import modulecommon.ui.FormStyleExitBtn;
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author 
	 */
	public class UIChargeRank extends FormStyleExitBtn 
	{
		private var m_list:ControlListVHeight;
		public function UIChargeRank() 
		{
			super();
			id = UIFormID.UIChargeRank;
			_hitYMax = 100;
			this.exitMode = EXITMODE_HIDE;
		}
		override public function onReady():void 
		{
			super.onReady();
			setSize(558,426);
			setPanelImageSkin("module/benefithall/peoplerank/rechargebg.png");
			setFade();
			m_exitBtn.setPos(529,67);
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			m_list = new ControlListVHeight(this, 40, 131);
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			param.m_bCreateScrollBar = true;
			param.m_class = ChargeRankItem;
			param.m_width = 484;
			param.m_height = 35;
			param.m_lineSize = 35;
			param.m_heightList = param.m_lineSize * 8;
			m_list.setParam(param);
		}
		
		public function process_st7DayRechargeRankListCmd(msg:ByteArray):void
		{
			var rev:st7DayRechargeRankListCmd = new st7DayRechargeRankListCmd();
			rev.deserialize(msg);
			m_list.setDatas(rev.m_dataList);
			show();
		}
	}

}