package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class NamerItem extends MovieClip
   {
       
      
      public var labelContainer:MovieClip;
      
      public var txtLabel:TextField;
      
      public function NamerItem()
      {
         super();
         this.txtLabel = this.labelContainer.txtLabel;
      }
      
      function set label(param1:String) : void
      {
         this.txtLabel.text = param1;
      }
   }
}
