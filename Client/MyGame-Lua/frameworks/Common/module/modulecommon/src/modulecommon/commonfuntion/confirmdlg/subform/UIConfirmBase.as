package modulecommon.commonfuntion.confirmdlg.subform 
{
	import modulecommon.commonfuntion.ConfirmDialogMgr;
	import com.util.UtilColor;

	import com.bit101.components.ButtonText;
	import com.bit101.components.Label;
	import com.bit101.components.TextNoScroll;
	import flash.events.MouseEvent;
	import modulecommon.ui.FormConfirmBase;
	/**
	 * ...
	 * @author 
	 */
	public class UIConfirmBase extends FormConfirmBase 
	{		
		protected var m_mode:int;
		
		protected var m_funOnConfirm:Function;
		protected var m_funOnConcel:Function;
		
		public function UIConfirmBase()
		{
			this.exitMode = EXITMODE_HIDE;
			draggable = false;
		}
		
		override public function onReady():void 
		{
			super.onReady();			
		}
		
		override public function onHide():void 
		{
			super.onHide();
			m_funOnConfirm = null;
			m_funOnConcel = null;
		}
		override public function onStageReSize():void 
		{
			super.onStageReSize();
			this.darkOthers();
		}
		public function updateDesc(desc:String):void
		{
			
		}
		protected function setConfirmAndConcelBtn(param:Object, top:Number):void
		{
			var nameConfirm:String;
			var nameConcel:String;
			var funConfirm:Function = param["funConfirm"];
			var funConcel:Function = param["funConcel"];
			var radioButton:Object = param["radioButton"];
			
			if (param["nameConfirm"] != undefined)
			{
				nameConfirm = param["nameConfirm"]
			}
			else
			{
				nameConfirm = "确认"
			}
			if (param["nameConcel"] != undefined)
			{
				nameConcel = param["nameConcel"]
			}
			else
			{
				nameConcel = "取消";
			}
			
			m_confirmBtn.setPos(72, top);
			setButtonName(m_confirmBtn,nameConfirm);			
			
			m_cancelBtn.visible = true;
			m_cancelBtn.setPos(224, top);
			setButtonName(m_cancelBtn,nameConcel);		
			
			m_funOnConfirm = funConfirm;
			m_funOnConcel = funConcel;
		}
		
		public function setDesc(param:Object):Number
		{
			var desc:String = param["desc"];
			m_tf.htmlText = "<body>" + desc + "</body>";
						
			return m_tf.y + m_tf.textHeight + 15;
		}
		
		protected function setButtonName(btn:ButtonText, name:String):void
		{
			if (name.length == 2)
			{
				btn.letterSpacing = 15;
			}
			else
			{
				btn.letterSpacing = 2;
			}
			btn.label = name;
		}
		override public function onConfirmBtnClick(e:MouseEvent):void
		{
			var bClose:Boolean = false;
			if (m_mode == ConfirmDialogMgr.MODE1)
			{
				if (m_funOnConfirm())
				{
					bClose = true;
					m_funOnConfirm = null;
				}				
			}
			else if (m_mode == ConfirmDialogMgr.MODE2)
			{
				if (m_funOnConfirm == null || m_funOnConfirm())
				{
					bClose = true;
					m_funOnConfirm = null;
				}
			}
			
			if (bClose)
			{
				this.exit();
			}
		}
		override public function onConcelBtnClick(e:MouseEvent):void
		{
			var bClose:Boolean = false;
			if (m_mode == ConfirmDialogMgr.MODE1)
			{
				if (m_funOnConcel != null)
				{
					if (m_funOnConcel())
					{						
						m_funOnConcel = null;
						bClose = true;
					}					
				}
				else
				{
					bClose = true;
				}
			}
			if (bClose)
			{
				this.exit();
			} 
		}
	}

}