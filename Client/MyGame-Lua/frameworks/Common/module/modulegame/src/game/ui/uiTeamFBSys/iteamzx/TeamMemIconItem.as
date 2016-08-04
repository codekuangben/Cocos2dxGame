package game.ui.uiTeamFBSys.iteamzx 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.PanelImage;
	import com.dnd.DragListener;
	import com.dnd.DragManager;
	import com.dnd.DraggingImage;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import common.event.DragAndDropEvent;
	
	import modulecommon.net.msg.copyUserCmd.UserDispatch;
	import modulecommon.net.msg.teamUserCmd.TeamUser;
	import ui.player.PlayerResMgr;
	import com.util.UtilColor;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.iteamzx.event.TeamDragEvent;
	import game.ui.uiTeamFBSys.msg.reqChangeUserPosUserCmd;

	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class TeamMemIconItem extends Component implements DragListener, DraggingImage
	{
		private var m_pngBg:Panel;			// 背景
		private var m_pnlHeaderImg:Panel;	// 头像
		private var m_lblName:Label;		// 名字
		private var m_pnlFlag:Panel;		// 队长旗子
		
		protected var m_pnlDnd:Component;	// 拖放位置
		public var m_TFBSysData:UITFBSysData;
		public var m_iTag:int;		// 这个就是索引序号
		
		public function TeamMemIconItem(data:UITFBSysData, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_TFBSysData = data;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);		
			this.buttonMode = true;
			
			m_pngBg = new Panel(this);
			
			m_pnlHeaderImg = new Panel(this, 12, 15);
			m_lblName = new Label(this, 63, 25, "");
			m_pnlFlag = new Panel(this, 63, 4);
			m_pnlDnd = new TeamMemIconItemDND(m_TFBSysData, null);
		}
		
		override public function dispose():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			super.dispose();
		}
		
		public function updateUI():void
		{
			var user:UserDispatch;
			if(m_TFBSysData.ud)
			{
				user = m_TFBSysData.ud[m_iTag];
				if(user)
				{
					// 设置显示 数据
					var item:TeamUser;
					item = m_TFBSysData.getUserInfo(user.charid);
					if(item)
					{
						m_pnlHeaderImg.visible = true;
						m_pnlHeaderImg.setPanelImageSkin(m_TFBSysData.m_gkcontext.m_context.m_playerResMgr.roundHeadPathName(item.job, item.sex, PlayerResMgr.HDMid));
						m_lblName.setFontColor(UtilColor.WHITE);
						m_lblName.text = item.name;
						
						if(m_TFBSysData.isLeader(item.id))	// 如果是队长
						{
							// 这个一定放在最后,最上面的处理鼠标放下的事件
							m_pnlFlag.visible = true;
							m_pnlFlag.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.dzbz");
						}
						else
						{
							m_pnlFlag.visible = false;
						}
					}
				}
				else
				{
					// 如果没有设置，就需要清除显示内容
					m_pnlHeaderImg.visible = false;
					m_pnlFlag.visible = false;
					m_lblName.setFontColor(UtilColor.GREEN);
					m_lblName.text = "缺少队伍成员";
				}
			}
			else
			{
				// 如果没有设置，就需要清除显示内容
				m_pnlHeaderImg.visible = false;
				m_lblName.setFontColor(UtilColor.GREEN);
				m_lblName.text = "缺少队伍成员";
			}
			
			if(m_TFBSysData.isSelfRow(m_iTag))	// 如果是自己
			{
				m_pngBg.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.kwdbzjt");
			}
			else
			{
				m_pngBg.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.kwct");
			}
			
			/*
			// test
			m_lblName.text = "你好";
			m_pnlFlag.visible = true;
			m_pnlFlag.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.dzbz");
			m_pnlHeaderImg.visible = true;
			m_pnlHeaderImg.setPanelImageSkin(m_TFBSysData.m_gkcontext.m_context.m_playerResMgr.roundHeadPathName(1, 1, PlayerResMgr.HDMid));
			*/
		}

		public function onMouseDown(e:MouseEvent):void
		{
			if (DragManager.isDragging() == true)
			{
				return;
			}
			
			var user:UserDispatch;
			if(m_TFBSysData.ud)
			{
				user = m_TFBSysData.ud[m_iTag];
			}
			
			if(!user)	// 如果这个位置没有人 
			{
				return;
			}
			
			DragManager.startDrag(this, null, this, this, true);
			this.dispatchEvent(new TeamDragEvent(TeamDragEvent.DRAG_TEAMMEM, user));
		}

		public function onOut():void
		{		
			if (m_TFBSysData.m_gkcontext.m_uiTip)
			{
				m_TFBSysData.m_gkcontext.m_uiTip.hideTip();
			}
		}

		public function onOver():void
		{
			
		}
		
		// 是否可以拖方
		public override function isDragAcceptableInitiator(com:Component):Boolean
		{
			return com is TeamMemIconItem;
		}

		public function getDisplayEx(bAccept:Boolean):Bitmap
		{
			var user:UserDispatch;
			if(m_TFBSysData.ud)
			{
				user = m_TFBSysData.ud[m_iTag];
			}
			
			var bitmap:Bitmap;
			if(user)
			{
				var model:String;
				var image:Image;
				var item:TeamUser;
				item = m_TFBSysData.getUserInfo(user.charid);
				model = m_TFBSysData.m_gkcontext.m_context.m_playerResMgr.roundHeadPathName(item.job, item.sex, PlayerResMgr.HDMid);
				image = m_TFBSysData.m_gkcontext.m_context.m_commonImageMgr.getImage(model);
		
				bitmap = m_TFBSysData.m_gkcontext.m_context.m_dragResPool.getBitmap();
				var bitmapData:BitmapData;
				
				if(image is PanelImage)
				{
					bitmapData = (image as PanelImage).data;
				}
				if(!bitmapData)
				{
					bitmapData = new BitmapData(1, 1);	// 一个默认颜色
				}
			}
			else
			{
				bitmapData = new BitmapData(1, 1);	// 一个默认颜色
			}
			bitmap.bitmapData = bitmapData;
			bitmap.width = bitmapData.width;
			bitmap.height = bitmapData.height;
			bitmap.bitmapData = bitmapData;
			bitmap.x = -bitmap.width/2;
			bitmap.y = -bitmap.height/2;
			return bitmap;
		}
		
		public function getDisplay () : DisplayObject
		{
			return getDisplayEx(true);			
		}
		
		public function switchToAcceptImage () : void
		{
			getDisplayEx(true);
		}
		
		public function switchToRejectImage () : void
		{
			getDisplayEx(false);
		}
		
		public function onReadyDrop (e:DragAndDropEvent) : void
		{
			if(!(e.getTargetComponent() is TeamMemIconItemDND))	// 如果点击不是要拖放的目的地
			{
				// 不符合拖放的位置,处理代码
			}
			else	// 如果是要拖放的目的地
			{
				var targetC:TeamMemIconItem = e.getTargetComponent() as TeamMemIconItem;
				if(targetC != m_pnlDnd)
				{
					// 发送消息交换
					var dataui:TeamMemIconItem = e.getTargetComponent().parent as TeamMemIconItem;
					var user:UserDispatch;
					if(m_TFBSysData.ud)
					{
						//user = m_TFBSysData.ud[dataui.m_iTag];
						user = m_TFBSysData.ud[m_iTag];
					}
	
					var cmd:reqChangeUserPosUserCmd = new reqChangeUserPosUserCmd();
					cmd.teamid = m_TFBSysData.m_gkcontext.m_teamFBSys.teamid;
					cmd.id = user.charid;
					cmd.pos = dataui.m_iTag;
					m_TFBSysData.m_gkcontext.sendMsg(cmd);
				}
			}
			
			// 发送拖放结束事件
			DragManager.drop();
			dispatchEvent(e);
		}
		
		private function ConfirmFn():Boolean
		{
			return true;
		}
		
		public function onDragDrop (e:DragAndDropEvent) : void
		{
			var user:UserDispatch;
			if(m_TFBSysData.ud)
			{
				user = m_TFBSysData.ud[m_iTag];
			}

			this.dispatchEvent(new TeamDragEvent(TeamDragEvent.DRAG_TEAMMEM, user));
		}
		
		public function onDragEnter (e:DragAndDropEvent) : void{}
		
		public function onDragExit (e:DragAndDropEvent) : void{}
		
		public function onDragOverring (e:DragAndDropEvent) : void{}
		
		public function onDragStart (e:DragAndDropEvent) : void{}
		
		public function toggleDnd(vis:Boolean):void
		{
			if(vis)
			{
				this.addChild(m_pnlDnd);
			}
			else
			{
				if(this.contains(m_pnlDnd))
				{
					this.removeChild(m_pnlDnd);
				}
			}
		}
	}
}