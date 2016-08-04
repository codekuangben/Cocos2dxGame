package game.ui.uibackpack.watch 
{
	import com.bit101.components.comboBox.ComboBox;
	import com.bit101.components.comboBox.ComboBoxParam;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.ImageForm;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import org.ffilmation.engine.datatypes.IntPoint;
	
	/**
	 * ...
	 * @author 
	 */
	public class UIWatchSelfAttr extends Form 
	{
		protected var m_exitBtn:PushButton;
		private var m_comboBox:ComboBox;
		private var m_attrList:Watch_AttrList;
		private var m_uiWatchPlayer:UIWatchPlayer;
		private var m_bg:PanelContainer;
		private var m_wuList:Array;
		private var m_curWuOfWatch:WuProperty;
		public function UIWatchSelfAttr(uiWatchPlayer:UIWatchPlayer) 
		{
			this.id = UIFormID.UIWatchSelfAttr;
			m_uiWatchPlayer = uiWatchPlayer;
			
			m_bg = new PanelContainer(this, 18, 39);
			m_exitBtn = new PushButton(this);
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			m_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
			
			m_comboBox = new ComboBox(this, 25, 72);
			m_comboBox.setSize(160, 20);
			m_comboBox.addEventListener(Event.SELECT, onSelect);
			
			var param:ComboBoxParam = new ComboBoxParam();
			param.m_listItemClass = Watch_ComboBoxItem;
			m_comboBox.setParam(param);
			
		}
		override public function onReady():void 
		{
			super.onReady();
			this.exitMode = EXITMODE_HIDE;
			
			this.setSize(210, 533);
			setSkinForm("form8.swf");
			
			m_exitBtn.setPos(this.width - 29, 6);
			
			m_bg.setPanelImageSkin("commoncontrol/panel/watch_back2.png");
			m_attrList = new Watch_AttrList(m_bg, 20, 67,Watch_Self_NameValue);
			
		}
		override public function onShow():void 
		{
			super.onShow();
			var w:Number = m_uiWatchPlayer.width + this.width;
			m_uiWatchPlayer.x = (m_gkcontext.m_context.m_config.m_curWidth - w) / 2;
			this.x = m_uiWatchPlayer.x + m_uiWatchPlayer.width;
			this.y = m_uiWatchPlayer.y;
			
			var arOut:Array = m_gkcontext.m_wuMgr.getFightWuList(true, true);
			var arIn:Array = m_gkcontext.m_wuMgr.getFightWuList(false, true);
			
			m_wuList = arOut.concat(arIn);
			if (m_wuList.length >= 7)
			{
				m_comboBox.numVisibleItems = 7;	
			}
			else
			{
				m_comboBox.numVisibleItems = m_wuList.length;		
			}
				
			m_comboBox.items = m_wuList;
			m_comboBox.selectedIndex = 0;
		}
		
		public function switchToWu(wu:WuProperty):void
		{
			m_attrList.switchToWu(wu, m_curWuOfWatch);
		}
		protected function onSelect(event:Event):void
		{
			var index:int = m_comboBox.selectedIndex;
			if (index >= 0 && index < m_wuList.length)
			{
				switchToWu(m_wuList[index]);
			}
		}
		public function set curWuOfWatch(wu:WuProperty):void
		{
			m_curWuOfWatch = wu;
			var index:int = m_comboBox.selectedIndex;
			if (m_wuList&&index >= 0 && index < m_wuList.length)
			{
				switchToWu(m_wuList[index]);
			}
		}
	}

}