package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   
   public class InputText extends MovieClip
   {
       
      
      public var txtValue:TextField;
      
      public var bkgd:MovieClip;
      
      private var searchHandler:Function;
      
      private var keyHandler:Function;
      
      private var defText:String;
      
      private var editing:Boolean = false;
      
      public function InputText()
      {
         super();
         this.setMaxChars(16);
      }
      
      public function setMaxChars(param1:uint) : void
      {
         this.txtValue.maxChars = param1;
      }
      
      public function set text(param1:String) : void
      {
         this.txtValue.text = param1;
      }
      
      public function get text() : String
      {
         return this.txtValue.text;
      }
      
      public function centerAt(param1:Number) : void
      {
         this.txtValue.x = param1 - this.txtValue.width * 0.5;
         this.bkgd.x = this.txtValue.x;
      }
      
      public function setActive(param1:Boolean, param2:Function = null, param3:Function = null, param4:String = null, param5:Boolean = false) : void
      {
         visible = param1;
         if(param5)
         {
            this.txtValue.mouseEnabled = false;
            Utils.removeListener(this.txtValue,FocusEvent.FOCUS_IN,this.onFocusIn);
         }
         else
         {
            this.txtValue.mouseEnabled = true;
            if(param1)
            {
               Utils.addListener(this.txtValue,FocusEvent.FOCUS_IN,this.onFocusIn,true);
            }
            else
            {
               Utils.removeListener(this.txtValue,FocusEvent.FOCUS_IN,this.onFocusIn);
            }
            this.searchHandler = param2;
            this.keyHandler = param3;
            this.defText = param4;
         }
      }
      
      public function hasFocus() : Boolean
      {
         return this.editing;
      }
      
      private function onFocusIn(param1:FocusEvent) : void
      {
         if(this.text == this.defText || this.text == L.text("type-here"))
         {
            this.text = "";
         }
         Utils.addListener(this.txtValue,FocusEvent.FOCUS_OUT,this.onFocusOut);
         Utils.addListener(this.txtValue,KeyboardEvent.KEY_UP,this.keyHandler);
         this.editing = true;
      }
      
      private function onFocusOut(param1:FocusEvent) : void
      {
         Utils.removeListener(this.txtValue,FocusEvent.FOCUS_OUT,this.onFocusOut);
         Utils.removeListener(this.txtValue,KeyboardEvent.KEY_UP,this.keyHandler);
         this.editing = false;
      }
      
      public function setWidth(param1:Number) : void
      {
         this.txtValue.width = param1;
         this.bkgd.width = param1;
      }
      
      public function blur() : void
      {
         stage.focus = null;
      }
   }
}
