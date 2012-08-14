package org.nad.dm
{
	internal interface IChainLink{
		function chain(informationController:IChainLink = null) : IChainLink;
		function next( caller : IChainLink, jumpto : Object = null  ) : void;
		function containsChild(idString : String, path : Array ) : Boolean;
	}
}