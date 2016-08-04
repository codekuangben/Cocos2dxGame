package modulefight.ui.battlehead
{
	//import com.ani.AniPositionParamEquation;
	//import com.ani.AniPropertys;
	//import com.ani.equation.EquationInverse;
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PanelDraw;
	import modulefight.netmsg.stmsg.stUserInfo;
	//import com.bit101.components.progressBar.ProgressBar;
	//import com.pblabs.engine.entity.EntityCValue;
	
	import common.event.UIEvent;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import modulecommon.GkContext;
	import modulecommon.appcontrol.DigitComponent;
	
	import modulefight.netmsg.stmsg.stArmy;
	import modulefight.netmsg.stmsg.stJinnang;
	
	/**
	 * ...
	 * @author
	 */
	public class BattleHeadPanel extends PanelContainer
	{
		public static const FRAME_WIDTH:int = 203;	//头像框的宽度
		public static const FRAME_HEIGHT:int = 107;	//头像框的高度
		
		protected var m_bg:PanelDraw;
		protected var m_jinnangBG:PanelContainer;
		protected var m_side:int;
		protected var m_gkContext:GkContext;
		protected var m_ui:UIBattleHead;
		protected var m_jnGrid:BatJinnangGrid;
		protected var m_levelLabel:Label;
		protected var m_vecGrids:Vector.<BatJinnangGrid>;
		
		protected var m_armyList:Vector.<stArmy>;
		protected var m_curArmy:stArmy;
		protected var m_jinnangFly:BatJinnangGridFly;
		public var m_jnAniData:DataJNAni;	// 这个是锦囊动画需要的数据
		
		public var m_pnlZLBgContainer:Component;	// 这个是 m_pnlZLBg 的容器
		public var m_pnlZLBg:Panel;		// 战力背景
		public var m_pnlZLDesc:Panel;		// 战力描述
		public var m_zlDigit:DigitComponent;// 战力数字

		public var m_pnlArmyContainer:Component;		// 战力背景
		public var m_aniArmyList:Vector.<Ani>;		// 后续兵团剩余数量

		public function BattleHeadPanel(side:int, gk:GkContext, ui:UIBattleHead)
		{
			m_gkContext = gk;
			m_side = side;
			m_ui = ui;
			
			var i:uint = 0;
			var left:Number;
			var top:uint = 38;
			var interval:Number = 43;
			/*if (m_side == EntityCValue.RKLeft)
			{
				left = 122;
				interval = 52;
			}
			else
			{
				left = 35;
				interval = -52;
			}*/
			
			m_bg = new PanelDraw(this);
			m_bg.setSize(114, 116);
			m_bg.addEventListener(UIEvent.IMAGELOADED, onPanelBGComplete);
			this.visible = false;
			
			m_levelLabel = new Label(this);
			m_levelLabel.autoSize = false;
			m_levelLabel.width = 0;
			m_levelLabel.align = Component.CENTER;
			
			m_aniArmyList = new Vector.<Ani>();
			m_pnlZLBgContainer = new Component(this);
			m_pnlArmyContainer = new Component(this);

			this.setSize(m_bg.width, m_bg.height);
		}
		
		protected function onPanelBGComplete(e:Event):void
		{
			visible = true;
			this.removeEventListener(Event.COMPLETE, onPanelBGComplete);
			m_ui.updateReady();
		}
		public function drawBG():void { }
		public function createJinnangUI():void{}
		public function setInitData(list:Vector.<stArmy>):void
		{
			m_armyList = list;
		}
		
		public function setCurArmy(army:stArmy):void
		{
			m_curArmy = army;
			var i:int;
			var jinnang:stJinnang;
						
			m_levelLabel.visible = false;
			var user:stUserInfo = army.userInfoForHeadportrait;
			jinnang = user.jinnang;
			
			if (user.level)
			{
				m_levelLabel.text = user.level.toString();
				m_levelLabel.visible = true;
			}
			
			if (jinnang.id)
			{
				if (m_jinnangBG == null)
				{
					createJinnangUI();					
				}
				m_jinnangBG.visible = true;
				// bug: 如果回放的时候之前这个位置是灰色的，那么显示就海事会灰色的
				m_jnGrid.clear();
				m_jnGrid.setJinnang(jinnang.id, jinnang.num);
			}
			else
			{
				if (m_jinnangBG)
				{
					m_jinnangBG.visible = false;
				}		
			}
			
			drawBG();
		}
		
		//bRestrained: true - 表示此锦囊被抑制
		//public function useJinnangID(id:uint, bRestrained:Boolean, onFlyEnd:Function=null):void
		public function useJinnangID():void
		{
			var i:int = 0;
			var grid:BatJinnangGrid;
			
			/*
			for (i = 0; i < 3; i++)
			{
				grid = m_vecGrids[i];				
				if (grid.jinnangItem && grid.jinnangItem.idLevel == id)
				{
					grid.setGray();
					m_jinnangFly = new BatJinnangGridFly(m_gkContext);
					m_jinnangFly.addSelfToDisplayList(m_ui);
					m_jinnangFly.onFlyEnd = onFlyEnd;
					var pos:Point = grid.posInRelativeParent(m_ui);
					m_jinnangFly.setPos(pos.x, pos.y);
					
					m_jinnangFly.setJinnang(grid.jinnangItem);
					m_jinnangFly.fly(1 - m_side, bRestrained);
					break;
				}
			}
			*/
			
			grid = m_jnGrid;
			// 现在就一个锦囊,就不用
			grid.setGray();
			m_jinnangFly = new BatJinnangGridFly(m_gkContext);
			m_jinnangFly.m_side = m_side;
			//m_jinnangFly.addSelfToDisplayList(m_ui);
			m_jnAniData.m_jnCnter.addChild(m_jinnangFly);		// 添加到锦囊容器节点
			var pos:Point = grid.posInRelativeParent(m_jnAniData.m_jnCnter);
			m_jinnangFly.setPos(pos.x, pos.y);
			m_jinnangFly.m_jnAniData = m_jnAniData;	// 锦囊动画数据
			m_jinnangFly.setJinnang(grid.jinnangItem);
			m_jinnangFly.fly(1 - m_side);
				
			// 保存锦囊特效
			m_jnAniData.m_jnFly[m_side] = m_jinnangFly; 
		}
		
		public function onEndRound():void
		{
			//if (m_jinnangFly != null)
			//{
			//	m_jinnangFly.disappear();
			//	m_jinnangFly = null;
			//}
		}
		
		public function set jnAniData(value:DataJNAni):void
		{
			m_jnAniData = value;
			
		}
		
		// 释放不在显示列表的内容
		override public function dispose():void
		{
			// 释放飞行的锦囊资源
			if (m_jinnangFly)
			{
				//trace("BattleHeadPanel_Begin");
			}
			if(m_jinnangFly && !m_jnAniData.m_jnCnter.contains(m_jinnangFly))
			{
				//trace("BattleHeadPanel_Begin");
				m_jinnangFly.dispose();
				m_jinnangFly = null;
			}
			super.dispose();
		}
		
		// 释放飞行的锦囊
		public function disposeFlyJN():void
		{
			if(m_jinnangFly)
			{
				m_jinnangFly.destroySelf();
				m_jinnangFly = null;
			}
		}
		
		// 停止锦囊播放
		public function stopJN():void
		{
			if(m_jinnangFly)
			{
				m_jinnangFly.stopJN();
			}
		}
	}
}