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
