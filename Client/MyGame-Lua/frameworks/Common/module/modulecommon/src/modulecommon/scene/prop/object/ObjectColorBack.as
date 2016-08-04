package modulecommon.scene.prop.object 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author ...
	 */
	public class ObjectColorBack extends PanelContainer
	{
		public static const COLOR_WHITE:int = 0;
		public static const COLOR_GREEN:int = 1;
		public static const COLOR_BLUE:int = 2;
		public static const COLOR_PURPLE:int = 3;
		public static const COLOR_GOLD:int = 4;
		
		private var m_gkContext:GkContext;
		private var m_ani:Ani;
		
		public function ObjectColorBack(gk:GkContext, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			
			this.mouseChildren = false;
			this.setSize(44, 44);
		}
		
		public function setIconBack(color:uint):void
		{
			var backRes:String;
			switch(color)
			{
				case COLOR_GREEN:
					backRes = "greenframe";
					break;
				case COLOR_BLUE:
					backRes = "blueframe";
					break;
				case COLOR_PURPLE:
					backRes = "purpleframe";
					break;
				case COLOR_GOLD:
					backRes = "goldframe";
					break;
			}
			if (backRes)
			{
				this.setPanelImageSkin("icon." + backRes);
				this.visible = true;
			}
			else
			{
				this.visible = false;
			}
		}
		
		//color:道具品质 type:特效类型
		public function setColorAni(color:uint, type:uint):void
		{
			var anitype:String;
			var aniRes:String;
			var duration:Number;
			switch(color)
			{
				case COLOR_GREEN:
					aniRes = "lv";
					duration = 1.8;
					break;
				case COLOR_BLUE:
					aniRes = "lan";
					duration = 1.8;
					break;
				case COLOR_PURPLE:
					aniRes = "zi";
					duration = 1.8;
					break;
				case COLOR_GOLD:
					aniRes = "jin";
					duration = 1.8;
					break;
				default:
					aniRes = null;
			}
			
			switch(type)
			{
				case ZObjectDef.ObjAniType_Neiguang:
					anitype = "ejzhuangbeineiguang";
					break;
				case ZObjectDef.ObjAniType_Xiaoguang:
					anitype = "ejzhuangbeixiaoguang";
					break;
				case ZObjectDef.ObjAniType_Huanrao:
					anitype = "ejzhuangbeihuanrao";
					break;
				default:
					anitype = null;
			}
			
			if (null == m_ani)
			{
				m_ani = new Ani(m_gkContext.m_context);
				m_ani.repeatCount = 0;
				m_ani.x = 22;
				m_ani.y = 22;
				m_ani.centerPlay = true;
				m_ani.mouseEnabled = false;
				m_ani.setAutoStopWhenHide();
			}
			
			if (aniRes && anitype)
			{
				m_ani.duration = duration;
				m_ani.setImageAni(anitype + aniRes + ".swf");
				m_ani.begin();
				
				if (!this.contains(m_ani))
				{
					this.addChild(m_ani);
				}
			}
			else
			{
				if (this.contains(m_ani))
				{
					this.removeChild(m_ani);
				}
			}
		}
		
		public function hide():void
		{
			this.visible = false;
			if (m_ani)
			{
				m_ani.stop();
				if (this.contains(m_ani))
				{
					this.removeChild(m_ani);
				}
			}
		}
		
		override public function dispose():void
		{
			if (m_ani && (null == m_ani.parent))
			{
				m_ani.dispose();
			}
			
			super.dispose();
		}
	}

}