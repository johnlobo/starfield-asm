.include "level.h.s"
.include "entities.h.s"

;;=================================================================================
;; DefineLevel Macro
;;
.macro DefineLevel _level 
    _level'::
.endm

;;=================================================================================
;; EndLevel Macro
;;
.macro EndLevel _level
    _level'_end::
.endm

;;=================================================================================
;; DefEnt Macro
;;
.macro DefEnt _X, _Y, _VX
    .db e_type_star, _X', _Y', _VX, e_color_default, 0x00, 0x00
.endm



;;
;; Level Definitions
;;
DefineLevel level_1
DefEnt 79, 10, -1
DefEnt 79, 30, -1
DefEnt 79, 50, -1
DefEnt 79, 70, -1
DefEnt 79, 90, -1
EndLevel level_1

DefineLevel level_2
DefEnt 79, 20, -4
DefEnt 79, 40, -2
DefEnt 79, 60, -2
DefEnt 79, 80, -3
DefEnt 79, 100, -4
DefEnt 79, 120, -3
DefEnt 79, 140, -2
DefEnt 79, 160, -2
DefEnt 79, 180, -1
EndLevel level_2

;;
;; Initialize a level
;; A = level to initialize
;;
man_level_init::
    call man_entity_init
    dec a
    jr z, _init_level_1
_init_level_2:
    ld hl, #level_2
    ld de, #level_2_end
    jr _init_level
_init_level_1:
    ld hl, #level_1
    ld de, #level_1_end
_init_level:
    ;; Setup ending-pointer values
    ld a, e
    ld (__end_l), a
    ld a, d
    ld (__end_h), a
_next_entity:
    ;; Check end of initizalization
    ld a, l
__end_l = .+1
    sub #00
    jr nz, _continue
    ld a, h
__end_h = .+1
    sub #00
    ret z
_continue:
    ;; Create next entity and fill in values
    push hl
    call man_entity_create
    pop hl
    ;; Copy values to new entity
    ld bc, #sizeof_e
    ldir

    jr _next_entity

