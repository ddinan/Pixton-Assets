package com.pixton.editor
{
   public class HandleRotate extends Handle
   {
       
      
      public function HandleRotate()
      {
         super();
      }
      
      public function setColor(param1:Array) : void
      {
         if(icon != null && icon.contents != null)
         {
            Utils.setColor(icon.contents,param1);
         }
         if(symbol != null)
         {
            Utils.setColor(symbol,param1);
         }
      }
   }
}
