package game.ui.uiTeamFBSys.xmldata
{
	/**
	 * @brief 一叶中的某一项内容
	 * */
	public class XmlFBItem
	{
		public var m_id:Vector.<uint>;
		public var m_picname:Vector.<String>;
		public var m_name:Vector.<String>;
		public var m_level:Vector.<uint>;
		//public var m_maxplayer:Vector.<uint>;
		public var m_rewardLst:Vector.<Vector.<XmlFBReward>>;
		
		//public var m_openedFBLst:Vector.<Array>;		// 已经开启次副本的列表
		public var m_rewardDesc:Vector.<String>;
		
		public function XmlFBItem()
		{
			m_id = new Vector.<uint>(2, true);
			m_picname = new Vector.<String>(2, true);
			m_name = new Vector.<String>(2, true);
			m_level = new Vector.<uint>(2, true);
			//m_maxplayer = new Vector.<uint>(2, true);
			m_rewardDesc = new Vector.<String>(2, true);
			m_rewardLst = new Vector.<Vector.<XmlFBReward>>(2, true);
			
			m_rewardLst[0] = new Vector.<XmlFBReward>();
			m_rewardLst[1] = new Vector.<XmlFBReward>();
			
			//m_openedFBLst = new Vector.<Array>();
			//m_openedFBLst[0] = [];
			//m_openedFBLst[1] = [];
			
			/*
			// test
			var openeditem:XmlOpenedFBItem;
			var idx:uint = 0;
			while(idx < 12)
			{
				openeditem = new XmlOpenedFBItem();
				openeditem.m_fbcurnum = idx;
				m_openedFBLst[0][m_openedFBLst[0].length] = openeditem;
				m_openedFBLst[1][m_openedFBLst[1].length] = openeditem;
				
				++idx;
			}
			*/
		}
		
		public function parseXml(xml:XML, idx:uint):void
		{
			m_id[idx] = parseInt(xml.@id);
			m_picname[idx] = xml.@picname;
			m_name[idx] = xml.@name;
			m_level[idx] = xml.@level;
			//m_maxplayer[idx] = xml.@maxplayer;
			//m_rewardDesc[idx] = xml.@desc;

			var listXML:XMLList = xml.child("obj");
			var i:int;
			var rewardItem:XmlFBReward;
			for (i = 0; i < listXML.length(); i++)
			{
				rewardItem = new XmlFBReward();
				rewardItem.parseXml(listXML[i]);
				m_rewardLst[idx].push(rewardItem);
			}
			
			var descxml:XML = xml.child("desc")[0];
			m_rewardDesc[idx] = descxml.toString();
		}
	}
}