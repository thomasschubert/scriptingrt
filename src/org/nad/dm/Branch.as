package org.nad.dm
{
	
	
	import r1.deval.D;
	
	public final class Branch
	{
		private var _condition:String;
		private var _next:String;
		public var operation:Function;
		
		public function Branch(){
			
		}
		
		public function set condition(c:String) : void {
			this._condition = c.replace(/and/g,'&&').
									replace(/or/g,'||').
									replace(/gte/g,'>=').
									replace(/lte/g,'<=').
									replace(/lt/g,'<').
									replace(/gt/g,'>').
									replace(/e/g,'==');	
		}
		
		public function set next(n:String) : void {
			this._next = n;
		}
		public function get next() : String {
			return this._next;
		}
		/*public function set operation(f:Function) : void {
			trace('##############...',f);
			this._operation = f;
		}*/
		
		public function eval(data:Object, testPart:TestPart) : Boolean {
			if(data == null || (this._condition == null && this.operation == null) || this._next == null){
				return false;
			}
			if(this.operation != null){
				trace('############ operation', testPart.count );
				trace('###################', this.operation.call(testPart, data));
				return this.operation.call(testPart, data);
			}
			var string:String = '';
			for(var n:String in data){
				string += 'var ' + n + ':* = ' + data[n] + ';';
			}
			string += 'return '+this._condition;
			return D.evalToBoolean(string);
		}
	}
}