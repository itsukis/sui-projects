module my_counter::my_counter;

use sui::coin::{Self, Coin};
use sui::balance::{Self, Balance};
use sui::sui::SUI;
use sui::event;

const EInsufficientPayment: u64 = 1;
const EInsufficientBalance: u64 = 2;
const EWrongOwner: u64 = 3;

const MIN_PAYMENT_MIST: u64 = 10_000_000; // 0.01 SUI (1 SUI = 10^9 MIST)

public struct Counter has key, store {
    id: UID,
    owner: address,
    value: u64,
    stored_sui: Balance<SUI>,
}

public struct WithdrawEvent has copy, drop {
    counter_id: ID,
    amount: u64,
    recipient: address
}

fun init(ctx: &mut TxContext) {
    let counter = Counter {
        id: object::new(ctx),
        owner: ctx.sender(),
        value: 0,
        stored_sui: balance::zero(),
    };
    transfer::public_transfer(counter, tx_context::sender(ctx));
}

public fun increment(counter: &mut Counter, payment: Coin<SUI>) {
    assert!(coin::value(&payment) >= MIN_PAYMENT_MIST, EInsufficientPayment);
    counter.value = counter.value + 1;
    balance::join(&mut counter.stored_sui, coin::into_balance(payment));
}

entry fun get_value(counter: &Counter): u64 {
    counter.value
}

public fun withdraw(counter: &mut Counter, recipient: address, amount: u64, ctx: &mut TxContext) {
    assert!(&counter.owner == tx_context::sender(ctx), EWrongOwner);
    assert!(balance::value(&counter.stored_sui) >= amount, EInsufficientBalance);
    let coin = coin::from_balance(balance::split(&mut counter.stored_sui, amount), ctx);
    
    // Emit withdraw event
    event::emit(WithdrawEvent {
        counter_id: object::id(counter),
        amount,
        recipient
    });
    
    transfer::public_transfer(coin, recipient);
}

#[test]
fun create(ctx: &mut TxContext) {
    init(ctx);
    let counter = transfer::public_take<Counter>(ctx);
    assert!(object::id(&counter) != object::null_id(), EWrongOwner);
    transfer::public_transfer(counter, tx_context::sender(ctx));
}