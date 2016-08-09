package com.bit101.components 
{
	import com.ani.AniPosition;
	import flash.display.DisplayObjectContainer;
	//import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class ButtonAni extends PushButton
	{
		public static const DIRECTION_UP:int = 1;	//向上
		public static const DIRECTION_DOWN:int = 2;	//向下
		
		public static const CHARGE_BIG:int = 11;	//变大
		public static const CHARGE_SMALL:int = 12;	//变小
		
		protected var _moveAniDirection:int;	//按钮移动方向
		protected var _sizeAniCharge:int;	//按钮变大效果
		
		private var m_formerParent:DisplayObjectContainer;
		private var _formerPos:Point;
		private var _ani:AniPosition;
		private var _bUpdateFormerPos:Boolean;
		
		public function ButtonAni(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, defaultHandler:Function = null)
		{
			m_formerParent = parent;
			super(parent, xpos, ypos, defaultHandler);
			
			_formerPos = new Point();
			_bUpdateFormerPos = true;
		}
		
		override protected function onMouseOver(event:MouseEvent):void
		{
			super.onMouseOver(event);
			
			if (_bUpdateFormerPos && m_formerParent == this.parent)
			{
				_formerPos.x = this.x;
				_formerPos.y = this.y;
				_bUpdateFormerPos = false;
			}
			
			if (moveAniDirection && m_formerParent == this.parent)
			{
				if (null == _ani)
				{
					_ani = new AniPosition();
					_ani.sprite = this;
					_ani.duration = 0.1;
				}
				
				moveToNewPos(_moveAniDirection);
			}
			
			if (sizeAniCharge && m_formerParent == this.parent)
			{
				chargeToNewSize(_sizeAniCharge);
			}
		}
		
		override protected function onMouseOut(event:MouseEvent):void
		{
			super.onMouseOut(event);
			
			if (_formerPos && m_formerParent == this.parent)
			{
				if (moveAniDirection)
				{
					moveToFormerPos();
				}
				
				if (sizeAniCharge)
				{
					chargeToFormerSize();
				}
			}
		}
		
		override public function setPos(xPos:Number, yPos:Number):void
		{
			super.setPos(xPos, yPos);
			if (!_bUpdateFormerPos && m_formerParent == this.parent)
			{
				_bUpdateFormerPos = true;
			}
		}
		
		//direction 移动方向 1上 2下
		private function moveToNewPos(direction:int):void
		{
			_ani.setBeginPos(this.x, this.y);
			
			switch(direction)
			{
				case DIRECTION_UP:
					_ani.setEndPos(_formerPos.x, _formerPos.y - 5);
					break;
				case DIRECTION_DOWN:
					_ani.setEndPos(_formerPos.x, _formerPos.y + 5);
					break;
			}
			_ani.begin();
		}
		
		private function moveToFormerPos():void
		{
			if (_ani)
			{
				_ani.setBeginPos(this.x, this.y);
				_ani.setEndPos(_formerPos.x, _formerPos.y);
				_ani.begin();
			}
		}
		
		//charge 变大或变小 CHARGE_BIG:变大  CHARGE_SMALL:变小
		private function chargeToNewSize(charge:int):void
		{
			var w:Number = this.width;
			var h:Number = this.height;
			
			switch(charge)
			{
				case CHARGE_BIG:
					this.scaleX = 1.1;
					this.scaleY = 1.1;
					break;
				case CHARGE_SMALL:
					this.scaleX = 0.9;
					this.scaleY = 0.9;
					break;
			}
			
			this.setPos(_formerPos.x + (w * (1 - this.scaleX)) / 2, _formerPos.y + (h * (1 - this.scaleY)) / 2);
		}
		
		private function chargeToFormerSize():void
		{
			this.scaleX = 1.0;
			this.scaleY = 1.0;
			this.setPos(_formerPos.x, _formerPos.y);
		}
		
		public function get moveAniDirection():int
		{
			return _moveAniDirection;
		}
		
		public function set moveAniDirection(direction:int):void
		{
			_moveAniDirection = direction;
		}
		
		public function get sizeAniCharge():int
		{
			return _sizeAniCharge;
		}
		
		public function set sizeAniCharge(charge:int):void
		{
			_sizeAniCharge = charge;
		}
		
		override public function dispose():void
		{
			if (_ani)
			{
				_ani.dispose();
			}
			
			super.dispose();
		}
	}

}