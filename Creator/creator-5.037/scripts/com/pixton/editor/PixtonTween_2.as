package com.pixton.editor
{
   import fl.transitions.Tween;
   import fl.transitions.TweenEvent;
   import fl.transitions.easing.Strong;
   import flash.display.DisplayObject;
   
   public final class PixtonTween
   {
       
      
      public var tween:Tween;
      
      private var target:DisplayObject;
      
      public function PixtonTween(param1:DisplayObject, param2:String, param3:Number, param4:Number = NaN, param5:Number = 0, param6:Function = null, param7:Function = null)
      {
         var target:DisplayObject = param1;
         var property:String = param2;
         var toValue:Number = param3;
         var fromValue:Number = param4;
         var duration:Number = param5;
         var easeType:Function = param6;
         var onComplete:Function = param7;
         super();
         if(isNaN(duration))
         {
            duration = 0;
         }
         if(easeType == null)
         {
            easeType = Strong.easeInOut;
         }
         this.target = target;
         this.tween = new Tween(target,property,easeType,fromValue,toValue,duration,true);
         if(property == "alpha" && toValue == 0)
         {
            Utils.addListener(this.tween,TweenEvent.MOTION_FINISH,this.onFinish);
         }
         if(onComplete != null)
         {
            Utils.addListener(this.tween,TweenEvent.MOTION_FINISH,function(param1:TweenEvent):void
            {
               onComplete();
            });
         }
      }
      
      private function onFinish(param1:TweenEvent) : void
      {
         this.target.visible = false;
         Utils.removeListener(param1.target,TweenEvent.MOTION_FINISH,this.onFinish);
      }
      
      public function stop() : void
      {
         this.tween.stop();
      }
   }
}
