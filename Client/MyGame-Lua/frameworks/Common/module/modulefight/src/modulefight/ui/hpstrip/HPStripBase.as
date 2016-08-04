package modulefight.ui.hpstrip 
{
	import modulefight.ui.battlehead.BattleHPBarInProgressMulBase;
	import modulefight.ui.BufferPanel;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.progressBar.ProgressBar;
	import com.pblabs.engine.entity.EntityCValue;
	import modulecommon.commonfuntion.SysNewFeatures;
	import com.util.UtilHtml;
	import modulefight.scene.fight.FightDB;
	
	import modulecommon.GkContext;
	//import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulefight.netmsg.stmsg.stMatrixInfo;
	import modulefight.scene.fight.FightGrid;
	import modulefight.ui.battlehead.BattleHPBarInProgressLeft;
	import modulefight.ui.battlehead.BattleHPBarInProgressRightMul;
	import modulefight.netmsg.stmsg.stEntryState;
	/**
	 * ...
	 * @author 
	 */
	public class HPStripBase extends Component 
	{
		protected var m_gkContext:GkContext;
		protected var m_side:int;
		protected var m_fightGrid:FightGrid;	
		protected var m_fightDB:FightDB;
		protected var m_barClass:Class;
		
		protected var m_name:Label;
		
		protected var m_progressBack:PanelContainer;
		protected var m_progressBar:ProgressBar;
		protected var m_numLayer:int;
		
		protected var m_addBuffList:Vector.<BufferPanel>;
		protected var m_debuffList:Vector.<BufferPanel>;
		protected var m_bufferInterval:Number;
		
		public function HPStripBase(grid:FightGrid, gk:GkContext) 
		{
			m_gkContext = gk;
			m_fightGrid = grid;
			m_fightDB = m_fightGrid.m_fightDB;
			
			m_name = new Label(this);
			m_progressBack = new PanelContainer(this, 0, 3);
			m_progressBar = new ProgressBar(m_progressBack, 8, 4);
			m_progressBack.setHorizontalImageSkin("commoncontrol/horstretch/hpback_mirror.png");			
			
			m_addBuffList = new Vector.<BufferPanel>();
			m_debuffList = new Vector.<BufferPanel>();
		}
		
		public function initData():void
		{
			var newNumLayer:int;
			var mat:stMatrixInfo = m_fightGrid.matrixInfo;
			var nameY:Number = 16;
			
			if (mat.m_beingType == stMatrixInfo.BEINGTYPE_BOSS || mat.m_beingType == stMatrixInfo.BEINGTYPE_Jingying)
			{
				if (mat.m_npcBase.m_iLevel <= 15)
				{
					newNumLayer = 1;
				}
				else if (mat.m_npcBase.m_iLevel <= 25)
				{
					newNumLayer = 2;
				}
				else
				{
					newNumLayer = 3;
				}
			}
			else
			{
				newNumLayer = 1;
			}
			
			if (m_numLayer != newNumLayer)
			{
				m_numLayer = newNumLayer;
				removeProgressBar();
				m_progressBar = new ProgressBar(m_progressBack, 8,4);
				m_progressBar.setBar(new m_barClass(m_gkContext));
				var bar:BattleHPBarInProgressMulBase = m_progressBar.bar as BattleHPBarInProgressMulBase;
				
				if (m_numLayer == 1)
				{
					m_progressBack.setSize(81, 15);
					bar.setParam(65, 7, ["commoncontrol/panel/hp.png"]);
				}
				else if (m_numLayer == 2)
				{
					bar.setParam(115,7,["commoncontrol/panel/hp.png", "commoncontrol/panel/hp_blue.png"]);
					m_progressBack.setSize(131, 15);
				}
				else
				{
					bar.setParam(115,7,["commoncontrol/panel/hp.png", "commoncontrol/panel/hp_blue.png", "commoncontrol/panel/hp_green.png"]);					
					m_progressBack.setSize(131, 15);					
				}			
			}
			m_progressBar.initValue = m_fightGrid.curHp / m_fightGrid.maxHp;;
			m_progressBar.initBar();
			
			var color:uint;
			if (mat.isWu&&mat.add == 3)
			{
				color = 0xffd800;	//当武将为神将，战斗界面中武将名字变色为ffd800
			}
			else
			{
				color = mat.nameColor;
			}
			UtilHtml.beginCompose();
			UtilHtml.add(mat.name, color);
			
			/*if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_WUJIANGJIHUO)&&mat.isWu)
			   {
			   UtilHtml.add(" [" + mat.actnum + "激活]", 0x32D991);
			 }	*/
			
			m_name.htmlText = UtilHtml.getComposedContent();
			m_name.flush();
			
			m_progressBack.x = -m_progressBack.width / 2;
			m_name.x = m_progressBack.x + (m_progressBack.width - m_name.width) / 2;
			m_name.y = nameY;
		}
		
		protected function removeProgressBar():void
		{
			if (m_progressBar)
			{
				m_progressBar.parent.removeChild(m_progressBar);
				m_progressBar.dispose();
				m_progressBar = null;
			}
		}
		public function updateHP():void
		{
			m_progressBar.value = m_fightGrid.curHp / m_fightGrid.maxHp;
		}		
		
		public function addBuffer(entrystate:stEntryState):void
		{
			var panel:BufferPanel = new BufferPanel(m_gkContext, m_fightDB);
			panel.scaleX = 0.75;
			panel.scaleY = 0.75;
			panel.setBufferState(entrystate);
			this.addChild(panel);
			disposeAllBuffer();
			m_addBuffList.push(panel);
			addjustPos();
			/*var list:Vector.<BufferPanel>;
			
			if (entrystate.mode == 1)	//增益
			{
				list = m_addBuffList;				
			}
			else
			{
				list = m_debuffList;				
			}
			list.push(panel);
			addjustPos();		*/	
		}
		public function deleteBuffer(entrystate:stEntryState):void
		{			
			var index:int = 0;
			for (index = 0; index < m_addBuffList.length; index++)
			{
				var panel:BufferPanel = m_addBuffList[index];
				if (panel.bufferState == entrystate)
				{
					this.removeChild(panel);
					panel.dispose();
					m_addBuffList.splice(index, 1);
					break;
				}
			}			
			addjustPos();			
		}
		public function addjustPos():void
		{
			var left:int = 0;
			var top:int = 0;
			
			if (m_fightGrid.side == EntityCValue.RKLeft)
			{
				left = m_progressBack.x + m_progressBack.width+5;
			}
			else
			{
				left = m_progressBack.x + m_bufferInterval-5;
			}
			if (m_debuffList.length > 0 && m_addBuffList.length>0)
			{
				top = -30;
			}
			else
			{
				top = -5;
			}
			var i:int;
			for (i = 0; i < m_addBuffList.length; i++)
			{
				m_addBuffList[i].setPos(left, top);
				left += m_bufferInterval;
			}
			
			
			if (m_addBuffList.length > 0)
			{
				top += 25;
			}
			for (i = 0; i < m_debuffList.length; i++)
			{
				m_debuffList[i].setPos(left, top);
				left += m_bufferInterval;
			}
		}	
		//去掉所有buffer
		public function disposeAllBuffer():void
		{
			var i:int;
			for (i = 0; i < m_addBuffList.length; i++)
			{
				this.removeChild(m_addBuffList[i]);
				m_addBuffList[i].dispose();
			}
			m_addBuffList.length = 0;
			for (i = 0; i < m_debuffList.length; i++)
			{
				this.removeChild(m_debuffList[i]);
				m_debuffList[i].dispose();
			}
			m_debuffList.length = 0;
		}
		
	}

}