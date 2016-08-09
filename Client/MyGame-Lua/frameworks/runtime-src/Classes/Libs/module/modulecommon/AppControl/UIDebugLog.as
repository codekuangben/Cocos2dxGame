package modulecommon.appcontrol 
{	
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.TextNoScroll;
	import common.logicinterface.IUIDebugLog;
	import flash.events.MouseEvent;
	import com.util.UtilColor;
	//import flash.text.TextField;
	import flash.text.TextFormat;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UIDebugLog extends Form implements IUIDebugLog
	{
		private var m_tf:TextNoScroll;
		private var m_exitBtn:ButtonText;
		public function UIDebugLog() 
		{		
			
			exitMode = EXITMODE_HIDE;		
			this.alignHorizontal = Component.LEFT;
			this.alignVertial = Component.TOP;
			this.id = UIFormID.UIDebugLog;
			m_tf = new TextNoScroll;			
			m_tf.width = 250;			
			m_tf.border = true;
			m_tf.defaultTextFormat = new TextFormat(null, 16);
			m_tf.y = 30;
			m_tf.x = 4;
			this.addChild(m_tf);
			
			m_exitBtn = new ButtonText(this, 100, 0, "关闭", onClick);
			m_exitBtn.normalColor = UtilColor.GREEN;
			m_exitBtn.setSize(60, 30);
			//m_exitBtn._labelText = "关闭";
		}
		public function onClick(e:MouseEvent):void
		{
			exit();
		}
		override public function onReady():void
		{			
			this.m_gkcontext.m_context.m_debugLog = this;
			super.onReady();
		}
		public function info(str:String):void
		{
			m_tf.text = str;
			this.setSize(260, m_tf.y+m_tf.height+10);
			this.show();
		}
		override public function draw():void 
		{
			super.draw();
			
			this._backgroundContainer.graphics.clear();
			this._backgroundContainer.graphics.beginFill(0xffffff);
			this._backgroundContainer.graphics.drawRoundRect(0, 0, this.width, this.height, 5, 5);
			this._backgroundContainer.graphics.endFill();
		}
		
	}

}