package org.nad.dm
{
	internal interface IChainResponseTarget extends IChainLink{
		
		function chainResponse(response:String) : void;
	}
}