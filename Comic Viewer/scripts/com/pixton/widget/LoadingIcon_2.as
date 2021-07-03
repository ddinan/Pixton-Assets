package com.pixton.widget
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class LoadingIcon extends MovieClip
   {
      
      private static const RATE_1:Number = 10;
      
      private static const RATE_2:Number = 20;
       
      
      public var outer:MovieClip;
      
      public var inner:MovieClip;
      
      public function LoadingIcon()
      {
         super();
      }
      
      function PanelLoader() : *
      {
         mouseEnabled = false;
         mouseChildren = mouseEnabled;
         this.outer.rotation = 0;
         this.inner.rotation = 180;
         visible = false;
      }
      
      function show() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.onFrame,false,0,true);
         visible = true;
      }
      
      function hide() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.onFrame,false);
         visible = false;
      }
      
      private function onFrame(param1:Event) : void
      {
         this.outer.rotation = (this.outer.rotation + RATE_1) % 360;
         this.inner.rotation = (this.inner.rotation - RATE_2 + 360) % 360;
      }
   }
}
