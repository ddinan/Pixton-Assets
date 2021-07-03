package com.pixton.animate
{
   import com.pixton.editor.Debug;
   import com.pixton.editor.Editor;
   
   public class Placement
   {
      
      private static var list:Array = [];
       
      
      public var target:Object;
      
      public var position:uint;
      
      public var sequence:Sequence;
      
      public var index:uint;
      
      private var numCells:uint = 0;
      
      public function Placement()
      {
         super();
      }
      
      public static function getList() : Array
      {
         return list;
      }
      
      public static function unsetData() : void
      {
         list = [];
      }
      
      public static function getData() : Array
      {
         var _loc2_:uint = 0;
         var _loc1_:Array = [];
         var _loc3_:uint = list.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_.push(Placement(list[_loc2_]).getData());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function setData(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:Placement = null;
         if(param1 == null)
         {
            return;
         }
         Debug.trace("Placement.setData: " + param1.length);
         var _loc3_:uint = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if((_loc4_ = new Placement()).setData(param1[_loc2_]))
            {
               Placement.save(_loc4_);
            }
            _loc2_++;
         }
         remap();
      }
      
      public static function save(param1:Placement) : void
      {
         list.push(param1);
         remap();
      }
      
      public static function clear(param1:Object, param2:int = -1) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = list.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(Placement(list[_loc3_]).target == param1 && Placement(list[_loc3_]).sequence.includesMode(param2))
            {
               delete global[list.splice(_loc3_--,1)];
               _loc4_ = list.length;
            }
            _loc3_++;
         }
         remap();
      }
      
      public static function noneAfter(param1:Placement) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = list.length;
         var _loc4_:Object = param1.target;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if((_loc4_ == null || _loc4_ == Placement(list[_loc2_]).target) && Placement(list[_loc2_]).position + Placement(list[_loc2_]).getNumCells() >= param1.position)
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      public static function insertCell(param1:Object, param2:int, param3:Boolean, param4:int) : void
      {
         var _loc6_:uint = 0;
         var _loc5_:uint = !!param3 ? uint(param4) : uint(-param4);
         var _loc7_:uint = list.length;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            if((param1 == null || param1 == Placement(list[_loc6_]).target) && Placement(list[_loc6_]).position >= param2)
            {
               Placement(list[_loc6_]).position = Placement(list[_loc6_]).position + _loc5_;
            }
            _loc6_++;
         }
      }
      
      public static function remove(param1:Placement) : void
      {
         list.splice(param1.index,1);
         remap();
      }
      
      public static function remap() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = list.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            Placement(list[_loc1_]).index = _loc1_;
            _loc1_++;
         }
      }
      
      public function setSequence(param1:Sequence) : void
      {
         this.sequence = param1;
      }
      
      public function setTarget(param1:Object) : void
      {
         this.target = param1;
      }
      
      public function setPosition(param1:uint) : void
      {
         this.position = param1;
      }
      
      public function setNumCells(param1:uint) : void
      {
         this.numCells = param1;
      }
      
      public function getNumCells() : uint
      {
         return this.numCells;
      }
      
      public function getNumRows() : uint
      {
         return this.sequence.getNumRows();
      }
      
      public function getName() : String
      {
         return this.sequence.name.toUpperCase();
      }
      
      public function getTarget() : Object
      {
         return this.target;
      }
      
      public function getPosition() : Object
      {
         return this.position;
      }
      
      public function getData() : Object
      {
         var _loc1_:Object = {};
         _loc1_.s = this.sequence.id;
         Editor.getTargetInfo(_loc1_,this.target);
         _loc1_.p = this.position;
         _loc1_.n = this.getNumCells();
         return _loc1_;
      }
      
      public function setData(param1:Object) : Boolean
      {
         var _loc2_:Sequence = Sequence.getSequence(param1.s);
         if(_loc2_ == null)
         {
            return false;
         }
         this.setSequence(_loc2_);
         this.setTarget(Editor.getTargetFromInfo(param1));
         this.setPosition(param1.p);
         this.setNumCells(param1.n);
         return true;
      }
      
      public function getTimelineData() : Array
      {
         return this.sequence.getTimelineData();
      }
   }
}
