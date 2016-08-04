package modulefight.ui.tip
{
	//import com.bit101.components.Label;
	import flash.display.Sprite;
	import flash.geom.Point;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.netmsg.stmsg.stEntryState;
	import modulefight.scene.fight.FightGrid;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UIBattleTip extends Form
	{		
		private var m_curSP:Sprite;
		private var m_tipArmy:TipArmy;
		private var m_tipBuffer:TipBuffer;
		public function UIBattleTip()
		{
			this.id = UIFormID.UIBattleTip;
		}
		
		override public function onReady():void
		{			
			this.exitMode = EXITMODE_HIDE;		
			super.onReady();
		}
		
		public function showTipArmy(pos:Point, npc:NpcBattle):void
		{
			
			if (m_tipArmy == null)
			{
				m_tipArmy = new TipArmy(m_gkcontext, this);				
			}
			addTip(m_tipArmy);
			m_tipArmy.showTip(npc);			
			
			this.show();
			var xPos:Number = pos.x + 30;
			var yPos:Number = pos.y + 30;
			var widthStage:int = m_gkcontext.m_context.m_config.m_showWidth;
			var heightStage:int = m_gkcontext.m_context.m_config.m_showHeight;
			if (xPos + m_tipArmy.width > widthStage)
			{
				xPos = widthStage-m_tipArmy.width;
			}
			
			if (yPos + m_tipArmy.height > heightStage)
			{
				yPos = heightStage-m_tipArmy.height;
			}
			
			this.setPos(xPos, yPos);
			
		}
		public function update(grid:FightGrid):void
		{
			if (m_curSP == m_tipArmy && m_tipArmy != null)
			{
				m_tipArmy.update(grid);
			}
		}
		override public function onShow():void
		{
			
		}
		public function showTipBuffer(pos:Point, state:stEntryState):void
		{
			if (m_tipBuffer == null)
			{
				m_tipBuffer = new TipBuffer(m_gkcontext, this);				
			}
			addTip(m_tipBuffer);
			m_tipBuffer.showTip(state);			
			
			this.setPos(pos.x, pos.y);
			this.show();
		}
		protected function removeCurSprite():void
		{
			if (m_curSP != null)
			{
				if (this.contains(m_curSP))
				{
					this.removeChild(m_curSP);
				}
				m_curSP = null;
			}
		}	
		
		protected function addTip(sp:Sprite):void
		{
			removeCurSprite();
			m_curSP = sp;
			this.addChild(m_curSP);
		}		
		
		public function hideTip():void
		{
			if (this.isVisible() == false)
			{
				return;
			}
			removeCurSprite();
			this.exit();
		}
		
		public function onNpcBattleDispose(npc:NpcBattle):void
		{
			if (m_tipArmy && m_tipArmy.curNpcBattle == npc)
			{
				m_tipArmy.onNpcBattleDispose(npc);
				if (m_curSP == m_tipArmy)
				{
					hideTip();
				}
			}
		}
		
	}

}