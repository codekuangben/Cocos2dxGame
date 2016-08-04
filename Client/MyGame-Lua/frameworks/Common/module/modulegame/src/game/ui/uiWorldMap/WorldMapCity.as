package game.ui.uiWorldMap
{
	import com.bit101.components.Ani;
	import com.bit101.components.AniZoom;
	import com.bit101.components.Component;
	import com.bit101.components.PushButton;
	import common.event.UIEvent;
	import flash.geom.Point;
	import modulecommon.scene.beings.PlayerMain;
	import org.ffilmation.engine.datatypes.PosOfLine;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.copyUserCmd.stReqAvailableCopyUserCmd;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TWorldmapItem;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	import game.ui.uiWorldMap.netmsg.reqGotoMapUserCmd;
	
	public class WorldMapCity extends Component
	{
		private var m_gkContext:GkContext;
		private var m_item:TWorldmapItem;
		private var m_btn:PushButton;
		private var m_player:PlayerCom;
		
		//private var m_redArrow:DirectLine;
		private var m_openFun:OpenFun;
		private var m_OpenFunList:Vector.<int>;
		private var m_taskMarkAni:AniZoom;
		
		public function WorldMapCity(gk:GkContext, item:TWorldmapItem, player:PlayerCom, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			m_gkContext = gk;
			m_item = item;
			m_player = player;
			super(parent, xpos, ypos);
			this.setPos(m_item.x, m_item.y);
			m_btn = new PushButton(this);
			
			m_btn.addEventListener(MouseEvent.CLICK, onClick);
			m_btn.addEventListener(UIEvent.IMAGELOADED, onImageLoad);
			m_btn.setSkinButton2Image("worldmap/" + item.pic + ".swf");
			
			//var pos:PosOfLine = new PosOfLine();
			//m_item.strArrowPos="100-30-270"
			/*if (m_item.strArrowPos&&m_item.strArrowPos.length)
			{
				pos.parse(m_item.strArrowPos);
				m_redArrow = new DirectLine(this, pos.m_x, pos.m_y);
				m_redArrow.setLinePanel("commoncontrol/panel/redarrow.png", 0, -6);
				m_redArrow.rotation = pos.m_dir;
			}*/
			
			//m_item.strOpenFunctions="0-0-90;8:藏宝囊窟"
			//1:星脉:12,45;2:武将激活:45,46

			if (m_item.strOpenFunctions&&m_item.strOpenFunctions.length)
			{
				var arr:Array = m_item.strOpenFunctions.split(";");
				
				
				m_OpenFunList = new Vector.<int>();
				var nameList:Vector.<String> = new Vector.<String>();
				var posList:Vector.<Point> = new Vector.<Point>();
				for (var i:int = 0; i < arr.length; i++)
				{
					var tempArr:Array = (arr[i] as String).split(":");
					if (tempArr.length != 3)
					{
						continue;
					}
					
					m_OpenFunList.push(parseInt(tempArr[0]));
					nameList.push(tempArr[1]);
					
					var posArr:Array = (tempArr[2] as String).split(",");
					var pos:Point = new Point();
					pos.x = parseInt(posArr[0]);
					pos.y = parseInt(posArr[1]);
					posList.push(pos);
				}
				
				var bAllOpen:Boolean = true;
				for (i = 0; i < m_OpenFunList.length; i++)
				{
					if (false == m_gkContext.m_sysnewfeatures.isSet(m_OpenFunList[i]))
					{
						bAllOpen = false;
						break;
					}
				}
				
				if (bAllOpen == false)
				{
					m_openFun = new OpenFun(this);
					m_openFun.setFunList(nameList, posList);
				}
			}
			
			updateTaskMark();
			//var mainPlayer:PlayerMain = m_gkContext.m_playerManager.hero as PlayerMain;
			//var mainLevel:uint = mainPlayer.level;
			
			/*var bActive:Boolean;
			if (m_item.type == 0 || m_item.type == 1)
			{
				if (mainLevel >= m_item.level && m_gkContext.m_beingProp.checkPoint >= m_item.checkpoint)
				{
					bActive = true;
				}
			}
			else if (m_item.type == 2)
			{
				if (mainLevel >= m_item.level)
				{
					bActive = true;
				}
			}
			
			if (bActive==false)
			{
				this.m_btn.enabled = false;
			}*/
			
		}
		
		
		public function onImageLoad(e:UIEvent):void
		{
			m_btn.setPos(- m_btn.width / 2, - m_btn.height / 2);
			m_btn.removeEventListener(UIEvent.IMAGELOADED, onImageLoad);
		}
		
		public function updateTaskMark():void
		{
			if (m_gkContext.m_taskMgr.isTaskworldmap(m_item.m_uID))
			{
				if (m_taskMarkAni == null)
				{
					m_taskMarkAni = new AniZoom(this, -25, -55);
					m_taskMarkAni.setParam(0.9, 1.1, 10, 78, 45, true);
					m_taskMarkAni.setImageAni("commoncontrol/panel/taskmark.png");
					m_taskMarkAni.begin();
				}
			}
			else
			{
				if (m_taskMarkAni)
				{
					m_taskMarkAni.stop();
					m_taskMarkAni.dispose();
					if (m_taskMarkAni.parent)
					{
						m_taskMarkAni.parent.removeChild(m_taskMarkAni);
					}
					m_taskMarkAni = null;
				}
			}
			
		}
		public function onArrive():void
		{
			var form:Form;
			if (1 == m_item.type)
			{ //打开副本
				var send:stReqAvailableCopyUserCmd = new stReqAvailableCopyUserCmd();
				send.id = m_item.city_checkpoint;
				m_gkContext.sendMsg(send);
			}
			else if (0 == m_item.type)
			{
				//跳转到下个主城
				if (m_item.city_checkpoint != m_gkContext.m_mapInfo.curMapID)
				{
					var gomap:reqGotoMapUserCmd = new reqGotoMapUserCmd();
					gomap.mapid = m_item.city_checkpoint;
					m_gkContext.sendMsg(gomap);
				}
				
				form = m_gkContext.m_UIMgr.getForm(UIFormID.UIWorldMap);
				if (form)
				{
					form.exit();
				}
				
				form = m_gkContext.m_UIMgr.getForm(UIFormID.UIFuben);
				if (form)
				{
					form.exit();
				}
			}
		}
		
		public function onClick(e:MouseEvent):void
		{
			if (e.target is PushButton)
			{
				runToMe();
			}
		}
		
		public function runToMe():void
		{
			m_player.runToPos(m_item, onArrive);
		}
		
		public function moveToMe():void
		{
			m_player.moveTo(this.x, this.y);
			onArrive();
		}
		
		public function get cityID():uint
		{
			return m_item.m_uID;
		}
		
		override public function dispose():void
		{
			if (m_taskMarkAni && (null == m_taskMarkAni.parent))
			{
				m_taskMarkAni.dispose();
			}
			
			super.dispose();
		}
		
		public function isCity(item:TWorldmapItem):Boolean
		{
			return m_item == item;
		}
	}
}