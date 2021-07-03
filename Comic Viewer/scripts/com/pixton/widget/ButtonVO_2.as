package com.pixton.widget
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ButtonVO extends MovieClip
   {
       
      
      public var icon:MovieClip;
      
      public var soundKey:String;
      
      public var url:String;
      
      private var loadingIcon:LoadingIcon;
      
      public function ButtonVO()
      {
         super();
         this.onOut();
         this.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.buttonMode = true;
         this.useHandCursor = true;
         this.loadingIcon = new LoadingIcon();
         addChild(this.loadingIcon);
         this.hideLoading();
      }
      
      function showLoading() : void
      {
         this.loadingIcon.show();
      }
      
      function hideLoading() : void
      {
         this.loadingIcon.hide();
      }
      
      private function onOver(param1:MouseEvent = null) : void
      {
         this.icon.alpha = 1;
      }
      
      private function onOut(param1:MouseEvent = null) : void
      {
         this.icon.alpha = 0.8;
      }
   }
}
