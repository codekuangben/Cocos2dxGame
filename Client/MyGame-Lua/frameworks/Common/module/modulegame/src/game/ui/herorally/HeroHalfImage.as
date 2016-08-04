package game.ui.herorally 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import flash.display.DisplayObjectContainer;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sgQunYingCmd.MatchUserInfo;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.herorally.FieldTimeParam;
	import modulecommon.time.TimeItem;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class HeroHalfImage extends Component 
	{
		private var m_gkcontext:GkContext;
		private var m_halfImage:Panel;
		private var m_redbg:Panel;
		private var m_nameLabel:Label;
		private var m_levelLabel:Label;
		private var m_severLabel:Label;
		private var m_severNameLabel:Label;
		private var m_pipeiLabel:Label;
		private var m_detailLabel:Label;
		public function HeroHalfImage(gk:GkContext,mirror:Boolean=false,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkcontext = gk;
			m_halfImage = new Panel(this, 0, 0);
			
			if (mirror)
			{
				m_redbg = new Panel(this, -5, 250);
				m_redbg.setPanelImageSkinMirror("commoncontrol/panel/herorally/redbg.png", Image.MirrorMode_HOR);
			}
			else
			{
				m_redbg = new Panel(this, -55, 250);
				m_redbg.setPanelImageSkin("commoncontrol/panel/herorally/redbg.png");
			}
			m_nameLabel = new Label(this, 29, 264);
			m_nameLabel.setLetterSpacing(1);
			m_levelLabel = new Label(this, 195, 264);
			m_levelLabel.setLetterSpacing(1);
			m_levelLabel.align = RIGHT;
			m_severLabel = new Label(this, 29, 284, "服务器", UtilColor.YELLOW);
			m_severLabel.setLetterSpacing(1);
			m_severNameLabel = new Label(this, 195, 284, "", UtilColor.YELLOW);
			m_severNameLabel.setLetterSpacing(1);
			m_severNameLabel.align = RIGHT;
			m_pipeiLabel = new Label(this, 135, 206);
			m_pipeiLabel.setLetterSpacing(1);
			m_pipeiLabel.align = CENTER;
			m_detailLabel = new Label(this, 135, 186);
			m_detailLabel.setLetterSpacing(1);
			m_detailLabel.align = CENTER;
		}
		/**
		 * 打开界面onshow
		 * @param	isact	是否正在活动
		 * @param	data	活动时的数据 null为系统未匹配到对手
		 * @param	ismatch	3-不处于系统匹配时间 0、1、2-处于第几场
		 */
		public function setdata(isact:Boolean, data:MatchUserInfo = null, ismatch:uint = 3):void//这边四种情况1.data为null活动进行未匹配 2data为空活动进行轮空 3data有数据活动进行 4活动未开始
		{
			if (!isact)//活动未开始
			{
				m_nameLabel.text = "????";
				m_levelLabel.text = "lv ??";
				m_severNameLabel.text = "????";
				m_detailLabel.text = "不在活动时间";
				m_detailLabel.visible = true;
				m_pipeiLabel.visible = false;
				m_halfImage.setPanelImageSkin("commoncontrol/panel/herorally/shadow.png");
				return;
			}
			if (!data||!effectData(data.m_matchTime))//data为null活动进行未匹配
			{
				if (ismatch!=3)
				{
					var timeItem:FieldTimeParam = m_gkcontext.m_heroRallyMgr.timeParam[ismatch];
					if (timeItem)
					{
					var setimelist:Array = timeItem.m_timearea.split("-");
					var starttime:TimeItem = new TimeItem();
					starttime.parse_hourAndMinute(setimelist[0]);
					m_pipeiLabel.text = "匹配时间：" + setimelist[0] + "-" + starttime.hour + ":" + (starttime.min + 30);
					}
					m_nameLabel.text = "????";
					m_levelLabel.text = "lv ??";
					m_severNameLabel.text = "????";
					m_pipeiLabel.visible = true;
					m_detailLabel.text = "等待系统匹配对手";
					m_detailLabel.visible = true;
					m_halfImage.setPanelImageSkin("commoncontrol/panel/herorally/shadow.png");
				}
				else
				{
					m_nameLabel.text = "????";
					m_levelLabel.text = "lv ??";
					m_severNameLabel.text = "????";
					m_pipeiLabel.visible = false;
					m_detailLabel.text = "本场次未匹配对手";
					m_detailLabel.visible = true;
					m_halfImage.setPanelImageSkin("commoncontrol/panel/herorally/shadow.png");
				}
			}
			else if (data.m_name=="")//data为空活动进行轮空
			{
				m_nameLabel.text = "????";
				m_levelLabel.text = "lv ??";
				m_severNameLabel.text = "????";
				m_pipeiLabel.visible = false;
				m_detailLabel.text = "本场次轮空直接获得胜利";
				m_detailLabel.visible = true;
				m_halfImage.setPanelImageSkin("commoncontrol/panel/herorally/shadow.png");
			}
			else//data有数据活动进行
			{
				m_nameLabel.text = data.m_name;
				m_levelLabel.text = "lv "+data.m_level.toString();
				m_severNameLabel.text = m_gkcontext.m_context.m_platformMgr.getZoneName(data.m_serverId, data.m_serverNo);
				m_halfImage.setPanelImageSkin(NpcBattleBaseMgr.composehalfingPathName(m_gkcontext.m_context.m_playerResMgr.uiName(data.m_job, data.m_sex)));
				m_pipeiLabel.visible = false;
				m_detailLabel.visible = false;
			}
			
		}
		/**
		 * 数据有效性 验证数据时间是否为当前活动时间内
		 * @param	time 数据时间(s)
		 * @return	true 有效
		 */
		private function effectData(time:uint):Boolean
		{
			if (Math.abs(time-m_gkcontext.m_context.m_timeMgr.getCalendarTimeSecond()) < 3600)
			{
				return true;
			}
			return false;
		}
		public function setmydata():void
		{
			m_nameLabel.text = m_gkcontext.playerMain.name;
			m_levelLabel.text = "lv "+m_gkcontext.playerMain.level.toString();
			m_severNameLabel.text = m_gkcontext.m_context.m_platformMgr.getZoneName(m_gkcontext.playerMain.platform, m_gkcontext.playerMain.zoneID);
			m_halfImage.setPanelImageSkin(NpcBattleBaseMgr.composehalfingPathName(m_gkcontext.m_context.m_playerResMgr.uiName(m_gkcontext.playerMain.job, m_gkcontext.playerMain.gender)));
				
			m_detailLabel.visible = false;
		}
	}

}