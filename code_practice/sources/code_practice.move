module code_practice::practice;

use std::string::String;

public struct Object has key {
    id: UID,
    name: String,
}

public fun new(name: String, ctx: &mut TxContext): Object {
    Object {
        id: object::new(ctx),
        name,
    }
}

public fun addition(x: u8, y: u8): u8 {
    
    let sum: u8 = x + y;

    sum

}