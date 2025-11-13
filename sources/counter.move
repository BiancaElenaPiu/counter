module counter::counter;
//use sui::clock;
use sui::event;



const ENotAuthorized: u64 = 1; //error


//events
public struct CounterCreatedEvent has copy, drop{
    owner:address,
    timestamp:u64,
    current_value:u64
}

public struct CounterIncrementedEvent has copy, drop {
    owner: address,
    new_value: u64,
}


//data structure
public struct Counter has key{
    id:UID,
    owner:address,
    current_value:u64,
    timestamp:u64
}




//create a new counter - owned bt the caller

entry fun create_counter(ctx: &mut TxContext) {
    
    let owner = tx_context::sender(ctx);
    let timestamp =  tx_context::epoch_timestamp_ms(ctx);

    //the inital value is 0
    let counter = Counter {
        id: object::new(ctx),
        owner:owner,
        current_value: 0,
        timestamp: timestamp,
        };

        event::emit(CounterCreatedEvent { owner:owner, timestamp:timestamp, current_value:counter.current_value });
        transfer::transfer(counter, owner);

        
    }


//this function modifies the object
entry fun increment(counter: &mut Counter, ctx: &TxContext)
{
    let sender = tx_context::sender(ctx);
    if (sender != counter.owner) {
        abort ENotAuthorized
    };
    
    counter.current_value = counter.current_value + 1;

    let new_timestamp = tx_context::epoch_timestamp_ms(ctx);
    counter.timestamp = new_timestamp;
    event::emit(CounterIncrementedEvent { owner: sender, new_value: counter.current_value });

}

//visualize the current value of the counter
public fun get_value(counter: &Counter):u64{
    counter.current_value
}

public fun get_timestamp(counter: &Counter): u64 {
    counter.timestamp
}




