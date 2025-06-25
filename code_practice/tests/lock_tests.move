#[test_only]
module code_practice::lock_tests;

use code_practice::lock;
use sui::test_scenario;
use std::debug::print;

// MyObject

#[test]
fun test_lock_unlock() {
    let mut ts = test_scenario::begin(@0xA);
    let ctx = ts.ctx();

    // 1. lock(my_obj) -> lock, key
    // 2. unlock(lock, key) -> my_obj
 
    ts.end();
}
