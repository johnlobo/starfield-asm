.globl man_entity_init
.globl man_entity_create
.globl man_entity_set4destruction
.globl man_entity_forall
.globl man_entity_update

max_entities = 10

e_type_default = 0x00
e_type_dead = 0x80
e_type_star = 0x01

e_color_default = e_type_star

e_type = 0 
e_x = 1
e_y = 2
e_vx = 3
e_vy = 4
e_color = 5
e_prevptr = 6

sizeof_e = 8
