;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
;;  Copyright (C) 2018 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU Lesser General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU Lesser General Public License for more details.
;;
;;  You should have received a copy of the GNU Lesser General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------

;; Include all CPCtelera constant definitions, macros and variables
.include "cpctelera.h.s"
.include "man/entities.h.s"
.include "man/level.h.s"
.include "sys/physics.h.s"
.include "sys/render.h.s"
.include "sys/generator.h.s"
.include "cpct_functions.h.s"

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA
.area _CODE

;;
;; Making system calls clearer
;;
.macro SysUpdate sysname
   ld hl, #sys_'sysname'_update
   call man_entity_forall
.endm

;;
;; Simple Starfield
;;
starfield:
   ;; INIT MANAGER AND RENDER
   ld a, #2
   call man_level_init
   call sys_render_init

;;
;; MAIN LOOP
;;
_st_loop:
   ;;Update Systems
   SysUpdate generator
   SysUpdate physics
   SysUpdate render
   ;; Update Entity Manager
   call man_entity_update
   ;; Wait VSYNC and repeat
   call cpct_waitVSYNC_asm
   jr _st_loop

;;
;; MAIN function. This is the entry point of the application.
;;    _main:: global symbol is required for correctly compiling and linking
;;
_main::
   ;; Disable firmware to prevent it from interfering with string drawing
   call cpct_disableFirmware_asm
   jr starfield
   

   ;; Loop forever
loop:
   jr    loop