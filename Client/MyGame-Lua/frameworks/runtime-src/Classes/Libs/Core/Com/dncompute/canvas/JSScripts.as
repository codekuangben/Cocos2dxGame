package com.dncompute.canvas 
{
	/**
	 * ...
	 * @author 
	 */
	public class JSScripts {
		
		public static var GET_FLASH_ID:XML = 
				<script><![CDATA[
				function(swfFullPath) {
					
					var getFileName = function(fullPath) {
						var ary =  fullPath.split("/");
						var fileName = ary[ary.length-1].split(".swf")[0];
						return fileName;
					}
					
					var ensureId = function(node) {
						if (node.attributes["id"] == null) {
							node.setAttribute("id",'swf'+new Date().getTime());
						}
					}
					
					var matchesTarget = function(fullPath) {
						return (getFileName(fullPath) == targetSwfName);
					}
					
					var targetSwfName = getFileName(swfFullPath);
					//Look through the embed nodes for one that matches our swf name
					var nodes = document.getElementsByTagName("embed");
					for (var i=0; i < nodes.length; i++) {
						//Parse just the SWF file name out of the whole src path and check if it matches
						if (matchesTarget(nodes[i].attributes["src"].nodeValue)) {
							ensureId(nodes[i]);
							return nodes[i].attributes["id"].nodeValue;
						}
					}
					
					
					//If we haven't found a matching embed, look through the object nodes
					nodes = document.getElementsByTagName("object");
					for (var j=0; j < nodes.length; j++) {
						//Check if the object tag has a data node
						if (nodes[j].attributes["data"] != null) {
							if (matchesTarget(nodes[j].attributes["data"].nodeValue)) {
								ensureId(nodes[j]);
								return nodes[j].attributes["id"].nodeValue;
							}
						}
						
						//Grab the param nodes out of this object, and look for one named "movie"
						var paramNodes = nodes[j].getElementsByTagName("param");
						for (var k=0; k < paramNodes.length; k++) {
							if (paramNodes[k].attributes["name"].nodeValue.toLowerCase() == "movie") {
								if (matchesTarget(paramNodes[k].attributes["value"].nodeValue)) {
									ensureId(nodes[j]);
									return nodes[j].attributes["id"].nodeValue;
								}
							}
						}
						
					}
					
					return null;
				}
				]]></script>;
				
		public static var INSERT_BROWSER_HACKS:XML = 
				<script><![CDATA[
				function (containerId,browserHacks) {
				
					var objNode = document.getElementById(containerId);
					if (objNode.nodeName.toLowerCase() == "div") return;
					
					//If you make the mistake of naming the object and embed nodes with the same id, firefox will get confused
					if (	((navigator.userAgent.toLowerCase().indexOf("firefox") != -1) ||
							(navigator.userAgent.toLowerCase().indexOf("opera") != -1)) &&
							(objNode.nodeName.toLowerCase() == "object") &&
							(browserHacks.indexOf("uniqueId") != -1)
							) {
						
						//Check if we have an embed tag inside of us, if so, ignore the obj tag
						var newNode = objNode.getElementsByTagName("embed")[0];
						if (newNode != null) {
							newNode.setAttribute("id",objNode.attributes["id"].nodeValue);
							objNode.attributes["id"].nodeValue += new Date().getTime();
							objNode.attributes['width'].nodeValue = "auto";
							objNode.attributes['height'].nodeValue = "auto";
							objNode.style.width = "";
							objNode.style.height = "";
							objNode = newNode;
						}
						
					}
					
					//All of the browsers but IE seem to put a margin underneath all object/embed tags. 
					//Seems like a bug, but it's suspicious that it's a problem in all browsers but IE.
					if (	(navigator.userAgent.toLowerCase().indexOf("msie") == -1) && 
							(browserHacks.indexOf("marginBottom") != -1)
							) {
						if (navigator.userAgent.toLowerCase().indexOf("opera") != -1) {
							objNode.style.marginBottom = "-4px";
						} else {
							objNode.style.marginBottom = "-5px";
						}
					}
					
					
					//IE has a bug where it doesn't respect the min-height/max-width style settings on an object tag
					//To work around this, we reparent the object tag into a div, and use the ref to the div instead.
					if (	(navigator.userAgent.toLowerCase().indexOf("msie") != -1) && 
							(objNode.nodeName.toLowerCase() == "object") && 
							(browserHacks.indexOf("IEReparent") != -1)
							) {
						
						//Insert a parent div above the object node
						var newId = "swfContainer"+(new Date().getTime());
						divNode = document.createElement('div');
						objNode.parentNode.insertBefore(divNode,objNode);
						divNode.setAttribute('id',newId);
						divNode.appendChild(objNode);
						
						//Set the parent div to the size of the object node, and the object node to 100%
						var getFormattedValue = function(val) {
							if ((val.indexOf("px") == -1) && (val.indexOf("%") == -1)) return val+"px";
							return val;
						}
						divNode.style.width = getFormattedValue(objNode.attributes['width'].nodeValue);
						divNode.style.height = getFormattedValue(objNode.attributes['height'].nodeValue);
						objNode.attributes['width'].nodeValue = "100%";
						objNode.attributes['height'].nodeValue = "100%";
						return newId;
					}
					return containerId;
				}
				]]></script>;
				
		
		public static var RESIZE_CONTAINER:XML = 
				<script><![CDATA[
				function(containerId,width,height,minWidth,minHeight,maxWidth,maxHeight) {
					var objNode = document.getElementById(containerId);
					objNode.style.width = width;
					objNode.style.height = height;
					objNode.style.minWidth = minWidth;
					objNode.style.minHeight = minHeight;
					objNode.style.maxWidth = maxWidth;
					objNode.style.maxHeight = maxHeight;
					objNode.attributes.width.nodeValue = width;
					objNode.attributes.height.nodeValue = height;
				}
				]]></script>;
		
	}
}