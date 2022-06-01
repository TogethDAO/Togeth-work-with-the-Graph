import { BigInt,Address } from "@graphprotocol/graph-ts"
import {
  Together,
  Bought,
  Cancle,
  Claimed,
  Contributed,
  CreateProposal,
  Expired,
  Log,
  Sell
} from "../generated/Together/Together"
import { OnContributed,OnBought,OnCancle,OnClaimed,OnSell, OnCreateProposal } from "../generated/schema"

export function handleBought(event: Bought): void {

  let entity = OnBought.load(event.params.index.toHexString())
  if(entity == null){
    entity = new OnBought(event.transaction.index.toHex())
  }
  entity.buyer = event.params.sender
  entity.proposal_index = event.params.index
  entity.nftContract = event.params.asset
  entity.token = event.params.token
  entity.token_amount = event.params.amount
  entity.save()


}

export function handleCancle(event: Cancle): void {
	
  let id = event.params.triggeredBy.toHexString()
  
  let entity = OnCancle.load(id)

  if(entity == null){
    entity = new OnCancle(event.transaction.index.toHex())
  }

  entity.sender = event.params.triggeredBy
  entity.tokenid = event.params.tokenid
  entity.nftContract = event.params.targetAddress
  entity.proposal = event.params.propsal
  entity.save()
}

export function handleClaimed(event: Claimed): void {
  let id = event.params.proposal.toHexString()
  
  let entity = OnClaimed.load(id)

  if(entity == null){
    entity = new OnClaimed(event.transaction.index.toHex())
  }
  entity.contributor = event.params.contributor
  entity.token = event.params.token
  entity.tokenAmount = event.params.tokenAmount
  entity.proposal = event.params.proposal
  entity.save()
}

export function handleContributed(event: Contributed): void {
  let id = event.params.proposal.toHexString()  
  let entity = OnContributed.load(id)
  if(entity == null){
    entity = new OnContributed(event.transaction.index.toHex() )
  }
  entity.contributor = event.params.contributor
  entity.token = event.params.token
  entity.amount = event.params.amount

  entity.save()
}

export function handleCreateProposal(event: CreateProposal): void {
  let entity =OnCreateProposal.load(event.params.index.toHexString())

  if(entity == null){
    entity = new OnCreateProposal(event.transaction.index.toHex())
  }

  entity.creator = event.params.creator
  entity.asset = event.params.asset
  entity.token = event.params.token
  entity.tokenAmount = event.params.tokenAmount
 
  entity.secondsToTimeoutFoundraising = event.params.secondsToTimeoutFoundraising
  entity.secondsToTimeoutBuy = event.params.secondsToTimeoutBuy
  entity.secondsToTimeoutSell = event.params.secondsToTimeoutSell
  entity.save()
}


export function handleSell(event: Sell): void {
  let entity = OnSell.load(event.params.index.toHex())
  if(entity == null){
    entity = new OnSell(event.transaction.index.toHex())
  }
  entity.sender = event.params.sender
  entity.index = event.params.index
  entity.nftContract = event.params.asset


  entity.save()
}
