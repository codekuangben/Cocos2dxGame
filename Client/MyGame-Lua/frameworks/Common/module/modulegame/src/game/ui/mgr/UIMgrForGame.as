package game.ui.mgr 
{
	import flash.utils.Dictionary;
	import game.ui.aniRewarded.UIAniRewarded;
	import game.ui.announcement.UIAnnouncement;
	import game.ui.collectProgress.UICollectProgress;
	import game.ui.expression.UIExpression;
	import game.ui.giftwatch.UIGiftWatch;
	import game.ui.herorally.UIHeroRally;
	import game.ui.market.corps.UICorpsMarket;
	import game.ui.market.UIMarketBuy_Corps;
	import game.ui.market.UIMarketBuy_Quick;
	import game.ui.market.UIMarketBuy_Rongyu;
	import game.ui.market.UIMarket;
	import game.ui.market.UIMarketBuy_Gold;
	import game.ui.netWorkDropped.UINetWorkDropped;
	import game.ui.recharge.UIDTRechatge;
	import game.ui.recharge.UIRechatge;
	import game.ui.sanguozhanchang.enter.UISanguoZhangchangEnter;
	import game.ui.sanguozhanchang.sanguoZhanchangRelive.UISanguoZhanchangRelive;
	import game.ui.tasktrace.UITaskTrace;
	import game.ui.uibackpack.fastswapequips.UIFastSwapEquips;
	import game.ui.uibackpack.UIBackPack;
	import game.ui.uibackpack.watch.UIWatchPlayer;
	import game.ui.uibenefithall.UIBenefitHall;
	import game.ui.uiblack.UIBlack;
	import game.ui.uicorpsduobao.enter.UICorpsTreasureEnter;
	import game.ui.uiGgzjExpReward.UIGgzjExpReward;
	import game.ui.uiHintMgr.UIHintMgr;
	import game.ui.uihuntexchange.UIHuntExchange;
	import game.ui.uimysteryshop.UIMysteryShop;
	import game.ui.uiNewHand.UINewHand;
	import game.ui.uiOpenNewFeature.UIOpenNewFeature;
	import game.ui.uipaoshangsys.UIPaoShangSys;
	import game.ui.uiPlotTips.UIPlotTips;
	import game.ui.uiQAsys.UIQAsys;
	import game.ui.uisysconfig.UISysConfig;
	import game.ui.uiTeamFBSys.UITeamFBSys;
	import game.ui.uiTipInchat.UITipInChat;
	import game.ui.uiviptiyan.UIVipTiYan;
	import game.ui.uiwuxueexchange.UIWuxueExchange;
	import game.ui.uiWorldMap.UIWorldMap;
	import game.ui.uiXingMai.UIXingMai;
	import game.ui.uiZhenfa.UIZhenfa;
	import game.ui.zhanliAdvance.UIZhanliAdvance_ValueAni;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIMgrForGame;
	import game.ui.tongquetai.backstage.UITongQueTai;
	import game.ui.tongquetai.forestage.UITongQueWuHui;
	import game.ui.treasurehunt.UITreasureHunt;
	import game.ui.uiRadar.UIRadar;
	import game.ui.uichat.UIChat;
	import game.ui.uiHero.UIHero;
	import game.ui.uiSysBtn.UISysBtn;
	import game.ui.uiScreenBtn.UIScreenBtn;
	import game.ui.uichargerank.UIChargeRank;
	import game.ui.uilqwj.UILQWJ;
	/**
	 * ...
	 * @author ...
	 */
	public class UIMgrForGame implements IUIMgrForGame
	{
		private var m_dicUIClass:Dictionary;
		public function UIMgrForGame() 
		{
			m_dicUIClass = new Dictionary();
			m_dicUIClass[UIFormID.UITipInChat] = UITipInChat;
			m_dicUIClass[UIFormID.UIMarket] = UIMarket;
			m_dicUIClass[UIFormID.UICorpsMarket] = UICorpsMarket;
			m_dicUIClass[UIFormID.UIGiftWatch] = UIGiftWatch;
			m_dicUIClass[UIFormID.UISanguoZhangchangEnter] = UISanguoZhangchangEnter;
			m_dicUIClass[UIFormID.UIAnnouncement] = UIAnnouncement;
			m_dicUIClass[UIFormID.UINewHand] = UINewHand;
			m_dicUIClass[UIFormID.UIOpenNewFeature] = UIOpenNewFeature;
			m_dicUIClass[UIFormID.UITaskTrace] = UITaskTrace;
			m_dicUIClass[UIFormID.UIZhanliAdvance_ValueAni] = UIZhanliAdvance_ValueAni;
			m_dicUIClass[UIFormID.UIExpression] = UIExpression;
			m_dicUIClass[UIFormID.UITongQueTai] = UITongQueTai;
			m_dicUIClass[UIFormID.UIWuxueExchange] = UIWuxueExchange;
			m_dicUIClass[UIFormID.UIRechatge] = UIRechatge;
			m_dicUIClass[UIFormID.UIDTRechatge] = UIDTRechatge;
			m_dicUIClass[UIFormID.UITongQueWuHui] = UITongQueWuHui;
			m_dicUIClass[UIFormID.UITreasureHunt] = UITreasureHunt;
			m_dicUIClass[UIFormID.UIHuntExchange] = UIHuntExchange;
			m_dicUIClass[UIFormID.UIRadar] = UIRadar;
			m_dicUIClass[UIFormID.UIChat] = UIChat;
			m_dicUIClass[UIFormID.UIHero] = UIHero;
			m_dicUIClass[UIFormID.UIZhenfa] = UIZhenfa;
			m_dicUIClass[UIFormID.UIXingMai] = UIXingMai;
			m_dicUIClass[UIFormID.UiSysBtn] = UISysBtn;
			m_dicUIClass[UIFormID.UIScreenBtn] = UIScreenBtn;
			m_dicUIClass[UIFormID.UIAniRewarded] = UIAniRewarded;
			m_dicUIClass[UIFormID.UIBenefitHall] = UIBenefitHall;
			m_dicUIClass[UIFormID.UIChargeRank] = UIChargeRank;
			m_dicUIClass[UIFormID.UIBlack] = UIBlack;
			m_dicUIClass[UIFormID.UIMarketBuy_Gold] = UIMarketBuy_Gold;
			m_dicUIClass[UIFormID.UIMarketBuy_Rongyu] = UIMarketBuy_Rongyu;
			m_dicUIClass[UIFormID.UIMarketBuy_Corps] = UIMarketBuy_Corps;
			m_dicUIClass[UIFormID.UIQAsys] = UIQAsys;
			m_dicUIClass[UIFormID.UIHintMgr] = UIHintMgr;
			m_dicUIClass[UIFormID.UISysConfig] = UISysConfig;
			m_dicUIClass[UIFormID.UIHeroRally] = UIHeroRally;
			m_dicUIClass[UIFormID.UISanguoZhanchangRelive] = UISanguoZhanchangRelive;
			m_dicUIClass[UIFormID.UIMarketBuy_Quick] = UIMarketBuy_Quick;
			m_dicUIClass[UIFormID.UITeamFBSys] = UITeamFBSys;
			m_dicUIClass[UIFormID.UIPaoShangSys] = UIPaoShangSys;
			m_dicUIClass[UIFormID.UIMysteryShop] = UIMysteryShop;
			m_dicUIClass[UIFormID.UIBackPack] = UIBackPack;
			m_dicUIClass[UIFormID.UIWatchPlayer] = UIWatchPlayer;
			m_dicUIClass[UIFormID.UIFastSwapEquips] = UIFastSwapEquips;
			m_dicUIClass[UIFormID.UINetWorkDropped] = UINetWorkDropped;
			m_dicUIClass[UIFormID.UIGgzjExpReward] = UIGgzjExpReward;
			m_dicUIClass[UIFormID.UIPlotTips] = UIPlotTips;
			m_dicUIClass[UIFormID.UIWorldMap] = UIWorldMap;
			m_dicUIClass[UIFormID.UILQWJ] = UILQWJ;
			m_dicUIClass[UIFormID.UIVipTiYan] = UIVipTiYan;
			m_dicUIClass[UIFormID.UICollectProgress] = UICollectProgress;
			m_dicUIClass[UIFormID.UICorpsTreasureEnter] = UICorpsTreasureEnter;
		}
		
		public function createUI(id:int):Form
		{
			return new m_dicUIClass[id];
		}
		
	}

}