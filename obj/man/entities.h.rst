ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180 / ZX-Next / eZ80), page 1.
Hexadecimal [16-Bits]



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
                     0001    13 e_color_default = e_type_star
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
