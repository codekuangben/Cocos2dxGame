package game.ui.uibackpack.tips 
{
	import com.bit101.components.Component;
	import flash.geom.Point;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.scene.beings.MountsShareData;
	import modulecommon.scene.beings.MountsSys;
	import modulecommon.scene.prop.relation.KejiItemInfo;
	import modulecommon.scene.prop.relation.KejiLearnedItem;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	/**
	 * ...
	 * @author ...
	 */
	public class WatchTipMgr extends Component
	{
		private var m_gkContext:GkContext;
		private var m_wuxueTipOther:OtherWuxueTip;
		private var m_wuxueTipSelf:OtherWuxueTip;
		private var m_corpsTipsOther:CorpsTip;
		private var m_corpsTipSelf:CorpsTip;
		private var m_gwTipOther:GodlyweaponTip;
		private var m_gwTipSelf:GodlyweaponTip;
		
		public function WatchTipMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			
		}
		
		//武学
		public function showWuxueTip(pt:Point):void
		{
			if (null == m_wuxueTipOther)
			{
				m_wuxueTipOther = new OtherWuxueTip(m_gkContext);
				
				m_wuxueTipSelf = new OtherWuxueTip(m_gkContext);
				m_wuxueTipOther.addChild(m_wuxueTipSelf);
				m_wuxueTipSelf.setPos(-180, 0);
			}
			
			if (m_gkContext.m_zhanxingMgr.vecStarWearing.length)
			{
				m_wuxueTipSelf.visible = true;
				m_wuxueTipSelf.showTip(m_gkContext.m_zhanxingMgr.vecStarWearing, true);
			}
			else
			{
				m_wuxueTipSelf.visible = false;
			}
			
			m_wuxueTipOther.showTip(m_gkContext.m_zhanxingMgr.m_vecStarOtherPlayer);
			
			pt.x += 10 - m_wuxueTipOther.width;
			pt.y += 10 - m_wuxueTipOther.height;
			
			m_gkContext.m_uiTip.hintComponent(pt, m_wuxueTipOther);
		}
		
		//军团科技
		public function showCorpsTip(pt:Point, data:Array):void
		{
			if (null == m_corpsTipsOther)
			{
				m_corpsTipsOther = new CorpsTip(m_gkContext);
				
				m_corpsTipSelf = new CorpsTip(m_gkContext);
				m_corpsTipsOther.addChild(m_corpsTipSelf);
				m_corpsTipSelf.setPos(-170, 0);
			}
			
			var kejiList:Array = m_gkContext.m_corpsMgr.m_kejiLearnd;
			if (kejiList && kejiList.length)
			{
				m_corpsTipSelf.visible = true;
				m_corpsTipSelf.showTip(kejiList, true);
			}
			else
			{
				m_corpsTipSelf.visible = false;
			}
			
			m_corpsTipsOther.showTip(data);
			
			pt.x += 10 - m_corpsTipsOther.width;
			pt.y += 10 - m_corpsTipsOther.height;
			
			m_gkContext.m_uiTip.hintComponent(pt, m_corpsTipsOther);
		}
		
		//坐骑
		public function showMountsTip(pt:Point):void
		{
			var bSelf:Boolean = true;
			//自己的坐骑功能未开启时，只显示观察玩家坐骑tip
			if (false == m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_MOUNT))
			{
				bSelf = false;
			}
			
			(m_gkContext.m_mountsShareData as MountsShareData).m_mountsTipData.reset();
			(m_gkContext.m_mountsShareData as MountsShareData).m_mountsTipData.m_tipsType = 3;
			(m_gkContext.m_mountsShareData as MountsShareData).m_mountsTipData.m_mountsDataSys = m_gkContext.m_mountsSysLogic.otherMountsSys;
			
			m_gkContext.m_uiTip.hintMountsInfo(pt, (m_gkContext.m_mountsShareData as MountsShareData).m_mountsTipData, 1, bSelf);
		}
		
		//神兵
		public function showGodlyweaponTip(pt:Point):void
		{
			if (null == m_gwTipOther)
			{
				m_gwTipOther = new GodlyweaponTip(m_gkContext);
				
				m_gwTipSelf = new GodlyweaponTip(m_gkContext);
				m_gwTipOther.addChild(m_gwTipSelf);
				m_gwTipSelf.setPos(-170, 0);
			}
			
			var weargwid:uint = m_gkContext.m_godlyWeaponMgr.m_curWearGWId;
			var gwslevel:uint = m_gkContext.m_godlyWeaponMgr.m_gwsCurLevel;
			if (weargwid > 0)
			{
				m_gwTipSelf.visible = true;
				m_gwTipSelf.showTip(weargwid, gwslevel, true);
			}
			else
			{
				m_gwTipSelf.visible = false;
			}
			
			weargwid = m_gkContext.m_watchMgr.m_weargwid;
			gwslevel = m_gkContext.m_watchMgr.m_gwslevel;
			m_gwTipOther.showTip(weargwid, gwslevel);
			
			pt.x += 10 - m_gwTipOther.width;
			pt.y += 10 - m_gwTipOther.height;
			
			m_gkContext.m_uiTip.hintComponent(pt, m_gwTipOther);
		}
		
		override public function dispose():void
		{
			if (m_wuxueTipOther)
			{
				if (m_wuxueTipOther.parent)
				{
					m_wuxueTipOther.parent.removeChild(m_wuxueTipOther);
				}
				
				m_wuxueTipOther.dispose();
				m_wuxueTipOther = null;
			}
			
			if (m_corpsTipsOther)
			{
				if (m_corpsTipsOther.parent)
				{
					m_corpsTipsOther.parent.removeChild(m_corpsTipsOther);
				}
				
				m_corpsTipsOther.dispose();
				m_corpsTipsOther = null;
			}
			
			if (m_gwTipOther)
			{
				if (m_gwTipOther.parent)
				{
					m_gwTipOther.parent.removeChild(m_gwTipOther);
				}
				
				m_gwTipOther.dispose();
				m_gwTipOther = null;
			}
			
			super.dispose();
		}
	}

}