package game.ui.uibenefithall.subcom.leftpart
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam_ForPageMode;
	import com.hurlant.util.der.Integer;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import game.ui.uibenefithall.DataBenefitHall;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	
	/**
	 * @brief 左边的面板
	 */
	public class LeftPanel extends Component
	{
		protected var m_dataBenefitHall:DataBenefitHall;
		
		public var m_list:ControlListVHeight;	// 列表框
		private var m_datas:Array;
		
		public function LeftPanel(data:DataBenefitHall, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			
			m_dataBenefitHall = data;
			this.height = 300;
			m_list = new ControlListVHeight(this, -8, 0);
			m_list.addEventListener(Event.SELECT, onSelected);
			var dataParam:Object = new Object();
			dataParam["data"] = m_dataBenefitHall;			
			
			var m_param:ControlVHeightAlignmentParam_ForPageMode = new ControlVHeightAlignmentParam_ForPageMode();
			m_param.m_class = ItemBtnLst;
			m_param.m_marginLeft = 8;
			m_param.m_height = 48;
			m_param.m_width = 164;
			m_param.m_intervalV = 2;
			m_param.m_numRow = 12;
			m_param.m_dataParam = dataParam;
		
			m_list.setParamForPageMode(m_param);
		}
		
		public function initData():void
		{
			m_datas = new Array();
			var i:int = 0;
			for (i = 0; i < BenefitHallMgr.BUTTON_Num; i++)
			{
				if (i == BenefitHallMgr.BUTTON_FuliLibao&&!m_dataBenefitHall.m_gkContext.m_welfarePackageMgr.m_activation)
				{
					continue;
				}
				if (i==BenefitHallMgr.BUTTON_XianshiFangsong1&&!m_dataBenefitHall.m_gkContext.m_LimitBagSendMgr.isact(0))
				{
					continue;
				}
				else if (i==BenefitHallMgr.BUTTON_XianshiFangsong2&&!m_dataBenefitHall.m_gkContext.m_LimitBagSendMgr.isact(1))
				{
					continue;
				}
				else if (i==BenefitHallMgr.BUTTON_XianshiFangsong3&&!m_dataBenefitHall.m_gkContext.m_LimitBagSendMgr.isact(2))
				{
					continue;
				}
				else if (i==BenefitHallMgr.BUTTON_XianshiFangsong4&&!m_dataBenefitHall.m_gkContext.m_LimitBagSendMgr.isact(3))
				{
					continue;
				}
				else if (i == BenefitHallMgr.BUTTON_Quanminchongbang)
				{
					if (!m_dataBenefitHall.m_gkContext.m_peopleRankMgr.isShowTabBtn())
					{
						continue;
					}
				}
				else if (i == BenefitHallMgr.BUTTON_QiriDenglu)
				{
					if (!m_dataBenefitHall.m_gkContext.m_qiridengluMgr.isAllLingqu())
					{
						continue;
					}
				}
				else if (i == BenefitHallMgr.BUTTON_JLZhaoHui && !m_dataBenefitHall.m_gkContext.m_contentBuffer.getContent("JLZHListTabPage", false))
				{
					continue;
				}
				m_datas.push(i);
			}
			m_list.setDatas(m_datas);
		}
		
		/*将id对应的按钮设置选中状态	 
		id：取BenefitHallMgr.BUTTON_HuoyueFuli等值*/
		public function setSelected(id:int):void
		{
			var index:int = m_list.findCtrolIndexByData(id);
			m_list.setSeleced(index);
		}
		
		public function getCurSelectedID():int
		{
			var btn:ItemBtnLst = m_list.getControlSelected() as ItemBtnLst;
			if (btn)
			{
				return btn.id;
			}
			return BenefitHallMgr.BUTTON_Num;
			
		}
		private function onSelected(e:Event):void
		{
			var id:int 
			m_dataBenefitHall.m_rightPanel.showPage(getCurSelectedID());
		}
		
		/*添加1个按钮		 
		id：取BenefitHallMgr.BUTTON_HuoyueFuli等值*/
		public function addItem(id:uint):void
		{
			var i:int;
			var j:int = m_datas.indexOf(id);
			if (j != -1)
			{
				return;
			}
			for (i = 0; i < m_datas.length; i++)
			{
				if (id < m_datas[i])
				{
					break;
				}
			}
			m_datas.splice(i, 0, id);
			m_list.insertData(i, id);
		}
		
		public function deleItem(id:uint):void
		{
			var i:int = m_datas.indexOf(id);
			if (i != -1)
			{
				m_datas.splice(i, 1);
				m_list.deleteData(i);
			}
		}
		
		//在id按钮上显示，bShow=true:显示奖icon，bShow=false:去掉奖icon
		public function showRewardFlag(id:int, bShow:Boolean):void
		{
			var item:ItemBtnLst = m_list.getCtrl(id) as ItemBtnLst;
			if (item)
			{
				item.showRewardFlag(bShow);
			}
		}	
	}
}