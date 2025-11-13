#[allow(unused_const)]

#[test_only]
module counter::counter_tests;

use counter::counter;
use sui::test_scenario;

const ENotAuthorized: u64 = 1;
const OWNER: address = @0xA;
const HACKER: address = @0xB;


#[test]
fun test_create_counter_success() {

    let mut scenario = test_scenario::begin(OWNER);

    {
        
        let ctx = test_scenario::ctx(&mut scenario);
        counter::create_counter(ctx);
    };


    test_scenario::next_tx(&mut scenario, OWNER);

    let counter_obj = test_scenario::take_from_address<counter::Counter>(&scenario, OWNER);


    let value = counter::get_value(&counter_obj);
    assert!(value == 0, 0);

    test_scenario::return_to_address(OWNER, counter_obj);
    let _effects = test_scenario::end(scenario);
}


#[test]
fun test_increment_success() {
    let mut scenario = test_scenario::begin(OWNER);

    {
        
        let ctx = test_scenario::ctx(&mut scenario);
        counter::create_counter(ctx);
    };

    
    test_scenario::next_tx(&mut scenario, OWNER);

    let mut counter_obj = test_scenario::take_from_sender<counter::Counter>(&scenario);

    {
        
        let ctx = test_scenario::ctx(&mut scenario);
        counter::increment(&mut counter_obj, ctx);
    };

    let value = counter::get_value(&counter_obj);
    assert!(value == 1, 0);

    test_scenario::return_to_sender(&scenario, counter_obj);
    let _effects = test_scenario::end(scenario);
}



#[test, expected_failure(abort_code = ENotAuthorized, location = counter)]
fun test_increment_fail() {
    
    let mut scenario = test_scenario::begin(OWNER);


    {
        let ctx = test_scenario::ctx(&mut scenario);
        counter::create_counter(ctx);
    };

    test_scenario::next_tx(&mut scenario, OWNER);
    let mut counter_obj = test_scenario::take_from_sender<counter::Counter>(&scenario);

    test_scenario::next_tx(&mut scenario, HACKER);

    {
        let ctx = test_scenario::ctx(&mut scenario);
        counter::increment(&mut counter_obj, ctx);
    };


    test_scenario::return_to_sender(&scenario, counter_obj);
    let _effects = test_scenario::end(scenario);


}



#[test]
fun test_first_timestamp_success() {
    let mut scenario = test_scenario::begin(OWNER);

    {
        let ctx = test_scenario::ctx(&mut scenario);
        counter::create_counter(ctx);
    };

    test_scenario::next_tx(&mut scenario, OWNER);

    let counter_obj = test_scenario::take_from_address<counter::Counter>(&scenario, OWNER);

    
    let timestamp = counter::get_timestamp(&counter_obj);
    assert!(timestamp >= 0, 0);

    test_scenario::return_to_address(OWNER, counter_obj);
    let _effects = test_scenario::end(scenario);
}




#[test]
fun test_timestamps_increase_success() {
   
    let mut scenario = test_scenario::begin(OWNER);

    {
        let ctx = test_scenario::ctx(&mut scenario);
        counter::create_counter(ctx);
    };

    

    test_scenario::next_tx(&mut scenario, OWNER);
    let mut counter_obj = test_scenario::take_from_sender<counter::Counter>(&scenario);
    let t1 = counter::get_timestamp(&counter_obj);


    test_scenario::later_epoch(&mut scenario, 1000, OWNER);
 
    {
        let ctx = test_scenario::ctx(&mut scenario);
        counter::increment(&mut counter_obj, ctx);
    };

    let t2 = counter::get_timestamp(&counter_obj);
    

    assert!(t2 > t1, 0);

    test_scenario::return_to_sender(&scenario, counter_obj);
    let _effects = test_scenario::end(scenario);
}
