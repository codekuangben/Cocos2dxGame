package game.ui.treasurehunt.resurticon 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import game.ui.treasurehunt.msg.stHuntingRward;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author 
	 */
	public class ResurtPrizeIcon_Obj extends ResurtPrizeIcon_1time 
	{
		protected var m_objPanel:ObjectPanel;
		private var m_rewardDate:stHuntingRward;
		public function ResurtPrizeIcon_Obj(data:stHuntingRward,gk:GkContext,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(gk, parent, xpos, ypos);
			m_rewardDate = data;
			m_objPanel = new ObjectPanel(gk, this, -20, -20);
			m_objPanel.setPanelImageSkin(ZObject.IconBg);
			m_objPanel.mouseEnabled = false;
			var objZ:ZObject = ZObject.createClientObject(data.id, data.num, data.upgrade);
			if (data.num == 1)
			{
				m_objPanel.objectIcon.showNum = false;
			}
			else
			{
				m_objPanel.objectIcon.showNum = true;
			}
			m_objPanel.objectIcon.setZObject(objZ);
		}	
		override public function prompt():void
		{
			var objZ:ZObject = ZObject.createClientObject(m_rewardDate.id, m_rewardDate.num);
			m_gkContext.m_systemPrompt.prompt("获得 "+objZ.name + " × " + m_rewardDate.num,m_midPart.localToScreen(new Point(206,296)),  objZ.colorValue);
		}
	}

}