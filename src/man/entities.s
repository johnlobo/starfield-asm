.include "cpctelera.h.s"
.include "entities.h.s"

;;
;; Entity storage
;;
entities::
entities_1st_free:  .dw entities_storage
entities_storage:   .ds max_entities * sizeof_e

;;
;; Initialize entity manager
;;
man_entity_init::
    ;; 1st free entity at the start of entities storage
    ld hl, #entities_storage
    ld (entities_1st_free), hl
    ;; 1st free entity with a 0 as first byte (no-entity)
    ld (hl), #0
    ret

;; CREATE A NEW ENTITY
;;  Returns: DE = New entity pointer
;;
;;
man_entity_create::
    ld hl, (entities_1st_free)  ;; HL Points to first free entity
    ld d, h
    ld e, l                     ;; DE copy of HL

    ;; Fill the entity
    ld (hl), #e_type_default    ;; Test alive entity

    ;; Update entities_1st_free to next location
    ld bc, #sizeof_e
    add hl, bc
    ld (entities_1st_free), hl

    ret

;;
;; SET an entity for destruction
;;  Marks an entity for later destruction
;; Input:
;;  IX: Points to Entity to be destroyed
;;
man_entity_set4destruction::
    ld a, e_type(ix)
    or #e_type_dead      ;; Add dead bit
    ld e_type(ix), a    ;; and store
    ret

;;
;; DESTROY an entity
;;  Note: Does nt check anything
;; Input:
;;  IX: Points to entity to be removed
;;
man_entity_destroy::
    ;;Update entitues 1st free to prev location
    ld hl, (entities_1st_free)
    ld bc, #-sizeof_e
    add hl, bc
    ld (entities_1st_free), hl
    ;; Check against IX (if they are equal, no copy)
    ld__a_ixl
    sub l
    jr nz, _copy
    ld__a_ixh
    sub h
    jr z, _nocopy
_copy:
    ;; Copy last entity in the array to remove entity
    ld__e_ixl
    ld__d_ixh
    ld bc, #sizeof_e
    ldir
_nocopy:
    ;; Remove las entity from the array, but setting
    ld hl, (entities_1st_free)
    ld (hl), #0
    ret

;;
;; CALL a function for all entities
;; Input:
;;  HL: Pointer to the function to be called
;;      Important: Function at HL must preserve IX
;;
man_entity_forall::
    ld (_to_call), hl       ;; Set function to be called
    ld ix, #entities_storage
    ;; check if entity is valid... 1st byte is 0 => not a valid entry
_next_entity:
    ld a, (ix)
    or a
    ret z
    ;; Entity is valid => call the function
_to_call = .+1
    call _to_call
    ;; Point to the next entity and repeat
    ld bc, #sizeof_e
    add ix, bc
    call _next_entity

;;
;; UPDATE ENTITY MANAGER
;;  updates the manager removing entities marked for destruction
;;
man_entity_update::
    ld ix, #entities_storage
    jr _nexte
_destroy_e:
    call man_entity_destroy
_nexte:
    ;; Check entity type
    ld a, e_type(ix)
    or a
    ret z
    ;; if it is dead, destroy de entity
    and #e_type_dead
    jr nz, _destroy_e
_dont_delete_e:
    ld bc, #sizeof_e
    add ix, bc
    jr _nexte


