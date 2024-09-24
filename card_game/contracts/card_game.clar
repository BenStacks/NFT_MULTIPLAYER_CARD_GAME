(define-data-var base-uri (string-ascii 256) "") ;; baseURI where token metadata is stored
(define-data-var total-supply uint u0) ;; Total number of tokens minted

(define-constant DEVIL u0) 
(define-constant GRIFFIN u1) 
(define-constant FIREBIRD u2)
(define-constant KAMO u3) 
(define-constant KUKULKAN u4) 
(define-constant CELESTION u5) 

;; Define a constant for max attack/defend strength
(define-constant MAX-ATTACK-DEFEND-STRENGTH u10)

;; Default battle status is PENDING
(define-data-var battle-status uint u0) ;; Default to PENDING (u0)

(define-constant PENDING u0)
(define-constant STARTED u1)
(define-constant ENDED u2)

;; A GameToken map to store player token info
(define-map game-tokens 
  { token-index: uint } 
  { name: (string-ascii 64), 
    attack-strength: uint, 
    defense-strength: uint })

;; A Player map to store player info
(define-map players 
  { player-index: uint } 
  { player-address: principal,
    player-name: (string-ascii 64), 
    player-mana: uint, 
    player-health: uint, 
    in-battle: bool })

;; Define a Battle map to store battle info
(define-map battles 
 { battle-index: uint } 
  { battle-hash: (buff 32),  
    battle-status: uint,      ;; Represents the enum battle status (PENDING, STARTED, ENDED)
    name: (string-ascii 64),  ;; Battle name (set by player who creates the battle)
    players: (list 2 principal), ;; Players array (2 players' principal addresses)
    moves: (list 2 uint),     ;; Moves array (uint representing players' moves)
    winner: (optional principal) ;; Winner's principal address, optional if battle not yet concluded
  })

;; Mapping of player addresses to player index in the players map
(define-map player-info 
  { player-address: principal } 
  { player-index: uint })

;; Mapping of player addresses to player token index in the game-tokens map
(define-map player-token-info 
  { player-address: principal } 
  { token-index: uint })

;; Mapping of battle name to battle index in the battles map
(define-map battle-info 
  { battle-name: (string-ascii 64) } 
  { battle-index: uint })

;; Counter to keep track of the number of players, game tokens, and battles
(define-data-var player-counter uint u0)
(define-data-var game-token-counter uint u0)
(define-data-var battle-counter uint u0)
