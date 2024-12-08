################# Segmento de Dados #####################
.data
    msgPromptN:     .asciiz "Digite um inteiro positivo n: "
    msgResultado:   .asciiz "Resultado da soma: "

################# Segmento de Código #####################
.text
.globl main
main:
    # Prompt para n
    li $v0, 4 		       # syscall para imprimir string
    la $a0, msgPromptN         # carrega mensagem de prompt
    syscall

    # Leitura de n
    li $v0, 5                  # syscall para leitura de inteiro
    syscall
    move $t0, $v0              # salva n em $t0

    # Inicialização de variáveis
    li $t1, 1                  # contador i = 1
    move $t2, $t0              # denominador inicial d = n
    li $t3, 0               # Carrega 0 no registrador inteiro
    mtc1 $t3, $f0           # Move o valor para o registrador de ponto flutuante
    cvt.s.w $f0, $f0        # Converte para ponto flutuante
    soma_loop:
    # Converte contador i para float
    mtc1 $t1, $f4              # move i para $f4
    cvt.s.w $f4, $f4           # converte $f4 para float

    # Converte denominador d para float
    mtc1 $t2, $f6              # move d para $f6
    cvt.s.w $f6, $f6           # converte $f6 para float

    # Calcula termo i/d
    div.s $f8, $f4, $f6        # $f8 = i / d

    # Soma termo à soma total
    add.s $f0, $f0, $f8        # soma total += i / d

    # Incrementa i e decrementa d
    addi $t1, $t1, 1           # i++
    subi $t2, $t2, 1           # d--

    # Verifica se i <= n
    ble $t1, $t0, soma_loop    # se i <= n, continua no loop

    # Exibe o resultado
    li $v0, 4                  # syscall para imprimir string
    la $a0, msgResultado       # carrega mensagem de resultado
    syscall

    li $v0, 2                  # syscall para imprimir float
    mov.s $f12, $f0            # move soma total para $f12
    syscall

    # Finaliza programa
    li $v0, 10                 # syscall para sair
    syscall
