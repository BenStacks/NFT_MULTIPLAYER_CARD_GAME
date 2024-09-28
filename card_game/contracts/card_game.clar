;; Constants
(define-constant MAX_ATTACK_DEFEND_STRENGTH u10)
(define-constant DEVIL u0)
(define-constant GRIFFIN u1)
(define-constant FIREBIRD u2)
(define-constant KAMO u3)
(define-constant KUKULKAN u4)
(define-constant CELESTION u5)

;; Data Variables
(define-data-var base-uri (string-ascii 256) "")
(define-data-var total-supply uint u0)

(define-constant BATTLE_STATUS_PENDING u0)
(define-constant BATTLE_STATUS_STARTED u1)
(define-constant BATTLE_STATUS_ENDED u2)

;; Data Maps and Variables
(define-map player-info principal uint)
(define-map player-token-info principal uint)
(define-map battle-info (string-ascii 256) uint)

;; Define structures
(define-map players uint 
  {
    player-address: principal,
    player-name: (string-ascii 256),
    player-mana: uint,
    player-health: uint,
    in-battle: bool
  }
)

(define-map game-tokens uint 
  {
    name: (string-ascii 256),
    id: uint,
    attack-strength: uint,
    defense-strength: uint
  }
)

(define-map battles uint 
  {
    battle-status: uint,
    battle-hash: (buff 32),
    name: (string-ascii 256),
    players: (list 2 principal),
    moves: (list 2 uint),
    winner: (optional principal)
  }
)

(define-data-var players-count uint u0)
(define-data-var game-tokens-count uint u0)
(define-data-var battles-count uint u0)


(define-private (generate-sequence-iter (acc (list 200 uint)) (i uint))
  (let ((current (+ u1 (len acc))))
    (if (> current i)
      acc
      (unwrap-panic (as-max-len? (append acc current) u200))
    )
  )
)

(define-private (get-player-if-exists (result (list 200 {player-address: principal, player-name: (string-ascii 256), player-mana: uint, player-health: uint, in-battle: bool})) (index uint))
  (match (map-get? players index)
    player (unwrap! (as-max-len? (append result player) u200) result)
    result
  )
)



;; Player  check and getter functions
(define-read-only (is-player (address principal))
  (is-some (map-get? player-info address))
)

(define-read-only (get-player (address principal))
  (match (map-get? player-info address)
    player-index (ok (unwrap! (map-get? players player-index) (err u404)))
    (err u404)
  )
)


;; Player token check and  getter functions
(define-read-only (is-player-token (address principal))
  (is-some (map-get? player-token-info address))
)


(define-read-only (get-player-token (address principal))
  (match (map-get? player-token-info address)
    player-token-index (ok (unwrap! (map-get? game-tokens player-token-index) (err u404)))
    (err u404)
  )
)


;; Battle getter functions
(define-read-only (is-battle (name (string-ascii 256)))
  (is-some (map-get? battle-info name))
)

(define-read-only (get-battle (name (string-ascii 256)))
  (match (map-get? battle-info name)
    battle-index (ok (unwrap! (map-get? battles battle-index) (err u404)))
    (err u404)
  )
)

;; updating a battle
(define-public (update-battle (name (string-ascii 256)) (new-battle {
    battle-status: uint,
    battle-hash: (buff 32),
    name: (string-ascii 256),
    players: (list 2 principal),
    moves: (list 2 uint),
    winner: (optional principal)
  }))
  (match (map-get? battle-info name)
    battle-index (begin
      (map-set battles battle-index new-battle)
      (ok true))
    (err u404)
  )
)

;; Function to get all players
(define-read-only (get-all-players)
  (let ((player-count (var-get players-count)))
    (fold get-player-fold (list u0 u1 u2 u3 u4 u5 u6 u7 u8 u9) (list ))
  )
)

;; Fold function to accumulate players
(define-private (get-player-fold (index uint) (acc (list 10 {
    player-address: principal,
    player-name: (string-ascii 256),
    player-mana: uint,
    player-health: uint,
    in-battle: bool
  })))
  (match (map-get? players index)
    player (unwrap-panic (as-max-len? (append acc player) u10))
    acc
  )
)

;; Function to get all battles
(define-read-only (get-all-battles)
  (let ((battle-count (var-get battles-count)))
    (fold get-battle-fold (list u0 u1 u2 u3 u4 u5 u6 u7 u8 u9) (list ))
  )
)

;; Fold function to accumulate battles
(define-private (get-battle-fold (index uint) (acc (list 10 {
    battle-status: uint,
    battle-hash: (buff 32),
    name: (string-ascii 256),
    players: (list 2 principal),
    moves: (list 2 uint),
    winner: (optional principal)
  })))
  (match (map-get? battles index)
    battle (unwrap-panic (as-max-len? (append acc battle) u10))
    acc
  )
)

;; Function to get all player tokens
(define-read-only (get-all-player-tokens)
  (let ((token-count (var-get game-tokens-count)))
    (fold get-token-fold (list u0 u1 u2 u3 u4 u5 u6 u7 u8 u9) (list ))
  )
)


;; Fold function to accumulate player tokens
(define-private (get-token-fold (index uint) (acc (list 10 {
    name: (string-ascii 256),
    id: uint,
    attack-strength: uint,
    defense-strength: uint
  })))
  (match (map-get? game-tokens index)
    token (unwrap-panic (as-max-len? (append acc token) u10))
    acc
  )
)

;; Add player function
(define-public (add-player 
  (player-address principal) 
  (player-name (string-ascii 256)) 
  (player-mana uint) 
  (player-health uint))
  (begin
  
    (if (is-some (map-get? player-info player-address))

      ;; If player exists, return an error
      (err u400) 

      ;; Else proceed to add the player
      (let 
        (
          ;; Get the current player count (this will be the index of the new player)
          (new-player-index (var-get players-count))
        )
        ;; Update the `players` map with new player details
        (map-set players new-player-index 
          {
            player-address: player-address,
            player-name: player-name,
            player-mana: player-mana,
            player-health: player-health,
            in-battle: false 
          }
        )
        ;; Update the `player-info` map to link player address to player index (just the index)
        (map-set player-info player-address new-player-index)
        
        (var-set players-count (+ new-player-index u1))

        (ok true)
      )
    )
  )
)

(define-public (create-battle (battle-name (string-ascii 256)) (player1 principal) (player2 principal))
  (begin
    ;; Check if both players exist in the player-info map
    (if (and (is-some (map-get? player-info player1)) (is-some (map-get? player-info player2)))
      (let (
            ;; Retrieve the current battle count for the new battle index
            (new-battle-index (var-get battles-count))
            (battle-hash (keccak256 (len battle-name)))


            ;; Define the initial battle structure
            (new-battle {
              battle-status: BATTLE_STATUS_PENDING,
              battle-hash: battle-hash,
              name: battle-name,
              players: (list player1 player2),
              moves: (list u0 u0), ;; No moves have been made yet
              winner: none
            })
          )

        (map-set battles new-battle-index new-battle)

        ;; Store the battle info (maps the battle name to the battle index)
        (map-set battle-info battle-name new-battle-index)

        (var-set battles-count (+ new-battle-index u1))
        (ok new-battle-index)
      )
      (err u404)
    )
  )
)

(define-public (mint-token (player principal) (token-name (string-ascii 256)) (attack-strength uint) (defense-strength uint))
  (begin
    (if (is-some (map-get? player-info player))
      (let (
            ;; Retrieve the current game tokens count to generate a unique token ID
            (new-token-index (var-get game-tokens-count))

            (new-token {
              name: token-name,
              id: new-token-index,
              attack-strength: attack-strength,
              defense-strength: defense-strength
            })
          )
          
        ;; Insert the new token into the game tokens map
        (map-set game-tokens new-token-index new-token)

        ;; Increment the game tokens count for future tokens
        (var-set game-tokens-count (+ new-token-index u1))

        ;; Associate the newly minted token with the player
        (map-set player-token-info player new-token-index)

        (ok new-token-index)
      )
      (err u404)
    )
  )
)



