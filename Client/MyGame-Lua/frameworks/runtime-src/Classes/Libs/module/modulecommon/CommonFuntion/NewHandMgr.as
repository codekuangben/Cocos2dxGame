package modulecommon.commonfuntion 
{
	/**
	 * ...
	 * @author 
	 * //新手提示管理器
	 */
	import com.bit101.components.Component;
	import flash.geom.Rectangle;
	import modulecommon.GkContext;
	import com.util.UtilTools;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	//import modulecommon.uiinterface.IForm;
	
	public class NewHandMgr 
	{
		private var m_gkContext:GkContext;
		private var m_rectFrame:Rectangle;
		private var m_frameType:uint;
		public var m_ui:Form;
		public var m_isClickedOne:Boolean = false; //确保promptOver() 只在第一次点击"按钮"时执行
		public var m_bMoveToNext:Boolean = false;
		
		public function NewHandMgr(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		
		public function setFocusFrame(x:Number, y:Number, width:Number, height:Number, type:uint = 0):void
		{
			if (m_rectFrame == null)
			{
				m_rectFrame = new Rectangle();
			}
			m_rectFrame.x = x;
			m_rectFrame.y = y;
			m_rectFrame.width = width;
			m_rectFrame.height = height;
			m_frameType = type;
		}
		
		//(xPos, yPos)是相对于focusCom的位置
		//rectFrame定义焦点效果框的位置、宽，和高。(rectFrame.x, rectFrame.y)是相对于focusCom的位置
		public function prompt(right:Boolean, xPos:Number, yPos:Number, text:String, focusCom:Component):void
		{
			var focusForm:Form = UtilTools.getDisplayObjectByChild(Form, focusCom) as Form;
			if (focusForm == null || focusForm.parent == null)
			{
				return;
			}
			
			
			var info:Object = new Object();
			info["right"] = right;
			info["xPos"] = xPos;
			info["yPos"] = yPos;
			info["text"] = text;
			info["focusCom"] = focusCom;
			info["rectFrame"] = m_rectFrame;
			info["frameType"] = m_frameType;
			
			if (m_ui == null)
			{
				m_ui = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UINewHand);
			}
			m_ui.updateData(info);
			
			m_isClickedOne = false;
		}
		public function hide():void
		{
			if (m_ui)
			{
				m_isClickedOne = false;
				m_ui.hide();
			}
			
			if (0)
			{
				//m_nft值暂时保留，因为新手引导还未结束
			}
			else
			{
				m_gkContext.m_sysnewfeatures.m_nft = SysNewFeatures.NFT_NONE;
			}
		}
		
		public function promptOver():void
		{
			if (m_isClickedOne)
			{
				return;
			}
			
			if (m_ui)
			{
				m_isClickedOne = true;
				m_ui.updateData(1);
			}
		}
		public function isVisible():Boolean
		{
			if (m_ui && m_ui.isVisible())
			{
				return true;
			}
			return false;
		}
	}

}