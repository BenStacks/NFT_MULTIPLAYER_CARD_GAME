import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

// Define interfaces for our data structures
interface Player
{
    'player-address': string;
    'player-name': string;
    'player-mana': number;
    'player-health': number;
    'in-battle': boolean;
}

interface Battle
{
    'battle-status': number;
    'battle-hash': string;
    'name': string;
    'players': string[];
    'moves': number[];
    'winner': string | null;
}

interface PlayerToken
{
    'name': string;
    'id': number;
    'attack-strength': number;
    'defense-strength': number;
}

Clarinet.test({
    name: "Ensure that get-all-players, get-all-battles, and get-all-player-tokens work correctly",
    async fn(chain: Chain, accounts: Map<string, Account>)
    {
        const deployer = accounts.get('deployer')!;
        const user1 = accounts.get('wallet_1')!;
        const user2 = accounts.get('wallet_2')!;

        // Test get-all-players
        let block = chain.mineBlock([
            Tx.contractCall('card_game', 'get-all-players', [], deployer.address),
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 2);
        const players = block.receipts[0].result;
        // Check the returned players data
        assertEquals(players.expectList().length, 0);  // Assuming no players have been added yet

        // Test get-all-battles
        block = chain.mineBlock([
            Tx.contractCall('card_game', 'get-all-battles', [], deployer.address),
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 3);
        const battles = block.receipts[0].result;
        // Check the returned battles data
        assertEquals(battles.expectList().length, 0);  // Assuming no battles have been created yet

        // Test get-all-player-tokens
        block = chain.mineBlock([
            Tx.contractCall('card_game', 'get-all-player-tokens', [], deployer.address),
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 4);
        const tokens = block.receipts[0].result;
        // Check the returned tokens data
        assertEquals(tokens.expectList().length, 0);  // Assuming no tokens have been minted yet
    },
});