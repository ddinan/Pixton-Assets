package com.pixton.editor
{
   import flash.events.Event;
   
   public class PanelTitle extends PanelText
   {
       
      
      private var _txtY:Number = 0;
      
      public function PanelTitle()
      {
         super();
         this._txtY = txtValue.y;
         Utils.addListener(this,Event.CHANGE,this.onChangeText);
      }
      
      override public function updateColor() : void
      {
         if(Palette.colorBkgd == null)
         {
            return;
         }
         updateColors(Palette.rgb2hex(Palette.colorBkgd),Palette.hex2rgb(!!isEditable() ? Number(Palette.lighten(Palette.colorText)) : Number(Palette.colorText)));
      }
      
      public function allowMultiline(param1:Boolean) : void
      {
         txtValue.multiline = txtValue.wordWrap = param1;
         if(param1)
         {
            setHeight(Comic.PANEL_TITLE_HEIGHT * 2 + (!!isEditable() ? 3 : 0));
            txtValue.maxChars = 64;
         }
         else
         {
            setHeight(Comic.PANEL_TITLE_HEIGHT + (!!isEditable() ? 3 : 0));
            txtValue.maxChars = 36;
         }
         this.onChangeText();
      }
      
      override protected function onChangeText(param1:Event = null) : void
      {
         var _loc2_:uint = 0;
         if(txtValue.multiline)
         {
            _loc2_ = txtValue.textHeight;
            txtValue.y = Math.round(getHeight() - _loc2_) / 2 - (!!isEditable() ? 6 : 4);
         }
         else
         {
            txtValue.y = this._txtY;
         }
      }
   }
}
