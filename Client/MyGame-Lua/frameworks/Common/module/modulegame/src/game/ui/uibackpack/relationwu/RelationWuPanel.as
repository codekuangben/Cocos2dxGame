package game.ui.uibackpack.relationwu 
{
	import com.ani.AniPosition;
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.table.TWuPropertyItem;
	import game.ui.uibackpack.UIBackPack;
	/**
	 * ...
	 * @author ...
	 * 右侧关系武将显示
	 */
	public class RelationWuPanel extends Component
	{
		private var m_gkContext:GkContext;
		private var m_ui:UIBackPack;
		private var m_dicRelaionWuList:Dictionary;
		private var m_relationWuList:RelationWuList;
		private var m_ani:AniPosition;
		private var m_curHeroID:uint;
		private var m_bShow:Boolean;
		
		public function RelationWuPanel(gk:GkContext, ui:UIBackPack, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_ui = ui;
			
			m_dicRelaionWuList = new Dictionary();
			
			m_relationWuList = new RelationWuList(m_gkContext, m_ui, this, this, 0, 0);
			
			m_ani = new AniPosition();
			m_ani.sprite = this;
			m_ani.duration = 0.5;
		}
		
		public function showRelationWusByHeroID(heroid:uint):void
		{
			if (m_curHeroID != heroid)
			{
				m_curHeroID = heroid;
				m_relationWuList.hideNextList();
				m_relationWuList.setData(m_curHeroID);
			}
			
			m_relationWuList.newHnadMoveToCard();
		}
		
		public function update():void
		{
			m_relationWuList.update();
		}
		
		public function setShowPos(isShow:Boolean):void
		{
			m_bShow = isShow;
			m_relationWuList.hideNextList();
			
			if (m_bShow)
			{
				this.setPos(446, 27);
			}
			else
			{
				this.setPos(306, 27);
			}
		}
		
		//更新显示位置
		public function updateShowPos():void
		{
			if (m_ani.bRun)
			{
				return;
			}
			
			m_ani.setBeginPos(this.x, this.y);
			if (m_bShow)
			{
				m_ani.setEndPos(this.x - 140, this.y);
				m_relationWuList.hideNextList();
			}
			else
			{
				m_ani.setEndPos(this.x + 140, this.y);
			}
			m_ani.begin();
			
			m_bShow = !m_bShow;
		}
		
		public function get bShow():Boolean
		{
			return m_bShow;
		}
		
		public function getActiveWuHeroID(heroid:uint):Vector.<uint>
		{
			var i:int;
			var ret:Vector.<uint> = new Vector.<uint>();
			var wutableid:uint = heroid / 10;
			var npcBase:TNpcBattleItem = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(wutableid);
			var wuProID:uint = wutableid * 10 + npcBase.m_uColor;
			var wuProItem:TWuPropertyItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_WUPROPERTY, wuProID) as TWuPropertyItem;
			var vecAtiveWu:Vector.<uint> = wuProItem.getVecAtiveWu();
			
			for (i = 0; i < vecAtiveWu.length; i++)
			{
				ret.push(vecAtiveWu[i] * 10 + heroid % 10);
			}
			
			return ret;
		}
		
		//隐藏下一关系武将列表（即关系武将显示第2列(含)以后）
		public function hideNextRelationWuListByHeroID(heroid:uint):void
		{
			m_relationWuList.hideNextRelationWuListByHeroID(heroid);
		}
		
		public function newHnadMoveToCard():void
		{
			m_relationWuList.newHnadMoveToCard();
		}
		
		override public function dispose():void
		{
			m_ani.dispose();
			
			super.dispose();
		}
	}

}