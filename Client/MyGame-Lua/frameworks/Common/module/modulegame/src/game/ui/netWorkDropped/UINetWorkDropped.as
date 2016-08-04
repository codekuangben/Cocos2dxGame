package game.ui.netWorkDropped
{
	import com.bit101.components.Label;
	import com.bit101.components.TextArea;
	import com.pblabs.engine.entity.EntityCValue;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	import net.ContentBuffer;
	import modulecommon.ui.Form;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UINetWorkDropped extends Form 
	{
		private var m_text:TextArea;
		public function UINetWorkDropped():void 
		{
			super();			
			
			this.setSize(200, 90);
			m_text = new TextArea(this, 20, 20, "");	
			var tf:TextFormat = new TextFormat();
			tf.leading = 7;
			tf.size = 12;
			tf.letterSpacing = 2;
			m_text.textformat = tf;
			m_text.setSize(180, 55);
			m_bCloseOnSwitchMap = false;
		}		
		override public function onReady():void
		{			
			this.graphics.beginFill(0xB9B08E);
			this.graphics.drawRect(0, 0, this.width, this.height);
			this.graphics.endFill();
			super.onReady();
		}
		
		override public function updateData(param:Object = null):void
		{
			var str:String;
			var type:int = param as int;			
			switch(type)
			{
				case EntityCValue.DISCONNECT_UNKNOWN:
				{
					str = "由于未知的原因，连接已经断开。";
					break;
				}
				case EntityCValue.DISCONNECT_TAKEOFF:
				{
					str = "GM强制你下线，连接已经断开。";
					break;
				}
				case EntityCValue.DISCONNECT_HEART:
				{
					str = "由于网络原因，连接已经断开。";
					break;
				}
				case EntityCValue.DISCONNECT_REPEAT:
				{
					str = "你的账号在另一个地方登陆，连接已经断开。";
					break;
				}
				case EntityCValue.DISCONNECT_CLIENT_DETECT:
				{
					str = "检测到网络异常，连接已经断开。";
					break;
				}
			}
			m_text.text = str;
		}
			
	}
	
}