package game.ui.treasurehunt
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.controlList.ControlAlignmentParam_ForPageMode;
	import com.bit101.components.controlList.ControlList;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import game.ui.treasurehunt.msg.stHuntingResultCmd;
	import game.ui.treasurehunt.msg.stHuntingRward;
	import game.ui.treasurehunt.resurticon.ResurtPrizeIcon_1time;
	import game.ui.treasurehunt.resurticon.ResurtPrizeIcon_Base;
	import game.ui.treasurehunt.resurticon.ResurtPrizeIcon_Hero;
	import game.ui.treasurehunt.resurticon.ResurtPrizeIcon_Money;
	import game.ui.treasurehunt.resurticon.ResurtPrizeIcon_More;
	import game.ui.treasurehunt.resurticon.ResurtPrizeIcon_Obj;
	import modulecommon.GkContext;
	import modulecommon.scene.treasurehunt.treasureInfo;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIAniRewarded;
	import modulecommon.uiinterface.IUIHero;
	import modulecommon.uiinterface.IUiSysBtn;
	import modulecommon.scene.sysbtn.SysbtnMgr;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.scene.prop.BeingProp;
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class midPart extends Component
	{
		private var m_list:ControlList;
		private var m_gkContext:GkContext;
		
		private var m_resultAni:Ani;
		private var m_prizeIconList:Vector.<ResurtPrizeIcon_Base>;
		private var m_prizeMoreList:Vector.<ResurtPrizeIcon_More>;
		
		public function midPart(gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_list = new ControlList(this, 0, -24);
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkContext;
			var param:ControlAlignmentParam_ForPageMode = new ControlAlignmentParam_ForPageMode();
			param.m_class = midPartItemIcon;
			param.m_height = 69;
			param.m_width = 72;
			param.m_numColumn = 6;
			param.m_numRow = 2;
			param.m_intervalV = 4;
			param.m_intervalH = 0;
			param.m_marginLeft = 10;
			param.m_marginRight = 10;
			param.m_dataParam = dataParam;
			m_list.setParamForPageMode(param);
			m_prizeIconList = new Vector.<ResurtPrizeIcon_Base>();
			m_prizeMoreList = new Vector.<ResurtPrizeIcon_More>();
		}
		public function onshow():void
		{
			if (m_gkContext.m_treasurehuntMgr.treasureInfoL)
			{
				m_list.setDatas(m_gkContext.m_treasurehuntMgr.treasureInfoL);
			}
		}
		public function updataResurt(msg:ByteArray):void
		{
			var rev:stHuntingResultCmd = new stHuntingResultCmd();
			rev.deserialize(msg);
			var len:int = rev.huntreward.length;
			showResurtIcon(len, rev.huntreward);
		}
		
		//在种类为id的地方，播放动画
		public function showAniOnList(pos:Point):void
		{
			if (m_resultAni == null)
			{
				m_resultAni = new Ani(m_gkContext.m_context, this);
				m_resultAni.setParam(1, true, false, 0.8, true);
				m_resultAni.setImageAni("ejkaijuntunabaoxiang.swf");
			}
			m_resultAni.x = pos.x;
			m_resultAni.y = pos.y;
			m_resultAni.show();
			m_resultAni.begin();
		}
		
		public static function findFunction(data, param:Object):Boolean
		{
			if ((data as treasureInfo).m_id == param)
			{
				return true;
			}
			return false;
		}
		
		private function showResurtIcon(len:uint, vec:Vector.<stHuntingRward>):void
		{
			if (len == 1)
			{
				var data:stHuntingRward = vec[0];
				var icon:midPartItemIcon = m_list.findCtrl(findFunction, data.picNO) as midPartItemIcon;
				var pt:Point = icon.posInRelativeParent(this);
				pt.x += 35;
				pt.y += 36;
				var prizeIcon_1time:ResurtPrizeIcon_1time;
				showAniOnList(pt);
				var typeno:uint = data.rewardType;
				var pos:Point = this.localToScreen(new Point(0, 0));
				if (typeno == 1)
				{
					prizeIcon_1time = new ResurtPrizeIcon_Obj(data, m_gkContext, this, 186, 208);
				}
				else if (typeno == 2)
				{
					prizeIcon_1time = new ResurtPrizeIcon_Hero(data, m_gkContext, this, 186, 208);
					var form:IUiSysBtn = m_gkContext.m_UIMgr.getForm(UIFormID.UiSysBtn) as IUiSysBtn;
					if (form && form.getBtnPosInScreenByIdx(SysbtnMgr.SYSBTN_WuXiaye))
					{
						pos=((form  as IUiSysBtn).getBtnPosInScreenByIdx(SysbtnMgr.SYSBTN_WuXiaye) as Point).subtract(pos);
					}
				}
				else if (typeno == 3)
				{
					data.id = m_gkContext.m_beingProp.tokenIconIDByType(data.upgrade);
					if (data.id != 0)
					{
						prizeIcon_1time = new ResurtPrizeIcon_Money(data, m_gkContext, this, 186, 208);
					}
					var formhero:IUIHero = m_gkContext.m_UIMgr.getForm(UIFormID.UIHero) as IUIHero;
					if (formhero)
					{
						pos = ((formhero  as IUIHero).getButtonPosInScreen(SysNewFeatures.NFT_XINGMAI) as Point).subtract(pos);
						pos = pos.add(new Point( 20, 20));
						if (data.upgrade == BeingProp.SILVER_COIN)
						{
							pos = pos.add(new Point( -153, -13));
						}
					}
				}
				if (pos.equals(this.localToScreen(new Point(0, 0))))//默认走包裹路线
				{
					form = m_gkContext.m_UIMgr.getForm(UIFormID.UiSysBtn) as IUiSysBtn;
					if (form)
					{
						pos=((form  as IUiSysBtn).getBtnPosInScreenByIdx(SysbtnMgr.SYSBTN_BeiBao) as Point).subtract(pos);
					}
				}
				prizeIcon_1time.setDesPos(pos.x,pos.y);
				if (prizeIcon_1time)
				{
					prizeIcon_1time.setMidPart(this);
					prizeIcon_1time.setSorPos(pt.x, pt.y);
					prizeIcon_1time.begin();
					m_prizeIconList.push(prizeIcon_1time);
					
					prizeIcon_1time.prompt();
				}
			}
			else
			{
				var prizeIconMore:ResurtPrizeIcon_More = new ResurtPrizeIcon_More(m_list, vec, m_gkContext, this, 0, 0);
				for each(var item:ResurtPrizeIcon_More in m_prizeMoreList)
				{
					item.moveup();
				}
				m_prizeMoreList.push(prizeIconMore);
				prizeIconMore.begin();
				
			}
			
		}
		public function moveoutItem(item:ResurtPrizeIcon_More):void
		{
			var i:int = m_prizeMoreList.indexOf(item);
			if (i != -1)
			{
				m_prizeMoreList.splice(i, 1);
			}
		}
		public function onPrizeIconAniEnd(PrizeIcon:ResurtPrizeIcon_Base):void
		{
			if (PrizeIcon.parent)
			{
				PrizeIcon.parent.removeChild(PrizeIcon);
			}
			PrizeIcon.dispose();
			var i:int = m_prizeIconList.indexOf(PrizeIcon);
			if (i != -1)
			{
				m_prizeIconList.splice(i, 1);
			}
		}
		
		override public function dispose():void
		{
			var prizeIcon:ResurtPrizeIcon_Base;
			for each (prizeIcon in m_prizeIconList)
			{
				prizeIcon.dispose();
			}
			super.dispose();
		}
	
	}

}