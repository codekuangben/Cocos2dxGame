package com.bit101.components.pageturn 
{
	/**
	 * ...
	 * @author 
	 */
	import com.bit101.components.Component;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	public class PageTurnBase extends Component
	{
		protected var m_preBtn:PushButton;
		protected var m_nextBtn:PushButton;
		protected var m_funOnPageBtnClick:Function; //单击翻页按钮后，回调这个函数；此函数含有1个参数bool:true-表示向前翻页
		protected var m_funNotRespondClick:Function;	//单击翻页按钮后，执行此函数，判断是否执行翻页
		public function PageTurnBase(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_preBtn = new PushButton(this, 0, 0, onPageBtnClick);
			m_preBtn.tag = 0;
			m_nextBtn = new PushButton(this, 0, 0, onPageBtnClick);
			m_nextBtn.tag = 1;
		}
		override public function dispose():void 
		{
			m_funOnPageBtnClick = null;
			m_funNotRespondClick = null;
			super.dispose();
		}
		public function setParam(funCallBack:Function, funNotRespondClick:Function=null):void
		{
			m_funOnPageBtnClick = funCallBack;
			m_funNotRespondClick = funNotRespondClick;
		}	
		//为横向镜像的2个按钮，不需输入路径
		public function setBtnNameHorizontal_Mirror(leftName:String):void
		{
			var str:String = "commoncontrol/button/" + leftName;
			m_preBtn.setPanelImageSkin(str);
			m_nextBtn.setPanelImageSkinMirror(str, Image.MirrorMode_HOR);
		}
		//为横向镜像的2个按钮，不需输入路径
		public function setBtnSkinButton1ImageHorizontal_Mirror(leftName:String):void
		{
			var str:String = "commoncontrol/button/" + leftName;
			m_preBtn.setSkinButton1Image(str);
			m_nextBtn.setSkinButton1ImageMirror(str, Image.MirrorMode_HOR);
		}
		public function onPageBtnClick(e:MouseEvent):void
		{
			
		}
	}

}