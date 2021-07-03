package com.pixton.editor
{
   import flash.events.Event;
   
   public final class PixtonEvent extends Event
   {
      
      public static const COMPLETE:String = "pixton_complete";
      
      public static const CHANGE:String = "pixton_change";
      
      public static const CLOSE:String = "pixton_close";
      
      public static const LOAD_COMIC:String = "load_comic";
      
      public static const LOAD_PANEL:String = "load_panel";
      
      public static const CHANGE_COMIC:String = "change_episode";
      
      public static const SAVE_SCENE:String = "save_scene";
      
      public static const DOWNLOAD_SCENE:String = "download_scene";
      
      public static const SAVE_STATE:String = "save_state";
      
      public static const CLOSE_SCENE:String = "close_scene";
      
      public static const DELETE_SCENE:String = "delete_scene";
      
      public static const RESIZE_SCENE:String = "resize_scene";
      
      public static const EDIT_SCENE:String = "edit_scene";
      
      public static const PRESS_SCENE:String = "press_scene";
      
      public static const MOVE_TARGET:String = "move_target";
      
      public static const Z_MOVE_TARGET:String = "z_move_target";
      
      public static const CHANGE_CHARACTER:String = "change_character";
      
      public static const EDIT_CHARACTER:String = "edit_character";
      
      public static const SAVE_CHARACTER:String = "save_character";
      
      public static const SAVE_PROPSET:String = "save_propset";
      
      public static const SAVE_PROPPHOTO:String = "save_propphoto";
      
      public static const SAVE_SEQUENCE:String = "save_sequence";
      
      public static const STATE_CHANGE:String = "state_change";
      
      public static const DOUBLE_CLICK:String = "double_click";
      
      public static const CLICK:String = "pixton_click";
      
      public static const SELECTION:String = "pixton_selection";
      
      public static const CLEAR:String = "pixton_clear";
      
      public static const POSITION_CHANGE:String = "pixton_position_change";
      
      public static const DETACH_SOUND:String = "detach_sound";
      
      public static const ADD_GESTURE_ROTATE:String = "add_gesture_rotate";
      
      public static const ADD_GESTURE_ZOOM:String = "add_gesture_zoom";
      
      public static const CLOSE_COMIC:String = "close_comic";
       
      
      public var value;
      
      public var value2;
      
      public var value3;
      
      public var value4;
      
      public function PixtonEvent(param1:String, param2:* = null, param3:* = null, param4:* = null, param5:* = null)
      {
         super(param1);
         this.value = param2;
         this.value2 = param3;
         this.value3 = param4;
         this.value4 = param5;
      }
   }
}
