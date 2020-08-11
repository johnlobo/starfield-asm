.include "generator.h.s"
.include "cpctelera.h.s"
.include "cpct_functions.h.s"
.include "man/entities.h.s"

counter: .db 0

;;
;;  When first called, takes address of first entity 
;;
p_getFirstEntityPointer:
    ld__a_ixl
    ld (__firste_l), a
    ld__a_ixh
    ld (__firste_h),a
    ld hl, #counter
    ld (hl), #1
    ld hl, #p_countEntities
    ld (sys_generator_update+1), hl
    ret

;;
;; Counts Entities
;;
p_countEntities:
    ld hl, #counter

    ;; Check if this is the first entity
    ld__a_ixl
    __firste_l = .+1
    sub #00
    jr nz, _pce_not_first
    ld__a_ixh
    __firste_h = .+1
    sub #00
    jr z, _pce_first
_pce_not_first:
    inc(hl)
    ret
_pce_first:
;; Check if there is less than constant_stars value
    ld a, #constant_stars
    sub (hl)
    ld (hl), #1
    ret z ;; Maximun number of stars complete
    ret c
_pce_create_stars:
;; Save IX will be modifying it
    push IX
    ;; set new stars to be created (up to three)
    cp #3
    jr c, _pce_star_n_ok
    ld a, #3
_pce_star_n_ok:
    ld (__star_cnt), a

_pce_create_next_star:
;; Create new stars
    call man_entity_create
    ld__ixl_e ;; IX = DE (Entity created)
    ld__ixh_d
    ;; Set default values
    ld e_type(ix), #e_type_star
    ld e_x(ix), #79
    ld e_color(ix), #e_color_default
    ld e_prevptr(ix), #0x00
    ld e_prevptr+1(ix), #0x00
    ;; Set random y (0..199)

_pce_invalid_y:
    call cpct_getRandom_xsp40_u8_asm
    cp #199
    jr nc, _pce_invalid_y
    ld e_y(ix), a

    ;; Set random vx (-1..-4)
    call cpct_getRandom_xsp40_u8_asm
    and #0x03
    neg
    ld e_vx(ix), a

    ;; Counter stars to be created
    __star_cnt = . + 1
    ld a, #3
    dec a
    jr z, _pce_return
    ld (__star_cnt), a
    jr _pce_create_next_star
_pce_return:
    pop ix
    ret

;;
;; UPDATE
;;  Generates new stars whenever required
;; Input
;;  IX : Particle (entity)
sys_generator_update::
    jp p_getFirstEntityPointer  ;; Jumps to current
