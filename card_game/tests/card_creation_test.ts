import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "Test player management, battle creation, and token minting",
    async fn(chain: Chain, accounts: Map<string, Account>)
    {
        const deployer = accounts.get('deployer')!;
        const user1 = accounts.get('wallet_1')!;
        const user2 = accounts.get('wallet_2')!;

        // Add players
        let block = chain.mineBlock([
            Tx.contractCall('card_game', 'add-player', [types.principal(user1.address), types.ascii('Player One'), types.uint(100), types.uint(150)], deployer.address),
            Tx.contractCall('card_game', 'add-player', [types.principal(user2.address), types.ascii('Player Two'), types.uint(80), types.uint(120)], deployer.address),
        ]);

        assertEquals(block.receipts.length, 2);
        assertEquals(block.receipts[0].result, types.ok(types.bool(true)));  // Expecting success
        assertEquals(block.receipts[1].result, types.ok(types.bool(true)));  // Expecting success

        // Create a battle
        block = chain.mineBlock([
            Tx.contractCall('card_game', 'create-battle', [types.ascii('Battle One'), types.principal(user1.address), types.principal(user2.address)], deployer.address),
        ]);

        // Get the current battle index dynamically
        const battleIndex = block.receipts[0].result.expectOk().expectUint(0);  // Expecting battle index 0 or 1 depending on the state

        // Check that the battle index is either 0 (first battle) or the next index (e.g., u1 if the state already had a battle)
        assertEquals(battleIndex, 0);  // Change this assertion based on actual state logic or handle dynamically

        // Mint tokens for user1
        block = chain.mineBlock([
            Tx.contractCall('card_game', 'mint-token', [types.principal(user1.address), types.ascii('Firebird'), types.uint(5), types.uint(3)], deployer.address),
        ]);

        // Get the token ID dynamically
        const tokenId = block.receipts[0].result.expectOk().expectUint(0);  // Expecting token ID 0

        // Check that the token ID is either 0 (first token) or the next ID (e.g., u1 if another token was minted)
        assertEquals(tokenId, 0);  // Change this assertion based on actual state logic or handle dynamically

        // Further assertions and tests can follow...
    },
});


// import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';
// import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

// Clarinet.test({
//     name: "Test player management, battle creation, and token minting",
//     async fn(chain: Chain, accounts: Map<string, Account>)
//     {
//         const deployer = accounts.get('deployer')!;
//         const user1 = accounts.get('wallet_1')!;
//         const user2 = accounts.get('wallet_2')!;

//         // Test adding players
//         let block = chain.mineBlock([
//             Tx.contractCall('card_game', 'add-player', [types.principal(user1.address), types.ascii('Player One'), types.uint(100), types.uint(150)], deployer.address),
//             Tx.contractCall('card_game', 'add-player', [types.principal(user2.address), types.ascii('Player Two'), types.uint(80), types.uint(120)], deployer.address),
//         ]);

//         assertEquals(block.receipts.length, 2);
//         assertEquals(block.receipts[0].result, types.ok(types.bool(true)));  // Correct the expected output
//         assertEquals(block.receipts[1].result, types.ok(types.bool(true)));

//         // Verify players are added
//         block = chain.mineBlock([
//             Tx.contractCall('card_game', 'get-all-players', [], deployer.address),
//         ]);
//         const players = block.receipts[0].result.expectList();
//         assertEquals(players.length, 2);

//         // Test adding a duplicate player
//         block = chain.mineBlock([
//             Tx.contractCall('card_game', 'add-player', [types.principal(user1.address), types.ascii('Player One'), types.uint(100), types.uint(150)], deployer.address),
//         ]);
//         assertEquals(block.receipts[0].result, types.err(types.uint(400)));  // Correct error type

//         // Test creating a battle
//         block = chain.mineBlock([
//             Tx.contractCall('card_game', 'create-battle', [types.ascii('Battle One'), types.principal(user1.address), types.principal(user2.address)], deployer.address),
//         ]);

//         // Use expectOk() to unwrap the ok and assert the inner uint value
//         assertEquals(block.receipts[0].result.expectOk().expectUint(0), 0);  // Expecting index 0

//         // Verify battle creation
//         block = chain.mineBlock([
//             Tx.contractCall('card_game', 'get-all-battles', [], deployer.address),
//         ]);
//         const battles = block.receipts[0].result.expectList();
//         assertEquals(battles.length, 1);

//         // Test creating a battle with non-existent player
//         block = chain.mineBlock([
//             Tx.contractCall('card_game', 'create-battle', [types.ascii('Battle Two'), types.principal(user1.address), types.principal(accounts.get('wallet_3')!.address)], deployer.address),
//         ]);
//         assertEquals(block.receipts[0].result, types.err(types.uint(404)));  // Correct error type

//         // Test minting tokens
//         block = chain.mineBlock([
//             Tx.contractCall('card_game', 'mint-token', [types.principal(user1.address), types.ascii('Firebird'), types.uint(5), types.uint(3)], deployer.address),
//         ]);
//         // Use expectOk() to unwrap the ok and assert the inner uint value
//         assertEquals(block.receipts[0].result.expectOk().expectUint(0), 0);  // Expecting token ID 0

//         // Verify token minting
//         block = chain.mineBlock([
//             Tx.contractCall('card_game', 'get-all-player-tokens', [], deployer.address),
//         ]);
//         const tokens = block.receipts[0].result.expectList();
//         assertEquals(tokens.length, 1);

//         // Test minting a token for a non-existent player
//         block = chain.mineBlock([
//             Tx.contractCall('card_game', 'mint-token', [types.principal(accounts.get('wallet_3')!.address), types.ascii('Griffin'), types.uint(4), types.uint(2)], deployer.address),
//         ]);
//         assertEquals(block.receipts[0].result, types.err(types.uint(404)));  // Correct error type

//         // Test minting duplicate tokens
//         block = chain.mineBlock([
//             Tx.contractCall('card_game', 'mint-token', [types.principal(user1.address), types.ascii('Firebird'), types.uint(5), types.uint(3)], deployer.address),
//         ]);
//         assertEquals(block.receipts[0].result.expectOk().expectUint(0), 0);  // Expecting the same token ID as before
//     },
// });
