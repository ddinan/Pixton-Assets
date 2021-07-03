package com.pixton.widget
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   public class Popup extends MovieClip
   {
       
      
      public var btnClose:MovieClip;
      
      public var txtEmbed:TextField;
      
      public function Popup()
      {
         super();
         this.visible = false;
         this.btnClose.buttonMode = true;
         this.btnClose.useHandCursor = true;
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onClose);
         this.txtEmbed.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
         this.txtEmbed.addEventListener(MouseEvent.CLICK,this.onFocusIn);
      }
      
      function show(param1:String) : void
      {
         this.txtEmbed.text = param1;
         this.visible = true;
         this.y = 152;
      }
      
      private function onFocusIn(param1:Event) : void
      {
         setTimeout(param1.target.setSelection,50,0,param1.target.text.length);
      }
      
      private function onFocusOut(param1:FocusEvent) : void
      {
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this.visible = false;
      }
      
      private function onCopy(param1:MouseEvent) : void
      {
         System.setClipboard(this.txtEmbed.text);
      }
   }
}
