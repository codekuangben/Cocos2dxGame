package game.ui.uiGgzjExpReward 
{
	import com.bit101.components.Component;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TGuoguanzhanjiangBase;
	import modulecommon.ui.Form;
	/**
	 * ...
	 * @author ...
	 * 过关斩将，经验奖励提示
	 */
	public class UIGgzjExpReward extends Form
	{
		private var m_expDC:DigitComponent;
		private var m_curLayer:uint;
		
		public function UIGgzjExpReward() 
		{
			
		}
		
		override public function onReady():void
		{
			super.onReady();
			
			this.draggable = false;
			this.setSize(368, 42);
			this.alignHorizontal = Component.RIGHT;
			this.alignVertial = Component.TOP;
			this.marginTop = 165;
			this.marginRight = 45;
			this.setPanelImageSkin("commoncontrol/panel/expreward.png");
			
			m_expDC = new DigitComponent(m_gkcontext.m_context, this, 200, 10);
			m_expDC.setParam("commoncontrol/digit/digit02",16,25);
			
			updateData();
		}
		
		override public function updateData(param:Object = null):void
		{
			super.updateData(param);
			
			m_curLayer = m_gkcontext.m_mapInfo.m_ggzjCurLayer;
			
			var item:TGuoguanzhanjiangBase = m_gkcontext.m_dataTable.getItem(DataTable.TABLE_GUOGUANZHANJIANG, m_curLayer) as TGuoguanzhanjiangBase;
			if (item)
			{
				m_expDC.digit = item.m_exp;
			}
		}
	}

}