# Title: Questão 1
# Description: 1Uma pessoa aplicou mensalmente em um fundo de pensão x reais durante 10 anos. Escreva um programa que determine o montante de capital ao final de cada ano durante este período.
# Input: Valor que será aplicado X e a tava mensal T.
# Output: Montante atual aproximado durante o período solicitado (10 anos).

################################## Data segment ######################################
.data
    msgEntradaX: .asciiz "Digite o valor que será aplicado mensalmente (R$): "
    msgEntradaT: .asciiz "Digite a taxa de juros mensal (%): "
    msgMontante: .asciiz ": Montante atual aproximado: R$ "

    numMeses: .word 12       # Número de meses em um ano
    numAnos:  .word 11       # Total de anos

################################## Code segment ######################################
.text
.globl main

main:
    # Prompt e leitura do valor X
    li $v0, 4                   
    la $a0, msgEntradaX
    syscall

    li $v0, 5                  
    syscall
    move $t0, $v0              

    # Prompt e leitura da taxa T
    li $v0, 4
    la $a0, msgEntradaT
    syscall

    li $v0, 5
    syscall
    move $t1, $v0              

    # Inicializando variáveis que serão utilizadas:
    li $t2, 1                  # Contador de anos.
    li $t3, 0                  # Montante acumulado (inicia como 0)
    lw $t4, numMeses           # Número de meses por ano (12 meses)
    lw $t5, numAnos            # Total de anos (10 anos)

cicloAnos:
    move $t6, $t4              # Inicializa o contador de meses para o ano atual (será utilizado como critério de parada do loop)

cicloMeses:
    add $t3, $t3, $t0	       # Soma o montante atual com o valor X
    mul $t7, $t3, $t1          # Montante * taxa mensal (%)
    div $t7, $t7, 100          # Ajusta o valor percentual
    add $t3, $t3, $t7          # Soma os juros com o montante atual

    # Decrementa o contador de meses
    sub $t6, $t6, 1
    bgtz $t6, cicloMeses       # Continua até completar os 12 meses

    #Imprime o monante atual aproximado:
    li $v0, 4
    la $a0, msgMontante
    syscall

    li $v0, 1
    move $a0, $t3              
    syscall

    # Incrementa o contador de anos
    addi $t2, $t2, 1
    blt $t2, $t5, cicloAnos