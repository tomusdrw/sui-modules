module module_3::hero; 
use sui::package;
use sui::display;
use sui::transfer::public_share_object;
use sui::package::version;

// One time witness for the entire module,
// name has to match the package.
public struct HERO has drop {}

/// Claim the `Publisher` object in the module initializer 
/// to then create a `Display`. The `Display` is initialized with
/// a set of fields (but can be modified later) and published via
/// the `update_version` call.
///
/// Keys and values are set in the initializer but could also be
/// set after publishing if a `Publisher` object was created.
fun init(otw: HERO, ctx: &mut TxContext) {
    let keys = vector[
        b"name".to_string(),
        b"link".to_string(),
        b"image_url".to_string(),
        b"description".to_string(),
        b"project_url".to_string(),
        b"creator".to_string(),
    ];

    let values = vector[
        // For `name` one can use the `Hero.name` property
        b"{name}".to_string(),
        // For `link` one can build a URL using an `id` property
        b"https://fluffylabs.dev/sui/hero/{id}".to_string(),
        // For `image_url` use an IPFS template + `image_url` property.
        b"{image_url}".to_string(),
        // Description is static for all `Hero` objects.
        b"A true Hero of the Sui ecosystem!".to_string(),
        // Project URL is usually static
        b"https://fluffylabs.dev".to_string(),
        // Creator field can be any
        b"tomek".to_string(),
    ];

    // Claim the `Publisher` for the package!
    let publisher = package::claim(otw, ctx);

    // Get a new `Display` object for the `Hero` type.
    let mut display = display::new_with_fields<Hero>(
        &publisher, keys, values, ctx
    );

    // Commit first version of `Display` to apply changes.
    display.update_version();

    transfer::public_transfer(publisher, ctx.sender());
    transfer::public_transfer(display, ctx.sender());
}

    // ========= IMPORTS =========
    use std::string::String;
    use sui::coin::Coin;
    use sui::sui::SUI;
    use sui::transfer::freeze_object;
    use sui::event::emit;
    use sui::transfer::share_object;
    
    // ========= STRUCTS =========
    public struct Hero has key, store {
        id: UID,
        name: String,
        image: String,
        image_url: String,
        power: u64,
    }

    public struct ListHero has key, store {
        id: UID,
        nft: Hero,
        price: u64,
        seller: address,
    }

    public struct HeroMetadata has key, store {
        id: UID,
        hero_id: ID,
        timestamp: u64,
    }

    // ========= EVENTS =========

    public struct HeroListed has copy, drop {
        list_hero_id: ID,
        price: u64,
        seller: address,
        timestamp: u64,
    }

    public struct HeroBought has copy, drop {
        list_hero_id: ID,
        price: u64,
        buyer: address,
        seller: address,
        timestamp: u64,
    }

    // ========= FUNCTIONS =========

    #[allow(lint(self_transfer))]
    public entry fun create_hero(name: String, image_url: String, power: u64,  ctx: &mut TxContext) {
        let hero = Hero {
            id: object::new(ctx),
            name,
            image: image_url,
            image_url,
            power
        };

        let hero_metadata = HeroMetadata {
            id: object::new(ctx),
            hero_id: object::id(&hero),
            timestamp: tx_context::epoch_timestamp_ms(ctx)
        };

        transfer::transfer(hero, ctx.sender());

        // TODO: Freeze the HeroMetadata object
        freeze_object(hero_metadata);
    }



    public entry fun list_hero(nft: Hero, price: u64, ctx: &mut TxContext) {
        // TODO: Define the ListHero object,
        let list_hero = ListHero {
            id: object::new(ctx),
            nft,
            price,
            seller: ctx.sender(),
        };

        // TODO: Emit the HeroListed event
        emit(HeroListed {
            list_hero_id: object::id(&list_hero),
            price,
            seller: ctx.sender(),
            timestamp: tx_context::epoch_timestamp_ms(ctx),
        });

        // TODO: Share the ListHero object 
        public_share_object(list_hero);
    }
    public entry fun change_listing(list_hero: &mut ListHero) {
        list_hero.price = 0;
    }

   public entry fun make_expensive(list_hero: &mut ListHero) {
        list_hero.price = 1_000_000_000_000_000;
    }

    public entry fun buy_hero(list_hero: ListHero, coin: Coin<SUI>, ctx: &mut TxContext) {
        let list_hero_id = object::id(&list_hero);
        // TODO: Deconstruct the ListHero object
        let ListHero { id, nft, price, seller } = list_hero;
        // TODO: Assert the price of the Hero is equal to the coin amount
        assert!(coin.balance().value() == price, 1);
        // TODO: Transfer the coin to the seller
        transfer::public_transfer(coin, seller);
        // TODO: Transfer the Hero object to the sender
        transfer::public_transfer(nft, ctx.sender());
        // TODO: Emit the HeroBought event
        emit(HeroBought {
            list_hero_id,
            price,
            buyer: ctx.sender(),
            seller,
            timestamp: tx_context::epoch_timestamp_ms(ctx),
        });
        // TODO: Destroy the ListHero object
        object::delete(id);
    }

    public entry fun transfer_hero(hero: Hero, to: address) {
        transfer::public_transfer(hero, to);
    }

    // ========= GETTER FUNCTIONS =========
    
    #[test_only]
    public fun hero_name(hero: &Hero): String {
        hero.name
    }

    #[test_only]
    public fun hero_image_url(hero: &Hero): String {
        hero.image_url
    }

    #[test_only]
    public fun hero_power(hero: &Hero): u64 {
        hero.power
    }

    #[test_only]
    public fun hero_id(hero: &Hero): ID {
        object::id(hero)
    }





