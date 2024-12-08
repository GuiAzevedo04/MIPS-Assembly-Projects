################################## Data segment ######################################
.data
    msgInicial:     .asciiz "Digite um inteiro positivo : "
    msgResultado:   .asciiz "Resultado da soma: "

################################## Code segment ######################################
.text
.globl main
main:
    # Mensagem inicial
    li $v0, 4 		       # imprimir string
    la $a0, msgIncial         # carrega mensagem declarada
    syscall

    # Leitura de n
    li $v0, 5                  # realiza a leitura de n inteiro
    syscall
    move $t0, $v0              # salva n em $t0

    # Variaveis
    li $t1, 1                  # contador i = 1
    move $t2, $t0              # d = n
    li $t3, 0               # Carrega 0 no registrador
    mtc1 $t3, $f0           # Move o valor para o registrador de ponto flutuante
    cvt.s.w $f0, $f0        # Converte para ponto flutuante

    soma_loop:
    # Converte contador i para float
    mtc1 $t1, $f4              # move i para $f4
    cvt.s.w $f4, $f4           # converte $f4 para float

    # Converte d para float
    mtc1 $t2, $f6              # move d para $f6
    cvt.s.w $f6, $f6           # converte $f6 para float

    div.s $f8, $f4, $f6        # $f8 = i / d

    add.s $f0, $f0, $f8        # soma total += i / d

    addi $t1, $t1, 1           # i++
    subi $t2, $t2, 1           # d--

    # Verifica se i <= n
    ble $t1, $t0, soma_loop    # se i <= n continua no loop

    # Exibe o resultado
    li $v0, 4                  # imprimir string
    la $a0, msgResultado       # carrega mensagem de resultado declarada no inicio
    syscall

    li $v0, 2                  # imprimir float
    mov.s $f12, $f0            # move soma total para $f12
    syscall

    # encerra o programa
    li $v0, 10
    syscall
