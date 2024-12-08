################################## Data segment ######################################
.data
    mensagemEntradaA:             	    .asciiz "Digite o coeficiente a: "
    mensagemEntradaB:             	    .asciiz "Digite o coeficiente b: "
    mensagemEntradaC:             	    .asciiz "Digite o coeficiente c: "
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
    # Leitura de a, armazenado em $f2
    li $v0, 4
    la $a0, mensagemEntradaA
    syscall
    
    li $v0, 6
    syscall
    mov.s $f2, $f0
    
    # Leitura de b, armazenando em $f3
    li $v0, 4
    la $a0, mensagemEntradaB
    syscall
    
    li $v0, 6
    syscall
    mov.s $f3, $f0
    
    # Leitura de c, armazenando em $f4
    li $v0, 4
    la $a0, mensagemEntradaC
    syscall
    
    li $v0, 6
    syscall
    mov.s $f4, $f0
    
    # Calcular delta em f7
    mul.s $f5, $f2, $f4   # a * c
    l.s $f6, quatroDelta  # 4.0
    mul.s $f5, $f5, $f6   # 4ac
    mul.s $f7, $f3, $f3   # b^2
    sub.s $f7, $f7, $f5   # b^2 - 4ac (delta)
    
    # Verifica se o delta é menor que 0
    l.s $f8, zeroF
    c.lt.s $f7, $f8       
    bc1t deltaMenorQueZero
    
    # Calcular raizes
    sqrt.s $f7, $f7        # raiz de delta
    l.s $f8, menosUmDelta  # -1.0
    mul.s $f9, $f3, $f8    # -b
    l.s $f10, doisDelta    # 2.0
    mul.s $f11, $f2, $f10  # 2a
    
    # Calcula raiz 1
    add.s $f12, $f9, $f7   # -b + raiz de delta
    div.s $f12, $f12, $f11 # dividido por 2a
    
    # Calcula raiz 2
    sub.s $f13, $f9, $f7   # -b - raiz de delta
    div.s $f13, $f13, $f11 # dividido por 2a
    
    # Imprimir raiz 1
    li $v0, 4
    la $a0, mensagemRaizRaiz1
    syscall
    
    li $v0, 2 
    mov.s $f12, $f12
    syscall

    # Imprimir raiz 2
    li $v0, 4
    la $a0, mensagemRaizRaiz2
    syscall
    
    li $v0, 2
    mov.s $f12, $f13
    syscall
    
    li $v0, 10  
    syscall
    
deltaMenorQueZero:
    li $v0, 4
    la $a0, mensagemRaizDeltaMenorQueZero
    syscall 
    
    li $v0, 10
    syscall
