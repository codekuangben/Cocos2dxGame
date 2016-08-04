package modulefight.ui.battlehead
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import modulefight.netmsg.stmsg.stUserInfo;
	//import com.bit101.components.progressBar.ProgressBar;
	//import com.bit101.components.Label;
	//import com.dgrigg.image.PanelImage;
	//import common.logicinterface.ICommonImageManager;
	import flash.display.Shape;
	import modulecommon.GkContext;
	//import modulecommon.scene.prop.table.TNpcBattleItem;
	//import modulefight.netmsg.fight.stAttackResultUserCmd;
	//import modulefight.netmsg.stmsg.stArmy;
	//import modulefight.netmsg.stmsg.stJinnang;
	//import com.pblabs.engine.resource.SWFResource;
	import com.dgrigg.image.Image;
	//import modulefight.netmsg.stmsg.stMatrixInfo;
	//import modulefight.scene.fight.FightGrid;
	import com.pblabs.engine.entity.EntityCValue;
	import modulecommon.appcontrol.DigitComponent;
	
	import com.bit101.components.Ani;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class BattleHeadRightPanel extends BattleHeadPanel
	{		
		public function BattleHeadRightPanel(gk:GkContext, ui:UIBattleHead)
		{
			super(EntityCValue.RKRight, gk, ui);
			m_levelLabel.setPos(-91, 89);
		}
				
		override public function drawBG():void
		{
			m_bg.x = -m_bg.width;
			m_bg.beginDraw();
			var panel:Panel;
			
			//var left:Number = 0;
			var panelContainer:Panel;
			var shape:Shape = new Shape();			
			shape.y = 7;
			shape.x = 10;
			panelContainer = new Panel();
			panelContainer.y = 6;			
			
			shape.graphics.beginFill(0);
			shape.graphics.drawCircle(46, 46, 46);
			shape.graphics.endFill();
			
			panelContainer.addChild(shape);
			
			panel = new Panel(panelContainer);		
			panel.setPanelImageSkinMirror("commoncontrol/panel/battleframe.png", Image.MirrorMode_HOR);
			
			panel = new Panel(panelContainer, 8,77);	
			panel.setPanelImageSkin("commoncontrol/panel/round_bg.png");
			panel.visible = false;
			
			var user:stUserInfo = m_curArmy.userInfoForHeadportrait;
			if (user.level)
			{
				panel.visible = true;
			}
			
			
			panel = new Panel(panelContainer);
			panel.x = 0;
			panel.y = -13;			
			var resName:String;
			if (m_curArmy.isPlayer)
			{
				resName = m_gkContext.m_context.m_playerResMgr.roundHeadPathName(user.job, user.sex);
			}
			else
			{
				resName = "roundhead/monster_default.png";
			}
			panel.setPanelImageSkin(resName);
					
			m_bg.addDrawCom(panelContainer);
			m_bg.drawPanel();
			
			// 显示战力
			if(user.zhanli)	// 只有玩家才显示,跟怪物不显示,大于 0 就显示
			{
				// 战力显示
				var pnlZLBg:Panel;		// 战力背景
				var pnlZLDesc:Panel;		// 战力描述
				var zlDigit:DigitComponent;// 战力数字
				
				var zlbaseX:Number = 0;
				var zlbaseY:Number = 0;
				// 如果存在就是有锦囊
				if(user.jinnang.id)
				{
					zlbaseX = -203 - 158;
					zlbaseY = 31;
				}
				else
				{
					zlbaseX = -203 + (98 - 158);
					//zlbaseX = 0;
					zlbaseY = 31;
				}
				if(!m_pnlZLBg)
				{
					m_pnlZLBg = new Panel(m_pnlZLBgContainer, zlbaseX, zlbaseY);
					m_pnlZLBg.setPanelImageSkinMirror("commoncontrol/panel/battlezhanlibg.png", Image.MirrorMode_HOR);
					
					m_pnlZLDesc = new Panel(m_pnlZLBg, 5, 5);
					m_pnlZLDesc.setPanelImageSkin("commoncontrol/panel/zhanli.png");;	// (40, 27)
					
					m_zlDigit = new DigitComponent(m_gkContext.m_context, m_pnlZLBg, 50, 10);				
					m_zlDigit.setParam("commoncontrol/digit/digit01",10,18);	// 红色数字
				}
				m_zlDigit.digit = user.zhanli;
				m_pnlZLDesc.setPos(113 - m_zlDigit.width, 5);
				m_zlDigit.setPos(158 - m_zlDigit.width, 10);
			}
			
		}
		override public function createJinnangUI():void
		{
			m_jinnangBG = new PanelContainer(this);
			m_jnGrid = new BatJinnangGrid(m_gkContext);
		
			m_jinnangBG.addChild(m_jnGrid);
			
			this.swapChildren(m_jinnangBG, m_bg);
			this.setChildIndex(m_levelLabel, this.numChildren - 1);
			m_jinnangBG.setPanelImageSkinMirror("commoncontrol/panel/battlejinnang.png", Image.MirrorMode_HOR);			
			m_jinnangBG.setPos(-203, 32);		// (98 * 60)
			m_jnGrid.setPos(35, 7);			
		}
		/*public function updateInfo(army:stArmy):void
		{
			var i:int = 0;
						
			var type:uint;
			var mat:stMatrixInfo;
			for (i = 0; i < army.matrixList.length; i++)
			{
				mat = army.matrixList[i];
				
				if (mat.tempid == uint.MAX_VALUE)
				{
					type = uint.MAX_VALUE;
					break;
				}
				else
				{
					if (mat.m_npcBase.m_iType == TNpcBattleItem.TYPE_BOSS || mat.m_npcBase.m_iType == TNpcBattleItem.TYPE_Jingying)
					{
						type = mat.m_npcBase.m_iType;
						break;
					}
				}
				
			}
			var layers:Vector.<Panel>;
			if (type == uint.MAX_VALUE)
			{
				m_nameLabel.text = army.user.name;
				m_levelLabel.text = army.user.level.toString();
				
				m_progressBar = new ProgressBar(this, 6, 27);
				m_progressBar.setBar(new BattleHPBarInProgressRightMul(m_gkContext));
				bar.setSize(229, 14);
				bar.numLayer = 1;
				layers = bar.layers;
				layers[0].setPanelImageSkin("battleHead.hpRed");
			}
			else if (type != 0)
			{
				m_nameLabel.text = army.matrixList[i].m_npcBase.m_name;
				m_levelLabel.text = army.matrixList[i].m_npcBase.m_iLevel.toString();
				var resArr:Array = new Array();
				
				m_progressBar = new ProgressBar(this, 6, 27);
				m_progressBar.setBar(new BattleHPBarInProgressRightMul(m_gkContext));
				bar.setSize(229, 14);
				
				if (type == TNpcBattleItem.TYPE_BOSS)
				{
					bar.numLayer = 3;
					resArr.push("battleHead.hpRed");
					resArr.push("battleHead.hpBlue");
					resArr.push("battleHead.hpPurple");
				}
				else
				{
					bar.numLayer = 2;
					resArr.push("battleHead.hpRed");
					resArr.push("battleHead.hpBlue");
				}
				
				layers = bar.layers;
				
				for (i = 0; i < layers.length; i++)
				{
					layers[i].setPanelImageSkin(resArr[i] as String);
				}
			}
			else
			{
				this.visible = false;
			}
			
			if (type == uint.MAX_VALUE)
			{
				var level:uint = army.user.level;
				if (level < 30)
				{
					m_vecGrids[1].showLock();
					m_vecGrids[2].showLock();
				}
				else if (level < 50)
				{
					m_vecGrids[2].showLock();
				}
			}
			else
			{
				for (i = 0; i < 3; i++)
				{
					jinnang = army.user.jinnangGrids[i];
					if (jinnang.id == 0)
					{
						m_vecGrids[i].showLock();
					}
				}
			}
			
		}*/
		
		
		/*public function updateHp():void
		{			
			if (m_progressBar == null)
			{
				return;
			}
			m_progressBar.value = m_gkContext.m_fightControl.getTotalHP(1);
		}
		
		protected function get bar():BattleHPBarInProgressRightMul
		{
			return (m_progressBar.bar as BattleHPBarInProgressRightMul);
		}	*/	
	
		// 右边更新
		public function setLeftArmyCnt(cnt:uint):void
		{
			// bug如果连站力都没有显示,说明这个是个 NPC ,因此就不会有后续部队,因此就不会显示后续部队人数
			// bug npc 也会有后续部队的
			//if(!m_pnlZLBg)
			//{
			//	return;
			//}
			
			// 调整位置
			var zlbaseX:Number = 0;
			var zlbaseY:Number = 0;
			// 如果存在就是有锦囊
			var user:stUserInfo = m_curArmy.userInfoForHeadportrait;
			if(user.jinnang.id)
			{
				zlbaseX = -203 - 158;
				zlbaseY = 31;
			}
			else
			{
				zlbaseX = -203 + (98 - 158);
				zlbaseY = 31;
			}
			
			m_pnlArmyContainer.setPos(zlbaseX, zlbaseY);
			
			var xoff:uint = 140;
			var yoff:uint = 50;
			var xinter:uint = 30;	// 间隔
			
			var change:int;
			var idx:uint;
			var ani:Ani;
			// 特效从前向后排着来
			if(cnt < m_aniArmyList.length)	// 如果现有的特效比较多了,把后面的删除掉
			{
				change = m_aniArmyList.length - cnt;
				// 右边的把后面的删除
				idx = cnt;
				// 删除前面不要的特效
				while(idx < m_aniArmyList.length)
				{
					m_pnlArmyContainer.removeChild(m_aniArmyList[idx]);
					m_aniArmyList[idx].dispose();
					++idx;
				}
				
				m_aniArmyList.splice(cnt, change);
			}
			else if(cnt > m_aniArmyList.length)		// 如果现有的特效不够
			{
				change = cnt - m_aniArmyList.length;
				idx = 0;
				// 删除前面不要的特效
				while(idx < change)
				{
					// 创建动画
					ani = new Ani(m_gkContext.m_context);
					ani.duration = 2;
					ani.repeatCount = uint.MAX_VALUE;	// 无限循环播放
					
					ani.setImageAni("e40412.swf");
					ani.centerPlay = true;
					ani.mouseEnabled = false;
					
					ani.x = xoff - m_aniArmyList.length * xinter;
					ani.y = yoff;
					
					m_pnlArmyContainer.addChild(ani);
					m_aniArmyList.push(ani);
					ani.begin();
					++idx;
				}
			}
		}
	}
}