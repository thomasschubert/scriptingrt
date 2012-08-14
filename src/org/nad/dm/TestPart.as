package org.nad.dm
{

	import flashx.textLayout.formats.Float;
	
	import mx.core.FlexGlobals;
	import org.nad.util.ArrayUtil;
	import org.nad.dm.AbstractResponseTarget;
	
	public class TestPart extends Part
	{
		
		protected var _scramble:int = 0;
		protected var _branches : Array;
		public var avg:Number = 0;
		public var sum:Number = 0;
		public var failures:uint = 0;
		public var noresponses:uint = 0;
		public var goals:uint = 0;
		public var count:uint = 0;
		
		public function set scramble(type:int) : void {
			this._scramble = type;
		}
		
		
		public function TestPart(){
			super();
			this._scramble = 0;
		}
		
		public function set branches(b:Array) : void {
			if(this._branches == null){
				this._branches = [];
			}
			for(var i:uint = 0, l:uint = b.length; i < l; i++){
				_branches.push(b[i]);	
			}
			
		}
		public function get branches() : Array {
			return _branches;
		}
		
		
		override public function chain(parent:IChainLink = null) : IChainLink {
			super.chain(this); // i'm the parent of all testItems or ~Frames
			if(this.chainedChilds.length > 0 && this._scramble > 0){
				this.doScramble();
			}
			return this;
		}
		
		protected function doScramble() : void {
			var reorder:Array = [], sub:int = 0,
				k:int, l:int,
				i:int = 0;
			for(k = 0, l = this.chainedChilds.length; k < l;){
				var inner:Array = [];
				for(i = 0; i < this._scramble && k < l; k++){
					inner.push(this.chainedChilds[k]);
					i++;	
				}
				reorder.push(ArrayUtil.shuffel(inner));
			}
			//trace('TestPart('+this.id+').doScramble: ' + );
			this.chainedChilds = ArrayUtil.flat(ArrayUtil.shuffel(reorder));
		}
		public function addResults(proto:Object) : void {
			this.count++;
			this.sum += proto.responseTime;
			if(proto.response is String){
				this.noresponses++;
			}else{
				if(proto.response >= 0){
					this.goals++;
				}else{
					this.failures++;
				}
			}
			this.avg = this.sum / this.count;
			
		}
		
		public function branch() : String { // wird erst nach frame.hide gefragt in frame.next
			if(this._branches != null){
				trace('testPart.branch:', this._branches.length);
				var evalObject:Object = {
						'incorrect': this.failures,
						'miss': this.noresponses,
						'correct': this.goals,
						'sum': this.sum,
						'avg': this.avg,
						'count': this.count
					};
				for(var i:uint=0,l:uint=this._branches.length; i < l; i++){
					if(this._branches[i].eval(evalObject, this)){
				
						return this._branches[i].next;
					}
				}
			}
			return null;
		}
	}
}