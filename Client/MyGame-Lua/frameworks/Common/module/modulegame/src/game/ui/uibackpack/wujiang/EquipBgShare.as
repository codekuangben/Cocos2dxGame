package game.ui.uibackpack.wujiang 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelDraw;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class EquipBgShare extends Component
	{		
		public function EquipBgShare()
		{
			this.x = -2;
			var left:int = 10;
			var top:int = 35;
			var interval:int = 50;
			var panelDraw:PanelDraw;
			var panel:Panel;
			var i:int;
			var array:Array = ["toukui", "xiongjia", "zhanxue", "jiezhi", "wuqi", "pifeng"];
			for (i = 0; i < ZObjectDef.EQUIP_MAX; i++)
			{
				if (i == ZObjectDef.NECKLACE)
				{
					left = 190;
					top = 35;
				}
				panelDraw = new PanelDraw(this, left, top);
				panelDraw.setSize(ZObject.IconBgSize, ZObject.IconBgSize);
				
				panel = new Panel(null);
				panel.setPanelImageSkin(ZObject.IconBg);
				panelDraw.addDrawCom(panel);
				
				panel = new Panel(panel, 5, 16);
				panel.setPanelImageSkin("commoncontrol/panel/backpack/" + array[i] + ".png");
				
				panelDraw.drawPanel();
				top += interval;
			}
		}
		override public function dispose():void 
		{
			
		}
		public function disposAll():void
		{
			super.dispose();
		}
		
	}

}