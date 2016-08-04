package game.ui.uiTeamFBSys.iteamzx
{
	import com.bit101.components.Component;
	//import com.bit101.components.Panel;
	
	//import flash.display.Bitmap;
	//import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	
	import game.ui.uiTeamFBSys.UITFBSysData;

	/**
	 * @brief 拖放处理
	 * */
	public class TeamMemIconItemDND extends Component
	{
		protected var m_TFBSysData:UITFBSysData;
		//protected var m_bmBG:Bitmap;

		public function TeamMemIconItemDND(data:UITFBSysData, parent:DisplayObjectContainer = null, xPos:int = 0, yPos:int = 0)
		{
			super(parent, xPos, yPos);
			m_TFBSysData = data;
			drawBg();
			this.setDropTrigger(true);
		}
		
		public function drawBg():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xff0000, 0);
			this.graphics.drawRect(0, 0, 60, 60);
			this.graphics.endFill();
			
			//m_pnlBG = new Panel(this);
			//m_pnlBG.mouseEnabled = false;
			//m_pnlBG.mouseChildren = false;
			//m_pnlBG.setSize(50, 50);
			//m_pnlBG.autoSizeByImage = false;
			//m_pnlBG.setPanelImageSkin("commoncontrol/panel/comnpnl.png");
			
			//m_bmBG = new Bitmap();
			//var bmd:BitmapData = new BitmapData(50, 50, false, 0xffff);
			//m_bmBG.bitmapData = bmd;
			//this.addChild(m_bmBG);
		}
	}
}