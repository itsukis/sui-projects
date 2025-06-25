module code_practice::lock;

use sui::dynamic_object_field as dof;
use std::string::{Self, String};
use sui::transfer::public_transfer;

public struct MyObject has key, store {
    id: UID,
    name: String,
}

public struct Locked<phantom T: key + store> has key, store {
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

public fun unlock<T: key + store>(mut lock: Locked<T>, key: Key): T {
    // 키가 일치하는지 확인
    assert!(object::id(&key) == lock.key, 0);
    
    // key를 소비하기 위해 drop
    let Key { id } = key;
    object::delete(id);
    
    // 동적 객체 필드에서 객체를 제거하고 반환
    let obj = dof::remove(&mut lock.id, b"Lock");

    let Locked { id, key: _ } = lock;
    object::delete(id);

    obj
}

public entry fun create_my_object(ctx: &mut TxContext) {
    let my_obj = MyObject {
        id: object::new(ctx),
        name: string::utf8(b"my_obj"),
    };
    
    public_transfer(my_obj, sui::tx_context::sender(ctx));

}

public entry fun lock_my_object(obj: MyObject, ctx: &mut TxContext) {
    let (lock, key) = lock(obj, ctx);
    public_transfer(lock, sui::tx_context::sender(ctx));
    public_transfer(key, sui::tx_context::sender(ctx));
}
