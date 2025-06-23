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
#[test_only]
use std::debug::print;

#[test]
fun test_add_and_delete_child() {

    // 1. create a test scenario
    let mut ts = test_scenario::begin(@0xA);
    let ctx = ts.ctx();

    // 2. create a parent object
    let mut parent = Parent { id: object::new(ctx) };

    // 3. create a child object
    let child = Child { id: object::new(ctx), count: 10 };

    // 4. add the child to the parent   
    add_child(&mut parent, child);

    // 5. delete the child from the parent
    let count : u64 = delete_child(&mut parent);

    // 6. print the count   
    print(&count);
    assert!(count == 10, 1);

    // 7. delete the parent object
    let Parent { id } = parent;
    //id.delete();
    object::delete(id);

    // 8. end the test scenario
    ts.end();
}
