import { BigInt } from "@graphprotocol/graph-ts"
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
import { ExampleEntity } from "../generated/schema"

export function handleBought(event: Bought): void {

  let entity = ExampleEntity.load(event.transaction.from.toHex())
  if (!entity) {
    entity = new ExampleEntity(event.transaction.from.toHex())    
  }
  entity.sender = event.params.sender
  entity.index = event.params.index
  entity.asset = event.params.asset
  entity.token = event.params.token
  entity.amount = event.params.amount
  entity.save()


}

export function handleCancle(event: Cancle): void {
	
  let id = event.params.index.toHexString()
  
  let entity = ExampleEntity.load(id)
  entity.count = entity.count + BigInt.fromI32(1)
  entity.sender = event.params.sender
  entity.index = event.params.index

  entity.save()
}

export function handleClaimed(event: Claimed): void {
  let id = event.params.proposal.toHexString()
  
  let entity = ExampleEntity.load(id)
  entity.contributor = event.params.contributor
  entity.token = event.params.token
  entity.tokenAmount = event.params.tokenAmount

  entity.save()
}

export function handleContributed(event: Contributed): void {
  let id = event.params.proposal.toHexString()  
  let entity = ExampleEntity.load(id)
  entity.contributor = event.params.contributor
  entity.token = event.params.token
  entity.tokenAmount = event.params.tokenAmount

  entity.save()
}

export function handleCreateProposal(event: CreateProposal): void {
  let entity =new ExampleEntity(event.params.index.toHex())

  entity.creator = event.params.creator
  entity.asset = event.params.asset
  entity.token = event.params.token
  entity.tokenAmount = event.params.tokenAmount
  entity.amount = event.params.amount
  entity.secondsToTimeoutFoundraising = event.params.secondsToTimeoutFoundraising
  entity.secondsToTimeoutBuy = event.params.secondsToTimeoutBuy
  entity.secondsToTimeoutSell = event.params.secondsToTimeoutSell
  entity.save()
}

export function handleExpired(event: Expired): void {
  let id = event.params.param0.toHexString()  
  let entity = ExampleEntity.load(id)
  entity.param1 = event.params.param1
  entity.save()
}

export function handleLog(event: Log): void {}

export function handleSell(event: Sell): void {
  let entity = ExampleEntity.load(event.params.index.toHex())
  if (!entity) {
    entity = new ExampleEntity(event.params.index.toHex())    
  }
  entity.sender = event.params.sender
  entity.index = event.params.index
  entity.asset = event.params.asset
  entity.token = event.params.token
  entity.amount = event.params.amount
  entity.save()
}
