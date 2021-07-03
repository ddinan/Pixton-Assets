package com.pixton.editor
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Moveable extends MovieClip
   {
      
      public static const MAX_Z:Number = 100;
       
      
      public var activated:Boolean = false;
      
      private var _hidden:Boolean = false;
      
      private var _clone:Clone;
      
      private var _locked:Boolean = false;
      
      private var _temporaryLock:Boolean = false;
      
      private var _disallowed:Boolean = false;
      
      private var _z:Number = 1;
      
      var _size:Number = 1;
      
      public function Moveable()
      {
         super();
         this.name = "moveable";
         this.cacheAsBitmap = Main.CACHE_AS_BITMAPS && this.canCacheBitmap();
      }
      
      private function canCacheBitmap() : Boolean
      {
         return this is Character || this is Dialog;
      }
      
      protected function onSetMode(param1:uint) : void
      {
         if(!this.canCacheBitmap())
         {
            return;
         }
         var _loc2_:Boolean = param1 == Editor.MODE_MAIN || param1 == Editor.MODE_MOVE;
         if(_loc2_ != this.cacheAsBitmap)
         {
            this.cacheAsBitmap = _loc2_ && Main.CACHE_AS_BITMAPS;
         }
      }
      
      function updateBMCache(param1:Boolean = true) : void
      {
      }
      
      public function setHidden(param1:Boolean) : void
      {
         visible = !param1;
         this._hidden = param1;
      }
      
      function getHidden() : Boolean
      {
         return this._hidden;
      }
      
      public function set zIndex(param1:Number) : void
      {
         if(param1 > MAX_Z)
         {
            param1 = MAX_Z;
         }
         else if(param1 < 0)
         {
            param1 = 0;
         }
         this._z = param1;
      }
      
      public function get zIndex() : Number
      {
         return this._z;
      }
      
      public function hasClone() : Boolean
      {
         return this._clone != null;
      }
      
      public function getClone() : Clone
      {
         if(!this.hasClone())
         {
            this._clone = new Clone(this);
         }
         return this._clone;
      }
      
      function disallow() : void
      {
         this._disallowed = true;
         this.updateEnableStatus();
      }
      
      function allow() : void
      {
         this._disallowed = false;
         this.updateEnableStatus();
      }
      
      function lock(param1:Boolean = false) : void
      {
         if(param1)
         {
            this._temporaryLock = true;
         }
         else
         {
            this._locked = true;
         }
         this.updateEnableStatus();
      }
      
      function unlock(param1:Boolean = false) : void
      {
         if(param1)
         {
            this._temporaryLock = false;
         }
         else
         {
            this._locked = false;
         }
         this.updateEnableStatus();
      }
      
      private function updateEnableStatus() : void
      {
         mouseEnabled = !(this._temporaryLock || this._locked || this._disallowed);
         mouseChildren = mouseEnabled;
      }
      
      function isLocked(param1:Boolean = false) : Boolean
      {
         return !!param1 ? Boolean(this._temporaryLock) : Boolean(this._locked);
      }
      
      function set size(param1:Number) : void
      {
         this._size = param1;
         if(this._size == Number.POSITIVE_INFINITY || this._size == Number.NEGATIVE_INFINITY)
         {
            this._size = 0;
         }
      }
      
      function get size() : Number
      {
         return this._size;
      }
      
      public function getAttachPos() : Point
      {
         return null;
      }
      
      public function getSelectableRect(param1:DisplayObject = null) : Rectangle
      {
         if(param1 == null)
         {
            param1 = this;
         }
         return this.getBounds(param1);
      }
      
      public function onSelect(param1:Boolean = true) : void
      {
      }
   }
}
