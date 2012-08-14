package org.nad.util
{
	public final class ArrayUtil
	{
		public function ArrayUtil()
		{
		}
		
		public static function shuffel(arr : Array) : Array {
			var tmp:*, rand:int;
			for(var i:int = 0; i < arr.length; i++){
				rand = Math.floor(Math.random() * arr.length);
				tmp = arr[i]; 
				arr[i] = arr[rand]; 
				arr[rand] = tmp;
			}
			return arr;
		}
		
		public static function flat(arr : Array) : Array {
			var values: Array = [],
				found:Boolean = false;
			for(var i:uint = 0; i < arr.length; i++){
				if(arr[i] is Array){
					var replace:Array = flat(arr[i]);
					while(replace.length > 0){
						values.push(replace.shift());
					}
				}else{
					values.push(arr[i]);
				}
			}
			return values;
		}
		
		
		public static function next(arr : Array, child : * = null, offset:uint = 0) : Object {
			if(!child){
				return arr[0];
			}
			for(var i:uint = offset, l:uint = arr.length; i < l; i++){
				if(arr[i] === child && i+1 < l){
					return arr[i+1];
				}
			}
			return null;
		}
	}
}