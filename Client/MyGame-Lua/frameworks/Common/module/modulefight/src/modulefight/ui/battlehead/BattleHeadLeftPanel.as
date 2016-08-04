package modulefight.ui.battlehead
{
	//import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.netmsg.stmsg.stUserInfo;
	
	import flash.display.Shape;
	import modulecommon.GkContext;
	import modulecommon.appcontrol.DigitComponent;
	//import modulecommon.ui.Form;
	
	//import modulefight.netmsg.stmsg.stArmy;
	//import modulefight.netmsg.stmsg.stJinnang;
	//import modulecommon.ui.UIFormID;
	import com.bit101.components.Ani;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class BattleHeadLeftPanel extends BattleHeadPanel
	{
		public function BattleHeadLeftPanel(gk:GkContext, ui:UIBattleHead)
		{
			super(EntityCValue.RKLeft, gk, ui);
			
			m_levelLabel.setPos(89, 90);
		}
		
		override public function drawBG():void
		{
			m_bg.beginDraw();
			var panel:Panel;
			
			var panelContainer:Panel;
			panelContainer = new Panel();
			panelContainer.y = 6;
			var shape:Shape = new Shape();
			shape.x = 5;
			shape.y = 5;
			shape.graphics.beginFill(0);
			shape.graphics.drawCircle(46, 46, 46);
			shape.graphics.endFill();
			panelContainer.addChild(shape);
			   
			panel = new Panel(panelContainer);
			panel.setPanelImageSkin("commoncontrol/panel/battleframe.png");
			var rondBGPanel:Panel = new Panel(panelContainer, 75, 77);
			rondBGPanel.setPanelImageSkin("commoncontrol/panel/round_bg.png");
			
			panel = new Panel(panelContainer);
			panel.y = -14;
			var user:stUserInfo = m_curArmy.userInfoForHeadportrait;
			var resName:String;
			if (m_curArmy.isPlayer)
			{
				resName = m_gkContext.m_context.m_playerResMgr.roundHeadPathName(user.job, user.sex);
				rondBGPanel.visible = true;
			}
			else
			{
				resName = "roundhead/monster_default.png";
				rondBGPanel.visible = false;
			}
			panel.setPanelImageSkin(resName);
			
			/*var i:int = 0;
			   var label:Label;
			   for (i = 0; i < 3; i++)
			   {
			   label = new Label(panelContainer, (137 + i * 52), 40, (i + 1).toString(), 0x777777, 28);
			   //m_bg.addDrawCom(label, false);
			   label.flush();
			 }*/
			
			m_bg.addDrawCom(panelContainer);
			m_bg.drawPanel();
			
			// 显示战力			
			if (user.zhanli) // 只有玩家才显示,跟怪物不显示,大于 0 就显示
			{
				showZhanliPanel();
				// 战力显示
				var zlbaseX:Number = 0;
				var zlbaseY:Number = 0;
				// 如果存在就是有锦囊
				
				if (user.jinnang.id)
				{
					zlbaseX = 106 + 98;
					zlbaseY = 31;
				}
				else
				{
					zlbaseX = 106;
					zlbaseY = 31;
				}
				
				m_zlDigit.digit = user.zhanli;
				m_pnlZLBg.x = zlbaseX;
				m_pnlZLBg.y = zlbaseY;
			}
			else
			{
				hideZhanliPanel();
			}
		}
		
		private function showZhanliPanel():void
		{
			if (!m_pnlZLBg)
			{
				m_pnlZLBg = new Panel(m_pnlZLBgContainer);
				m_pnlZLBg.setPanelImageSkin("commoncontrol/panel/battlezhanlibg.png"); // (158 * 40)
				
				m_pnlZLDesc = new Panel(m_pnlZLBg, 5, 5);
				m_pnlZLDesc.setPanelImageSkin("commoncontrol/panel/zhanli.png");
				; // (40, 27)
				
				m_zlDigit = new DigitComponent(m_gkContext.m_context, m_pnlZLBg, 50, 10);
				m_zlDigit.setSize(80, 18);
				m_zlDigit.setParam("commoncontrol/digit/digit01", 10, 18); // 红色数字
				
			}
		}
		private function hideZhanliPanel():void
		{
			if (m_pnlZLBg)
			{
				m_pnlZLBg.visible = false;
			}
		}
		
		override public function createJinnangUI():void
		{
			m_jinnangBG = new PanelContainer(this);
			m_jnGrid = new BatJinnangGrid(m_gkContext);
			
			m_jinnangBG.addChild(m_jnGrid);
			
			this.swapChildren(m_jinnangBG, m_bg);
			this.setChildIndex(m_levelLabel, this.numChildren - 1);
			m_jinnangBG.setPanelImageSkin("commoncontrol/panel/battlejinnang.png"); // (98 * 60)
			m_jinnangBG.setPos(106, 31);
			m_jnGrid.setPos(18, 7);		
		}
		
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
			if (user.jinnang.id)
			{
				zlbaseX = 106 + 98;
				zlbaseY = 31;
			}
			else
			{
				zlbaseX = 106;
				zlbaseY = 31;
			}
			
			m_pnlArmyContainer.setPos(zlbaseX, zlbaseY);
			
			var xoff:uint = 20;
			var yoff:uint = 50;
			var xinter:uint = 30; // 间隔
			
			var change:int;
			var idx:uint;
			var ani:Ani;
			// 特效从前向后排着来
			if (cnt < m_aniArmyList.length) // 如果现有的特效比较多了,把后面的删除掉
			{
				change = m_aniArmyList.length - cnt;
				idx = cnt;
				// 删除前面不要的特效
				while (idx < m_aniArmyList.length)
				{
					m_pnlArmyContainer.removeChild(m_aniArmyList[idx]);
					m_aniArmyList[idx].dispose();
					++idx;
				}
				
				m_aniArmyList.splice(cnt, change);
			}
			else if (cnt > m_aniArmyList.length) // 如果现有的特效不够
			{
				change = cnt - m_aniArmyList.length;
				idx = 0;
				// 删除前面不要的特效
				while (idx < change)
				{
					// 创建动画
					ani = new Ani(m_gkContext.m_context);
					ani.duration = 2;
					ani.repeatCount = uint.MAX_VALUE; // 无限循环播放
					
					ani.setImageAni("e40412.swf");
					ani.centerPlay = true;
					ani.mouseEnabled = false;
					
					ani.x = xoff + m_aniArmyList.length * xinter;
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