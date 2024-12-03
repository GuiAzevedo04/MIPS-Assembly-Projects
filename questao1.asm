# Title: Questão 1
# Description: 1- Uma pessoa aplicou mensalmente em um fundo de pensão X reais durante 10 anos. 
# Escreva um programa que determine o montante de capital ao final de cada ano durante este período.
# Input: Valor que será aplicado X e a taxa mensal T.
# Output: Montante atual aproximado durante o período solicitado (10 anos).

################################## Data segment ######################################
.data
    msgEntradaX: .asciiz "Digite o valor que será aplicado mensalmente (R$): "
    msgEntradaT: .asciiz "Digite a taxa de juros mensal (%): "
    msgMontante: .asciiz "\nMontante atual aproximado: R$ "

    numMeses: .word 12       # Número de meses em um ano
    numAnos:  .word 11       # Total de anos
    montanteInicial:	.float 0.0
    cem:		.float 100.0
################################## Code segment ######################################
.text
.globl main

main:
    # Prompt e leitura do valor X
    li $v0, 4                    
    la $a0, msgEntradaX
    syscall

    li $v0, 6                    
    syscall
    mov.s $f1, $f0               

    # Prompt e leitura da taxa T
    li $v0, 4                    
    la $a0, msgEntradaT
    syscall

    li $v0, 6                    	
    syscall
    mov.s $f2, $f0               

    # Inicializando variáveis
    li $t2, 1                    # Contador de anos
    lw $t4, numMeses             # Número de meses por ano (12 meses)
    lw $t5, numAnos              # Total de anos (10 anos)
    l.s $f3, montanteInicial              # Montante acumulado inicial (0.0)

cicloAnos:
    move $t6, $t4                # Inicializa o contador de meses para o ano atual

cicloMeses:
    add.s $f3, $f3, $f1          # Soma o montante atual com o valor aplicado mensalmente (X)
    mul.s $f4, $f3, $f2          # Montante * taxa mensal (%)
    l.s $f5, cem            # Carrega 100.0 em um registrador
    div.s $f4, $f4, $f5          # Ajusta o valor percentual
    add.s $f3, $f3, $f4          # Soma os juros com o montante atual

    # Decrementa o contador de meses
    sub $t6, $t6, 1
    bgtz $t6, cicloMeses         # Continua até completar os 12 meses

    # Imprime o montante atual aproximado
    li $v0, 4
    la $a0, msgMontante
    syscall

    li $v0, 2                    # Imprime o número em ponto flutuante
    mov.s $f12, $f3
    syscall

    # Incrementa o contador de anos
    addi $t2, $t2, 1
    blt $t2, $t5, cicloAnos      # Continua para o próximo ano

    # Finaliza o programa
    li $v0, 10                   # Encerrar programa
    syscall
