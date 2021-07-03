package com.pixton.editor
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.filters.BitmapFilterQuality;
   
   public class Asset extends Moveable
   {
      
      public static var lineAlpha:Number = 1;
       
      
      public var _colorID:Array;
      
      public var imageData:Object;
      
      public var snapShot:BitmapData;
      
      private var startPosition:Object;
      
      private var _flipX:int = 1;
      
      private var _flipY:int = 1;
      
      private var _silhouette:Boolean = false;
      
      private var targetDialogs:Array;
      
      private var _blurAmount:Number = 0;
      
      private var _blurAngle:Number = 0;
      
      private var _glowAmount:Number = 0;
      
      protected var dirty:Boolean = true;
      
      protected var vector:MovieClip;
      
      protected var raster:Bitmap;
      
      public function Asset()
      {
         super();
         this.vector = new MovieClip();
         this.vector.name = "vector";
         addChild(this.vector);
         this.raster = new Bitmap();
         addChild(this.raster);
         this.reset();
         this.updateStartPosition();
      }
      
      public static function loadFromServer(param1:String, param2:Function, param3:Object = null) : void
      {
         var method:String = param1;
         var onComplete:Function = param2;
         var data:Object = param3;
         Utils.remote("" + method,data,function(param1:Object):*
         {
            onComplete(param1);
         });
      }
      
      public function reset() : void
      {
         this._colorID = [0,0,0,0,0];
         this.targetDialogs = [];
      }
      
      public function set flipX(param1:int) : void
      {
         this._flipX = param1;
         this.updateScaleX();
      }
      
      public function get flipX() : int
      {
         return this._flipX;
      }
      
      public function set flipY(param1:int) : void
      {
         this._flipY = param1;
         this.updateScaleY();
      }
      
      public function get flipY() : int
      {
         return this._flipY;
      }
      
      override function set size(param1:Number) : void
      {
         _size = param1;
         if(_size == Number.POSITIVE_INFINITY || _size == Number.NEGATIVE_INFINITY)
         {
            _size = 0;
         }
         this.updateScaleX();
         this.updateScaleY();
      }
      
      function updateScaleX() : void
      {
         scaleX = size * this._flipX;
      }
      
      function updateScaleY() : void
      {
         scaleY = size * this._flipY;
      }
      
      function updateScale() : void
      {
         this._flipX = scaleX < 0 ? -1 : 1;
         this._flipY = scaleY < 0 ? -1 : 1;
         this.size = scaleX / this._flipX;
      }
      
      function updateStartPosition() : void
      {
         this.startPosition = {
            "x":x,
            "y":y
         };
      }
      
      function move(param1:Number, param2:Number) : void
      {
         x = this.startPosition.x + param1;
         y = this.startPosition.y + param2;
      }
      
      function canSilhouette() : Boolean
      {
         return true;
      }
      
      function setSilhouette(param1:Boolean, param2:Boolean = true) : void
      {
         if(this.silhouette)
         {
            if(!param1)
            {
               if(this is PropSet)
               {
                  this._colorID = [0,0,0,0,0];
               }
               else if(this is Character && Character(this).isLockedLooks())
               {
                  Character(this).setColor(Palette.SILHOUETTE_COLOR,Palette.TRANSPARENT_ID);
               }
            }
         }
         else if(param1 && this is Character && Character(this).isLockedLooks() && Character(this).getColor() == Palette.TRANSPARENT_ID)
         {
            Character(this).setColor(Palette.SILHOUETTE_COLOR,Palette.WHITE_ID);
         }
         this._silhouette = param1;
         if(param2)
         {
            this.setColor(-1,this.getColor(),false,param2);
         }
      }
      
      function get silhouette() : Boolean
      {
         return this._silhouette;
      }
      
      function setColor(param1:int, param2:*, param3:Boolean = false, param4:Boolean = true) : void
      {
      }
      
      function getColor(param1:int = -1) : *
      {
         if(param1 == -1)
         {
            return this._colorID;
         }
         return this._colorID[param1];
      }
      
      public function redraw(param1:Boolean = false) : void
      {
      }
      
      function linkTarget(param1:Dialog) : void
      {
         this.targetDialogs.push(param1);
      }
      
      function unlinkTarget(param1:Dialog) : void
      {
         var _loc2_:* = this.getTarget(param1);
         if(_loc2_ > -1)
         {
            this.targetDialogs.splice(_loc2_,1);
         }
      }
      
      function drawTargets() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.targetDialogs)
         {
            Dialog(this.targetDialogs[_loc1_]).drawBubble();
         }
      }
      
      function unlinkAllTargets() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this.targetDialogs.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            Dialog(this.targetDialogs[0]).target = null;
            _loc1_++;
         }
      }
      
      private function getTarget(param1:Dialog) : int
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.targetDialogs)
         {
            if(this.targetDialogs[_loc2_] == param1)
            {
               return _loc2_;
            }
         }
         return -1;
      }
      
      private function targetVisible() : Boolean
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.targetDialogs)
         {
            if(!Moveable(this.targetDialogs[_loc1_]).getHidden() && Dialog(this.targetDialogs[_loc1_]).spikeMode != Dialog.SPIKE_THOUGHT)
            {
               return true;
            }
         }
         return false;
      }
      
      function captureAll() : Boolean
      {
         return false;
      }
      
      function drawSnapshot(param1:Number = 0) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1 > 0)
         {
            _loc2_ = Math.ceil(width * param1);
            _loc3_ = Math.ceil(height * param1);
         }
         else
         {
            param1 = 1;
            _loc2_ = Picker.ITEM_WIDTH_BKGD - Utils.DEFAULT_PADDING * 2;
            _loc3_ = Picker.ITEM_HEIGHT_BKGD - Utils.DEFAULT_PADDING * 2;
         }
         if(this.captureAll())
         {
            this.snapShot = Pixton.getEditorImage(Editor.self,Math.min(_loc2_ / Editor.self.getWidth(),_loc3_ / Editor.self.getHeight()),null,true,true,this);
            this.imageData = Pixton.getEditorImage(Editor.self,Math.min(_loc2_ / Editor.self.getWidth(),_loc3_ / Editor.self.getHeight()),null,true,false,this);
         }
         else
         {
            this.snapShot = Pixton.getImage(this,_loc2_,_loc3_,true);
            this.imageData = Pixton.encodeBMD(this.snapShot,param1);
         }
      }
      
      function getGlowAmount() : Number
      {
         if(this.silhouette)
         {
            return 0;
         }
         return this._glowAmount;
      }
      
      function getBlurAmount() : Number
      {
         return this._blurAmount;
      }
      
      function getBlurAngle() : Number
      {
         return this._blurAngle;
      }
      
      function setGlowAmount(param1:Number) : void
      {
         if(this.silhouette)
         {
            this._glowAmount = 0;
         }
         else
         {
            this._glowAmount = param1;
         }
         FX.glow(this,Math.pow(param1,1.5),Palette.RGBtoHex(Palette.getColor(this.getColor(0))),16,BitmapFilterQuality.HIGH);
      }
      
      function setBlurAmount(param1:Number) : void
      {
         this._blurAmount = param1;
         FX.blur(this,param1 + 1);
      }
      
      function setBlurAngle(param1:Number) : void
      {
         this._blurAngle = param1;
      }
      
      function getExtraData() : Object
      {
         var _loc1_:Object = {};
         if(FeatureTrial.can(FeatureTrial.BLUR))
         {
            _loc1_.bv = this.getBlurAmount();
            _loc1_.ba = this.getBlurAngle();
         }
         if(FeatureTrial.can(FeatureTrial.GLOW))
         {
            _loc1_.gv = this.getGlowAmount();
         }
         return _loc1_;
      }
      
      function setExtraData(param1:Object = null) : void
      {
         this.setBlurAmount(0);
         this.setBlurAngle(0);
         this.setGlowAmount(0);
         if(param1 != null)
         {
            if(param1.bv != null && param1.bv != 0)
            {
               if(FeatureTrial.can(FeatureTrial.BLUR))
               {
                  this.setBlurAmount(param1.bv);
                  this.setBlurAngle(param1.ba);
               }
               else
               {
                  Editor.warnFeatureLoss();
               }
            }
            if(param1.gv != null && param1.gv != 0)
            {
               if(FeatureTrial.can(FeatureTrial.GLOW))
               {
                  this.setGlowAmount(param1.gv);
               }
               else
               {
                  Editor.warnFeatureLoss();
               }
            }
         }
      }
      
      public function getTargetDialogs() : Array
      {
         return this.targetDialogs;
      }
   }
}
