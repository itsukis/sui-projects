#[test_only]
module code_practice::test;

use code_practice::practice;
use std::debug::print;
use std::string;

const TEST_RESULT_FAIL: u64 = 0x0;

#[test]
fun test_addition() {

    let result  = practice::addition(4, 7);

    print(&string::utf8(b"Result: "));
    print(&result);

    assert!(result == 11, TEST_RESULT_FAIL);
}

#[test]
fun test_vector() {

    // Vector examples
    let mut v8: vector<u8> = vector[];
    let mut v16_2: vector<u16> = vector[];

    let mut v16: vector<u16> = vector[10, 20, 30];
    let v32: vector<u32> = vector[100, 200, 300];
    let v64: vector<u64> = vector[1000, 2000, 3000];

    // 2-dimensional vector example
    let vv8: vector<vector<u8>> = vector[vector[1,2], vector[3,4]];

    print(&v8);
    print(&v16);
    print(&v32);
    print(&v64);

    print(&vv8[0][0]);
    print(&vv8[1][1]);

    vector::push_back(&mut v8, 1);
    v8.push_back(2);

    print(&v8.length());
    print(&v8);

    print(&v8.pop_back());
    print(&v8);

    vector::push_back(&mut v16_2, 100);
    vector::push_back(&mut v16_2, 200);
    print(&v16_2);

    let mut i = 0;
    while (i < v16.length()) {
        let element = vector::borrow_mut(&mut v16, i);
        *element = *element + 1; // Increment each element by 1
        i = i + 1;
    };
    
    print(&v16);
}

public struct VectorTest has drop {
    x: u64,
    y: u64,
}

#[test]
fun test_struct_vector() {
    let mut v: vector<VectorTest> = vector[];

    let v1 = VectorTest { x: 1, y: 2 };
    let v2 = VectorTest { x: 3, y: 4 };

    vector::push_back(&mut v, v1);
    vector::push_back(&mut v, v2);

    print(&v.length());
    print(&v);

}

public struct NoDropVectorTest {}

#[test]
fun test_struct_no_drop_vector() {
    let v: vector<NoDropVectorTest> = vector[];

    print(&vector::length(&v));

    assert!(vector::is_empty(&v ), TEST_RESULT_FAIL);

    vector::destroy_empty(v);
}