.include "physics.h.s"
.include "man/entities.h.s"

;;
;; UPDATE
;;  Moves every physics particle
;; Input:
;;  IX: Particle (entity) to move
sys_physics_update::
    ;; Move and check
    ;; X is valid unless adition generates carry: below
    ld a, e_x(ix)
    ld b, a
    add e_vx(ix)
    ld e_x(ix), a
    sub b
    ret c   ;; Carry = XPrev > XNew = Valid X
_invalid_x:
    jp man_entity_set4destruction
    ;; ret