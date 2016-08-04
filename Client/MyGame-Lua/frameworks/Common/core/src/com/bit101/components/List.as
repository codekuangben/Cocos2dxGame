/**
 * List.as
 * Keith Peters
 * version 0.9.10
 *
 * A scrolling list of selectable items.
 *
 * Copyright (c) 2011 Keith Peters
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.bit101.components
{
	//import com.ani.AniToDestPostion_BezierCurve1;
	//import com.dgrigg.utils.SkinManager;
	//import com.dgrigg.utils.UIConst;
	import flash.display.DisplayObjectContainer;
	//import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Event(name="select",type="flash.events.Event")]
	
	public class List extends PanelContainer
	{
		public var _topMargin:Number;
		public var _bottomMargin:Number;
		public var _leftMargin:Number;
		public var _rightMargin:Number;
		
		public var m_scrollbarTopAndBottomMargin:Number;
		public var m_scrollbarRightMargin:Number;
		public var m_paramForListItem:Object;	//传入ListItem的参数
		public var _items:Array;
		protected var _itemHolder:Sprite;
		public var _listItemHeight:Number = 20;
		protected var _listItemClass:Class = ListItem;
		public var _scrollbar:VScrollBar;
		public var _selectedIndex:int = -1;	
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this List.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param items An array of items to display in the list. Either strings or objects with label property.
		 */
		public function List(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, items:Array = null)
		{
			if (items != null)
			{
				_items = items;
			}
			else
			{
				_items = new Array();
			}
			_topMargin = 0;
			_bottomMargin = 0;
			_leftMargin = 0;
			_rightMargin = 0;
			
			m_scrollbarTopAndBottomMargin = 0;
			m_scrollbarRightMargin = 0;
			super(parent, xpos, ypos);
			
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(Event.RESIZE, onResize);
			
		}		
			
		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function addChildren():void
		{
			super.addChildren();
			
			_itemHolder = new Sprite();
			this.addChild(_itemHolder);
			_scrollbar = new VScrollBar(this, 0, 0, onScroll);
			_scrollbar.visible = false;
		}
		
		protected function updateScrollParam():void
		{			
			_scrollbar.y = m_scrollbarTopAndBottomMargin;
			_scrollbar.height = this.height - m_scrollbarTopAndBottomMargin - m_scrollbarTopAndBottomMargin;
			_scrollbar.x = this.width - _scrollbar.width - m_scrollbarRightMargin;
			_scrollbar.pageSize = Math.ceil(this.height / _listItemHeight);
		}
		
		/**
		 * Creates all the list items based on data.
		 * 当List的宽度、高度, 和Item的高度发生变化时，需要调用此函数，重新构造_itemHolder。
		 */
		protected function makeListItems():void
		{
			var item:ListItem;
			while (_itemHolder.numChildren > 0)
			{
				item = ListItem(_itemHolder.getChildAt(0));
				item.removeEventListener(MouseEvent.CLICK, onSelect);
				_itemHolder.removeChildAt(0);
			}
			
			var numItems:int = Math.ceil((_height-_topMargin-_bottomMargin)  / _listItemHeight);
			//numItems = Math.min(numItems, _items.length);
			//numItems = Math.max(numItems, 1);
			var top:Number = _topMargin;
			var left:Number = _leftMargin;
			for (var i:int = 0; i < numItems; i++)
			{
				item = new _listItemClass(_itemHolder, left, top,null,m_paramForListItem);
				item.setSize(width, _listItemHeight);
				item.addEventListener(MouseEvent.CLICK, onSelect);
				top += _listItemHeight;
			}
		}
		
		/*
		 * 滚动条的位置变化，或数据填充完毕后，调用此函数
		 */
		protected function fillItems():void
		{
			var offset:int = _scrollbar.value;
			var numItems:int = Math.ceil(_height / _listItemHeight);
			//numItems = Math.min(numItems, _items.length);
			var numChild:int = _itemHolder.numChildren;
			var indexChild:int = 0;
			var indexData:int = 0;
			for (indexChild = 0; indexChild < numChild; indexChild++)
			{
				var item:ListItem = _itemHolder.getChildAt(indexChild) as ListItem;
				indexData = offset + indexChild;
				if (indexData < _items.length)
				{
					item.data = _items[indexData];
					item.visible = true;
				}
				else
				{
					item.data = null;
					item.visible = false;
				}
				if (indexData == _selectedIndex)
				{
					item.selected = true;
				}
				else
				{
					item.selected = false;
				}
			}
		}
		
		/**
		 * If the selected item is not in view, scrolls the list to make the selected item appear in the view.
		 */
		private function onItemClick(e:MouseEvent):void
		{
			if (e.currentTarget is ListItem)
			{
				var item:ListItem = e.currentTarget as ListItem;
				item._selected = true;
				var index:int = _itemHolder.getChildIndex(item);
				selectedIndex = _scrollbar.value + index;
			}
		}
		
		protected function scrollToSelection():void
		{
			var numItems:int = Math.ceil(_height / _listItemHeight);
			if (_selectedIndex != -1)
			{
				if (_scrollbar.value > _selectedIndex)
				{
//                    _scrollbar.value = _selectedIndex;
				}
				else if (_scrollbar.value + numItems < _selectedIndex)
				{
					_scrollbar.value = _selectedIndex - numItems + 1;
				}
			}
			else
			{
				_scrollbar.value = 0;
			}
			fillItems();
		}
		
		/**
		 * Adds an item to the list.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 */
		public function addItem(item:Object):void
		{
			_items.push(item);
			invalidate();
			fillItems();
		}  
		
		public function removeItem(item:Object):void
		{
			var index:int = _items.indexOf(item);
			if (index != -1)
			{
				_items.splice(index, 1);
				invalidate();
				fillItems();
			}
		}
		
		/**
		 * Adds an item to the list at the specified index.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 * @param index The index at which to add the item.
		 */
		public function addItemAt(item:Object, index:int):void
		{
			index = Math.max(0, index);
			index = Math.min(_items.length, index);
			_items.splice(index, 0, item);
			invalidate();
			fillItems();
		}
		
		public function updateItem(index:int):void
		{
			var iCtrl:int = index - _scrollbar.value;
			if (iCtrl < 0 || iCtrl >= _itemHolder.numChildren)
			{
				return;
			}
			var item:ListItem = _itemHolder.getChildAt(iCtrl) as ListItem;
			item.update();
		}
		
		/**
		 * Removes the referenced item from the list.
		 * @param item The item to remove. If a string, must match the item containing that string. If an object, must be a reference to the exact same object.
		 */ /*public function removeItem(item:Object):void
		   {
		   var index:int = _items.indexOf(item);
		   removeItemAt(index);
		   }
		
		   /**
		 * Removes the item from the list at the specified index
		 * @param index The index of the item to remove.
		 */ /*public function removeItemAt(index:int):void
		   {
		   if(index < 0 || index >= _items.length) return;
		   _items.splice(index, 1);
		   invalidate();
		   fillItems();
		 }*/
		
		/**
		 * Removes all items from the list.
		 */ /*public function removeAll():void
		   {
		   _items.length = 0;
		   //invalidate();
		   fillItems();
		 }*/
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called when a user selects an item in the list.
		 */
		protected function onSelect(event:Event):void
		{
			if (!(event.target is ListItem))
				return;
			var item:ListItem = event.target as ListItem;
			var offset:int = _scrollbar.value;
			var newSeletedIndex:int = -1;
			newSeletedIndex = _itemHolder.getChildIndex(item) + offset;
			if (newSeletedIndex == _selectedIndex)
			{
				return;
			}
			
			for (var i:int = 0; i < _itemHolder.numChildren; i++)
			{
				if (_itemHolder.getChildAt(i) == event.target)
					newSeletedIndex = i + offset;
				ListItem(_itemHolder.getChildAt(i)).selected = false;
			}
			ListItem(event.target).selected = true;
			
			_selectedIndex = newSeletedIndex;
			dispatchEvent(new Event(Event.SELECT));
			
		}
		
		/**
		 * Called when the user scrolls the scroll bar.
		 */
		protected function onScroll(event:Event):void
		{
			fillItems();
		}
		
		/**
		 * Called when the mouse wheel is scrolled over the component.
		 */
		protected function onMouseWheel(event:MouseEvent):void
		{
			_scrollbar.value -= event.delta;
			fillItems();
		}
		
		protected function onResize(event:Event):void
		{
			updateScrollParam();
			makeListItems();
			fillItems();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets the index of the selected list item.
		 */
		public function set selectedIndex(value:int):void
		{
			if (value >= 0 && value < _items.length)
			{
				_selectedIndex = value;
			}
			else
			{
				_selectedIndex = -1;
			}
			
			var offset:int = _scrollbar.value;			
			var numChild:int = _itemHolder.numChildren;
			var indexChild:int = 0;
			var indexData:int = 0;
			for (indexChild = 0; indexChild < numChild; indexChild++)
			{
				var item:ListItem = _itemHolder.getChildAt(indexChild) as ListItem;
				indexData = offset + indexChild;
				
				if (indexData == _selectedIndex)
				{
					item.selected = true;
				}
				else
				{
					item.selected = false;
				}
			}
			
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		/**
		 * Sets / gets the item in the list, if it exists.
		 */
		public function set selectedItem(item:Object):void
		{
			var index:int = _items.indexOf(item);
//			if(index != -1)
//			{
			selectedIndex = index;
			invalidate();
			dispatchEvent(new Event(Event.SELECT));
//			}
		}
		
		public function get selectedItem():Object
		{
			if (_selectedIndex >= 0 && _selectedIndex < _items.length)
			{
				return _items[_selectedIndex];
			}
			return null;
		}
		public function get selectedItemCtrl():ListItem
		{
			var index:int = _selectedIndex - _scrollbar.value;
			if (index >= 0 && index < _itemHolder.numChildren)
			{
				return _itemHolder.getChildAt(index) as ListItem;
			}
			return null;			
		}
		
		/*
		 * public function funFind(ctrl:ListItem, name:String):void
		 */
		public function findListItem(funFind:Function, param:Object = null):ListItem
		{
			var index:int;
			var count:int = _itemHolder.numChildren;
			var item:ListItem;
			for (index = 0; index < count; index++)
			{
				item = _itemHolder.getChildAt(index) as ListItem;
				if (funFind(item, param) == true)
				{
					return item;
				}
			}
			return null;
		}
						
		
		/**
		 * Sets the height of each list item.
		 */
		public function set listItemHeight(value:Number):void
		{
			_listItemHeight = value;
			updateScrollParam();
			makeListItems();
			//invalidate();
		}
		
		public function get listItemHeight():Number
		{
			return _listItemHeight;
		}
		
		/**
		 * Sets / gets the list of items to be shown.
		 */
		public function set items(value:Array):void
		{
			_items = value;
			_scrollbar.numTotalData = _items.length;
			fillItems();
		}
		
		public function get items():Array
		{
			return _items;
		}
		
		/**
		 * Sets / gets the class used to render list items. Must extend ListItem.
		 */
		public function set listItemClass(value:Class):void
		{
			_listItemClass = value;
		}
		
		public function get listItemClass():Class
		{
			return _listItemClass;
		}
		
			
		
		/**
		 * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
		 */
		public function set autoHideScrollBar(value:Boolean):void
		{
			_scrollbar.autoHide = value;
		}
		
		public function get autoHideScrollBar():Boolean
		{
			return _scrollbar.autoHide;
		}
		
		public function get fscrollToSelection():Function
		{
			return scrollToSelection;
		}
	}
}