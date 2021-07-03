package com.pixton.editor
{
   public final class Printing
   {
      
      public static var titleHeight:Number = 0;
      
      private static var pageWidth:Number = 8.5;
      
      private static var pageHeight:Number = 11;
      
      private static var defMargin:Number = 0.5;
      
      private static var isMetric:Boolean = true;
       
      
      public function Printing()
      {
         super();
      }
      
      static function init(param1:Object) : void
      {
         titleHeight = param1.prt;
         pageWidth = param1.prw;
         pageHeight = param1.prh;
         isMetric = param1.pru == 1;
      }
      
      static function getPageLength(param1:Number) : Number
      {
         return Math.round(param1 / pageWidth * pageHeight);
      }
   }
}
