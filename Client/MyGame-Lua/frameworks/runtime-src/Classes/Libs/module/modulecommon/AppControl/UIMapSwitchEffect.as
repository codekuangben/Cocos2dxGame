package modulecommon.appcontrol 
{
	import com.bit101.components.Component;
	import flash.display.Shape;
	//import flash.display.Sprite;
	import com.ani.AniPropertys;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author 
	 */
	public class UIMapSwitchEffect extends Form 
	{
		private var m_shape:Shape;
		private var m_ani:AniPropertys;
		private var m_bLeaveMap:Boolean;
		public function UIMapSwitchEffect() 
		{
			m_ani = new AniPropertys();
			m_ani.sprite = this;
			m_ani.onEnd = onEnd;
			this.id = UIFormID.UIMapSwitchEffect;
			this.alignHorizontal = Component.LEFT;
			this.alignVertial = Component.TOP;
			
			m_shape = new Shape();
			this.addChild(m_shape);
		}
		override public function onStageReSize():void 
		{
			drawGrahphic();
		}
		
		protected function drawGrahphic():void
		{
			var w:uint = m_gkcontext.m_context.m_config.m_curWidth;
			var h:uint = m_gkcontext.m_context.m_config.m_curHeight;
			
			m_shape.graphics.clear();
			m_shape.graphics.beginFill(0x000000);
			m_shape.graphics.drawRect(0, 0, w, h);
			m_shape.graphics.endFill();
		}
		
		public function leaveMap():void
		{			
			m_bLeaveMap = true;
			drawGrahphic();
			this.alpha = 0;
			m_ani.resetValues( { alpha:1 } );
			m_ani.duration = 0.5;
			m_ani.begin();
			this.show();
		}
		
		public function enterMap():void
		{
			if (!this.isVisible())
			{
				return;
			}
			m_bLeaveMap = false;
			m_ani.resetValues( { alpha:0 } );
			m_ani.duration = 1;			
			m_ani.begin();	
			//this.hide();
		}
		
		protected function onEnd():void
		{
			if (m_bLeaveMap == false)
			{
				this.hide();
			}
		}
		
	}

}