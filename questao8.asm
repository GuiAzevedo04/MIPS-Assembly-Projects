# Title: Questão 8
# Description: 8- Dados números reais a, b e c, calcular as raízes de uma equação do segundo grau da forma ax2 + bx + c = 0. Apresente a saída das raízes de forma apropriada.
# Input: Valores dos coeficientes a, b e c
# Output: Raizes reais, caso existam

################################## Data segment ######################################
.data
    msgPromptA:             .asciiz "Digite o coeficiente a: "
    msgPromptB:             .asciiz "Digite o coeficiente b: "
    msgPromptC:             .asciiz "Digite o coeficiente c: "
    msgDeltaMenorQueZero:   .asciiz "Não existem raízes reais.\n"
    msgRaiz1:               .asciiz "Raiz 1: "
    msgRaiz2:               .asciiz "\nRaiz 2: "
    
    zeroF:        .float  0.0
    quatroDelta:  .float  4.0
    doisDelta:    .float  2.0
    menosUmDelta: .float -1.0

################################## Code segment ######################################
.text
.globl main

main:
    # Prompt e leitura de a
    li $v0, 4
    la $a0, msgPromptA
    syscall

    li $v0, 6  # Leitura de float
    syscall
    mov.s $f12, $f0

    # Prompt e leitura de b
    li $v0, 4
    la $a0, msgPromptB
    syscall

    li $v0, 6
    syscall
    mov.s $f13, $f0

    # Prompt e leitura de c
    li $v0, 4
    la $a0, msgPromptC
    syscall

    li $v0, 6
    syscall
    mov.s $f14, $f0

    # Calcular delta
    mul.s $f15, $f12, $f14   # a * c
    l.s $f16, quatroDelta    # 4.0
    mul.s $f15, $f15, $f16   # 4ac
    mul.s $f17, $f13, $f13   # b²
    sub.s $f17, $f17, $f15   # b² - 4ac (delta)

    # Verifica o delta
    l.s $f18, zeroF
    c.lt.s $f17, $f18        # compara delta com 0
    bc1t deltaMenorQueZero   # se delta < 0, raízes complexas

    # Raízes reais
    sqrt.s $f17, $f17        # √delta
    l.s $f18, menosUmDelta   # -1.0
    mul.s $f19, $f13, $f18   # -b
    l.s $f20, doisDelta      # 2.0
    mul.s $f21, $f12, $f20   # 2a

    # Calcula primeira raiz
    add.s $f22, $f19, $f17   # -b + √delta
    div.s $f22, $f22, $f21   # dividido por 2a

    # Calcula segunda raiz
    sub.s $f23, $f19, $f17   # -b - √delta
    div.s $f23, $f23, $f21   # dividido por 2a

    # Imprimir raízes
    li $v0, 4
    la $a0, msgRaiz1
    syscall

    li $v0, 2 
    mov.s $f12, $f22
    syscall

    li $v0, 4
    la $a0, msgRaiz2
    syscall

    li $v0, 2
    mov.s $f12, $f23
    syscall

    li $v0, 10  
    syscall

deltaMenorQueZero:
    li $v0, 4
    la $a0, msgDeltaMenorQueZero
    syscall 
