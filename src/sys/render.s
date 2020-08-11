.include "cpct_functions.h.s"
.include "cpctelera.h.s"
.include "man/entities.h.s"

palette:
.db HW_BLACK        , HW_BRIGHT_YELLOW  , HW_BRIGHT_YELLOW  , HW_BRIGHT_YELLOW
.db HW_BRIGHT_WHITE , HW_BRIGHT_WHITE   , HW_BRIGHT_WHITE   , HW_BRIGHT_WHITE
.db HW_BRIGHT_WHITE , HW_BRIGHT_WHITE   , HW_BRIGHT_WHITE   , HW_BRIGHT_WHITE
.db HW_BRIGHT_WHITE , HW_BRIGHT_WHITE   , HW_BRIGHT_WHITE   , HW_BRIGHT_WHITE

;;
;; INIT 
;;  Initialize video mode
;;
sys_render_init::
    ld c,#0
    call cpct_setVideoMode_asm
    ld hl, #palette
    ld de, #16
    call cpct_setPalette_asm
    cpctm_setBorder_asm HW_BLACK
    ret

;;
;; UPDATE
;;  Renders an entity
;; Input
;;  IX: Entity to be rendered
;;
sys_render_update::
    ;; HL = Pointer to previous render location
    ld e, e_prevptr(ix)
    ld d, e_prevptr+1(ix)
    ex de, hl
    ;; Check previous render location (nullptr = no previous render location)
    ld a, l
    or h
    jr z, _do_not_erase
_erase_prev:
    ld (hl),#0
_do_not_erase:
    ;; Check entity alive before drawing
    ld a, e_type(ix)
    and #e_type_dead
    ret nz

;; Calculate new location
    ld de, #0xc000
    ld c, e_x(ix)
    ld b, e_y(ix)
    call cpct_getScreenPtr_asm

;; Draw pixel
    ld a, e_color(ix)
    ld (hl), a

;; Save new location to previous (for later erasing)
    ex de, hl
    ld e_prevptr(ix), e
    ld e_prevptr+1(ix), d
    ret