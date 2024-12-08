# Title: Questão 8
# Description: 8- Dados números reais a, b e c, calcular as raízes de uma equação do segundo grau da forma ax2 + bx + c = 0. Apresente a saída das raízes de forma apropriada.
# Input: Valores dos coeficientes a, b e c
# Output: Raizes reais, caso existam

################################## Data segment ######################################
.data
    mensagemEntradaA:             	.asciiz "Digite o coeficiente a: "
    mensagemEntradaB:             	.asciiz "Digite o coeficiente b: "
    mensagemEntradaC:             	.asciiz "Digite o coeficiente c: "
    mensagemRaizDeltaMenorQueZero:   	.asciiz "Não existem raízes reais.\n"
    mensagemRaizRaiz1:               	.asciiz "Raiz 1: "
    mensagemRaizRaiz2:               	.asciiz "\nRaiz 2: "
    
    zeroF:        .float  0.0
    quatroDelta:  .float  4.0
    doisDelta:    .float  2.0
    menosUmDelta: .float -1.0

################################## Code segment ######################################
.text
.globl main

main:
    # Leitura de a, mrmazenando em $f1
    li $v0, 4
    la $a0, mensagemEntradaA
    syscall

    li $v0, 6
    syscall
    mov.s $f1, $f0

    # Leitura de b, armazenando em $f2
    li $v0, 4
    la $a0, mensagemEntradaB
    syscall

    li $v0, 6
    syscall
    mov.s $f2, $f0

    # Leitura de c, armazenando em $f3
    li $v0, 4
    la $a0, mensagemEntradaC
    syscall

    li $v0, 6
    syscall
    mov.s $f3, $f0

    # Calcular delta
    mul.s $f4, $f1, $f3       # a * c
    l.s $f5, quatroDelta      # 4.0
    mul.s $f4, $f4, $f5       # 4ac
    mul.s $f6, $f2, $f2       # b^2
    sub.s $f6, $f6, $f4       # b^2 - 4ac (delta)

    # Verifica o delta
    l.s $f7, zeroF
    c.lt.s $f6, $f7           # compara delta com 0
    bc1t deltaMenorQueZero    # se delta < 0, não possui raizes reais

    # Raízes reais
    sqrt.s $f6, $f6           # raiz de delta
    l.s $f7, menosUmDelta     # -1.0
    mul.s $f8, $f2, $f7       # -b
    l.s $f9, doisDelta        # 2.0
    mul.s $f10, $f1, $f9      # 2a

    # Calcula primeira raiz
    add.s $f11, $f8, $f6      # -b + raiz de delta
    div.s $f11, $f11, $f10    # dividido por 2a

    # Calcula segunda raiz
    sub.s $f12, $f8, $f6      # -b - raiz de delta
    div.s $f12, $f12, $f10    # dividido por 2a

    # Imprimir raízes
    li $v0, 4
    la $a0, mensagemRaizRaiz1
    syscall

    li $v0, 2 
    mov.s $f0, $f11
    syscall

    li $v0, 4
    la $a0, mensagemRaizRaiz2
    syscall

    li $v0, 2
    mov.s $f0, $f12
    syscall

    li $v0, 10  
    syscall

deltaMenorQueZero:
    li $v0, 4
    la $a0, mensagemRaizDeltaMenorQueZero
    syscall 
