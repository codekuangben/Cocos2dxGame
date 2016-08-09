package modulecommon.commonfuntion.systemprompt
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import datast.reuse.IObjectForReuse;
	import datast.reuse.ObjectForReuse_Component;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.ani.InOutAni;
	import modulecommon.GkContext;
	
	/**
	 * ...
	 * @author
	 */
	public class MsgCtrl2 extends ObjectForReuse_Component implements IObjectForReuse
	{
		private var m_gkContext:GkContext;
		private var m_tf:Label;
		private var m_ani:InOutAni;
	
		
		public function MsgCtrl2(gk:GkContext)
		{
			m_gkContext = gk;
			m_tf = new Label(this);
			m_tf.width = 1000;
			m_tf.setFontSize(26);
			m_tf.setBold(true);		
			m_tf.miaobian = false;
			m_tf.textField.filters = m_gkContext.m_context.m_globalObj.glowFilter;

		
			m_ani = new InOutAni();
			m_ani.onEnd = onEndAni;
			m_ani.sprite = this;
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		public function begin(format:MsgCtrl2_format):void
		{
			m_tf.setFontColor(format.m_color);
			m_ani.direct = format.direct;
			m_tf.htmlText = format.m_msg;
			m_tf.flush();
			this.setPos(format.m_pos.x - (m_tf.width) / 2, format.m_pos.y);
			
			m_gkContext.m_UIMgr.addToTopMoseLayer(this);
			
			if (format.m_msg.length > 25)
			{
				m_ani.delay = 2;
			}
			else
			{
				m_ani.delay = 1;
			}
			m_ani.begin();
		}
		
		protected function onEndAni():void
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			reserveSelf();
		}
		
		override public function dispose():void
		{
			m_ani.dispose();
		}
	}

}