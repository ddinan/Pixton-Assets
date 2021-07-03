package com.pixton.animate
{
   public class TimelineSelection
   {
      
      private static var p1:Object;
      
      private static var p2:Object;
       
      
      public function TimelineSelection()
      {
         super();
      }
      
      public static function setStart(param1:int, param2:int) : *
      {
         if(p1 == null)
         {
            p1 = {};
         }
         p1.x = param1;
         p1.y = param2;
      }
      
      public static function setEnd(param1:int, param2:int) : *
      {
         if(p2 == null)
         {
            p2 = {};
         }
         p2.x = param1;
         p2.y = param2;
      }
      
      public static function unity() : void
      {
         if(p1 == null)
         {
            return;
         }
         if(p2 == null)
         {
            p2 = {};
         }
         p2.x = p1.x;
         p2.y = p1.y;
      }
      
      public static function getPos() : int
      {
         if(p1 == null)
         {
            return -1;
         }
         return Math.min(p1.x,p2.x);
      }
      
      public static function getRow() : int
      {
         if(p1 == null)
         {
            return -1;
         }
         return Math.min(p1.y,p2.y);
      }
      
      public static function getCells() : uint
      {
         if(p1 == null)
         {
            return 0;
         }
         return Math.abs(p2.x - p1.x + 1);
      }
      
      public static function getRows() : uint
      {
         if(p1 == null)
         {
            return 0;
         }
         return Math.abs(p2.y - p1.y + 1);
      }
      
      public static function getEnd() : int
      {
         if(p1 == null)
         {
            return -1;
         }
         return Math.max(p1.x,p2.x);
      }
      
      public static function unset() : void
      {
         p1 = null;
         p2 = null;
      }
      
      public static function isEmpty() : Boolean
      {
         return p1 == null || p2 == null;
      }
      
      public static function echo() : String
      {
         if(isEmpty())
         {
            return "null";
         }
         return p1.x + ", " + p1.y + "; " + p2.x + ", " + p2.y;
      }
   }
}
