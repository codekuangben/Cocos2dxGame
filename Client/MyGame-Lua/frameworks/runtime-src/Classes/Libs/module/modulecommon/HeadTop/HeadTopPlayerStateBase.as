package modulecommon.headtop 
{
	import com.bit101.components.Ani;
	
	import flash.events.MouseEvent;
	
	import modulecommon.GkContext;
	import modulecommon.scene.beings.Player;
	import modulecommon.scene.beings.PlayerOther;
	import modulecommon.scene.beings.PlayerMain;
	import com.bit101.components.Panel;
	
	/**
	 * ...
	 * @author ...
	 * 玩家状态头顶显示: 打坐、
	 */
	public class HeadTopPlayerStateBase extends HeadTopBlockBase
	{		
		protected var m_player:Player;
		protected var m_displayControl:DisplayControlBase;
		private var m_dazuoBall:Ani;//打坐时，头顶的光球
		private var m_nameGM:Panel;
		
		public function HeadTopPlayerStateBase(gk:GkContext, player:Player) 
		{
			super(gk);
			m_player = player;
		}

		override public function update():void
		{
			var controlClass:Class = null;
			clearAutoData();
			if (m_gkContext.m_sanguozhanchangMgr.inZhanchang)
			{
				controlClass = DisplayForSanguoZhanChang;
			}
			if (controlClass != null)
			{
				if (m_displayControl != null)
				{
					if (!(m_displayControl is controlClass))
					{
						m_displayControl.dispose();
						m_displayControl = null;
					}
				}
				if (m_displayControl == null)
				{
					m_displayControl = new controlClass(this);
				}
				m_displayControl.update();			
			}
			else
			{
				if (m_displayControl != null)
				{
					m_displayControl.dispose();
					m_displayControl = null;
				}
				showNormal();
			}			
		}
		
		protected function showNormal():void
		{			
			addName(0x00deff);
			addCorpsName(0x00deff);
			addGuanzhiNameInArena(0xffde00);
		}

		public function addName(color:uint):void
		{
			var str:String;
			if (m_gkContext.versonForOut)
			{
				str = m_player.name;
			}
			else
			{
				str = "charID:" + m_player.charID + m_player.name;
			}
			addAutoData(str, color, 14);
		}
		
		//玩家名字前加区名称
		public function addNameWithZone(color:uint):void
		{
			var str:String = "【" + m_gkContext.m_context.m_platformMgr.getZoneName(m_player.platform, m_player.zoneID) + "】" + m_player.name;
			addAutoData(str, color, 14);
		}

		public function addCorpsName(color:uint):void
		{
			var str:String;
			if (this is PlayerMainHeadTopBlock)
			{
				if (m_gkContext.m_corpsMgr.hasCorps)
				{
					str = m_gkContext.m_corpsMgr.m_corpsName;
				}
			}
			else
			{
				str = (m_player as PlayerOther).m_corpsName;
			}
			if (str && str.length)
			{
				str = "<" + str + ">";
				//addAutoData(str, 0x00deff, 14);
				addAutoData(str, color, 14);
			}
		}

		public function addGuanzhiNameInArena(color:uint):void
		{
			var str:String;
			str = m_player.guanzhiName;
			if (str && str.length)
			{
				//addAutoData(str, 0xffde00, 14);
				addAutoData(str, color, 14);
			}
		}
		
		public function addCorpsCoolTime(color:uint):void
		{
			if ((m_player as PlayerMain).cooltime)
			{
				//if ((m_player as PlayerMain).coolType == 0)
				//{
					addAutoData("战斗冷却: " + (int)((m_player as PlayerMain).cooltime), color, 14);
				//}
				//else
				//{
				//	addAutoData("移动冷却: " + (int)((m_player as PlayerMain).cooltime), color, 14);
				//}
			}
		}
		
		//三国战场中
		protected function showForZhanchang():void
		{
			
		}

		public function showDazuoBall():void
		{
			if (null == m_dazuoBall)
			{
				m_dazuoBall = new Ani(m_gkContext.m_context);
				this.addChild(m_dazuoBall);
				m_dazuoBall.centerPlay = true;
				m_dazuoBall.x = 0;
				m_dazuoBall.y = 18;
				m_dazuoBall.setImageAni("ejdazuojingyanqiu.swf");
				m_dazuoBall.duration = 1
				m_dazuoBall.repeatCount = 0;
				m_dazuoBall.begin();
				m_dazuoBall.buttonMode = true;
				m_dazuoBall.addEventListener(MouseEvent.CLICK, onClickStateBtn);
				m_dazuoBall.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownBtn);
			}
			
			if (m_dazuoBall.parent != this)
			{
				this.addChild(m_dazuoBall);
			}
		}
		public function showGMName():void
		{
			if (null == m_nameGM)
			{
				m_nameGM = new Panel(this, -145);
				m_nameGM.setPanelImageSkin("commoncontrol/panel/gmname.png");
			}
			m_nameGM.y = curTop - 30;
			curTop = m_nameGM.y;			
		}
		public function hideDazuoBall():void
		{
			if (m_dazuoBall && m_dazuoBall.parent)
			{
				m_dazuoBall.parent.removeChild(m_dazuoBall);
			}
		}
		
		public function onMouseDownBtn(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		public function onClickStateBtn(event:MouseEvent):void
		{
			var list:Array = new Array();
			list.push(m_player.tempid);
			m_gkContext.m_dazuoMgr.reqOtherFuyouTimes(list);
		}
		
		override public function dispose():void
		{
			if (m_displayControl)
			{
				m_displayControl.dispose();
				m_displayControl = null;
			}
			if (m_dazuoBall && null == m_dazuoBall.parent)
			{
				m_dazuoBall.removeEventListener(MouseEvent.CLICK, onClickStateBtn);
				m_dazuoBall.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownBtn);
				m_dazuoBall.dispose();
			}
			
			super.dispose();
		}

		public function get player():Player
		{
			return m_player;
		}	
	}
}