package game.ui.uiTeamFBSys.teamhall 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.progressBar.BarInProgress2;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import game.ui.uiTeamFBSys.msg.stGainTeamAssistGiftUserCmd;
	import game.ui.uiTeamFBSys.msg.stRetTeamAssistInfoUserCmd;
	import game.ui.uiTeamFBSys.UITFBSysData;
	/**
	 * @brief 进度条面板存储在这里
	 */
	public class PnlProg extends Component
	{
		public var m_TFBSysData:UITFBSysData;
		
		private var m_activeValueBar:BarInProgress2;	//活跃值进度条，这个是第一条，表示能否领取当前奖励的提示
		//private var m_activeValueBar1f:BarInProgress2;	//活跃值进度条，这个是第二条，第一条满了就出现第二条
		protected var m_barbg:Panel;
		protected var m_pnlVec:Vector.<Panel>;
		
		public function PnlProg(data:UITFBSysData, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_TFBSysData = data;
			
			m_activeValueBar = new BarInProgress2(this, 22, 3);
			m_activeValueBar.setSize(248, 11);
			m_activeValueBar.autoSizeByImage = false;
			m_activeValueBar.setPanelImageSkin("commoncontrol/panel/barblue.png");
			m_activeValueBar.maximum = 1;
			m_activeValueBar.initValue = 0;
			
			m_activeValueBar.value = 0;
			
			//m_activeValueBar1f = new BarInProgress2(this, 22, 3);
			//m_activeValueBar1f.setSize(248, 11);
			//m_activeValueBar1f.autoSizeByImage = false;
			//m_activeValueBar1f.setPanelImageSkin("commoncontrol/panel/barpurple.png");
			//m_activeValueBar1f.maximum = 1;
			//m_activeValueBar1f.initValue = 0;
			
			//m_activeValueBar1f.value = 0;
			//m_activeValueBar1f.visible = false;
			
			m_barbg = new Panel(this, 0, 0);
			m_barbg.setSize(292, 17);
			m_barbg.setHorizontalImageSkin("commoncontrol/horstretch/progressBg2_mirror.png");
			
			var panel:Panel;
			var i:int = 0;
			m_pnlVec = new Vector.<Panel>(9, true);
			for (i = 0; i < 9; i++)
			{
				m_pnlVec[i] = new Panel(m_barbg, 45 + i * 25, 1);
				m_pnlVec[i].setPanelImageSkin("commoncontrol/panel/lattice.png");
			}
			
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		override public function dispose():void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			super.dispose();
		}
		
		private function onRollOver(event:MouseEvent):void
		{
			UtilHtml.beginCompose();
			UtilHtml.add("当前助人值: " + m_TFBSysData.m_assistv + "<br>自己副本无法获得奖励时，帮助别人下组队副本或挑战组队BOSS可获得助人值，助人值达到10,30,50,70,90可领取助人礼品箱，每日最多领取5个助人礼品箱", UtilColor.WHITE);
			var pt:Point = this.localToScreen(new Point(20, 20));
			m_TFBSysData.m_gkcontext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent());
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			m_TFBSysData.m_gkcontext.m_uiTip.hideTip();
		}
		
		public function psstRetTeamAssistInfoUserCmd(cmd:stRetTeamAssistInfoUserCmd):void
		{
			// 10,30,50,70,90
			// 一个进度条显示满级 90 点值，一个进度条显示 25 点值
			//if (cmd.assistv <= 45)
			//{
				//m_activeValueBar1f.visible = false;
				//m_activeValueBar.value = cmd.assistv / 45;
			//}
			//else
			//{
				//m_activeValueBar1f.visible = true;
				
				//m_activeValueBar.value = 1;
				//m_activeValueBar1f.value = (cmd.assistv - 45) / 45;
			//}
			
			// 仅仅表示当前可领取的礼包的进度
			var valueVec:Vector.<uint> = new Vector.<uint>(6, true);
			valueVec[0] = 0;		// 0 的时候可以领取一个
			valueVec[1] = 10;		// 10 的时候可以领取一个
			valueVec[2] = 30;		// 30 的时候可以领取一个
			valueVec[3] = 50;		// 50 的时候可以领取一个
			valueVec[4] = 70;		// 70 的时候可以领取一个
			valueVec[5] = 90;		// 90 的时候可以领取一个

			var idx:int = 1;		// 当前可领取的索引
			if (m_TFBSysData.m_gainflag)	// 如果有值，需要从第一位开始查找，下标从 0 开始
			{
				while (idx < 32)
				{
					if (!(m_TFBSysData.m_gainflag & (1 << idx)))	// 找到第一个 0 
					{
						break;
					}
					
					++idx;
				}
			}
			else
			{
				idx = 1;
			}
			
			if (idx < 6)
			{
				m_activeValueBar.value = m_TFBSysData.m_assistv/valueVec[idx];
			}
			else	// 如果都领过了
			{
				m_activeValueBar.value = 0;
			}
		}
	}
}