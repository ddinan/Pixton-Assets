package com.pixton.editor
{
   public class PanelDesc extends PanelText
   {
       
      
      public function PanelDesc()
      {
         super();
         txtValue.wordWrap = true;
      }
      
      override public function updateColor() : void
      {
         if(isNaN(Palette.colorText))
         {
            return;
         }
         updateColors(Palette.colorText,Palette.colorPage);
      }
   }
}
