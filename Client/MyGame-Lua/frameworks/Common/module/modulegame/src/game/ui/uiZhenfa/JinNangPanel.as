package game.ui.uiZhenfa 
{
	
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.PanelImage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import modulecommon.GkContext;
	import flash.display.DisplayObjectContainer;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.scene.prop.skill.SkillMgr;
	import com.bit101.components.controlList.ControlAlignmentParam;
	import com.bit101.components.controlList.ControlList;
	import modulecommon.scene.prop.object.ZObject;
	import com.pblabs.engine.resource.SWFResource;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class JinNangPanel extends PanelContainer 
	{
		public static const JINNAGEDESTGRID_MAX:int = 1;	//出战锦囊列表最大锦囊数
		private var m_jinnangList:ControlList;
		private var m_gkContext:GkContext;
		private var m_vecDestGrid:Vector.<JinnangDestGrid>;
		private var m_closedBg1:PanelContainer;
		private var m_notopenPanel:Panel;
		private var m_dragRPanel:Panel;
		private var m_objBG:PanelImage;
		public var m_uizhenfa:UIZhenfa;
		private var m_descTf:TextField;
		
		public function JinNangPanel(parent:DisplayObjectContainer, xPos:int, yPos:int, gk:GkContext)
		{
			m_gkContext = gk;
			m_uizhenfa = parent as UIZhenfa;
			super(parent, xPos, yPos);
			
			m_jinnangList = new ControlList(this, 8, -20);
			
			var param:ControlAlignmentParam = new ControlAlignmentParam();
			var obj:Object = new Object();
			obj["gk"] = m_gkContext;
			obj["jinnang"] = this;
			
			param.m_class = JinnangGrid;
			param.m_width = ZObject.IconBgSize;
			param.m_height = ZObject.IconBgSize;
			param.m_intervalH = 2;
			param.m_intervalV = 2;
			param.m_marginTop = 0;
			param.m_marginBottom = 0;
			param.m_marginLeft = 0;
			param.m_marginRight = 0;
			param.m_needScroll = false;
			param.m_numColumn = 2;
			param.m_parentHeight = 96;
			param.m_dataParam = obj;
			m_jinnangList.setParam(param);
			
			m_vecDestGrid = new Vector.<JinnangDestGrid>(JINNAGEDESTGRID_MAX);
			
			m_dragRPanel = new Panel(this, -46, -71);
			m_dragRPanel.setSize(65, 35);
			
			m_descTf = new TextField();
			this.addChild(m_descTf);
			m_descTf.multiline = true;
			m_descTf.wordWrap = true
			m_descTf.x = -150;
			m_descTf.y = -73;
			m_descTf.width = 100;
			m_descTf.height = 60;
			m_descTf.mouseEnabled = false;
			m_descTf.textColor = 0xE0972E;
			m_descTf.text = "将锦囊拖入才会在战斗中生效";
			
			this.setSize(120, 310);
		}
		
		public function initData():void
		{
			var list:Array = m_gkContext.m_wuMgr.getJinnangList();
			m_jinnangList.setDatas(list);
			
			var i:int;
			var left:int = -205;
			var top:int = -78;
			for (i = 0; i < JINNAGEDESTGRID_MAX; i++)
			{
				m_vecDestGrid[i] = new JinnangDestGrid(m_uizhenfa, this, left, top, m_gkContext, i);
				m_vecDestGrid[i].tag = i;
				left += 55;
			}
			
			resetJinnang();
			
			m_gkContext.m_context.m_commonImageMgr.loadImage(ZObject.IconBg, PanelImage, onObjBGLoaded, null);
		}
		
		public function showNewHandOfJinnang():void
		{
			if (m_gkContext.m_newHandMgr.isVisible() && (m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_JINNANG))
			{
				if (m_jinnangList.getControlByIndex(0))
				{
					m_gkContext.m_newHandMgr.setFocusFrame(-12, -12, 70, 70, 1);
					m_gkContext.m_newHandMgr.prompt(false, 50, 50, "点击锦囊，移动到出战锦囊列表中。", m_jinnangList.getControlByIndex(0) as JinnangGrid);
				}
			}
		}
		
		public function resetJinnang():void
		{
			var list:Vector.<uint> = m_gkContext.m_zhenfaMgr.getJinnangList();			
			var i:int;
			for (i = 0; i < JINNAGEDESTGRID_MAX; i++)
			{
				if (list[i] == 0)
				{
					m_vecDestGrid[i].clear();
				}
				else
				{
					m_vecDestGrid[i].setJinang(list[i]);
				}			
			}			
		}
		public function  clearJinnang(pos:int):void
		{
			m_vecDestGrid[pos].clear()
		}
		override public function dispose():void 
		{
			super.dispose();
			
			if (m_objBG != null)
			{
				m_gkContext.m_context.m_commonImageMgr.unLoad(m_objBG.name);
				m_objBG = null;
			}
			else
			{
				m_gkContext.m_context.m_commonImageMgr.removeFun(ZObject.IconBg, onObjBGLoaded, null);
			}
		}
		public function  updateLock():void
		{
			for (var i:int = 0; i < JINNAGEDESTGRID_MAX; i++)
			{
				if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_JINNANG))
				{
					m_vecDestGrid[i].open = true;
				}
				else
				{
					m_vecDestGrid[i].open = false;
				}
			
				m_vecDestGrid[i].updateLockState();
			}
		}
		
		public function  setJinnang(idInit:uint, pos:int):void
		{
			m_vecDestGrid[pos].setJinang(idInit);
		}
		
		public function onObjBGLoaded(image:Image):void
		{
			m_objBG = image as PanelImage;
			var i:int = 0;
			var bgImage:PanelImage;
			var container:Sprite = new Sprite();
			var bt:BitmapData;
			
			var bitmap:Bitmap = new Bitmap(m_objBG.data);
			container.addChild(bitmap);
			var tf:TextField = m_gkContext.m_context.m_globalObj.tf;
			tf.defaultTextFormat = new TextFormat(null, 28, 0x777777, true);
			tf.y = 7;
			tf.filters = null;
			container.addChild(tf);
			
			for (i = 0; i < JINNAGEDESTGRID_MAX; i++)
			{
				bgImage = new PanelImage();
				bt = new BitmapData(m_objBG.width, m_objBG.height);
				bgImage.setBitmapDataDirect(bt);
				tf.text = "";// (i + 1).toString();//只有一个格子不需要显示数字
				tf.x = (m_objBG.width - tf.textWidth - 4) / 2;
				bt.draw(container);
				
				//m_vecDestGrid[i].setPanelImageSkinByImage(bgImage);
			}
			
			container.removeChild(tf);
			container.removeChild(bitmap);
		}
		
		public function createImage(res:SWFResource):void
		{
			m_dragRPanel.setPanelImageSkinBySWF(res, "zhenfa.dragR");
		}
		
		//锦囊未开启时
		public function showTopBackOfJNNotOpen(bool:Boolean = true):void
		{
			if (bool)
			{
				if (null == m_closedBg1)
				{
					m_closedBg1 = new PanelContainer(this, -4, -63);
					m_closedBg1.setPanelImageSkinMirror("commoncontrol/panel/jinnangBg1.png", Image.MirrorMode_LR);
					m_notopenPanel = new Panel(m_closedBg1, 34, 95);
					m_notopenPanel.setPanelImageSkin("commoncontrol/panel/notOpen.png");
				}
				m_closedBg1.visible = true;
			}
			else
			{
				if (m_closedBg1)
				{
					m_closedBg1.visible = false;
				}
			}
		}
		
		public function showNewHand():void
		{
			if (m_gkContext.m_newHandMgr.isVisible() && (m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_JINNANG))
			{
				m_gkContext.m_newHandMgr.setFocusFrame(-12, -12, 70, 70, 1);
				m_gkContext.m_newHandMgr.prompt(true, 0, 46, "点击设置锦囊出战。", m_vecDestGrid[0]);
			}
		}
		
		public function setDescJinnang(idlevel:uint):void
		{
			var desc:String = "将锦囊拖入才会在战斗中生效";
			
			if (!m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_JINNANG))
			{
				m_descTf.text = "暂未开放";
				return;
			}
			else if (idlevel == 0)
			{
				m_descTf.text = desc;
				return;
			}
			
			switch(SkillMgr.jnAttrType(idlevel))
			{
				case SkillMgr.JNTYPE_FIRE:
					desc = "克木系 ；被水克  ";
					break;
				case SkillMgr.JNTYPE_WOOD:
					desc = "克土系 ；被火克  ";
					break;
				case SkillMgr.JNTYPE_EARTH:
					desc = "克水系 ；被木克  ";
					break;
				case SkillMgr.JNTYPE_WATER:
					desc = "克火系 ；被土克  ";
					break;
			}
			desc += "压制" + SkillMgr.jnLevel(idlevel) + "级以下锦囊";
			
			m_descTf.text = desc;
		}
		
		//更新锦囊库中锦囊列表
		public function updateJinnangGrid():void
		{
			m_jinnangList.setDatas(m_gkContext.m_wuMgr.getJinnangList());
			resetJinnang();
		}
	}

}