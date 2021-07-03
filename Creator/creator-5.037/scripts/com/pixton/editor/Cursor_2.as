package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   
   public final class Cursor
   {
      
      public static const MOVE:String = "Move";
      
      public static const DRAG:String = "Drag";
      
      public static const ROTATE:String = "Rotate";
      
      public static const RESIZE_H:String = "ResizeH";
      
      public static const RESIZE_V:String = "ResizeV";
      
      public static const RESIZE_NE:String = "ResizeNE";
      
      public static const RESIZE_NW:String = "ResizeNW";
      
      public static const NO_ENTRY:String = "Noentry";
      
      public static const ZOOM_IN:String = "ZoomIn";
      
      public static const ZOOM_OUT:String = "ZoomOut";
      
      public static const TURN:String = "Turn";
      
      private static var stage:Stage;
      
      private static var cursor:MovieClip;
      
      private static var currentValue:String;
       
      
      public function Cursor()
      {
         super();
      }
      
      public static function init(param1:Stage) : void
      {
         stage = param1;
      }
      
      public static function show(param1:String = null) : void
      {
         var _loc2_:Class = null;
         if(param1 == currentValue)
         {
            return;
         }
         currentValue = param1;
         if(cursor != null)
         {
            stage.removeChild(cursor);
            cursor = null;
            Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,mouseMoveHandler);
            Utils.removeListener(stage,Event.MOUSE_LEAVE,mouseLeaveHandler);
         }
         if(param1 == null)
         {
            Mouse.show();
         }
         else
         {
            Mouse.hide();
            _loc2_ = Utils.getDefinition("com.pixton.cursor." + param1);
            cursor = new _loc2_() as MovieClip;
            cursor.mouseEnabled = false;
            cursor.mouseChildren = false;
            cursor.x = stage.mouseX;
            cursor.y = stage.mouseY;
            cursor.visible = true;
            stage.addChild(cursor);
            Utils.addListener(stage,MouseEvent.MOUSE_MOVE,mouseMoveHandler);
            Utils.addListener(stage,Event.MOUSE_LEAVE,mouseLeaveHandler);
         }
      }
      
      public static function has(param1:String) : Boolean
      {
         return currentValue == param1;
      }
      
      private static function mouseLeaveHandler(param1:Event) : void
      {
         cursor.visible = false;
      }
      
      private static function mouseMoveHandler(param1:MouseEvent) : void
      {
         cursor.x = Math.round(param1.stageX);
         cursor.y = Math.round(param1.stageY);
         cursor.visible = true;
      }
   }
}
