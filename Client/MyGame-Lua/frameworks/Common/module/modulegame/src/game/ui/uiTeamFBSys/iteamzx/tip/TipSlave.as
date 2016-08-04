package game.ui.uiTeamFBSys.iteamzx.tip
{
	import com.bit101.components.Label;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.TextNoScroll;
	
	import modulecommon.appcontrol.AttrStrip;
	import modulecommon.net.msg.copyUserCmd.DispatchHero;
	import modulecommon.net.msg.copyUserCmd.UserDispatch;
	import modulecommon.net.msg.teamUserCmd.TeamUser;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import com.util.UtilColor;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.msg.HeroData;

	/**
	 * ...
	 * @author
	 */
	public class TipSlave extends PanelContainer
	{
		public static const WIDTH:uint = 190;

		private var m_nameLabel:Label;
		private var m_levelLabel:Label;
		private var m_zhanliLabel:Label;
		private var m_tf:TextNoScroll;
		private var m_attrStrip:AttrStrip;
		private var m_descLabel:Label;
		
		public var m_TFBSysData:UITFBSysData;
		
		public function TipSlave(data:UITFBSysData)
		{
			m_TFBSysData = data;
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
			m_nameLabel = new Label(this, 12, 14);
			m_nameLabel.setFontSize(14);
			m_nameLabel.setBold(true);
			m_nameLabel.setFontColor(UtilColor.GREEN);
			
			m_attrStrip = new AttrStrip(this, 4, 40);
			m_attrStrip.setSize(WIDTH - 8, 45);
			
			m_levelLabel = new Label(m_attrStrip);
			m_levelLabel.setFontColor(UtilColor.GREEN);
			m_levelLabel.setPos(12, 4);
			
			m_zhanliLabel = new Label(m_attrStrip);
			m_zhanliLabel.setFontColor(UtilColor.GREEN);
			m_zhanliLabel.setPos(12, 20);
			
			m_descLabel = new Label(this, 12, 92);
			m_descLabel.setFontColor(UtilColor.GRAY);
			this.setSize(WIDTH, 120);
		}
		
		//public function showTip(data:HeroData):void
		public function showTip(row:uint, col:uint):void
		{
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			var itemTU:TeamUser;
			
			var herodata:HeroData;
			var npcBase:TNpcBattleItem;
			
			itemUD = m_TFBSysData.ud[row];
			itemDH = itemUD.dh[col];
			
			var isMain:Boolean;
			var idorcharid:uint;	// 如果是武将就是武将 id，如果是主角就是 charid
			isMain = !!(itemDH.ds & 0x1);
			idorcharid = itemDH.id;
			herodata = m_TFBSysData.getHeroData(itemUD.charid, itemDH.id);
			
			var str:String;
			
			if(isMain)
			{
				itemTU = m_TFBSysData.getUserInfo(itemUD.charid);
				str = itemTU.name;
			}
			else
			{
				npcBase = m_TFBSysData.m_gkcontext.m_dataTable.getItem(DataTable.TABLE_NPCBATTLE, idorcharid/10) as TNpcBattleItem;
				if(npcBase)
				{
					str = npcBase.m_name;
				}
			}

			if(herodata)
			{
				m_nameLabel.text = str;
				m_levelLabel.text = "出手速度 " + herodata.speed;
				m_zhanliLabel.text = "战力  " + herodata.zhanli;
				m_descLabel.text = "[" + herodata.active + "]激活";
			}
		}
	}
}