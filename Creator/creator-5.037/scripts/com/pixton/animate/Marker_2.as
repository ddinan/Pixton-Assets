package com.pixton.animate
{
   import com.pixton.editor.Utils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class Marker extends MovieClip
   {
       
      
      public var txtValue:TextField;
      
      public function Marker(param1:Array)
      {
         super();
         Utils.setColor(this.txtValue,param1);
         this.txtValue.autoSize = TextFieldAutoSize.LEFT;
         this.txtValue.mouseEnabled = false;
      }
      
      public function set value(param1:uint) : void
      {
         this.txtValue.text = param1.toString();
      }
   }
}
