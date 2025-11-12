-----Keyboard Loop-----------------------------------

$5000:

jsr 5080
lda #00
ldx #20
pha
dex
sta d400,x
bne (fa)
lda 25
sta d404
lda 26
sta d405
lda 27
sta d406
lda 28
sta d418
jsr ffe4
beq (26)
cmp #03
beq (35)
tax
lda 5100
sta 2a
lda 5100,x
sta 30
ldy #00
lda (29),y
sta d400
iny
lda (29),y
sta d401
pla
lda #10
clc
adc a2
pha
jmp 5022
pla
cmp a2
bne (0a)
tax
lda #00
sta d400
sta d401
txa
pha
jmp 5022
pla
lda #00
sta d400
sta d401
sta d404
rts

-----Octave Writer-----------------------------------

$5080:

ldx #18
lda 5100
sta 508e
dex
lda 50e0,x
sta 5200,x
cpx #00
bne (f5)
ldx #07
lda #18
sta 30
lda #00
sta 2b
lda 5100
sta 2a
sta 2c
ldy #00
lda #00
sta 2d
lda (2b),y
asl
bcc (02)
inc 2d
sta (29),y
iny
lda (2b),y
asl
ora 2d
sta (29),y
iny
cpy #18
bne (e6)
lda 29
clc
adc #18
sta 29
lda 2b
clc
adc #18
sta 2b
dex
bne (d3)
txa
tay
lda #00
sta (29),y
inc 29
sta (29),y
rts

-----Octave 0-----------------------------------

$50e0:

:50e0 0c 01 1c 01 2d 01 3e 01
:50e8 51 01 66 01 7b 01 91 01
:50f0 a9 01 c3 01 dd 01 fa 01

-----Key Mapping-----------------------------------

$5100:

:5100 52 c0 c0 c0 c0 c0 c0 c0
:5108 c0 c0 c0 c0 c0 c0 c0 c0
:5110 c0 c0 c0 c0 c0 c0 c0 c0
:5118 c0 c0 c0 c0 c0 c0 c0 c0
:5120 c0 c0 c0 c0 c0 c0 c0 c0
:5128 c0 c0 c0 c0 c0 c0 c0 c0
:5130 7e c0 62 66 c0 6c 70 74
:5138 c0 7a c0 c0 c0 c0 c0 c0
:5140 c0 c0 c0 c0 c0 68 c0 c0
:5148 c0 78 c0 c0 c0 c0 c0 7c
:5150 80 60 6a c0 6e 76 c0 64
:5158 c0 72 c0 c0 c0 c0 c0 c0
:5160 c0 c0 c0 c0 c0 c0 c0 c0

-----------------------------------End-----