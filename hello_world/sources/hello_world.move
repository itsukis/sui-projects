#[allow(lint(self_transfer))]
module hello_world::hello_world {

    //use sui::object::{Self, UID};
    use std::string;

    public struct HelloWorldObject has key, store {
        id: UID,
        text: string::String,
    }

    public struct Artist {
        /// The name of the artist.
        name: string::String,
    }


    public fun mint(ctx: &mut TxContext) {
       let object = HelloWorldObject {
            id: object::new(ctx),
            text: string::utf8(b"Hello, World!"),
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }

    public fun set_artist(): Artist {
        let artist = Artist {
            name: string::utf8(b"John Doe"),
        };
        artist
    }


}
