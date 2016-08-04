package game.ui.uiTeamFBSys.teamhall
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.progressBar.BarInProgress2;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	import modulecommon.scene.benefithall.dailyactivities.Rewards;
	import game.ui.uiTeamFBSys.msg.stGainTeamAssistGiftUserCmd;
	import game.ui.uiTeamFBSys.msg.stRetTeamAssistInfoUserCmd;
	import game.ui.uiTeamFBSys.UITFBSysData;
	/**
	 * @brief 中间面板
	 */
	public class MidPnl extends Component
	{
		public var m_TFBSysData:UITFBSysData;
		
		protected var m_pnlProg:PnlProg;
		protected var m_rewardBox:RewardBox;

		public function MidPnl(data:UITFBSysData, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_TFBSysData = data;
			
			m_pnlProg = new PnlProg(data, this, 40, 70);
			
			var mat:Matrix = m_pnlProg.transform.matrix;
			mat.identity();
			mat.translate(0, -8);
			var radians:Number = 1.5 * Math.PI;
			mat.rotate(radians);
			mat.translate(40, 362);
			m_pnlProg.transform.matrix = mat;
			
			m_rewardBox = new RewardBox(m_TFBSysData, this);
			var reward:Rewards = new Rewards();
			m_rewardBox.setDatas("1");
		}
		
		public function psstRetTeamAssistInfoUserCmd(msg:ByteArray):void
		{
			var cmd:stRetTeamAssistInfoUserCmd = new stRetTeamAssistInfoUserCmd();
			cmd.deserialize(msg);
			
			//cmd.assistv = 35;
			//cmd.gainflag = 100;
			
			m_TFBSysData.m_assistv = cmd.assistv;
			m_TFBSysData.m_lastGiftId = cmd.boxid;
			m_TFBSysData.m_gainflag = cmd.gainflag;
			m_pnlProg.psstRetTeamAssistInfoUserCmd(cmd);
			m_rewardBox.psstRetTeamAssistInfoUserCmd(cmd);
		}
		
		public function psstGainTeamAssistGiftUserCmd(msg:ByteArray):void
		{
			var cmd:stGainTeamAssistGiftUserCmd = new stGainTeamAssistGiftUserCmd();
			cmd.deserialize(msg);
			
			m_TFBSysData.m_lastGiftId = cmd.boxid;
			m_TFBSysData.m_gainflag |= (1 << cmd.giftno);
			m_rewardBox.psstGainTeamAssistGiftUserCmd(cmd);
			// 更新一下进度条
			m_pnlProg.psstRetTeamAssistInfoUserCmd(null);
		}
	}
}