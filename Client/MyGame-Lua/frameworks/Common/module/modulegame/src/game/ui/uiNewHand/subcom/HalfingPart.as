package game.ui.uiNewHand.subcom 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import flash.geom.Point;
	import flash.display.DisplayObjectContainer;
	import com.ani.AniPropertys;
	/**
	 * ...
	 * @author 
	 */
	public class HalfingPart extends Component 
	{
		private var m_right:Boolean;
		private var m_copy:Panel;
		private var m_bg:Panel;
		private var m_textPart:TextPart;
		
		protected var m_aniAlpha:AniPropertys;
		public function HalfingPart(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent,xpos,ypos);
			m_copy = new Panel();
			m_copy.setPanelImageSkin("commoncontrol/panel/mm.png");
			
			m_bg = new Panel(this);
			m_bg.setPanelImageSkin("commoncontrol/panel/mm.png");
			
			m_textPart = new TextPart(this);
			m_right = true;
			
			m_aniAlpha = new AniPropertys();
			m_aniAlpha.sprite = m_textPart;			
		}
		
		override public function dispose():void 
		{
			m_aniAlpha.dispose();
			m_aniAlpha = null;
			super.dispose();		
		}
		
		public function set(right:Boolean):void
		{
			if (m_right!=right)
			{
				if (right)
				{
					m_bg.setPanelImageSkin("commoncontrol/panel/mm.png");
				}
				else
				{
					m_bg.setPanelImageSkinMirror("commoncontrol/panel/mm.png", Image.MirrorMode_HOR);
				}
				m_right = right;
			}
			 
				
		}
		
		public function setText(text:String):void
		{
			var xPos:int;
			var yPos:int = 61;
			
			if (m_right)
			{
				xPos = 67;				
			}
			else
			{
				xPos = 172;				
			}
			m_textPart.showText(m_right, xPos, yPos, text);
		}
		
		//返回手指相对于点(this.x,this.y)的偏移
		public function getOffset():Point
		{
			var ret:Point = new Point();
			if (m_right)
			{
				ret.x = 231;
				ret.y = 80;
			}
			else
			{
				ret.x = 9;
				ret.y = 80;
			}
			return ret;
		}
		
		public function hideText():void
		{
			if (m_textPart.visible)
			{				
				m_aniAlpha.resetValues({alpha: 0});
				m_aniAlpha.duration = 0.2;	
				m_aniAlpha.onEnd = fadeOutEnd;
				m_aniAlpha.begin();
			}
		}
		
		public function showText(fadeIn:Boolean=true):void
		{
			if (m_textPart.visible == false)
			{				
				if (fadeIn)
				{
					m_aniAlpha.resetValues({alpha: 1});
					m_aniAlpha.duration = 0.2;
					m_aniAlpha.onEnd = fadeInEnd;
					m_aniAlpha.begin();
				}
				else
				{
					m_textPart.visible = true;
				}
			}
		}
		
		public function fadeInEnd():void
		{
			m_textPart.visible = true;
		}
		
		public function fadeOutEnd():void
		{
			m_textPart.visible = false;
		}
		
	}

}