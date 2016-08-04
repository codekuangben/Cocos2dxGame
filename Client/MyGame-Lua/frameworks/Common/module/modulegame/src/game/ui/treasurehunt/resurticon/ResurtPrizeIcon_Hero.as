package game.ui.treasurehunt.resurticon 
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import game.ui.treasurehunt.msg.stHuntingRward;
	import modulecommon.GkContext;
	import modulecommon.scene.wu.WuHeroProperty;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class ResurtPrizeIcon_Hero extends ResurtPrizeIcon_1time 
	{
		protected var m_wjPanel:PanelContainer;
		protected var m_addNamePanel:Panel;
		private var m_rwardData:stHuntingRward;
		public function ResurtPrizeIcon_Hero(data:stHuntingRward,gk:GkContext,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(gk, parent, xpos, ypos);
			m_rwardData = data;
			m_wjPanel = new PanelContainer(this, -29,-36);
			m_wjPanel.setSize(50, 62);
			m_wjPanel.setPanelImageSkin(gk.m_npcBattleBaseMgr.squareHeadResName(data.id));
			if (data.upgrade > 0)
			{
				m_addNamePanel = new Panel(m_wjPanel, -2, -2);
				m_addNamePanel.mouseEnabled = false;
				var arr:Array = ["icon.gui", "icon.xian","icon.shen"];
				m_addNamePanel.setPanelImageSkin(arr[data.upgrade-1]);
			}
			
		}
		override public function prompt():void 
		{
			var wu:WuHeroProperty = m_gkContext.m_wuMgr.getLowestWuByTableID(m_rwardData.id) as WuHeroProperty;
			m_gkContext.m_systemPrompt.prompt("获得 "+wu.fullName, m_midPart.localToScreen(new Point(206,296)),wu.colorValue);
		}
	}

}