package game.ui.herorally.myrecord 
{
	import com.ani.AniMiaobian;
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.herorally.msg.stViewUserZhanJiCmd;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sgQunYingCmd.stGetVicBoxCmd;
	import modulecommon.net.msg.sgQunYingCmd.UserZhanJi;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class BureauItem extends Component 
	{
		private var m_fightText:Label;
		private var m_result:Panel;
		private var m_look:ButtonText;
		private var m_box:Panel;
		private var m_id:uint;
		private var m_aniMiaobian:AniMiaobian;
		private var m_gkcontext:GkContext;
		public function BureauItem(gk:GkContext,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkcontext = gk;
			m_fightText = new Label(this);
			m_result = new Panel(this, 132, -1);
			m_look = new ButtonText(this, 156, -2, "查看", onLookClick);
			m_look.setSkinButton1Image("commoncontrol/panel/herorally/rebtn.png");
			m_box = new Panel(this, 204, -1);
			m_box.setPanelImageSkin("commoncontrol/panel/box.png");
			m_box.buttonMode = true;
			m_box.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			m_box.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			m_box.addEventListener(MouseEvent.CLICK, onBoxClick);
		}
		public function setDatas(info:UserZhanJi,num:uint):void
		{
			var arr:Array = ["一", "二", "三"];
			if (info.m_name == "")
			{
				m_fightText.text = "第" + arr[num] + "局 轮空";
			}
			else
			{
				m_fightText.text = "第" + arr[num] + "局 vs " + info.m_name;
			}
			if (info.m_result == 2)
			{
				m_result.visible = false;
				m_look.visible = false;
				m_box.visible = false;
				m_fightText.setFontColor(UtilColor.GRAY);
			}
			else
			{
				m_result.visible = true;
				if (info.m_result == 3)
				{
					m_look.visible = false;
				}
				else
				{
					m_look.visible = true;
				}
				if (info.m_result == 0)
				{
					m_result.setPanelImageSkin("commoncontrol/panel/herorally/fail.png");
					m_fightText.setFontColor(UtilColor.RED);
					m_box.visible = false;
				}
				else
				{
					m_result.setPanelImageSkin("commoncontrol/panel/herorally/win.png");
					m_fightText.setFontColor(UtilColor.YELLOW);
					if (info.m_rewardflag == 0)
					{
						m_box.visible = true;
						if (!m_aniMiaobian)
						{
							m_aniMiaobian = new AniMiaobian();
							m_aniMiaobian.sprite = m_box;
							m_aniMiaobian.setParam(6, UtilColor.GREEN, 1, 5);
							m_aniMiaobian.begin();
						}
					}
					else
					{
						m_box.visible = false;
					}
				}
			}
			m_id = info.m_zhanjiNo;
		}
		private function onRollOver(e:MouseEvent):void
		{
			//m_box.filtersAttr(true); 
			if (!m_gkcontext.m_heroRallyMgr.groupIfor())
			{
				return;
			}
			var str:String = m_gkcontext.m_heroRallyMgr.groupIfor().m_recordBoxTip;
			if (str)
			{
				var pt:Point = m_box.localToScreen();
				pt.x += 21;
				m_gkcontext.m_uiTip.hintHtiml(pt.x, pt.y, str,180);
			}
			
		}
		private function onRollOut(e:MouseEvent):void
		{
			m_gkcontext.m_uiTip.hideTip();
			//m_box.filtersAttr(false);
		}
		private function onLookClick(e:MouseEvent):void
		{
			var send:stViewUserZhanJiCmd = new stViewUserZhanJiCmd();
			send.m_zhanjiId = m_id;
			m_gkcontext.sendMsg(send);
		}
		private function onBoxClick(e:MouseEvent):void
		{
			var send:stGetVicBoxCmd = new stGetVicBoxCmd();
			send.m_zhanjiId = m_id;
			m_gkcontext.sendMsg(send);
		}
		public function updataBox():void
		{
			m_box.visible = false;
			if (m_aniMiaobian)
			{
				m_aniMiaobian.stop();
				m_aniMiaobian.dispose();
				m_aniMiaobian = null;
			}
		}
		override public function dispose():void 
		{
			if (m_box)
			{
				m_box.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				m_box.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
				m_box.removeEventListener(MouseEvent.CLICK, onBoxClick);
			}
			if (m_aniMiaobian)
			{
				m_aniMiaobian.dispose();
				m_aniMiaobian = null;
			}
			super.dispose();
		}
		
	}

}