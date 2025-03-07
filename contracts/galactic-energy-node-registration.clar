;; Galactic Energy Node Registration Contract

(define-map energy-nodes
  { id: uint }
  {
    owner: principal,
    location: (string-utf8 64),
    capacity: uint,
    active: bool
  }
)

(define-data-var next-node-id uint u0)

(define-public (register-node (location (string-utf8 64)) (capacity uint))
  (let
    ((new-id (var-get next-node-id)))
    (var-set next-node-id (+ new-id u1))
    (ok (map-set energy-nodes
      { id: new-id }
      {
        owner: tx-sender,
        location: location,
        capacity: capacity,
        active: true
      }
    ))
  )
)

(define-public (update-node-status (node-id uint) (active bool))
  (match (map-get? energy-nodes { id: node-id })
    node
      (begin
        (asserts! (is-eq tx-sender (get owner node)) (err u403))
        (ok (map-set energy-nodes
          { id: node-id }
          (merge node { active: active })
        )))
    (err u404)
  )
)

(define-read-only (get-node (node-id uint))
  (map-get? energy-nodes { id: node-id })
)

