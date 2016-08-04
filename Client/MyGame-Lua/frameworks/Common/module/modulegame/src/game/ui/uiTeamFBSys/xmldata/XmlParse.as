package game.ui.uiTeamFBSys.xmldata 
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.XMLResource;
	
	import modulecommon.scene.prop.xml.DataXml;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	
	/**
	 * @brief XML 解析
	 */
	public class XmlParse 
	{
		public var m_data:UITFBSysData;
		
		public function XmlParse(data:UITFBSysData)
		{
			m_data = data;
		}
		
		public function loadConfig():void
		{
			//m_data.m_gkcontext.m_context.m_resMgr.load("asset/config/teamfbsys.xml", XMLResource, onLoaded, onFailed);
			parseXml(m_data.m_gkcontext.m_dataXml.getXML(DataXml.XML_Teamfbsys));
		}
		
		public function onLoaded(event:ResourceEvent):void
		{
			Logger.info(null, null, "asset/config/teamfbsys.xml is loaded");
			var res:XMLResource = event.resourceObject as XMLResource;
			parseXml(res.XMLData);
			m_data.m_gkcontext.m_context.m_resMgr.unload("asset/config/teamfbsys.xml", XMLResource);
		}
		
		private function onFailed(event:ResourceEvent):void
		{
			Logger.error(null, null, "asset/config/teamfbsys.xml is failed");
			m_data.m_gkcontext.m_context.m_resMgr.unload("asset/config/teamfbsys.xml", XMLResource);
		}
		
		public function parseXml(xml:XML):void
		{
			var cityList:XMLList;
			var cityXML:XML;
			var page:XmlPage;
			
			cityList = xml.child("page");
			for each(cityXML in cityList)
			{
				page = new XmlPage();
				page.parseXml(cityXML);
				m_data.m_pageLst.push(page);
			}
			
			// 解析提示
			var tip:XML;
			tip = xml.child("guanshujianglitip")[0];
			m_data.m_xmlData.m_guanshujianglitip = tip.@text;
			m_data.m_xmlData.m_defGuanshujianglitip = tip.@textdefault;
			tip = xml.child("mingcijianglitip")[0];
			m_data.m_xmlData.m_mingcijianglitip = tip.@text;
			m_data.m_xmlData.m_defMingcijianglitip = tip.@textdefault;
			
			// 解析 boss 奖励
			m_data.m_xmlData.m_bossRewardVec = new Vector.<XmlBossRewardItem>();
			var bossrewarditem:XmlBossRewardItem;
			var bossrewardxml:XMLList
			bossrewardxml = xml.child("bossreward")[0].child("boss");
			var bossrewarditemxml:XML;
			for each(bossrewarditemxml in bossrewardxml)
			{
				bossrewarditem = new XmlBossRewardItem();
				bossrewarditem.parseXml(bossrewarditemxml);
				m_data.m_xmlData.m_bossRewardVec.push(bossrewarditem);
			}
			
			// 解析 reank 奖励
			var rankXmlLst:XMLList = xml.child("bossreward")[0].child("rank");
			var rankitemXml:XML;
			var rankitem:XmlRankItem;
			for each(rankitemXml in rankXmlLst)
			{
				rankitem = new XmlRankItem();
				rankitem.parseXml(rankitemXml);
				m_data.m_xmlData.m_rankVec.push(rankitem);
			}
			
			if(m_data.m_xmlParseEndCB != null)
			{
				m_data.m_xmlParseEndCB();
				m_data.m_xmlParseEndCB = null;
			}
		}
	}
}