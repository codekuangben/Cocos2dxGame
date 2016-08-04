package game.ui.uibenefithall.subcom.sevenlogin 
{
	import com.bit101.components.controlList.CtrolHComponent;
	import com.bit101.components.Label;
	import com.util.UtilColor;

	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import modulecommon.GkContext;
	import modulecommon.scene.benefithall.qiridenglu.Qiri_DayData;
	
	/**
	 * ...
	 * @author 
	 * 代表每日的按钮
	 */
	public class Qiri_DayItem extends CtrolHComponent 
	{
		private var m_gkContext:GkContext;
		private var m_dayData:Qiri_DayData;
		private var m_container:PanelContainer;
		private var m_btn:PushButton;
		private var m_lingquLabel:Label;
		public function Qiri_DayItem(param:Object=null) 
		{
			super(param);
			m_gkContext = param["gk"];
			
			m_container = new PanelContainer(this);		
			m_container.setPanelImageSkin("module/benefithall/qiridenglu/lockbg.png");
			
			m_btn = new PushButton(m_container, 0, -10);
			this.width = 66;
		}
		override public function setData(_data:Object):void
		{			    
			super.setData(_data);
			m_dayData = m_gkContext.m_qiridengluMgr.getQiri_DayDataByID(_data as int);
			m_btn.setSkinButton1Image("godlyweapon/" + m_dayData.m_name +"_icon.png");
			m_btn.setPos(m_dayData.m_x, m_dayData.m_y);
			update();
		}
		
		override public function update():void 
		{
			super.update();
			
			var color:uint = 0;
			var str:String;
			if (m_gkContext.m_qiridengluMgr.isLingqu(m_dayData.m_id))
			{
				color = UtilColor.RED;
				str = "已领取";
			}
			else if (m_dayData.m_id <= m_gkContext.m_qiridengluMgr.daysOfDenglu)
			{
				color = UtilColor.GREEN;
				str = "可领取";
			}
			
			if (color > 0)
			{
				if (m_lingquLabel == null)
				{
					m_lingquLabel = new Label(this, 10, 100);
					m_lingquLabel.setBold(true);
				}
				m_lingquLabel.text = str;
				m_lingquLabel.setFontColor(color);
			}
		}
			
		
		override public function onSelected():void 
		{
			super.onSelected();
			m_container.filtersAttr(true);
		}
		
		override public function onNotSelected():void 
		{
			super.onNotSelected();
			m_container.filtersAttr(false);
		}
		
				
		public function get id():int
		{
			return m_dayData.m_id;
		}
	}

}