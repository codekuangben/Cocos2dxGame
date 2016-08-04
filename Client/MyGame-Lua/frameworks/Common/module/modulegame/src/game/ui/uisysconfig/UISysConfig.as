package game.ui.uisysconfig
{
	import com.bit101.components.ButtonRadio;
	import com.pblabs.engine.entity.EntityCValue;

	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import modulecommon.ui.FormStyleOne;
	import modulecommon.ui.UIFormID;
	import com.bit101.components.Label;
	import modulecommon.commonfuntion.LocalDataMgr;
	
	/**
	 * @brief 系统配置
	 */
	public class UISysConfig extends FormStyleOne
	{
		private var m_radioBtnDX:ButtonRadio;		// 电信
		protected var m_lblDX:Label;
		private var m_radioBtnWT:ButtonRadio;		// 网通
		protected var m_lblWT:Label;
		
		private var m_radioBtnPlayerShow:ButtonRadio;		// 隐藏周围玩家，选中就是隐藏
		protected var m_lblPlayerShow:Label;

		public function UISysConfig() 
		{
			this.id = UIFormID.UISysConfig;
		}

		override public function onReady():void
		{
			super.onReady();
			this.setSize(400, 350);
			this.setFormSkin("form1", 250);
			this.title = "系统设置";
			
			m_radioBtnDX = new ButtonRadio(this, 30, 30, onRadioBtn);
			m_radioBtnDX.setPanelImageSkin("commoncontrol/button/bb_buttonradio.swf");
			m_radioBtnDX.goupID = 0;
			
			m_radioBtnWT = new ButtonRadio(this, 30, 70, onRadioBtn);
			m_radioBtnWT.setPanelImageSkin("commoncontrol/button/bb_buttonradio.swf");
			m_radioBtnWT.goupID = 0;
			
			m_radioBtnPlayerShow = new ButtonRadio(this, 30, 110, onRadioBtnPlayerShow);
			m_radioBtnPlayerShow.setPanelImageSkin("commoncontrol/button/bb_buttonradio.swf");
			m_radioBtnPlayerShow.goupID = 1;
			
			m_lblDX = new Label(this, 60, 30, "电信");
			m_lblWT = new Label(this, 60, 70, "网通");
			m_lblPlayerShow = new Label(this, 60, 110, "是否显示周围玩家");
			
			if (m_gkcontext.m_context.m_platformMgr.getNetType())
			{
				m_radioBtnWT.selected = true;
			}
			else
			{
				m_radioBtnDX.selected = true;
			}
			
			if (m_gkcontext.m_localMgr.isSet(LocalDataMgr.LOCAL_ShowOtherPlayer))
			{
				m_radioBtnPlayerShow.selected = true;
			}
		}
		
		private function onRadioBtn(event:MouseEvent):void
		{
			var type:int = 0;
			if (m_radioBtnDX.selected)
			{
				type = 0;
			}
			else if(m_radioBtnWT.selected)
			{
				type = 1;
			}
			
			m_gkcontext.m_context.m_platformMgr.setNetType(type);
		}
		
		private function onRadioBtnPlayerShow(event:MouseEvent):void
		{
			if (m_radioBtnPlayerShow.selected)
			{
				m_gkcontext.m_localMgr.set(LocalDataMgr.LOCAL_ShowOtherPlayer);
			}
			else
			{
				m_gkcontext.m_localMgr.clear(LocalDataMgr.LOCAL_ShowOtherPlayer);
			}
			
			m_gkcontext.m_playerManager.toggleSceneShow(!m_radioBtnPlayerShow.selected);
		}
	}
}