module code_practice::escrow;

use sui::dynamic_object_field as dof;
use sui::transfer::public_share_object;

public struct Escrow<phantom T: key + store> has key, store {
    id: UID,
    sender: address,
    receiver: address,
    exchange_key: ID,
}

public fun create_escrow<T: key + store>(obj: T, receiver: address, key: ID, ctx: &mut TxContext) {
    let mut escrow: Escrow<T> = Escrow {
        id: object::new(ctx),
        sender: sui::tx_context::sender(ctx),
        receiver: receiver,
        exchange_key: key,
    };

    dof::add(&mut escrow.id, b"Escrow", obj);

    public_share_object(escrow);

}

