package com.pixton.animate
{
   import com.pixton.editor.Utils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class Playhead extends MovieClip
   {
       
      
      public var bkgd:MovieClip;
      
      public var txtValue:TextField;
      
      public function Playhead()
      {
         super();
         Utils.useHand(this);
         this.txtValue.autoSize = TextFieldAutoSize.LEFT;
         this.txtValue.mouseEnabled = false;
      }
      
      public function setText(param1:String) : void
      {
         this.txtValue.text = param1;
         this.bkgd.width = Math.round(this.txtValue.textWidth) + 5;
      }
   }
}
