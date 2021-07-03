package com.pixton.editor
{
   public final class PropPack
   {
      
      static var propPacks:Array;
      
      static var propPackMap:Object;
      
      static var lastPoolValue:int = -1;
      
      private static var freePackID:int = -1;
       
      
      var id:uint;
      
      var props:Array;
      
      var map:Object;
      
      private var name:String;
      
      public function PropPack(param1:Object)
      {
         var _loc2_:Array = null;
         super();
         this.id = param1.id;
         this.name = param1.n;
         if(!(param1.p is Array))
         {
            if(param1.p == "free")
            {
               freePackID = this.id;
               _loc2_ = [];
            }
            else
            {
               _loc2_ = Prop.getAll();
               if(param1.p == "random")
               {
                  Utils.shuffle(_loc2_);
               }
            }
         }
         else
         {
            _loc2_ = param1.p;
            if(!param1.faves)
            {
               Utils.shuffle(_loc2_);
            }
         }
         this.setProps(_loc2_);
      }
      
      static function getPack(param1:uint) : PropPack
      {
         return propPacks[propPackMap[param1.toString()]] as PropPack;
      }
      
      static function updateFree() : void
      {
         var _loc4_:uint = 0;
         var _loc6_:Object = null;
         if(freePackID == -1)
         {
            return;
         }
         var _loc1_:Object = getPack(freePackID);
         var _loc2_:Array = Prop.getAll();
         var _loc3_:Array = [];
         var _loc5_:uint = _loc2_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if((_loc6_ = Prop.getLock(_loc2_[_loc4_])) == null)
            {
               _loc3_.push(_loc2_[_loc4_]);
            }
            _loc4_++;
         }
         Utils.shuffle(_loc3_);
         _loc1_.setProps(_loc3_);
      }
      
      function setProps(param1:Array) : void
      {
         var _loc2_:uint = 0;
         this.props = [];
         this.map = {};
         var _loc3_:uint = 0;
         var _loc4_:uint = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            if(Prop.exists(uint(param1[_loc2_])))
            {
               this.props[_loc3_] = {"id":uint(param1[_loc2_])};
               this.map[param1[_loc2_].toString()] = _loc3_;
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      function getName() : String
      {
         return this.name;
      }
   }
}
