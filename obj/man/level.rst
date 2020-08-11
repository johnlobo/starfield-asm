ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180 / ZX-Next / eZ80), page 1.
Hexadecimal [16-Bits]



                              1 .include "level.h.s"
                              1 .globl man_level_init
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180 / ZX-Next / eZ80), page 2.
Hexadecimal [16-Bits]



                              2 .include "entities.h.s"
                              1 .globl man_entity_init
                              2 .globl man_entity_create
                              3 .globl man_entity_set4destruction
                              4 .globl man_entity_forall
                              5 .globl man_entity_update
                              6 
                     000A     7 max_entities = 10
                              8 
                     0000     9 e_type_default = 0x00
                     0080    10 e_type_dead = 0x80
                     0001    11 e_type_star = 0x01
                             12 
                     0001    13 e_color_default = 0x01
                             14 
                     0000    15 e_type = 0 
                     0001    16 e_x = 1
                     0002    17 e_y = 2
                     0003    18 e_vx = 3
                     0004    19 e_vy = 4
                     0005    20 e_color = 5
                     0006    21 e_prevptr = 6
                             22 
                     0008    23 sizeof_e = 8
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180 / ZX-Next / eZ80), page 3.
Hexadecimal [16-Bits]



                              3 
                              4 ;;=================================================================================
                              5 ;; DefineLevel Macro
                              6 ;;
                              7 .macro DefineLevel _level 
                              8     _level':
                              9 .endm
                             10 
                             11 ;;=================================================================================
                             12 ;; EndLevel Macro
                             13 ;;
                             14 .macro EndLevel _level
                             15     _level'_end:
                             16 .endm
                             17 
                             18 ;;=================================================================================
                             19 ;; DefEnt Macro
                             20 ;;
                             21 .macro DefEnt _X, _Y, _VX
                             22     .db _X', _Y', _VX
                             23 .endm
                             24 
                             25 
                             26 
                             27 ;;
                             28 ;; Level Definitions
                             29 ;;
   012F                      30 DefineLevel level_1
   0000                       1     level_1:
   0000                      31 DefEnt 79, 10, -1
   012F 4F 0A FF              1     .db 79, 10, -1
   0003                      32 DefEnt 79, 30, -1
   0132 4F 1E FF              1     .db 79, 30, -1
   0006                      33 DefEnt 79, 50, -1
   0135 4F 32 FF              1     .db 79, 50, -1
   0009                      34 DefEnt 79, 70, -1
   0138 4F 46 FF              1     .db 79, 70, -1
   000C                      35 DefEnt 79, 90, -1
   013B 4F 5A FF              1     .db 79, 90, -1
   013E                      36 EndLevel level_1
   013E                       1     level_1_end:
                             37 
   000F                      38 DefineLevel level_2
   000F                       1     level_2:
   000F                      39 DefEnt 79, 20, -1
   013E 4F 14 FF              1     .db 79, 20, -1
   0012                      40 DefEnt 79, 40, -2
   0141 4F 28 FE              1     .db 79, 40, -2
   0015                      41 DefEnt 79, 60, -2
   0144 4F 3C FE              1     .db 79, 60, -2
   0018                      42 DefEnt 79, 80, -3
   0147 4F 50 FD              1     .db 79, 80, -3
   001B                      43 DefEnt 79, 100, -4
   014A 4F 64 FC              1     .db 79, 100, -4
   001E                      44 DefEnt 79, 120, -3
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180 / ZX-Next / eZ80), page 4.
Hexadecimal [16-Bits]



   014D 4F 78 FD              1     .db 79, 120, -3
   0021                      45 DefEnt 79, 140, -2
   0150 4F 8C FE              1     .db 79, 140, -2
   0024                      46 DefEnt 79, 160, -2
   0153 4F A0 FE              1     .db 79, 160, -2
   0027                      47 DefEnt 79, 180, -1
   0156 4F B4 FF              1     .db 79, 180, -1
   0159                      48 EndLevel level_2
   0159                       1     level_2_end:
                             49 
                             50 ;;
                             51 ;; Initialize a level
                             52 ;; A = level to initialize
                             53 ;;
   002A                      54 man_level_init::
   0159 CD BB 00      [17]   55     call man_entity_init
   015C 3D            [ 4]   56     dec a
   015D 28 08         [12]   57     jr z, _init_level_1
   015F                      58 _init_level_2:
   015F 21 3E 01      [10]   59     ld hl, #level_2
   0162 11 59 01      [10]   60     ld de, #level_2_end
   0165 18 06         [12]   61     jr _init_level
   0167                      62 _init_level_1:
   0167 21 2F 01      [10]   63     ld hl, #level_1
   016A 11 3E 01      [10]   64     ld de, #level_1_end
   016D                      65 _init_level:
                             66     ;; Setup ending-pointer values
   016D 7B            [ 4]   67     ld a, e
   016E 32 77 01      [13]   68     ld (__end_l), a
   0171 7A            [ 4]   69     ld a, d
   0172 32 7C 01      [13]   70     ld (__end_h), a
   0175                      71 _next_entity:
                             72     ;; Check end of initizalization
   0175 7D            [ 4]   73     ld a, l
                     0048    74 __end_l = .+1
   0176 D6 00         [ 7]   75     sub #00
   0178 20 04         [12]   76     jr nz, _continue
   017A 7C            [ 4]   77     ld a, h
                     004D    78 __end_h = .+1
   017B D6 00         [ 7]   79     sub #00
   017D C8            [11]   80     ret z
   017E                      81 _continue:
                             82     ;; Create next entity and fill in values
   017E E5            [11]   83     push hl
   017F CD C4 00      [17]   84     call man_entity_create
   0182 E1            [10]   85     pop hl
                             86     ;; Copy values to new entity
   0183 01 08 00      [10]   87     ld bc, #sizeof_e
   0186 ED B0         [21]   88     ldir
                             89 
   0188 18 EB         [12]   90     jr _next_entity
                             91 
