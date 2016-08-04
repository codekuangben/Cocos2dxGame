package game.ui.uibackpack.tips 
{
	import com.bit101.components.Label;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.TextNoScroll;
	import modulecommon.GkContext;
	import modulecommon.net.msg.zhanXingCmd.stLocation;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TZhanxingItem;
	import modulecommon.scene.zhanxing.T_Star;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	/**
	 * ...
	 * @author ...
	 * 观察其他玩家的已装备武学Tips
	 */
	public class OtherWuxueTip extends PanelContainer
	{
		private var m_gkContext:GkContext;
		private var m_nameLabel:Label;
		private var m_typeLabel:Label;
		private var m_vecAttrs:Vector.<Label>;
		private var m_vecStar:Vector.<T_Star>;
		
		public function OtherWuxueTip(gk:GkContext) 
		{
			m_gkContext = gk;
			this.setSize(62, 40);
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
			
			m_nameLabel = new Label(this, 15, 10, "武学", UtilColor.BLUE, 14);
			m_nameLabel.setBold(true);
			
			m_typeLabel = new Label(this, 60, 11, "（我的）", UtilColor.WHITE_B);
			m_typeLabel.visible = false;
			
			m_vecAttrs = new Vector.<Label>();
		}
		
		//bSelf 是否自己的武学信息
		public function showTip(data:Vector.<T_Star>, bSelf:Boolean = false):void
		{
			clearData();
			
			m_vecStar = data;
			if (null == m_vecStar)
			{
				return;
			}
			
			if (bSelf)
			{
				m_typeLabel.visible = true;
			}
			else
			{
				m_typeLabel.visible = false;
			}
			
			addStars(stLocation.SBCELLTYPE_FRONT);
			addStars(stLocation.SBCELLTYPE_CENTER);
			addStars(stLocation.SBCELLTYPE_BACK);
			
			var h:int;
			var top:int = m_nameLabel.y + 25;
			for (var i:int = 0; i < m_vecAttrs.length; i++)
			{
				m_vecAttrs[i].y = top;
				top = top + m_vecAttrs[i].height;
			}
			
			this.setSize(180, top + 10);
		}
		
		private function clearData():void
		{
			for (var i:int = 0; i < m_vecAttrs.length; i++)
			{
				if (m_vecAttrs[i].parent)
				{
					m_vecAttrs[i].parent.removeChild(m_vecAttrs[i]);
				}
				m_vecAttrs[i].dispose();
				m_vecAttrs[i] = null;
			}
			m_vecAttrs.length = 0;
			
			this.setSize(60, 40);
		}
		
		private function addStars(zhenwei:int):void
		{
			var zhenweilabel:Label;
			var stars:TextNoScroll;
			var vecstar:Vector.<T_Star> = getVecStarByByZhenwei(zhenwei);
			
			if (vecstar.length)
			{
				zhenweilabel = new Label(this, 15, 0, getZhenweiName(zhenwei), UtilColor.BLUE);
				
				stars = new TextNoScroll();
				stars.x = 42;
				stars.y = -2;
				stars.width = 180;
				stars.setCSS("body", { leading: 3, letterSpacing:1 } );
				zhenweilabel.addChild(stars);
				
				stars.htmlText = getStarsStr(vecstar);
				
				zhenweilabel.setSize(180, stars.textHeight - 8);
				
				m_vecAttrs.push(zhenweilabel);
			}
		}
		
		private function getStarsStr(vecstar:Vector.<T_Star>):String
		{
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat("<body>");
			
			var star:T_Star;
			var starBase:TZhanxingItem;
			
			for each (star in vecstar)
			{
				starBase = m_gkContext.m_dataTable.getItem(DataTable.TABLE_ZHANXING, star.m_id) as TZhanxingItem;
				
				if (starBase)
				{
					UtilHtml.add(starBase.m_name + " LV." + star.m_level.toString(), NpcBattleBaseMgr.colorValue(starBase.m_color), 12);
					UtilHtml.breakline();
				}
			}
			UtilHtml.addStringNoFormat("</body>");
			
			return UtilHtml.getComposedContent();
		}
		
		private function getVecStarByByZhenwei(zhenwei:int):Vector.<T_Star>
		{
			var ret:Vector.<T_Star> = new Vector.<T_Star>();
			var star:T_Star;
			
			for each(star in m_vecStar)
			{
				if (star.m_location.location == zhenwei)
				{
					ret.push(star);
				}
			}
			
			return ret;
		}
		
		private function getZhenweiName(zhenwei:int):String
		{
			var ret:String = "";
			
			if (stLocation.SBCELLTYPE_FRONT == zhenwei)
			{
				ret = "前军：";
			}
			else if (stLocation.SBCELLTYPE_CENTER == zhenwei)
			{
				ret = "中军：";
			}
			else if (stLocation.SBCELLTYPE_BACK == zhenwei)
			{
				ret = "后军：";
			}
			
			return ret;
		}
	}

}