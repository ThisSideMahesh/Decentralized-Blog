;; Decentralized Blog
;; A minimal blog platform on Stacks blockchain

(define-map blog-posts
  uint ;; post ID
  {
    author: principal,
    title: (string-ascii 100),
    content: (string-ascii 500)
  }
)

(define-data-var post-counter uint u0)

;; Function 1: Add a blog post
(define-public (add-post (title (string-ascii 100)) (content (string-ascii 500)))
  (begin
    (asserts! (> (len title) u0) (err u100)) ;; title must not be empty
    (asserts! (> (len content) u0) (err u101)) ;; content must not be empty
    (let ((new-id (+ (var-get post-counter) u1)))
      (map-set blog-posts new-id {
        author: tx-sender,
        title: title,
        content: content
      })
      (var-set post-counter new-id)
      (ok new-id)
    )
  )
)

;; Function 2: Get a blog post by ID
(define-read-only (get-post (id uint))
  (ok (map-get? blog-posts id))
)
