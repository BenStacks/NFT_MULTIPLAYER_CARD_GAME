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

;; Enums (represented as constants in Clarity)
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

;; Read-only Functions
(define-read-only (is-player (address principal))
  (is-some (map-get? player-info address))
)

;; Read-only Functions
(define-read-only (is-player-token (address principal))
  (is-some (map-get? player-token-info address))
)


(define-read-only (get-player (address principal))
  (match (map-get? player-info address)
    player-index (ok (unwrap! (map-get? players player-index) (err u404)))
    (err u404)
  )
)

(define-read-only (get-player-token (address principal))
  (match (map-get? player-token-info address)
    player-token-index (ok (unwrap! (map-get? game-tokens player-token-index) (err u404)))
    (err u404)
  )
)


