;; Interstellar Power Routing Contract

(define-map power-routes
  { id: uint }
  {
    source-node: uint,
    destination-node: uint,
    capacity: uint,
    efficiency: uint
  }
)

(define-map power-transfers
  { id: uint }
  {
    route-id: uint,
    amount: uint,
    timestamp: uint
  }
)

(define-data-var next-route-id uint u0)
(define-data-var next-transfer-id uint u0)

(define-public (create-route (source-node uint) (destination-node uint) (capacity uint) (efficiency uint))
  (let
    ((new-id (var-get next-route-id)))
    (var-set next-route-id (+ new-id u1))
    (ok (map-set power-routes
      { id: new-id }
      {
        source-node: source-node,
        destination-node: destination-node,
        capacity: capacity,
        efficiency: efficiency
      }
    ))
  )
)

(define-public (transfer-power (route-id uint) (amount uint))
  (match (map-get? power-routes { id: route-id })
    route
      (let
        ((new-id (var-get next-transfer-id)))
        (asserts! (<= amount (get capacity route)) (err u400))
        (var-set next-transfer-id (+ new-id u1))
        (ok (map-set power-transfers
          { id: new-id }
          {
            route-id: route-id,
            amount: amount,
            timestamp: block-height
          }
        )))
    (err u404)
  )
)

(define-read-only (get-route (route-id uint))
  (map-get? power-routes { id: route-id })
)

(define-read-only (get-transfer (transfer-id uint))
  (map-get? power-transfers { id: transfer-id })
)

