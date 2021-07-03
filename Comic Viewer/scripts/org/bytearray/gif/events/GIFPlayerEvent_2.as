package org.bytearray.gif.events
{
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class GIFPlayerEvent extends Event
   {
      
      public static const COMPLETE:String = "complete";
       
      
      public var rect:Rectangle;
      
      public function GIFPlayerEvent(param1:String, param2:Rectangle)
      {
         super(param1,false,false);
         this.rect = param2;
      }
   }
}
