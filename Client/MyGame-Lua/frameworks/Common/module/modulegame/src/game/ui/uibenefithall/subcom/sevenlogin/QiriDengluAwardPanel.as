package game.ui.uibenefithall.subcom.sevenlogin 
{
	import com.bit101.components.controlList.ControlHAlignmentParam;
	import com.bit101.components.controlList.ControlListH;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelPage;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import game.ui.uibenefithall.DataBenefitHall;
	import modulecommon.net.msg.activityCmd.stGetSevenLoginRewardCmd;
	import modulecommon.scene.benefithall.qiridenglu.Qiri_DayData;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author 
	 */
	public class QiriDengluAwardPanel extends PanelPage 
	{
		protected var m_dataBenefitHall:DataBenefitHall;
		private var m_dayData:Qiri_DayData;
		private var m_list:ControlListH;
		private var m_funBtn:PushButton;
		private var m_namePanel:Panel;
		private var m_movingAni:AniMoving;
		public function QiriDengluAwardPanel(data:DataBenefitHall, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);			
			m_dataBenefitHall = data;
			
			m_movingAni = new AniMoving(this);
			m_movingAni.mouseChildren = false;
			m_movingAni.mouseEnabled = false;
			m_funBtn = new PushButton(this, 419, 218, onFunClick);
			m_funBtn.setSkinButton1Image("module/benefithall/lingqulibaobtn.png");	
			
			m_namePanel = new Panel(this);			
			
			m_list = new ControlListH(this, 290, 100);
			var param:ControlHAlignmentParam = new ControlHAlignmentParam();
			param.m_class = Qiri_AwardItem;
			
			var dataParam:Object = new Object();
			dataParam["data"] = m_dataBenefitHall;			
			
			param.m_dataParam = dataParam;
			param.m_marginBottom = 0;
			param.m_marginLeft = 0;
			param.m_marginRight = 0;
			param.m_marginTop = 30;
			param.m_intervalH = 15;
			param.m_height = 85;
			param.m_widthList = 360;
			m_list.setParam(param);
		}
		public function initData(dataBenefitHall:DataBenefitHall, id:int):void
		{
			m_dataBenefitHall = dataBenefitHall;
			m_dayData = m_dataBenefitHall.m_gkContext.m_qiridengluMgr.getQiri_DayDataByID(id);
			m_namePanel.setPanelImageSkin("godlyweapon/" + m_dayData.m_name +"_word.png");
			
			m_movingAni.setPos(m_dayData.m_xView, m_dayData.m_yView);
			
			m_movingAni.scaleX = m_dayData.m_scaleView;
			m_movingAni.scaleY = m_dayData.m_scaleView;
			
			m_movingAni.setParam("godlyweapon/" + m_dayData.m_name +"_view.png", m_dayData.m_bMirror, 467, 528, 3);
			m_movingAni.begin();
			
			var datas:Array = new Array();
			datas.push(m_dayData.m_id);
			datas = datas.concat(m_dayData.m_awardList);
			m_list.setDatas(datas);
		}
		
		private function onFunClick(e:MouseEvent):void
		{			
			var send:stGetSevenLoginRewardCmd = new stGetSevenLoginRewardCmd();
			send.day = m_dayData.m_id;
			m_dataBenefitHall.m_gkContext.sendMsg(send);			
		}
		
		public function updateBtn():void
		{
			if (m_dataBenefitHall.m_gkContext.m_qiridengluMgr.isLingqu(m_dayData.m_id))
			{
				m_funBtn.enabled = false;
			}
			else
			{
				m_funBtn.enabled = true;
			}
		}
	}

}