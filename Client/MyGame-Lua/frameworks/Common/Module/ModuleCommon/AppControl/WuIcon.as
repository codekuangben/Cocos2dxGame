package modulecommon.appcontrol 
{
	//import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import common.event.UIEvent;
	import flash.geom.Rectangle;
	import modulecommon.GkContext;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author 
	 */
	public class WuIcon extends PanelContainer 
	{
		protected var m_gkContext:GkContext;
		protected var m_showFrame:Boolean = true; 
		protected var m_iconResName:String;
		
		protected var m_zhenweiPanel:Panel;
		protected var m_addNamePanel:Panel;
		protected var m_bShowZhenwei:Boolean;
		
		public function WuIcon(gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			setSize(WuProperty.SQUAREHEAD_WIDHT, WuProperty.SQUAREHEAD_HEIGHT);
			this.recycleSkins = true;
			this.addEventListener(UIEvent.IMAGEFAILED, onImageFailed);	
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);			
		}
		
		override public function dispose():void
		{
			this.removeEventListener(UIEvent.IMAGEFAILED, onImageFailed);	
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			
			super.dispose();
		}
		
		public function setIconNameByWu(wu:WuHeroProperty):void
		{		
			m_iconResName = NpcBattleBaseMgr.composeSquareHeadResName(wu.m_npcBase.m_squareHeadName);			
			setResName(m_iconResName, wu.m_npcBase.m_iZhenwei, wu.add);
		}
		
		public function setIconNameByTableID(tableID:uint):void
		{
			var base:TNpcBattleItem = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(tableID);
			m_iconResName = m_gkContext.m_npcBattleBaseMgr.squareHeadResName(tableID);
			setResName(m_iconResName, base.m_iZhenwei, 0);
			
		}
		
		public function setIconNameByHeroID(heroid:uint):void
		{
			var tableID:uint = heroid / 10;
			var add:uint = heroid % 10;
			var base:TNpcBattleItem = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(tableID);
			
			m_iconResName = m_gkContext.m_npcBattleBaseMgr.squareHeadResName(tableID);
			setResName(m_iconResName, base.m_iZhenwei, add);
		}
		
		protected function setResName(resName:String, iZhenwei:int, add:int):void
		{
			this.setPanelImageSkin(m_iconResName);
			if (m_bShowZhenwei)
			{				
				m_zhenweiPanel.setPanelImageSkin("commoncontrol/panel/zhenwei" + iZhenwei + ".png");
			}
			if (add)
			{
				if (m_addNamePanel==null)
				{
					m_addNamePanel = new Panel(this, -2, -2);
					m_addNamePanel.mouseEnabled = false;
					this.scrollRect = new Rectangle(0, 0, WuProperty.SQUAREHEAD_WIDHT, WuProperty.SQUAREHEAD_HEIGHT);
				}
				m_addNamePanel.visible = true;
				
				var arr:Array = ["icon.gui", "icon.xian","icon.shen"];
				m_addNamePanel.setPanelImageSkin(arr[add-1]);
			}
			else
			{
				if (m_addNamePanel)
				{
					m_addNamePanel.visible = false;
				}
			}
		}
		public function onImageFailed(e:UIEvent):void
		{
			this.graphics.beginFill(0x59A3FF);
			this.graphics.drawRoundRect(0, 0, this.width, this.height,10,10);
			this.graphics.endFill();
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			if (m_showFrame)
			{
				m_gkContext.m_wuMgr.hideWuMouseOverPanel(this);
			}
		}
		protected function onMouseOver(event:MouseEvent):void
		{
			if (m_showFrame)
			{
				m_gkContext.m_wuMgr.showWuMouseOverPanel(this);
			}
		}
		
		public function set showFrame(b:Boolean):void
		{
			m_showFrame = b;
		}
		public function set showZhenwei(b:Boolean):void
		{
			m_bShowZhenwei = b;
			m_zhenweiPanel = new Panel(this, 3, 53);
			m_zhenweiPanel.mouseEnabled = false;
		}
	}

}