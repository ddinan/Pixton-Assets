package com.pixton.editor
{
   public class PanelNotes extends PanelDesc
   {
       
      
      public function PanelNotes()
      {
         super();
         this.visible = false;
      }
      
      override public function updateColor() : void
      {
         if(isNaN(Palette.colorText))
         {
            return;
         }
         updateColors(Palette.colorHeaderText,Palette.colorHot);
      }
   }
}
