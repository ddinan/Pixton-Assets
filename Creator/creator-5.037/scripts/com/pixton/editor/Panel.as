package com.pixton.editor
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public final class Panel extends MovieClip
   {
      
      public static const STATE_DELETED:String = "deleted";
       
      
      public var row:uint;
      
      public var relModTime:Number = -1;
      
      public var absModTime:Number = -1;
      
      public var contents:DisplayObject;
      
      public var container:MovieClip;
      
      public var txtInfo:TextField;
      
      public var imageLoaded:Boolean = false;
      
      public var imageLoading:Boolean = false;
      
      public var imageNeedsSaving:Boolean = false;
      
      public var loading:PanelLoader;
      
      public var panelInfo:PanelInfo;
      
      public var num:MovieClip;
      
      public var panelTitle:PanelTitle;
      
      public var panelDesc:PanelDesc;
      
      public var panelNotes:PanelNotes;
      
      public var isNew:Boolean = false;
      
      private var _hasExternalBorder:Boolean = false;
      
      private var _key:String;
      
      private var _w:Number = 0;
      
      private var _h:Number = 0;
      
      private var _xp:Number;
      
      private var _yp:Number;
      
      private var _index:uint;
      
      private var _busy:Boolean = false;
      
      private var _lockData:Object;
      
      private var _version:uint;
      
      private var _version0:uint;
      
      private var _cache:Object;
      
      private var border:MovieClip;
      
      private var masker:MovieClip;
      
      private var fade:PixtonTween;
      
      private var _isThumb:Boolean = false;
      
      private var _isFreeStyle:Boolean = false;
      
      private var _comicKey:String;
      
      private var _tempWidth:uint = 0;
      
      private var _tempHeight:uint = 0;
      
      private var _spaceLeftInRow:uint = 0;
      
      public function Panel(param1:Object, param2:Boolean = false, param3:String = null)
      {
         super();
         this.txtInfo.visible = false;
         this.txtInfo.mouseEnabled = false;
         this.loading.show();
         buttonMode = true;
         useHandCursor = true;
         mouseEnabled = false;
         mouseChildren = false;
         this.num.mouseEnabled = false;
         this.num.mouseChildren = false;
         this.panelTitle.visible = false;
         this.panelDesc.visible = false;
         this.panelNotes.visible = false;
         this.panelTitle.mouseChildren = false;
         this.panelDesc.mouseChildren = false;
         this.panelNotes.mouseChildren = false;
         if(!Utils.empty(param1.scene))
         {
            this.key = param1.scene;
         }
         else if(!Utils.empty(param1.key))
         {
            this.key = param1.key;
         }
         this.update(param1);
         this.container.alpha = 0;
         this.masker = new MovieClip();
         addChild(this.masker);
         this.border = new MovieClip();
         addChild(this.border);
         this.border.mouseEnabled = false;
         this.border.mouseChildren = this.border.mouseEnabled;
         this._isThumb = param1.thumb != null;
         this._isFreeStyle = param2;
         this._comicKey = param3;
         if(!this._isThumb)
         {
            Utils.addListener(this,MouseEvent.MOUSE_OVER,this.updateNumber);
            Utils.addListener(this,MouseEvent.MOUSE_OUT,this.updateNumber);
         }
         this.updateBorder(true);
         this.updateNumber();
      }
      
      static function showLocked(param1:MovieClip, param2:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         if(param2 != null)
         {
            _loc3_ = param2.u;
            _loc4_ = param2.s;
         }
         if(param2 != null)
         {
            if(param1.panelInfo == null)
            {
               param1.panelInfo = new PanelInfo();
               param1.panelInfo.mouseEnabled = false;
               param1.panelInfo.mouseChildren = false;
               param1.panelInfo.x = 10;
               param1.panelInfo.y = 13;
               param1.addChild(param1.panelInfo);
            }
            param1.panelInfo.setUser(param2);
            param1.panelInfo.visible = true;
         }
         else if(param1.panelInfo != null)
         {
            param1.panelInfo.visible = false;
         }
      }
      
      function updateNumber(param1:MouseEvent = null) : void
      {
         if(Main.isProfile() || this._isThumb)
         {
            this.num.visible = false;
         }
         else
         {
            this.num.visible = !(param1 != null && param1.type == MouseEvent.MOUSE_OVER) && AppSettings.getActive(AppSettings.NUMBERS);
         }
      }
      
      public function update(param1:Object, param2:Boolean = false, param3:Boolean = false) : void
      {
         if(!Utils.empty(param1.o))
         {
            this.index = param1.o;
         }
         if(!Utils.empty(param1.v))
         {
            if(!isNaN(this.version) && param1.v > this.version)
            {
               param3 = false;
            }
            this.version = param1.v;
         }
         if(!Utils.empty(param1.v0))
         {
            this.version0 = param1.v0;
         }
         if(!Utils.empty(param1.m))
         {
            if(this.absModTime > -1 && param1.m > this.absModTime && !param2)
            {
               this.imageLoaded = false;
            }
            this.absModTime = param1.m;
         }
         if(!Utils.empty(param1.xp))
         {
            this.xp = param1.xp;
         }
         if(!Utils.empty(param1.yp))
         {
            this.yp = param1.yp;
         }
         if(!Utils.empty(param1.w) && !param2)
         {
            this.setWidth(param1.w);
         }
         if(!Utils.empty(param1.h) && !param2)
         {
            this.setHeight(param1.h);
         }
         if(param1.border)
         {
            this._hasExternalBorder = true;
         }
         else
         {
            this._hasExternalBorder = false;
         }
         this.panelTitle.updateColor();
         this.panelTitle.x = 0;
         this.panelTitle.setWidth(this.getWidth() + 1);
         if(Main.isMindMap() && this.getHeight(true,true) == 0)
         {
            this.panelDesc.visible = false;
         }
         else if(Main.isCharMap() && this.getHeight(true,true) == 0)
         {
            this.panelDesc.visible = true;
         }
         else if(Editor.canToggleMeta())
         {
            this.panelDesc.visible = Comic.hasPanelDescriptions() || param1.hasPD;
         }
         else
         {
            this.panelDesc.visible = Comic.hasPanelDescriptions();
         }
         if(this.getHeight(true,true) == 0)
         {
            this.panelTitle.allowMultiline(!this.panelDesc.visible);
         }
         else
         {
            this.panelTitle.allowMultiline(false);
         }
         this.panelTitle.y = -this.panelTitle.getHeight();
         if(param1.pt != null)
         {
            this.panelTitle.setText(param1.pt);
         }
         if((Main.isMindMap() || Main.isCharMap()) && this.getHeight(true,true) == 0)
         {
            this.panelTitle.visible = true;
         }
         else if(Editor.canToggleMeta())
         {
            this.panelTitle.visible = Comic.hasPanelTitles() || param1.hasPT;
         }
         else
         {
            this.panelTitle.visible = Comic.hasPanelTitles();
         }
         this.panelDesc.updateColor();
         this.panelNotes.updateColor();
         this.updateDescHeight(param1.descLen);
         this.updateExtraPos();
         if(param1.pd != null)
         {
            this.panelDesc.setText(param1.pd);
         }
         if(param1.pn != null)
         {
            this.panelNotes.setText(param1.pn);
         }
         if(param1.isNew == 1)
         {
            this.isNew = true;
         }
         this.updateNum();
      }
      
      public function updateDescHeight(param1:uint) : void
      {
         this.panelDesc.setHeight(Comic.PANEL_DESC_HEIGHT / Comic.DEFAULT_DESC_LINES * (param1 > 0 ? param1 : Comic.getDefDescLines()));
      }
      
      public function updateExtraPos() : void
      {
         this.panelDesc.x = 0;
         this.panelDesc.setWidth(this.getWidth() + 1);
         this.panelDesc.y = this.getHeight(true,true) + 1;
         this.panelNotes.x = 0;
         this.panelNotes.setWidth(this.getWidth() + 1);
         this.panelNotes.setHeight(Comic.PANEL_DESC_HEIGHT);
         this.panelNotes.y = this.panelDesc.y + (!!this.panelDesc.visible ? this.panelDesc.getHeight() : 0);
      }
      
      public function get version() : uint
      {
         return this._version;
      }
      
      public function set version(param1:uint) : void
      {
         this._version = param1;
         this.updateInfo();
      }
      
      public function get version0() : uint
      {
         return this._version0;
      }
      
      public function set version0(param1:uint) : void
      {
         this._version0 = param1;
      }
      
      public function set locked(param1:Object) : void
      {
         this._lockData = param1;
         showLocked(this,param1);
      }
      
      public function get locked() : Object
      {
         return this._lockData;
      }
      
      public function set busy(param1:Boolean) : void
      {
         this._busy = param1;
      }
      
      public function get busy() : Boolean
      {
         return this._busy;
      }
      
      public function setVisible(param1:Boolean) : void
      {
         if(Main.isReadOnly())
         {
            if(this.contents)
            {
               this.contents.visible = param1;
            }
         }
         else
         {
            this.visible = param1;
         }
      }
      
      public function updateBorder(param1:Boolean = false) : void
      {
         var _loc2_:Graphics = null;
         if(Utils.empty(this.getWidth()))
         {
            Comic.self.setPanelVisible(this,false);
            return;
         }
         Comic.self.setPanelVisible(this,true);
         if(param1)
         {
            Lib.drawPlaceHolder(this.border,this.getWidth(),this.getHeight(true,true));
         }
         else
         {
            _loc2_ = this.border.graphics;
            _loc2_.clear();
            if((!Comic.isFreestyle() && !this._isFreeStyle || Comic.isFreestyle() && this._hasExternalBorder) && this.getHeight(true,true) > 0)
            {
               _loc2_.lineStyle(1,Palette.colorText);
               _loc2_.moveTo(0,0);
               _loc2_.lineTo(this.getWidth(),0);
               _loc2_.lineTo(this.getWidth(),this.getHeight(true,true));
               _loc2_.lineTo(0,this.getHeight(true,true));
               _loc2_.lineTo(0,0);
            }
         }
      }
      
      public function mimicSize(param1:Panel, param2:Number) : void
      {
         var _loc3_:Object = {
            "width":param1.width,
            "height":param1.height
         };
         if(param2 < _loc3_.width)
         {
            _loc3_.width = param2;
         }
         Utils.drawBorder(this.border,_loc3_);
         this.setWidth(_loc3_.width);
         this.setHeight(_loc3_.height);
      }
      
      public function set cache(param1:Object) : void
      {
         if(param1 != null)
         {
            param1.o = null;
            param1.key = null;
         }
         this._cache = param1;
         if(param1 != null)
         {
            this.update(param1);
         }
      }
      
      public function get cache() : Object
      {
         return this._cache;
      }
      
      public function reset() : void
      {
         if(this.cache == null)
         {
            return;
         }
         this.setWidth(this.cache.w);
         this.setHeight(this.cache.h);
         if(this.cache.xp != null)
         {
            this.xp = this.cache.xp;
            this.yp = this.cache.yp;
         }
      }
      
      public function resetCache() : void
      {
         this.cache = null;
      }
      
      public function set index(param1:uint) : void
      {
         this._index = param1;
         this.updateInfo();
         this.updateNum();
      }
      
      public function get index() : uint
      {
         return this._index;
      }
      
      public function loadImage() : void
      {
         var _loc1_:String = null;
         if(this.key == null)
         {
            return;
         }
         this.loading.show();
         if(L.multiLangID > 0)
         {
            _loc1_ = Main.IO_DIR + "loadImage/" + (!!this._isThumb ? "_" + this._comicKey : Comic.key) + "/" + this.key + "/" + this.version;
            if(L.multiLangID > 0)
            {
               _loc1_ += "/" + L.multiLangID + "?v0=" + this.version0;
            }
         }
         else
         {
            _loc1_ = Comic.getPath((!!this._isThumb ? "_" + this._comicKey : Comic.key) + this.key,this.version,L.multiLangID > 0 ? L.multiLangID.toString() : null);
         }
         if(this.getHeight(true,true) > 0)
         {
            this.imageLoading = true;
            Utils.load(_loc1_,this.onLoadImage,false,File.BUCKET_NONE,this.onLoadImageError);
         }
         else
         {
            this.onLoadImage();
         }
      }
      
      private function onLoadImageError(param1:Object) : void
      {
         this.onLoadImage(null);
      }
      
      private function onLoadImage(param1:Event = null) : void
      {
         if(param1 == null)
         {
            this.setContent(null);
         }
         else
         {
            this.setContent(param1.target.loader.contentLoaderInfo.content);
         }
         dispatchEvent(new PixtonEvent(PixtonEvent.LOAD_PANEL));
      }
      
      public function setContent(param1:DisplayObject) : void
      {
         var _loc2_:MovieClip = null;
         this.loading.hide();
         this.imageLoading = false;
         this.imageNeedsSaving = false;
         if(param1 == null)
         {
            if(this.container.numChildren > 0)
            {
               this.container.removeChildAt(0);
            }
            if(this.getHeight(true,true) > 0)
            {
               _loc2_ = new MovieClip();
               this.container.addChild(_loc2_);
               _loc2_.graphics.beginFill(16777215);
               _loc2_.graphics.moveTo(0,0);
               _loc2_.graphics.lineTo(this.getWidth(),0);
               _loc2_.graphics.lineTo(this.getWidth(),this.getHeight(true,true));
               _loc2_.graphics.lineTo(0,this.getHeight(true,true));
               _loc2_.graphics.lineTo(0,0);
               _loc2_.graphics.endFill();
            }
            this.imageLoaded = true;
         }
         else if(param1.width > 0)
         {
            if(this.container.numChildren > 0)
            {
               this.container.removeChildAt(0);
            }
            this.contents = this.container.addChild(param1);
            this.imageNeedsSaving = this.contents.width != this.getWidth() || this.contents.height != this.getHeight(true,true);
            param1.width = this.getWidth();
            param1.height = this.getHeight(true,true);
            this.imageLoaded = true;
         }
         else
         {
            this.imageLoaded = false;
         }
         if(this._isThumb)
         {
         }
         this.updateBorder();
         this.updateNum();
         mouseEnabled = true;
         mouseChildren = true;
         if(this.container.alpha == 0)
         {
            this.fade = Utils.tween(this.container,"alpha",1);
         }
      }
      
      function setWidth(param1:Number) : void
      {
         this._w = param1;
         this.loading.x = this._w * 0.5;
      }
      
      public function setTempWidth(param1:uint) : void
      {
         if(param1 == this._tempWidth || param1 == this._w && !this.hasTempWidth())
         {
            return;
         }
         this._tempWidth = param1;
         this.updateImageSize();
      }
      
      public function setHeight(param1:uint) : void
      {
         this._h = param1;
         this.loading.y = this._h * 0.5;
      }
      
      public function updateImageSize() : void
      {
         if(this.contents)
         {
            this.contents.width = this.getWidth();
            this.contents.height = this.getHeight(true,true);
         }
         this.updateBorder();
         this.updateNum();
      }
      
      public function setTempHeight(param1:uint) : void
      {
         if(param1 == this._tempHeight || param1 == this._h && !this.hasTempHeight())
         {
            return;
         }
         this._tempHeight = param1;
         this.updateImageSize();
      }
      
      public function getWidth(param1:Boolean = true) : uint
      {
         if(param1 && this.hasTempWidth())
         {
            return this._tempWidth;
         }
         return this._w;
      }
      
      public function getHeight(param1:Boolean = true, param2:Boolean = false, param3:Boolean = false) : Number
      {
         var _loc4_:uint = 0;
         if(param1 && this.hasTempHeight())
         {
            _loc4_ += this._tempHeight;
         }
         else
         {
            _loc4_ += this._h;
         }
         if(!param2 && !param3 && this.panelTitle.visible)
         {
            _loc4_ += this.panelTitle.getHeight();
         }
         if(!param2 && this.panelDesc.visible)
         {
            _loc4_ += this.panelDesc.getHeight();
         }
         return _loc4_;
      }
      
      public function getDescription() : String
      {
         return this.key + " [" + this.index + "]";
      }
      
      public function set key(param1:String) : void
      {
         this._key = param1;
         this.updateInfo();
      }
      
      public function get key() : String
      {
         return this._key;
      }
      
      public function getKey() : String
      {
         return this._key;
      }
      
      public function set xp(param1:Number) : void
      {
         this._xp = param1;
         Comic.self.setPanelX(this,this.xp);
         this.updateInfo();
      }
      
      public function get xp() : Number
      {
         return this._xp;
      }
      
      public function set yp(param1:Number) : void
      {
         this._yp = param1;
         Comic.self.setPanelY(this,this.yp);
         this.updateInfo();
      }
      
      public function get yp() : Number
      {
         return this._yp;
      }
      
      private function updateNum() : void
      {
         if(this._isThumb)
         {
            return;
         }
         this.num.x = this.getWidth() * 0.5;
         this.num.y = this.getHeight(true,true) * 0.5;
         this.num.txtValue.text = this.index + 1;
         if(Debug.ACTIVE)
         {
            this.num.txtValue.autoSize = TextFieldAutoSize.CENTER;
            this.num.txtValue.text += ":" + this._key;
         }
      }
      
      private function updateInfo() : void
      {
         if(!this.txtInfo.visible)
         {
            return;
         }
         this.txtInfo.text = "k: " + this.key + "\n" + "i: " + this.index + "\n" + "v: " + this.version;
      }
      
      public function hasTempWidth() : Boolean
      {
         return this._tempWidth != this._w && this._tempWidth != 0;
      }
      
      public function hasTempHeight() : Boolean
      {
         return this._tempHeight != this._h && this._tempHeight != 0;
      }
      
      public function resetTempWidth(param1:Boolean = false) : void
      {
         if(param1)
         {
            this.setWidth(this.getWidth());
         }
         this.setTempWidth(this._w);
      }
      
      public function resetTempHeight(param1:Boolean = false) : void
      {
         if(param1)
         {
            this.setHeight(this.getHeight());
         }
         this.setTempHeight(this._h);
      }
      
      public function setSpaceLeftInRow(param1:uint) : void
      {
         this._spaceLeftInRow = param1;
      }
      
      public function getSpaceLeftInRow() : uint
      {
         return this._spaceLeftInRow;
      }
      
      public function setNotesVisible(param1:Boolean) : void
      {
         this.panelNotes.visible = param1;
      }
   }
}
