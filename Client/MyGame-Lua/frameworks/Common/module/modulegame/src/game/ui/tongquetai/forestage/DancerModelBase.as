package game.ui.tongquetai.forestage 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelShowAndHide;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import modulecommon.uiObject.UIMBeing;
	import modulecommon.GkContext;
	import game.ui.tongquetai.forestage.mydancers.MyDancerModel;
	import com.pblabs.engine.entity.EntityCValue;
	import com.hurlant.crypto.prng.Random;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author 
	 */
	public class DancerModelBase extends Component 
	{
		protected var m_beingContainer:Panel;
		protected var m_wuBeing:UIMBeing;
		protected var m_gkContext:GkContext;
		protected var m_pos:int;
		protected var m_ani:Ani;
		protected var m_aniPanel:AniPanel;
		protected var m_talkPanel:Panel;
		protected var m_talkText:TextField;
		public function DancerModelBase(pos:int, gk:GkContext,parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			m_pos = pos;
			m_gkContext = gk;
			super(parent, xpos, ypos);
			m_beingContainer = new Panel(this);
			m_talkPanel = new Panel(null,18,-102);
			m_talkPanel.setPanelImageSkin("commoncontrol/panel/tongquetai/talkbg.png");
			m_talkText = new TextField();
			m_talkText.text = "";
			var format:TextFormat = new TextFormat();
			format.letterSpacing = 1;
			//format.leading = 4;
			m_talkText.defaultTextFormat = format;
			m_talkText.x = 5;
			m_talkText.width = 156;
			m_talkText.height = 50;
			m_talkText.textColor = UtilColor.WHITE_Yellow;
			m_talkText.wordWrap = true;
			m_talkPanel.addChild(m_talkText);
		}
		
		protected function createUIMBeing(model:String,isdancing:Boolean):void
		{
			m_wuBeing = m_gkContext.m_context.m_uiObjMgr.createUIObject("tongquetai.forestageWuhui" + m_pos+isMyDancer.toString(), model, UIMBeing) as UIMBeing;
			m_wuBeing.changeContainerParent(m_beingContainer);
			m_wuBeing.moveTo(0, 118, 0);
			if (isdancing)
			{
				m_wuBeing.state = EntityCValue.TDance;
				m_wuBeing.definition.dicAction[7].repeat = true;
				m_wuBeing.definition.dicAction[7].framerate = 8;
			}
			else
			{
				m_wuBeing.state = EntityCValue.TActStand;
				m_wuBeing.definition.dicAction[0].framerate = 8;
			}
		}
		
		protected function releaseUIMBeing():void
		{
			if (m_wuBeing)
			{
				m_wuBeing.offawayContainerParent();
				m_gkContext.m_context.m_uiObjMgr.releaseUIObject(m_wuBeing);
				m_wuBeing = null;
			}
			if (m_aniPanel)
			{
				m_aniPanel.dispose();
				m_aniPanel = null;
			}
		}
		protected function playEff(type:int):void
		{
			if (null == m_ani)
			{
				m_ani = new Ani(m_gkContext.m_context);
				m_ani.duration = 1;
				if (type == 4)
				{
					m_ani.setImageAni("ejtongquetaichuanglian.swf");//蝴蝶
					m_ani.duration = 3;
				}
				else if (type == 1)
				{
					m_ani.setImageAni("ejtongquetaihuanghua.swf");//黄花
					m_ani.duration = 2;
				}
				else
				{
					m_ani.setImageAni("ejtongquetaitaohuan.swf");//桃花
					m_ani.duration = 1;
				}
				m_ani.x = -12;
				m_ani.y = 108;
				m_ani.repeatCount = 0;
				m_ani.centerPlay = true;// 居中播放
				m_ani.mouseEnabled = false;
				m_ani.setAutoStopWhenHide();
			}
			
			if (!this.contains(m_ani))
			{
				this.addChild(m_ani);
			}
			
			m_ani.begin();
		}
		
		protected function removeEff():void
		{
			if (m_ani)
			{
				this.removeChild(m_ani);
				m_ani.dispose();
				m_ani = null;
			}
		}
		protected function showChatAni():void
		{
			if (!m_talkPanel.parent)
			{
				addChild(m_talkPanel);
			}
			if (!m_aniPanel)
			{
				m_aniPanel = new AniPanel(m_talkPanel);
			}
			m_talkPanel.x = 18;//这里重新赋值是为了对动画播放时移动的位置进行修正
			m_talkPanel.y = -102;
			m_aniPanel.playAniForShow(m_talkPanel.x - 30, m_talkPanel.y + 30, m_talkPanel.x, m_talkPanel.y);
		}
		protected function hideChatAni():void
		{
			if (m_talkPanel.parent)
			{
				m_talkPanel.parent.removeChild(m_talkPanel);
			}
			if (m_aniPanel)
			{
				m_aniPanel.dispose();
				m_aniPanel = null;
			}
		}
		
		public function get isMyDancer():Boolean
		{
			return this is MyDancerModel;
		}
		
		public function get pos():int
		{
			return m_pos;
		}
		
		override public function dispose():void 
		{
			removeEff();
			hideChatAni();
			super.dispose();
			
			
		}
	}

}