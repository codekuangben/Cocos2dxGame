package game.ui.uiHintMgr.subform
{
	/**
	 * ...
	 * @author wangtianzhu
	 * 获得奴隶时提示
	 */
	import flash.events.MouseEvent;
	
	import com.util.UtilColor;
	import com.util.UtilHtml;
	
	import game.ui.uiHintMgr.UIHintMgr;
	
	public class UIAddSlaveHint extends UIHint
	{
		public function UIAddSlaveHint(mgr:UIHintMgr)
		{
			super(mgr);
		}
		
		override public function onReady():void 
		{
			this.m_tf.width = 200;
			this.m_tf.x = 30;
			super.onReady();
		}
		
		public function addSlave(slavename:String):void
		{
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat("您已经战胜玩家");
			UtilHtml.add(slavename,UtilColor.GREEN);
			UtilHtml.addStringNoFormat("，并将他（她）收做你的战俘");
			var str:String = UtilHtml.getComposedContent();
			
			this.setText(str);
			m_funBtn.label = "知道了";
		}
		
		override protected function onFunBtnClick(e:MouseEvent):void 
		{
			exit();		
		}
	}
}