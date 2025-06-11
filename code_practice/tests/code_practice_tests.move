#[test_only]
module code_practice::test;

use code_practice::practice;
use std::debug::print;

#[test]
fun test_addition() {
    let result  = practice::addition(4, 7);
    print(&result);
    
}
