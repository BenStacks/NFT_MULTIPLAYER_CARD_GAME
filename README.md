# NFT_MULTIPLAYER_CARD_GAME

## Overview
The **NFT_MULTIPLAYER_CARD_GAME** is a decentralized multiplayer card game utilizing NFTs, built on the Clarity language and deployed on the Stacks blockchain. The game features player registration, token minting, and battle mechanics using NFTs as unique game tokens.

### Project Structure
- **Smart Contract**: Written in Clarity.
- **Frontend**: Built with React.
- **Backend**: Managed with Node.js for authentication and other server-side functionalities.

## Features
- **NFT Minting**: Players can mint unique battle cards represented as NFTs.
- **Player Registration**: Players can register with a username and receive a game token.
- **Battles**: Players can engage in battles, utilizing their unique tokens.
- **Randomized Strengths**: Each battle card has randomly generated attack and defense strengths.
- **Events**: The game emits events for player registration, battles, and outcomes.

## Technologies Used
- **Blockchain**: Stacks
- **Smart Contract Language**: Clarity
- **Frontend Framework**: React
- **Backend**: Node.js, Express.js
- **NFT Standard**: ERC1155-like structure in Clarity

## Getting Started

### Prerequisites
- Install [Node.js](https://nodejs.org/)
- Install [npm](https://www.npmjs.com/)
- Install [Clarity CLI](https://github.com/blockstack/clarity-cli)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/NFT_MULTIPLAYER_CARD_GAME.git
   cd NFT_MULTIPLAYER_CARD_GAME
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the backend server:
   ```bash
   cd backend
   node server.js
   ```

4. Start the frontend:
   ```bash
   cd frontend
   npm start
   ```

## Smart Contract Development
The smart contract implements the core functionalities of the game, including player registration, token creation, and battle mechanics. It handles the state of players, battles, and the rules governing the interactions between players.

### Key Functions
- **Player Registration**: Players can register and receive a unique game token.
- **Battle Creation**: Players can create and join battles, competing against each other using their tokens.
- **Move Handling**: Players can make strategic choices during battles, influencing the outcomes based on their tokens' attributes.

### Event Emission
The contract emits various events to facilitate real-time updates for the frontend:
- `NewPlayer`: Triggered when a new player registers.
- `NewBattle`: Triggered when a new battle is created.
- `BattleEnded`: Triggered when a battle concludes.
- `BattleMove`: Triggered when a player makes a move in battle.

## Future Development
- Implement the frontend with React to interact seamlessly with the Clarity smart contract.
- Set up Node.js backend for player authentication, session management, and API interactions.
- Expand the smart contract functionalities based on player feedback and gameplay experience.

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request for any improvements or bug fixes.

## License
This project is not yet licenced by right protected. 

## Contact
For any inquiries, please contact:
- Bennett Uchechukwu (@BenStacks)
- bennet.btc.stacks@gmail.com
