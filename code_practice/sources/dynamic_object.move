module code_practice::dynamic_object;

use sui::dynamic_object_field as dof;

public struct Parent has key {
    id: UID,
}

public struct Child has key, store {
    id: UID,
    count: u64,
}

public fun add_child(parent: &mut Parent, child: Child) {
    dof::add(&mut parent.id, b"child", child);
}

public fun delete_child(parent: &mut Parent) : u64 {
    let Child { id, count } = dof::remove(&mut parent.id, b"child");
    object::delete(id);
    count
}

#[test_only]
use sui::test_scenario;

use std::debug::print;

#[test]
fun test_add_and_delete_child() {

    let mut ts = test_scenario::begin(@0xA);
    let ctx = ts.ctx();

    let mut parent = Parent { id: object::new(ctx) };
    let child = Child { id: object::new(ctx), count: 10 };
    add_child(&mut parent, child);
    
    let count : u64 = delete_child(&mut parent);

    print(&count);
    assert!(count == 10, 1);
    
    let Parent { id } = parent;
    //id.delete();
    object::delete(id);

    ts.end();
}
