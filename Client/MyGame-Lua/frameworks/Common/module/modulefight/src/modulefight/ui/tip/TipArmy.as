package modulefight.ui.tip
{
	import com.bit101.components.Label;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.progressBar.ProgressBar;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	import com.util.UtilHtml;
	import modulefight.netmsg.stmsg.stMatrixInfo;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import modulecommon.GkContext;
	import modulecommon.res.ResGrid9;
	//import modulecommon.scene.prop.table.DataTable;
	//import modulecommon.scene.prop.table.TRoleStateItem;
	
	import modulefight.netmsg.stmsg.stEntryState;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.scene.fight.FightGrid;
	import modulefight.ui.battlehead.BattleHPBarInProgressLeft;
	
	import com.util.UtilColor;
	import com.bit101.components.TextNoScroll;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class TipArmy extends PanelContainer
	{
		private var m_gkContext:GkContext;
		private var m_name:Label;
		private var m_level:Label;
		
		private var m_hpName:Label;
		private var m_shiqiName:Label;
		private var m_speedLabel:Label;
		private var m_zhanshuName:Label;
		private var m_zhanshuValue:Label;
		private var m_hpProgressBar:ProgressBar;
		private var m_shiqiProgressBar:ProgressBar;
		
		private var m_tianfuText:TextNoScroll;
		private var m_lblBuff:TextNoScroll;
		
		private var m_curNpc:NpcBattle;
		
		public function TipArmy(gk:GkContext, parent:DisplayObjectContainer = null)
		{
			m_gkContext = gk;
			this.setSize(150, 100);
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
			m_name = new Label(this, 10, 10);
			m_level = new Label(this, 80, 10);
			
			m_hpName = new Label(this, 10, 35);
			m_hpName.setFontColor(0xcccccc);
			m_hpName.text = "兵力：";
			m_hpProgressBar = new ProgressBar(m_hpName, 37, 5);
			m_hpProgressBar.setSize(90, 8);
			m_hpProgressBar.setHorizontalImageSkin("commoncontrol/horstretch/progressBg_mirror.png");
			m_hpProgressBar.setBar(new BattleHPBarInProgressLeft(m_gkContext));
			(m_hpProgressBar.bar as BattleHPBarInProgressLeft)._bg.setHorizontalImageSkin("commoncontrol/horstretch/progressRed_mirror.png");
			(m_hpProgressBar.bar as BattleHPBarInProgressLeft).setSize(90, 8);
			
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0xff0000);
			sprite.graphics.drawRoundRect(0, 1, 90, 6, 6, 6);
			sprite.graphics.endFill();
			(m_hpProgressBar.bar as BattleHPBarInProgressLeft)._topShade.addChild(sprite);
			(m_hpProgressBar.bar as BattleHPBarInProgressLeft)._topShade.mask = sprite;
			
			m_shiqiName = new Label(this, 10, 55);
			m_shiqiName.setFontColor(0xcccccc);
			m_shiqiName.text = "士气：";
			m_shiqiProgressBar = new ProgressBar(m_shiqiName, 37, 5);
			m_shiqiProgressBar.setSize(90, 8);
			m_shiqiProgressBar.setHorizontalImageSkin("commoncontrol/horstretch/progressBg_mirror.png");
			m_shiqiProgressBar.setBar(new BattleHPBarInProgressLeft(m_gkContext));
			(m_shiqiProgressBar.bar as BattleHPBarInProgressLeft)._bg.setHorizontalImageSkin("commoncontrol/horstretch/progressBlue_mirror.png");
			(m_shiqiProgressBar.bar as BattleHPBarInProgressLeft).setSize(90, 8);
			m_shiqiProgressBar.maximum = 100;
			
			m_speedLabel = new Label(this, 10, 75);
			m_speedLabel.setFontColor(0xcccccc);
			
			sprite = new Sprite();
			sprite.graphics.beginFill(0xff0000);
			sprite.graphics.drawRoundRect(0, 1, 90, 6, 6, 6);
			sprite.graphics.endFill();
			(m_shiqiProgressBar.bar as BattleHPBarInProgressLeft)._topShade.mask = sprite;
			
			m_zhanshuName = new Label(this, 10, 95);
			m_zhanshuName.setFontColor(0xcccccc);
			m_zhanshuName.text = "技能：";
			m_zhanshuValue = new Label(this, 50, 95);
			
			
			m_tianfuText = new TextNoScroll(this, 10,115);		
			m_tianfuText.width = 155;
			m_tianfuText.height = 50;
			m_tianfuText.setBodyCSS(UtilColor.WHITE, 12);	
			m_tianfuText.setMiaobian();
			
			// buff 描述
			m_lblBuff = new TextNoScroll(this, 10,115);		
			m_lblBuff.width = 155;
			m_lblBuff.height = 50;
			m_lblBuff.setBodyCSS(UtilColor.WHITE, 12);	
			m_lblBuff.setMiaobian();
		}
		
		public function showTip(npc:NpcBattle):void
		{
			var grid:FightGrid = npc.fightGrid;
			var mat:stMatrixInfo = grid.matrixInfo;
			m_curNpc = npc;
			m_name.text = npc.name;
			m_name.setBold(true);
			m_name.setFontSize(14);
			m_name.setFontColor(npc.colorValue);
			m_name.flush();
			
			//m_level.x = m_name.x + m_name.width + 30;
			m_level.text = "LV:" + mat.level.toString();
			m_level.flush();
			m_level.x = this.width - 10 - m_level.width;
			
			m_hpProgressBar.maximum = grid.maxHp;
			m_hpProgressBar.initValue = grid.curHp;
			m_hpProgressBar.initBar();
			
			var shiqi:uint = npc.shiqi;
			if (shiqi > 100)
			{
				shiqi = 100;
			}
			m_shiqiProgressBar.initValue = shiqi;
			m_shiqiProgressBar.initBar();
			
			m_speedLabel.text = "速度： " + mat.speed;
			m_zhanshuValue.text = mat.zhanshuName;
			
			var top:Number = m_tianfuText.y;
			UtilHtml.beginCompose();
			var tianfuSkillBase:TSkillBaseItem = mat.activeTianfuSkillItem;
			if (tianfuSkillBase)
			{				
				UtilHtml.add(tianfuSkillBase.m_desc, UtilColor.GREEN);
				m_tianfuText.setBodyHtml(UtilHtml.getComposedContent());
				m_tianfuText.visible = true;
				
				top = m_tianfuText.y + m_tianfuText.height + 7;
			}
			else
			{
				m_tianfuText.visible = false;
			}
			
			// 继续显示当前武将所中状态 buff, 增益状态为绿色字，减益状态为红色字表示
			
			var bufferList:Vector.<stEntryState> = grid.getEntryStates();
			if (bufferList&&bufferList.length>0)
			{
				UtilHtml.beginCompose();
				var buffer:stEntryState;
				var color:uint;
				for each (buffer in bufferList)
				{
					if (buffer.base.mode == 1) // 增益
					{
						color = UtilColor.GREEN;
					}
					else // 减益
					{
						color = UtilColor.RED;						
					}
					var desc:String = buffer.stateDesc.replace("aa", buffer.value.toString());
					UtilHtml.add("【" + buffer.name + "】" + desc, color);					
				}
				
				m_lblBuff.setBodyHtml(UtilHtml.getComposedContent());
				m_lblBuff.visible = true;
				m_lblBuff.y = top;
				top += m_lblBuff.height + 7;
			}
			else
			{
				m_lblBuff.visible = false;
			}
			
			
			
			this.setSize(170, top+6);
		}
		
		public function update(grid:FightGrid):void
		{
			if(m_curNpc&&m_curNpc.fightGrid==grid)			
			{
				m_hpProgressBar.value = grid.curHp;
				var shiqi:uint = grid.shiqi;
				if (shiqi > 100)
				{
					shiqi = 100;
				}
				m_shiqiProgressBar.value = shiqi;
			}
		}
		
		public function get curNpcBattle():NpcBattle
		{
			return m_curNpc;
		}
		public function onNpcBattleDispose(npc:NpcBattle):void
		{
			m_curNpc = null;
		}
		
	}

}