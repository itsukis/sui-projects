module my_counter::my_counter;

use sui::coin::{Self, Coin};
use sui::balance::{Self, Balance};
use sui::sui::SUI;

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

fun init(ctx: &mut TxContext) {
    let counter = Counter {
        id: object::new(ctx),
        owner: ctx.sender(),
        value: 0,
        stored_sui: balance::zero(),
    };
    transfer::public_transfer(counter, tx_context::sender(ctx));
}

// increment 호출한 사람이 0.01 SUI = 10,000,000 MIST (1 SUI = 10^9 MIST) 를 지불했는지 확인 필요
// 지불 안했으면 오류 발생
// increment Args 돈을 넣어야 하는데 (0.01 SUI 이상을 들고 있는 Ojbect)
public fun increment(counter: &mut Counter, payment: Coin<SUI>) {
    assert!(coin::value(&payment) >= MIN_PAYMENT_MIST, EInsufficientPayment);
    counter.value = counter.value + 1;
    balance::join(&mut counter.stored_sui, coin::into_balance(payment));
}

entry fun get_value(counter: &Counter): u64 {
    counter.value
}

public fun withdraw(counter: &mut Counter, recipient: address, amount: u64, ctx: &mut TxContext) {
    assert!(&counter.owner == ctx.sender(), EWrongOwner);
    assert!(balance::value(&counter.stored_sui) >= amount, EInsufficientBalance);
    let coin = coin::from_balance(balance::split(&mut counter.stored_sui, amount), ctx);
    transfer::public_transfer(coin, recipient);
}

