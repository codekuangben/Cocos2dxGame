package game.ui.uiZhenfa.tips 
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.TextNoScroll;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.net.msg.zhanXingCmd.stLocation;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.fight.ZhenfaMgr;
	import modulecommon.scene.prop.relation.KejiItemInfo;
	import modulecommon.scene.prop.relation.KejiLearnedItem;
	import modulecommon.scene.prop.relation.RelArmy;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.zhanxing.PackageStar;
	import modulecommon.scene.zhanxing.ZStar;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	/**
	 * ...
	 * @author ...
	 * 阵位下边显示图标tips
	 */
	public class ZhenweiIconTip extends PanelContainer
	{
		public static const TYPE_NONE:int = 0;		//
		public static const TYPE_JUNTUAN:int = 1;	//军团
		public static const TYPE_WUXUE:int = 2;		//武学
		
		private var m_gkContext:GkContext;
		private var m_vecNameAttr:Vector.<Label>;		//功能加成属性
		private var m_segmentPanel:Panel;				//分割线
		
		public function ZhenweiIconTip(gk:GkContext) 
		{
			m_gkContext = gk;
			this.setSize(228, 200);
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
			
			m_vecNameAttr = new Vector.<Label>();
		}
		
		public function showTip(zhenwei:int):void
		{
			clearData();
			
			//军团属性加成
			if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_JUNTUAN))
			{
				itemNameAttr(TYPE_JUNTUAN, zhenwei);
			}
			
			//武学属性加成
			if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_ZHANXING))
			{
				itemNameAttr(TYPE_WUXUE, zhenwei);
			}
			
			var len:int = m_vecNameAttr.length;
			if (len)
			{
				if (2 == len)
				{
					if (null == m_segmentPanel)
					{
						m_segmentPanel = new Panel(this, 4, 20);
						m_segmentPanel.setSize(220, 1);
						m_segmentPanel.autoSizeByImage = false;
						m_segmentPanel.setPanelImageSkin("commoncontrol/panel/tipsegment.png");
					}
					m_segmentPanel.y = m_vecNameAttr[0].y + m_vecNameAttr[0].height + 10;
					
					m_vecNameAttr[1].y = m_segmentPanel.y + 10;
				}
			}
			else
			{
				itemNameAttr(TYPE_NONE, zhenwei);
			}
			
			len = m_vecNameAttr.length;
			this.height = m_vecNameAttr[len - 1].y + m_vecNameAttr[len - 1].height + 20;
		}
		
		private function clearData():void
		{
			for (var i:int = 0; i < m_vecNameAttr.length; i++)
			{
				if (m_vecNameAttr[i].parent)
				{
					m_vecNameAttr[i].parent.removeChild(m_vecNameAttr[i]);
				}
				m_vecNameAttr[i].dispose();
				m_vecNameAttr[i] = null;
			}
			m_vecNameAttr.length = 0;
		}
		
		private function itemNameAttr(type:int, zhenwei:int):void
		{
			var str:String = WuHeroProperty.toZhenweiName(zhenwei);
			var namelabel:Label = new Label(this, 10, 15, "", UtilColor.BLUE, 14);
			var attrs:TextNoScroll = new TextNoScroll();
			attrs.x = 16;
			attrs.y = 2;
			attrs.width = 180;
			attrs.setCSS("body", {leading: 3,letterSpacing:1});
			
			if (TYPE_JUNTUAN == type)
			{
				namelabel.text = "军团科技对" + str + "加成：";
				attrs.htmlText = getJuntuanKejiAttrStr(zhenwei);
			}
			else if (TYPE_WUXUE == type)
			{
				namelabel.text = "武学对" + str + "加成：";
				attrs.htmlText = getWuxueAttrStr(zhenwei);
			}
			else
			{
				namelabel.text = str + "属性加成：";
				UtilHtml.beginCompose();
				UtilHtml.breakline();
				UtilHtml.add("<body>无</body>", UtilColor.WHITE_B, 12);
				attrs.htmlText = UtilHtml.getComposedContent();
			}
			
			namelabel.addChild(attrs);
			namelabel.setSize(200, attrs.y + attrs.textHeight);
			
			m_vecNameAttr.push(namelabel);
		}
		
		//军团科技加成属性
		private function getJuntuanKejiAttrStr(zhenwei:int):String
		{
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat("<body>");
			
			var kejiList:Array = m_gkContext.m_corpsMgr.m_kejiLearnd;
			var attrNum:int = 0;
			
			if (kejiList && kejiList.length)
			{
				var item:KejiLearnedItem;
				var kejiInfo:KejiItemInfo;
				for each (item in kejiList)
				{
					kejiInfo = m_gkContext.m_corpsMgr.getKejiInfoByType(item.m_type);
					if ((RelArmy.getZhenweiTSX(item.m_type) == zhenwei) && kejiInfo)
					{
						UtilHtml.breakline();
						UtilHtml.add(kejiInfo.m_name, 0xD78E03, 12);
						UtilHtml.add("  +" + item.m_value, 0x23C911, 12);
						attrNum++;
					}
				}
			}
			
			if (0 == attrNum)
			{
				UtilHtml.breakline();
				UtilHtml.add("对应军团科技尚未学习", UtilColor.WHITE_B, 12);
			}
			
			UtilHtml.addStringNoFormat("</body>");
			return UtilHtml.getComposedContent();
		}
		
		//武学加成属性
		private function getWuxueAttrStr(zhenwei:int):String
		{
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat("<body>");
			
			var str:String;
			var packageStar:PackageStar;
			if (ZhenfaMgr.ZHENWEI_FRONT == zhenwei)
			{
				packageStar = m_gkContext.m_zhanxingMgr.getPackage(stLocation.SBCELLTYPE_FRONT);
			}
			else if (ZhenfaMgr.ZHENWEI_MIDDLE == zhenwei)
			{
				packageStar = m_gkContext.m_zhanxingMgr.getPackage(stLocation.SBCELLTYPE_CENTER);
			}
			else if (ZhenfaMgr.ZHENWEI_BACK == zhenwei)
			{
				packageStar = m_gkContext.m_zhanxingMgr.getPackage(stLocation.SBCELLTYPE_BACK);
			}
			
			if (packageStar && packageStar.datas.length)
			{
				var starList:Array = packageStar.datas;
				var star:ZStar;
				for (var i:int = 0; i < starList.length; i++)
				{
					star = starList[i];
					str = star.attrName + " +" + star.attrValueOfPurple;
					if (star.isTopColor)
					{
						str += "   +" + star.attrValue + "%";
					}
					
					UtilHtml.breakline();
					UtilHtml.add(str, star.colorValue);
				}
			}
			else
			{
				UtilHtml.breakline();
				UtilHtml.add("对应武学尚未装备", UtilColor.WHITE_B, 12);
			}
			
			UtilHtml.addStringNoFormat("</body>");
			return UtilHtml.getComposedContent();
		}
		
	}

}