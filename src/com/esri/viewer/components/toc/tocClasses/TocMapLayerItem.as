﻿////////////////////////////////////////////////////////////////////////////////
//
// Copyright © 2008 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/FlexViewer/License.txt
//
////////////////////////////////////////////////////////////////////////////////

package com.esri.viewer.components.toc.tocClasses
{
	
	import com.esri.ags.events.LayerEvent;
	import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
	import com.esri.ags.layers.ArcGISTiledMapServiceLayer;
	import com.esri.ags.layers.ArcIMSMapServiceLayer;
	import com.esri.ags.layers.Layer;
	import com.esri.ags.layers.supportClasses.LayerDetails;
	import com.esri.ags.layers.supportClasses.LayerInfo;
	import com.esri.viewer.AppEvent;
	import com.esri.viewer.ViewerContainer;
	import com.esri.viewer.components.toc.utils.MapUtil;
	import mx.controls.Alert;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.rpc.AsyncResponder;
	
	/**
	 * A TOC item representing a map service or graphics layer.
	 */
	public class TocMapLayerItem extends TocItem
	{
		public function TocMapLayerItem( layer:Layer, labelFunction:Function = null )
		{
			super();
			
			_layer = layer;
			
			// Set the initial visibility without causing a layer refresh
			setVisible(layer.visible, false);
			
			if (labelFunction == null) {
				// Default label function
				labelFunction = MapUtil.labelLayer;
			}
			_labelFunction = labelFunction;
			label = labelFunction(layer);
			
			if (layer.loaded) {
				// Process the layer info immediately
				createChildren();
			}
			
			// Listen for future layer load events
			layer.addEventListener(LayerEvent.LOAD, onLayerLoad, false, 0, true);
			
			// Listen for changes in layer visibility
			layer.addEventListener(FlexEvent.SHOW, onLayerShow, false, 0, true);
			layer.addEventListener(FlexEvent.HIDE, onLayerHide, false, 0, true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _layer:Layer;
		
		private var _labelFunction:Function;
		
		//--------------------------------------------------------------------------
		//  Property:  mapLayer
		//--------------------------------------------------------------------------
		
		/**
		 * The map layer to which this TOC item is attached.
		 */
		public function get layer():Layer
		{
			return _layer;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override internal function updateScaleDependantState( calledFromChild:Boolean = false ):void
		{
			scaledependant = DEFAULT_SCALEDEPENDANT;
			
			// Recurse up the tree
			if (parent) {
				parent.updateScaleDependantState(true);
			}
		}
		
		/**
		 * @private
		 */
		override internal function refreshLayer():void
		{
			layer.visible = visible;
			
			// ArcIMS requires layer names, whereas ArcGIS Server requires layer IDs
			var useLayerInfoName:Boolean = (layer is ArcIMSMapServiceLayer);
			
			var visLayers:Array = [];
			for each (var child:TocItem in children) {
				accumVisibleLayers(child, visLayers, useLayerInfoName);
			}
			
			if (layer is ArcGISDynamicMapServiceLayer) {
				ArcGISDynamicMapServiceLayer(layer).visibleLayers = new ArrayCollection(visLayers);
				//ArcGISDynamicMapServiceLayer(layer).getLayerDetails(
			} else if (layer is ArcIMSMapServiceLayer) {
				ArcIMSMapServiceLayer(layer).visibleLayers = new ArrayCollection(visLayers);
			}
		}
		
		private function accumVisibleLayers( item:TocItem, accum:Array, useLayerInfoName:Boolean = false ):void
		{
			if (item.isGroupLayer()) {
				// Don't include group layer IDs/names in the visible layer list, since the ArcGIS REST API
				// implicitly turns on all child layers when the group layer is visible. This goes
				// counter to what most users have come to expect from apps, e.g. ArcMap.
				for each (var child:TocItem in item.children) {
					accumVisibleLayers(child, accum, useLayerInfoName);
				}
			} else {  // Leaf layer
				if (item.visible) {
					if (item is TocLayerInfoItem) {
						var layer:TocLayerInfoItem = TocLayerInfoItem(item);
						accum.push(useLayerInfoName ? layer.layerInfo.name : layer.layerInfo.id);
					}
				}
			}
		}
		
		private function onLayerLoad( event:LayerEvent ):void
		{
			// Relabel this item, since map layer URL or service name might have changed.
			label = _labelFunction(layer);
			
			createChildren();
		}
		
		private function onLayerShow( event:FlexEvent ):void
		{
			setVisible(layer.visible, false);
		}
		
		private function onLayerHide( event:FlexEvent ):void
		{
			setVisible(layer.visible, false);
		}
		
		/**
		 * Populates this item's children collection based on any layer info
		 * of the map service.
		 */
		private function createChildren():void
		{
			children = null;
			
			var layerInfos:Array;  // of LayerInfo
			
			if (layer is ArcGISTiledMapServiceLayer) {
				layerInfos = ArcGISTiledMapServiceLayer(layer).layerInfos;
			} else if (layer is ArcGISDynamicMapServiceLayer) {
				layerInfos = ArcGISDynamicMapServiceLayer(layer).layerInfos;
			} else if (layer is ArcIMSMapServiceLayer) {
				layerInfos = ArcIMSMapServiceLayer(layer).layerInfos;
			}
			
			if (layerInfos) {
				var rootLayers:Array = findRootLayers(layerInfos);
				var tli:TocLayerInfoItem;
				for each (var layerInfo:LayerInfo in rootLayers) {
					addChild(createTocLayer(this, layerInfo, layerInfos, layer)); 
				}
			}
		}
		
		private static function findRootLayers( layerInfos:Array ):Array  // of LayerInfo
		{
			var roots:Array = [];
			for each (var layerInfo:LayerInfo in layerInfos) {
				// ArcGIS: parentLayerId is -1
				// ArcIMS: parentLayerId is NaN
				if (isNaN(layerInfo.parentLayerId) || layerInfo.parentLayerId == -1) {
					roots.push(layerInfo);
				}
			}
			return roots;
		}
		
		private static function findLayerById( id:Number, layerInfos:Array ):com.esri.ags.layers.supportClasses.LayerInfo
		{
			for each (var layerInfo:LayerInfo in layerInfos) {
				if (id == layerInfo.id) {
					return layerInfo;
				}
			}
			return null;
		}
		
		private static function createTocLayer( parentItem:TocItem, layerInfo:LayerInfo, layerInfos:Array, tlayer:Layer):TocLayerInfoItem
		{
			var item:TocLayerInfoItem = new TocLayerInfoItem(parentItem, layerInfo);
			if (tlayer is ArcGISTiledMapServiceLayer) {
				ArcGISTiledMapServiceLayer(tlayer).getDetails(layerInfo.id,new AsyncResponder(
                   	function myResultFunction(result:com.esri.ags.layers.supportClasses.LayerDetails, token:Object = null):void
                    {
                        
						item.minScale = result.minScale
                        item.maxScale = result.maxScale
                    },
                    function myFaultFunction(error:Object, token:Object = null):void
                    {
                    	//do nothing
                    }
				));
			} else if (tlayer is ArcGISDynamicMapServiceLayer) {
				ArcGISDynamicMapServiceLayer(tlayer).getDetails(layerInfo.id,new AsyncResponder(
                    function myResultFunction(result:com.esri.ags.layers.supportClasses.LayerDetails, token:Object = null):void
                    {
                        
						item.minScale = result.minScale
                        item.maxScale = result.maxScale
                    },
                    function myFaultFunction(error:Object, token:Object = null):void
                    {
                    	//do nothing
                    }
				));
			}
			// Handle any sublayers of a group layer
			if (layerInfo.subLayerIds) {
				for each (var childId:Number in layerInfo.subLayerIds) {
					var childLayer:LayerInfo = findLayerById(childId, layerInfos);
					if (childLayer) {
						item.addChild( createTocLayer(item, childLayer, layerInfos, tlayer) );
					}
				}
			}
			return item;
		}
	}

}
