/**
 * ComboBox.as
 * Keith Peters
 * version 0.9.10
 * 
 * A button that exposes a list of choices and displays the chosen item. 
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

package com.bit101.components.comboBox 
{
	import com.bit101.components.comboBox.ComboBoxParam;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	//import com.bit101.components.ListItem;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	//import com.dgrigg.utils.SkinManager;
	//import com.dgrigg.utils.UIConst;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	//import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[Event(name="select", type="flash.events.Event")]
	public class ComboBox extends Component
	{
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		
		private var m_param:ComboBoxParam;
		public var _dropDownButton:PushButton;
		protected var _items:Array;
		public var _editLabel:Label;
		protected var _listContainer:Panel;
		public var _list:List;
		public var _numVisibleItems:int = 6;
		protected var _open:Boolean = false;

		protected var m_overPanel:Panel;
		protected var m_selectPanel:Panel;
		
		/**
		 * Constructor 
		 * @param parent The parent DisplayObjectContainer on which to add this List.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param defaultLabel The label to show when no item is selected.
		 * @param items An array of items to display in the list. Either strings or objects with label property.
		 */
		public function ComboBox(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			super(parent, xpos, ypos);
			
			m_overPanel = new Panel();
			m_overPanel.autoSizeByImage = false;
			m_overPanel.mouseEnabled = false;
			m_overPanel.setPanelImageSkin("commoncontrol/panel/mouseover.png");
			m_selectPanel = new Panel();
			m_selectPanel.autoSizeByImage = false;
			m_selectPanel.mouseEnabled = false;
			m_selectPanel.setPanelImageSkin("commoncontrol/panel/mouseselect.png");
			_listContainer = new Panel(this);
			
			var listParam:Object = new Object();
			listParam["over"] = m_overPanel;
			listParam["select"] = m_selectPanel;
			
			_list = new List(null, 0, 0, _items);
			_list.m_paramForListItem = listParam;
			_list.autoHideScrollBar = true;
			_list.addEventListener(Event.SELECT, onSelect);
			_list._topMargin = 10;
			_list._leftMargin = 10;
			_list._bottomMargin = 10;
			_list.m_scrollbarRightMargin = 5;
			_list.m_scrollbarTopAndBottomMargin = 5;
			_list.setSkinGrid9Image9("commoncontrol/grid9/grid9StyleThree.swf");
			
			//_editLabel.autoSize = false;
			//_editLabel.align = Component.CENTER;
			this.addEventListener(MouseEvent.CLICK, onDropDown);			
		}	
		override protected function addChildren():void 
		{
			super.addChildren();
			
			setHorizontalImageSkin("commoncontrol/horstretch/inputBg_mirror.png");
			
			_editLabel = new Label(this, 10, 3);
			_dropDownButton = new PushButton(this, 0, 3);
			_dropDownButton.setPanelImageSkinMirror("commoncontrol/button/leftArrow2.swf", Image.MirrorMode_AnticlockwiseRotation90);
			addEventListener(Event.RESIZE, onResize);	
		}
		override public function dispose():void 
		{
			if (m_overPanel.parent==null)
			{
				m_overPanel.dispose();
			}
			if (m_selectPanel.parent==null)
			{
				m_selectPanel.dispose();
			}
			if (_list.parent == null)
			{
				_list.dispose();
			}
			if (m_param)
			{
				m_param.m_funIgoreMouseUpOnStageClick = null;
			}
			super.dispose();
		}
		protected function onResize(event:Event):void
		{
			_dropDownButton.x = this.width - 20//_dropDownButton.width;
			//_editLabel.width = _dropDownButton.x;
			_listContainer.y = this.height;
		}
		
		/**
		 * Determines what to use for the main button label and sets it.
		 */
		protected function setLabelButtonLabel():void
		{
			var listItem:ComoBoxItem = _list.selectedItemCtrl as ComoBoxItem;
			if (listItem.funMakeLabel != null)
			{
				listItem.funMakeLabel(_editLabel);
			}
			else
			{
				if(selectedItem is String)
				{
					_editLabel.text = selectedItem as String;
				}
				else
				{
					_editLabel.text = selectedItem.toString();
				}
			}			
		}
		
		/**
		 * Removes the list from the stage.
		 */
		protected function removeList():void
		{
			if (_list.parent)
			{
				_list.parent.removeChild(_list);
			}
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageClick);			
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////						
		/**
		 * Adds an item to the list.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 */
		public function addItem(item:Object):void
		{
			_list.addItem(item);
		}
		
		/**
		 * Adds an item to the list at the specified index.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 * @param index The index at which to add the item.
		 */
		public function addItemAt(item:Object, index:int):void
		{
			_list.addItemAt(item, index);
		}
		
		/**
		 * Removes the referenced item from the list.
		 * @param item The item to remove. If a string, must match the item containing that string. If an object, must be a reference to the exact same object.
		 */
		public function removeItem(item:Object):void
		{
			//_list.removeItem(item);
		}
		
		/**
		 * Removes the item from the list at the specified index
		 * @param index The index of the item to remove.
		 */
		public function removeItemAt(index:int):void
		{
			//_list.removeItemAt(index);
		}
		
		public function setItems(value:Array):void
		{
			_list.items = value;
		}
		
		public function setParam(param:ComboBoxParam):void
		{
			m_param = param;
			if (m_param.m_ListWidth == 0)
			{
				_list.width = this.width;				
			}
			else
			{
				_list.width = m_param.m_ListWidth;
			}
			_list.listItemHeight = m_param.m_listItemHeight;	
			_list.listItemClass = m_param.m_listItemClass;
			//m_overPanel.setSize(_list.width-_list.m_scrollbarRightMargin-_list._leftMargin, m_param.m_listItemHeight);
			m_overPanel.setSize(_list.width-8, m_param.m_listItemHeight);
			m_selectPanel.setSize(m_overPanel.width, m_param.m_listItemHeight);
			m_overPanel.x = 4-_list._leftMargin;
			m_selectPanel.x = m_overPanel.x
		}
		/**
		 * Removes all items from the list.
		 */
		public function removeAll():void
		{
			//_list.removeAll();
		}
	
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called when one of the top buttons is pressed. Either opens or closes the list.
		 */
		protected function onDropDown(event:MouseEvent):void
		{
			if (event.target == this || event.target == _editLabel || event.target == _dropDownButton)
			{
				toggleList();
			}
		}
		
		protected function toggleList():void
		{
			_open = !_open;
			if(_open)
			{				
				_list.y = - _list.height;
				_list.move(0, 0);
				_listContainer.addChild(_list);
				stage.addEventListener(MouseEvent.MOUSE_UP, onStageClick);			
			}
			else
			{
				removeList();
			}
		}
		
		/**
		 * Called when the mouse is clicked somewhere outside of the combo box when the list is open. Closes the list.
		 */
		protected function onStageClick(event:MouseEvent):void
		{
			// ignore clicks within buttons or list
			var display:DisplayObject = event.target as DisplayObject;
			if (display == null)
			{
				return;
			}
			if (display == this || display == _editLabel || display == _dropDownButton) return;
			if (m_param.m_funIgoreMouseUpOnStageClick != null)
			{
				if (m_param.m_funIgoreMouseUpOnStageClick(event))
				{
					return;
				}
			}
			if (_list.contains(display))
			{
				return;
			}
			//if(new Rectangle(_list.x, _list.y, _list.width, _list.height).contains(event.stageX, event.stageY)) return;
			
			_open = false;
			removeList();
		}
		
		/**
		 * Called when an item in the list is selected. Displays that item in the label button.
		 */
		protected function onSelect(event:Event):void
		{
			_open = false;
			//_dropDownButton.label = "+";
			//skin.btnStateChange(UIConst.EtClose);
			if(_list.parent)
			{
				_list.parent.removeChild(_list);
			}
			setLabelButtonLabel();
			dispatchEvent(event);
		}			
		
		/**
		 * Called when the component is removed from the stage.
		 */
		protected function onRemovedFromStage(event:Event):void
		{
			removeList();
		}
		

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets the index of the selected list item.
		 */
		public function set selectedIndex(value:int):void
		{
			_list.selectedIndex = value;
			setLabelButtonLabel();
		}
		public function get selectedIndex():int
		{
			return _list.selectedIndex;
		}
		
		/**
		 * Sets / gets the item in the list, if it exists.
		 */
		public function set selectedItem(item:Object):void
		{
			_list.selectedItem = item;
			setLabelButtonLabel();
		}
		public function get selectedItem():Object
		{
			return _list.selectedItem;
		}
				
					
		
		/**
		 * Sets / gets the number of visible items in the drop down list. i.e. the height of the list.
		 */
		public function set numVisibleItems(value:int):void
		{
			_numVisibleItems = Math.max(1, value);
			_list.height = _numVisibleItems * m_param.m_listItemHeight + _list._topMargin + _list._bottomMargin;
			_listContainer.scrollRect = new Rectangle(0, 0, _list.width, _list.height);
		}
		public function get numVisibleItems():int
		{
			return _numVisibleItems;
		}

		/**
		 * Sets / gets the list of items to be shown.
		 */
		public function set items(value:Array):void
		{
			_list.items = value;
		}
		public function get items():Array
		{
			return _list.items;
		}
		
		

        /**
         * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
         */
        public function set autoHideScrollBar(value:Boolean):void
        {
            _list.autoHideScrollBar = value;
            invalidate();
        }
        public function get autoHideScrollBar():Boolean
        {
            return _list.autoHideScrollBar;
        }
		
		/**
		 * Gets whether or not the combo box is currently open.
		 */
		public function get isOpen():Boolean
		{
			return _open;
		}
		
		override public function get stage():Stage
		{
			return m_con.m_mainStage;
		}
	}
}