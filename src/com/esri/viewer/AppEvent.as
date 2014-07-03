////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2010 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/License.txt
//
////////////////////////////////////////////////////////////////////////////////
package com.esri.viewer
{

import flash.events.Event;

/**
 * AppEvent is used within the application to send message among components
 * through the EventBus. All event driven messaging in the Flex Viewer is
 * using the AppEvent.
 *
 * <p>The typical way of sending a message via the AppEvent is, for example:</p>
 *
 * <listing>
 *   ViewerContainer.dispatchEvent(new AppEvent(AppEvent.WIDGET_MENU_CLICKED, false, false, data));
 * </listing>
 *
 * <p>The typical way of receiving a message via the AppEvent is, for example:</p>
 * <listing>
 *   ViewerContainer.addEventListener(AppEvent.WIDGET_MENU_CLICKED, widgetMenuClicked);
 * </listing>
 *
 * @see EventBus
 */
public class AppEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     * The error event type. This event type is used to send a user friendly
     * error message via the event bus. A error window will display the error
     * message.
     *
     * <p>When sending the error message, the data sent with the AppEvent is the
     * error string. For example: </p>
     *
     * <listing>
     * SiteContainer.dispatchEvent(new AppEvent(AppEvent.APP_ERROR, false, false, "An Error Message"));
     * </listing>
     *
     * @see components.ErrorWindow
     */
    public static const APP_ERROR:String = "appError";

    /**
     * This event type indicates that the Flex Viewer application has completed loading the
     * configuration file. The ConfigManager sends this event so that other components that
     * are interested in obtaining configuration data can listen to this event.
     *
     * @see ConfigManager
     */
    public static const CONFIG_LOADED:String = "configLoaded";

    /**
     * This event type indicates that the map is loaded. The MapManager sends this event so
     * that other components such as the Controller can start working with the map.
     *
     * @see MapManager
     * @see Controller
     */
    public static const MAP_LOADED:String = "mapLoaded";

    public static const MAP_RESIZE:String = "mapResize";

    public static const MAP_LAYER_VISIBLE:String = "mapLayerVisibleChange";

    /**
     * This event type indicates a dynamic layer is loaded.
     */
    public static const LAYER_LOADED:String = "layerLoaded";

    //public static const LAYER_VISIBLE_CHANGED:String   = "layerVisibilityChanged";
    /**
     * This event type is used by the Controller to indicate a base map menu item
     * is clicked.
     *
     * @see Controller
     */
    public static const BASEMAP_SWITCH:String = "basemapSwitch";


    /**
     * This event type is used by either Flex Viewer components or a widget to
     * request set the map naviation method. The map navigation method could be
     * pan, zoomin, zoomout, etc.
     *
     * <p>The navigation methods supported are:</p>
     * <listing>
     * pan          (Navigation.PAN)
     * zoomin       (Navigation.ZOOM_IN)
     * zoomout      (Navigation.ZOOM_OUT)
     * zoomfull     (SiteContainer.NAVIGATION_ZOOM_FULL)
     * zoomprevious (SiteContainer.NAVIGATION_ZOOM_PREVIOUS)
     * zoomnext     (SiteContainer.NAVIGATION_ZOOM_NEXT)
     * </listing>
     *
     * <p>The navigation request can be sent as such:</P>
     * <listing>
     *  var data:Object =
     *     {
     *       tool: Navigation.PAN,
     *       status: status
     *      }
     *   SiteContainer.dispatchEvent(new AppEvent(AppEvent.SET_MAP_NAVIGATION, false, false, data));
     * </listing>
     *
     */
    public static const SET_MAP_NAVIGATION:String = "setMapNavigation";

    /**
     * This event type is used to set the status text shown at the controller bar. to AppEvent
     * to set the status string, for example:
     *
     * <listing>
     *  dispatchEvent(new AppEvent(AppEvent.SET_STATUS, false, false, status));
     * </listing>
     */
    public static const SET_STATUS:String = "setStatus";

    /**
     * Used to show the info windows on the map through the AppEvent via EventBus.
     *
     * <listing>
     *  SiteContainer.dispatchEvent(new AppEvent(AppEvent.SHOW_INFOWINDOW, false, false, infoData));
     * </listing>
     *
     * The infoData is a dynamic object structure as, for example:
     * <listing>
     *   var infoData:Object =
     *       {
     *          icon: icon,              //a Image object
     *          title: "a title string",
     *          content: "a string",
     *          link: "http://a.url.com",
     *          point: point,            //a Point object
     *          geometry: geom           //a Geometry object
     *       };
     * </listing>
     */
    public static const SHOW_INFOWINDOW:String = "widgetShowInfo";

    /**
     * Used to set map's interactive mode, such as Draw point, line, etc. To
     * use AppEvent via EventBus:
     *
     * <listing>
     * SiteContainer.dispatchEvent(new AppEvent(AppEvent.SET_MAP_ACTION, false, false, data));
     * </listing>
     *
     * Where data is a dynamic data structure:
     *
     * <listing>
     * var data:Object =
     *   {
     *       tool: action,       //an action string token
     *       status: "status string",
     *       handler: callback   //a callback Function
     *   }
     * </listing>
     * Please refer to the Developer's Guide for details.
     */
    public static const SET_MAP_ACTION:String = "setMapAction";

	public static const NAV_LOADED:String = "NavLoaded";
	
    /**
     * For widget chain and data manager to manage the session generated data.
     */
    public static const DATA_PUBLISH:String = "dataPublishing";

    /**
     * For widget chain. TBD
     */
    public static const DATA_NEW_PUBLISHED:String = "dataPublished";

    /**
     * for widget chain. TBD
     */
    public static const DATA_FETCH_ALL:String = "dataFetchAll";

    public static const DATA_FETCH:String = "dataFetch";

    public static const DATA_SENT:String = "dataFetched";
	
	public static const DATA_SENT_TIME:String = "dataFetchedTime";

    public static const DATA_OPT_LAYERS:String = "dataOperationalLayers";

    public static const DATA_CREATE_INFOWIDGET:String = "createInfoWidget";
	
	//Added for the double click start and end used for the Predicted Data widget
	public static const IDENTIFY_SINGLE_CLICK:String = "identifyClick";
	
	public static const IDENTIFY_SINGLE_CLICK_STOP:String = "identifyClickStop";

    /**
     * for widget layout
     */
    public static const CHANGE_LAYOUT:String = "changeLayout";

    /**
     * This event type is used by the Controller to indicate a widget run request
     */
    public static const WIDGET_RUN:String = "widgetRunRequested";

    /**
     * used to send message to widget to change its state such as close, min and max
     * var data:Object {
     *    id: widgetId, //as Number
     *    state: stateString //as String
     * }
     * ViewerContainer.publish(AppEvent.WIDGET_CHANGE_STATE, data);
     */
    public static const WIDGET_CHANGE_STATE:String = "widgetChangeState";

    public static const WIDGET_STATE_CHANGED:String = "widgetStateChanged";

    /**
     * for widget layout
     */
    public static const WIDGET_FOCUS:String = "focusWidget";

    public static const WIDGET_CHAIN_NEXT:String = "widgetChainNextRequested";

    public static const WIDGET_CHAIN_START:String = "widgetChainStartRequested"

    public static const WIDGET_MGR_RESIZE:String = "widgetManagerResize";

    public static const WIDGET_ADD:String = "addWidget";

    public static const WIDGET_ADDED:String = "widgetAdded";

    public static const INFOWIDGET_REQUEST:String = "requestInfoWidget";

    public static const INFOWIDGET_READY:String = "infoWidgetReady";
	
	public static const LAYER_VISIBILITY_CHANGED:String = "layerVisibiltyChange";
	
	//ASA TIME SLIDER
	public static const TIME_SLIDER_TIME_CHANGED:String = 'timeSliderTimeChanged';
	
	//ASA START DATE PICKER
	public static const START_DATE_CHANGED:String = 'startTimeChanged';
	
	//ASA END DATE PICKER
	public static const END_DATE_CHANGED:String = 'endTimeChanged';
	
	//ASA OIL NAME CHANGE
	public static const OIL_MODEL_NAME_CHANGE:String = 'oilNameChange';
	
	//ASA OIL PARTS VISIBILITY CHANGE
	public static const OIL_MODEL_VIS_CHANGE:String = 'oilVisChange';
	
	//ASA WINDS NAME CHANGE
	public static const WINDS_NAME_CHANGE:String = 'windsNameChange';
	
	//ASA CURRENTS NAME CHANGE
	public static const CURRENTS_NAME_CHANGE:String = 'currentsNameChange';
	
	//ASA rerun model
	public static const RERUN_MODEL_COMPLETE:String = 'rerunmodelChange';
	
	//Called when Oil Map Service is run
	public static const OIL_RUN:String = 'oilRun';
	
	//ASA LOAD COMPLETE
	public static const MODEL_LOAD_COMPLETE:String = 'modelLoadComplete';
	//asa winds and currents style change
	public static const WINDS_STYLE_CHANGE:String='windsStyleChange';
	public static const CURRENTS_STYLE_CHANGE:String='currentsStyleChange';
	//asa system login and out
	public static const SYSTEM_LOG_IN:String='systemLonIn';
	public static const SYSTEM_LOG_OUT:String='systemLogOut';
	public static const SYSTEM_LOG_SUCCESS:String='systemLogSuccess';
	public static const SYSTEM_LOG_UNSUCCESS:String='systemLogUnSuccess';
	// TimeSlider setttings form event
	public static const TIME_ZONE_CHANGED:String='timeZoneChanged';
	public static const TIMESLIDER_SETTING_CHANGED:String='timesliderSettingChanged';
	//FOR MODELFEATURES
	public static const CURRENT_SCENARIO_CHANGED:String='currentScenarioChanged';
	//for get management services for config file
	public static const MANAGEMENT_SERVICES_LOADED:String='managementServiceLoaded';
	//for save the login user's info
	public static const LOGIN_USER_CHANGED:String='loginUserChanged';
	//timeslider settings closed
	public static const TIMESLIDER_SETTING_CLOSED:String='timesliderSettingClosed';
	public static const SPILL_TIME_CHANGED:String='spillTimeChanged';
	//language changed
	public static const LANGUAGE_CHANGED:String='languageChanged';
	//select authorized scenario for visitor
	public static const SELECT_SCENARIO:String="selectScenario";
	//dispatch when new resource layer created
	public static const RESOURCE_TYPE_CREATED:String="resourceTypeCreated";
	
	public static const ECOP_START_CHANGE:String='ecopStartChange';
	public static const ECOP_END_CHANGE:String='ecopEndChange';
	public static const TIMESLIDER_INTERVAL_CHANGE:String='timesliderIntervalChange';
	public static const DISPLAY_RATE_CHANGE:String='displayRateChange';
	
	//rerun scenario
	//public static const 
	
	//

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    //TODO: simplify this by moving data to 2nd position
    public function AppEvent(type:String, data:Object = null, callback:Function = null)
    {
        super(type, false, false);
        _data = data;
        _callback = callback;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _data:Object;

    private var _callback:Function;

    /**
     * The data will be passed via the event. It allows the event dispatcher to publish
     * data to event listener(s).
     */
    public function get data():Object
    {
        return _data;
    }

    /**
     * @private
     */
    public function set data(value:Object):void
    {
        _data = value;
    }

    /**
     * The callback function associated with this event.
     */
    public function get callback():Function
    {
        return _callback;
    }

    /**
     * @private
     */
    public function set callback(value:Function):void
    {
        _callback = value;
    }

    public override function clone():Event
    {
        return new AppEvent(this.type, this.data);

    }
}

}
