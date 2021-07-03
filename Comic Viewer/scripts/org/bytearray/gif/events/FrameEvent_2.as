package org.bytearray.gif.events
{
   import flash.events.Event;
   import org.bytearray.gif.frames.GIFFrame;
   
   public class FrameEvent extends Event
   {
      
      public static const FRAME_RENDERED:String = "rendered";
       
      
      public var frame:GIFFrame;
      
      public function FrameEvent(param1:String, param2:GIFFrame)
      {
         super(param1,false,false);
         this.frame = param2;
      }
   }
}
