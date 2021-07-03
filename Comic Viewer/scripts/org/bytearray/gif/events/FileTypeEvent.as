package org.bytearray.gif.events
{
   import flash.events.Event;
   
   public class FileTypeEvent extends Event
   {
      
      public static const INVALID:String = "invalid";
       
      
      public function FileTypeEvent(param1:String)
      {
         super(param1,false,false);
      }
   }
}
