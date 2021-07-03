package com.pixton.widget
{
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import flash.ui.Mouse;
   
   public class Cursor
   {
      
      public static const DRAG:String = "Drag";
      
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
      
      public static function hide() : void
      {
         show(null);
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
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
            stage.removeEventListener(Event.MOUSE_LEAVE,mouseLeaveHandler);
         }
         if(param1 == null)
         {
            Mouse.show();
         }
         else
         {
            Mouse.hide();
            _loc2_ = ApplicationDomain.currentDomain.getDefinition("com.pixton.cursor." + param1) as Class;
            cursor = new _loc2_() as MovieClip;
            cursor.mouseEnabled = false;
            cursor.mouseChildren = false;
            cursor.x = stage.mouseX;
            cursor.y = stage.mouseY;
            cursor.visible = true;
            stage.addChild(cursor);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,false,0,true);
            stage.addEventListener(Event.MOUSE_LEAVE,mouseLeaveHandler,false,0,true);
         }
      }
      
      private static function mouseLeaveHandler(param1:MouseEvent) : void
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
