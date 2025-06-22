module code_practice::lock;

use sui::dynamic_object_field as dof;

public struct Locked<T: key + store> has key, store {
    id: UID,
    key: ID,
}

public struct Key has key, store {
    id: UID,
}

public fun lock<T: key + store>(obj: T, ctx: &mut TxContext) : (Locked<T>, Key) {

    let key: Key = Key {
        id: object::new(ctx),
    };

    let mut lock: Locked<T> = Locked {
        id: object::new(ctx),
        key: object::id(&key),
    };

    dof::add(&mut lock.id, b"Lock", obj);

    (lock, key)
    
}


