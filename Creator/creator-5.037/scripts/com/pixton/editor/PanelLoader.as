package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public final class PanelLoader extends MovieClip
   {
      
      private static const RATE_1:Number = 10;
      
      private static const RATE_2:Number = 20;
       
      
      public var outer:MovieClip;
      
      public var inner:MovieClip;
      
      public function PanelLoader()
      {
         super();
         Utils.setColor(this,Palette.hexToRGB(Palette.colorText),0,false,0.15);
         mouseEnabled = false;
         mouseChildren = mouseEnabled;
         this.outer.rotation = 0;
         this.inner.rotation = 180;
      }
      
      function show() : void
      {
         Utils.addListener(this,Event.ENTER_FRAME,this.onFrame);
         visible = true;
      }
      
      function hide() : void
      {
         Utils.removeListener(this,Event.ENTER_FRAME,this.onFrame);
         visible = false;
      }
      
      private function onFrame(param1:Event) : void
      {
         this.outer.rotation = Utils.wrap(this.outer.rotation + RATE_1);
         this.inner.rotation = Utils.wrap(this.inner.rotation - RATE_2);
      }
   }
}
