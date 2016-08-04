package game.ui.tongquetai.backstage 
{
	import com.bit101.components.PanelPage;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import com.bit101.components.controlList.controlList_VerticalAlign.ControlList_VerticalAlign;
	import com.bit101.components.controlList.controlList_VerticalAlign.ControlList_VerticalAlign_Param;

	import modulecommon.net.msg.wunvCmd.SpecialWuNv;
	import com.bit101.components.pageturn.PageTurn;
	import modulecommon.scene.tongquetai.DancerBase;
	/**
	 * ...
	 * @author ...
	 */
	public class MysteryPage extends PanelPage 
	{
		private var m_gkContext:GkContext;
		private var m_list:ControlList_VerticalAlign;
		private var m_dataList:Array;
		private var m_pageturn:PageTurn;
		private var m_ui:UITongQueTai;
		public function MysteryPage(ui:UITongQueTai, gk:GkContext,parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_ui = ui;
			this.setPanelImageSkin("commoncontrol/panel/tongquetai/mysterybg.png");
			
			m_dataList = new Array();
			m_list = new ControlList_VerticalAlign(this,5,50);//, -100, 
			
			var dataparam:Object = new Object();
			dataparam["gk"] = m_gkContext;
			
			var param:ControlList_VerticalAlign_Param = new ControlList_VerticalAlign_Param();
			param.m_class = DancerIconMystery;
			
			param.m_height = 98;
			param.m_width = 90;
			
			param.m_numRow = 3;
			param.m_numColum = 1;
			param.m_intervalV = 35;
			param.m_intervalH = 60;		
			param.m_marginTop = 31;
			param.m_marginBottom = 6;
			param.m_dataParam = dataparam;
			
			m_list.setParam(param);	
			m_list.addEventListener(Event.SELECT, onSelect);
			m_list.speed = 200
			m_pageturn = new PageTurn(this, 40, 465);
			m_pageturn.setBtnPos(0, 0, 60, 0, 0, 18);
			m_pageturn.setParam(onPageTurn,m_list.isAni);		
			m_pageturn.setBtnNameHorizontal_Mirror("leftArrow2.swf");
			
			initData();
			
		}
		
		public function initData():void
		{
			var dic:Dictionary = m_gkContext.m_tongquetaiMgr.getMysteryList();
			var item:SpecialWuNv;
			for each(item in dic)
			{
				m_dataList.push(item);
			}
			
			m_dataList.sort(sortMystery);
			m_list.setDatas(m_dataList);
			m_pageturn.pageCount = m_list.pageCount;
			m_pageturn.curPage = 0;
			if (m_dataList.length == 0)
			{
				this.hide();
			}
			else
			{
				this.show();
			}
		}
		//得到神秘舞女
		public function addSpecialDancer(id:uint):void
		{
			var mysteryDancer:SpecialWuNv = m_gkContext.m_tongquetaiMgr.getSpecialDancerOwned(id);
			var i:int = 0;
			for (i = 0; i < m_dataList.length; i++)
			{
				if (id < m_dataList[i].id)
				{
					break;
				}
			}
			m_dataList.splice(i, 0, mysteryDancer);
			if (m_dataList.length > 0)
			{
				this.show();
			}
			m_list.insertData(i, mysteryDancer);
			m_pageturn.pageCount = m_list.pageCount;
		}
		
		//删除神秘舞女
		public function deleteSpecialDancer(id:uint):void
		{
			var mysteryDancer:SpecialWuNv = m_gkContext.m_tongquetaiMgr.getSpecialDancerOwned(id);
			var i:int = m_dataList.indexOf(mysteryDancer);
			if (i != -1)
			{
				m_dataList.splice(i, 1);
			}
			m_list.deleteData(i);
			if (m_dataList.length == 0)
			{
				this.hide();
			}
			m_pageturn.pageCount = m_list.pageCount;
		}
		
		//更新神秘舞女的数量
		public function updateNumOfSpecialDancer(id:uint):void
		{
			var icon:DancerIconMystery = m_list.findCtrl(DancerIconBase.s_compare,id) as DancerIconMystery;
			if (icon)
			{
				icon.update();
			}
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
		public function onSelect(e:Event):void
		{
			var dancer:DancerBase = m_list.getDataSelected() as DancerBase;
			if (dancer)
			{
				m_ui.updataSelectModel(dancer);
			}
		}
		public function selectNO():void
		{
			m_list.setSeleced( -1);
		}
		private static function sortMystery(x:SpecialWuNv, y:SpecialWuNv):int
		{
			if (x.id< y.id)
			{
				return -1;
			}
			else if (x.id > y.id)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
	}

}