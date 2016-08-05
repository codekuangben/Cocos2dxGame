package modulecommon.scene.prop.xml 
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author ...
	 */
	public class DataXml 
	{		
		public static const XML_Equiphecheng:String = "equiphecheng.xml";
		public static const XML_Common:String = "common.xml";
		public static const XML_Zhanxing:String = "zhanxing.xml";
		public static const XML_Yizhelibao:String = "yizhelibao.xml";	//一折礼包
		public static const XML_JunTuanZhan:String = "juntuanzhan.xml";	//军团争夺战
		public static const XML_Teamfbsys:String = "teamfbsys.xml";	//组队副本
		public static const XML_Xingmaicfg:String = "xingmaicfg.xml";	//星脉(觉醒)
		public static const XML_TongQueTai:String = "tongquetai.xml";	//铜雀台
		public static const XML_EquipXilian:String = "equipfjxl.xml";	//装备洗练
		public static const XML_Treasurehunting:String = "treasurehunting_client.xml";	//寻宝
		public static const XML_GodlyWeapon:String = "godlyweapon.xml";	//神兵(绝世七宝)
		public static const XML_Meiribizuo:String = "meiribizuo.xml";	//每日必做
		public static const XML_Limitbigsendact:String = "limitbigsendact.xml";	//限时放送活动
		public static const XML_Sevenloginaward:String = "sevenloginaward.xml";	//7日登陆奖
		public static const XML_Rankreward:String = "rankreward.xml";	//全民冲榜
		public static const XML_RechargeRebate:String = "rechargerebate.xml";	//充值返利
		public static const XML_DTRechargeRebate:String = "dtrechargerebate.xml";	//定时充值返利
		public static const XML_Guanzhijingji:String = "guanzhijingji.xml";		//竞技场奖励
		public static const XML_Heropub:String = "heropub.xml";					//紫色武将招募
		public static const XML_Herotrain:String = "herotrain.xml";				//武将培养
		public static const XML_Vip:String = "vip.xml";							//vip配置
		public static const XML_Yugaogongneng:String = "yugaogongneng.xml";		//功能预告
		public static const XML_Zhanlitishen:String = "zhanlitishen.xml";		//战力提升配置
		public static const XML_Sanguoqunyinghui:String = "sanguoqunyinghui_client.xml";		//三国英雄会
		public static const XML_Jianglizhaohui:String = "jianglizhaohui_client.xml";		//奖励找回
		public static const XML_Secretstore:String = "secretstore.xml";		//神秘商店
		public static const XML_Paoshang:String = "paoshang.xml";		//跑商
		public static const XML_Useractrelations:String = "useractrelations.xml";			//我的三国关系
		public static const XML_Mountsystrain:String = "mountsystrain.xml";			//坐骑培养
		public static const XML_Fighttips:String = "fighttips.xml";			//战斗小贴士
		public static const XML_Preload:String = "preload.xml";			//预加载
		
		private var m_res:SWFResource;
		private var m_dicConfig:Dictionary;
		private var m_gkContext:GkContext;
		public function DataXml(gk:GkContext)
		{
			m_gkContext = gk;
			m_dicConfig = new Dictionary();
			m_dicConfig[XML_Equiphecheng] = "equiphecheng";
			m_dicConfig[XML_Common] = "common";
			m_dicConfig[XML_Zhanxing] = "zhanxing";
			m_dicConfig[XML_Yizhelibao] = "yizhelibao";
			m_dicConfig[XML_JunTuanZhan] = "juntuanzhan";
			m_dicConfig[XML_Teamfbsys] = "teamfbsys";
			m_dicConfig[XML_Xingmaicfg] = "xingmaicfg";
			m_dicConfig[XML_TongQueTai] = "tongquetai";
			m_dicConfig[XML_EquipXilian] = "equipfjxl";
			m_dicConfig[XML_Treasurehunting] = "treasurehunting_client";
			m_dicConfig[XML_GodlyWeapon] = "godlyweapon";
			m_dicConfig[XML_Meiribizuo] = "meiribizuo";
			m_dicConfig[XML_Limitbigsendact] = "limitbigsendact";
			m_dicConfig[XML_Sevenloginaward] = "sevenloginaward";
			m_dicConfig[XML_Rankreward] = "rankreward";
			m_dicConfig[XML_RechargeRebate] = "rechargerebate";
			m_dicConfig[XML_DTRechargeRebate] = "dtrechargerebate";
			m_dicConfig[XML_Guanzhijingji] = "guanzhijingji";
			m_dicConfig[XML_Heropub] = "heropub";
			m_dicConfig[XML_Herotrain] = "herotrain";
			m_dicConfig[XML_Vip] = "vip";
			m_dicConfig[XML_Yugaogongneng] = "yugaogongneng";
			m_dicConfig[XML_Zhanlitishen] = "zhanlitishen";
			m_dicConfig[XML_Sanguoqunyinghui] = "sanguoqunyinghui_client";
			m_dicConfig[XML_Jianglizhaohui] = "jianglizhaohui_client";
			m_dicConfig[XML_Secretstore] = "secretstore";
			m_dicConfig[XML_Paoshang] = "paoshang";
			m_dicConfig[XML_Useractrelations] = "useractrelations";
			m_dicConfig[XML_Mountsystrain] = "mountsystrain";
			m_dicConfig[XML_Fighttips] = "fighttips";
			m_dicConfig[XML_Preload] = "preload";
		}
		
		
		public function setRes(res:SWFResource):void
		{
			m_res = res;
		}
		
		public function getXML(xmlType:String):XML
		{
			var bytes:ByteArray = m_res.getExportedAsset(m_dicConfig[xmlType]) as ByteArray;
			var str:String = bytes.readUTFBytes(bytes.length);
			return new XML(str);
		}
	}

}