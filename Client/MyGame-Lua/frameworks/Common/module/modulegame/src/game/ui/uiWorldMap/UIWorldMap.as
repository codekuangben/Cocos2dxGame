package game.ui.uiWorldMap
{
	//import art.worldmap.bg;art.worldmap.bg;
	import com.bit101.components.PushButton;
	import common.event.UIEvent;
	import flash.utils.Dictionary;
	//import com.bit101.components.ButtonText;
	import com.bit101.components.Panel;
	//import flash.display.Sprite;
	import flash.utils.ByteArray;
	import modulecommon.uiinterface.IUIFuben;
	import game.ui.uiWorldMap.netmsg.stRefreshCheckPointListUserCmd;
	
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import flash.events.MouseEvent;
	//import com.bit101.components.ButtonImageText;
	import modulecommon.uiinterface.IUIWorldMap;
	//import flash.utils.Dictionary;
	import modulecommon.scene.prop.table.TWorldmapItem;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TDataItem;
	import modulecommon.scene.beings.PlayerMain;


	/**
	 * ...
	 * @author panqiangqiang
	 */
	public class UIWorldMap extends Form  implements IUIWorldMap
	{
		private var m_bgPanel:Panel;
		private var m_playerCom:PlayerCom;
		private var m_btnClose:PushButton;
		private var m_worldCity:Dictionary; //[id,  WorldMapCity];
		
		//private var m_lstVLine:Vector.<Panel>;		// 竖线
		//private var m_lstArrow:Vector.<Panel>;		// 箭头
		
		public function UIWorldMap()
		{
			m_worldCity = new Dictionary();
		}
		override public function onReady():void
		{	
			this.exitMode = EXITMODE_HIDE;
			this.m_gkcontext.m_UIs.worldmap = this;
			
			//m_lstVLine = new Vector.<Panel>();
			//m_lstArrow = new Vector.<Panel>();
			
			m_bgPanel =  new Panel(this, 0, 0);
			m_bgPanel.setPanelImageSkin("commoncontrol/panel/wordmapbg.jpg");
			this.setSize(1920, 1080);
			
			m_btnClose = new PushButton(m_bgPanel, m_bgPanel.width - 100 - 80, 40 + 80, onBtnClick);
			m_btnClose.setSkinButton1Image("commoncontrol/panel/word_leave1.png");
			//m_btnClose.setPanelImageSkin("radarbutton");
			
			//m_btnClose.setImageText("commoncontrol/panel/word_leave1.png");
			m_playerCom = new PlayerCom(m_gkcontext);
			this.addChild(m_playerCom);
			
			
			this.adjustPosWithAlign();
			this.darkOthers(0, 1);
			setFade();
			super.onReady();
		}
		
		override public function onShow():void 
		{
			super.onShow();
			updateCloseBtnPos();	
			var send:stRefreshCheckPointListUserCmd = new stRefreshCheckPointListUserCmd();
			var baseList:Vector.<TDataItem> = this.m_gkcontext.m_dataTable.getTable(DataTable.TABLE_WORLDMAP);
			var mapItem:TWorldmapItem;
			for(var i:uint = 0; i < baseList.length; ++i)
			{
				mapItem = baseList[i] as TWorldmapItem;
				if (mapItem.checkpoint)
				{
					if (-1==send.list.indexOf(mapItem.checkpoint))
					{
						send.list.push(mapItem.checkpoint);
					}					
				}
				
			}
			m_gkcontext.sendMsg(send);
		}
		private function onBtnClick(event:MouseEvent):void
		{
			// 关闭副本地图
			var ui:IUIFuben = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFuben) as IUIFuben;
			if (ui)
			{
				ui.exit();
			}
			
			var form:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFubenSaoDang);
			if (form)
			{
				form.exit();
			}
			
			this.exit();
		}
		public function onNotify():void
		{
			//calCityList();
		}
		override public function onStageReSize():void 
		{
			super.onStageReSize();
			this.darkOthers(0, 1);
			updateCloseBtnPos();
		}
		
		
		//收到消息stRefreshCheckPointListUserCmd时，调用此函数
		override public function updateData(param:Object = null):void 
		{
			var rev:stRefreshCheckPointListUserCmd = new stRefreshCheckPointListUserCmd();
			rev.deserialize(param as ByteArray);
			calCityList(rev.list);
		}
		
		private function calCityList(checklist:Vector.<uint>):void
		{
			var mainPlayer:PlayerMain = m_gkcontext.m_playerManager.hero as PlayerMain;
			var mainLevel:uint = mainPlayer.level;
			var wmc:WorldMapCity = null;
			var iCurMapID:int = m_gkcontext.m_mapInfo.curMapID;
			var curMapItem:TWorldmapItem;
			var baseList:Vector.<TDataItem> = this.m_gkcontext.m_dataTable.getTable(DataTable.TABLE_WORLDMAP);
			var bAdd:Boolean;
			for(var i:uint = 0; i < baseList.length; ++i)
			{
				var item:TWorldmapItem = baseList[i] as TWorldmapItem;
				if (item.type == 0 && item.city_checkpoint == iCurMapID)
				{
					curMapItem = item;
				}
				bAdd = false;
				if (item.type == 0 || item.type == 1)
				{
					if(mainLevel >= item.level && (item.checkpoint == 0 || -1!=checklist.indexOf(item.checkpoint)))
					{
						bAdd = true;						
					}
				}
				else if (item.type == 2)
				{
					if (mainLevel >= item.level)
					{
						bAdd = true;						
					}
				}
				//bAdd = true;
				
				if (bAdd == true)
				{
					if (m_worldCity[item.m_uID] == undefined)
					{
						m_worldCity[item.m_uID] = new WorldMapCity(m_gkcontext, item, m_playerCom, m_bgPanel);
					}					
				}
			}
			
			m_playerCom.initData(curMapItem);
			autoRun();
		}
		//自动走
		protected function autoRun():void
		{			
			var bRun:Boolean;
			var cityID:uint;
			cityID = m_gkcontext.m_contentBuffer.getContent("uiWorldMap_runToCity", true) as uint;
			if (cityID != 0)
			{
				bRun = true;
			}
			else
			{
				cityID = m_gkcontext.m_contentBuffer.getContent("uiWorldMap_moveToCity", true) as uint;
			}
			
			if (cityID)
			{
				var wmc:WorldMapCity;
				for each(wmc in m_worldCity)
				{
					if (wmc.cityID == cityID)
					{
						if (bRun)
						{
							wmc.runToMe();
						}
						else
						{
							wmc.moveToMe();
						}
						break;
					}
				}				
			}
		}
		
		override public function onDestroy():void 
		{
			super.onDestroy();
			this.m_gkcontext.m_UIs.worldmap = null;
		}
		
		private function updateCloseBtnPos():void
		{
			var stageW:int = m_gkcontext.m_context.m_config.m_curWidth;
			
			//m_btnClose.x = stageW - this.x - 75;
			//m_btnClose.y = -this.y + 14;
			
			m_btnClose.x = stageW - this.x - 75 - 80;
			m_btnClose.y = -this.y + 14 + 80;
		}
		
		override protected function onFormMouseGoDown(event:MouseEvent):void
		{
			//点击世界地图，不要显示到“UIFuben”上面来
		}
	}
}