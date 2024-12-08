################# Segmento de Dados #####################
.data
mensagemDeEntrada:  .asciiz "Digite o n�mero n: "     # Mensagem para entrada
mensagemDeResultado: .asciiz "O resultado �: "       # Mensagem para resultado

soma:    	.float 0.0      # Vari�vel para armazenar a soma (Hn)
K_float:		.float 0.0      # Valor tempor�rio de k em ponto flutuante
K_inteiro: 	.word 0         # Valor atual de k como inteiro
um: 		.float 1.0      # Constante 1.0 para a primeira divis�o

################# Segmento de C�digo #####################
.text
.globl main
main:
    # Exibir mensagem para entrada de n
    li $v0, 4
    la $a0, mensagemDeEntrada
    syscall

    # Ler entrada do inteiro n
    li $v0, 5
    syscall
    move $t1, $v0           # Salvar o valor digitado (n) em $t1

    # Inicializar vari�veis do loop
    li $t2, 1               # k = 1 (in�cio do loop)
    li $t3, 0               # Inicializar acumulador de soma inteiro (n�o usado aqui e sim em 'loop')

    # Limpar soma em ponto flutuante
    li $t0, 0               # Registrador tempor�rio com valor 0
    mtc1 $t0, $f0           # Mover 0 para $f0 (soma em ponto flutuante)

loop:
    # Verificar se k <= n
    bgt $t2, $t1, final     # Se k > n, sair do loop

    # Converter k (inteiro) para ponto flutuante
    mtc1 $t2, $f2           # Mover k (inteiro) para $f2
    cvt.s.w $f2, $f2        # Converter k inteiro para ponto flutuante

    # Realizar 1/k e adicionar � soma
    lwc1 $f4, um            # Carregar 1.0 em $f4
    div.s $f6, $f4, $f2     # f6 = 1.0 / k
    add.s $f0, $f0, $f6     # soma += 1/k

    # Incrementar k
    addi $t2, $t2, 1        # k++

    # Repetir o loop
    j loop

final:
    # Exibir o resultado
    li $v0, 4               # C�digo de syscall para print_string
    la $a0, mensagemDeResultado # Carregar mensagem de resultado
    syscall

    mov.s $f12, $f0         # Mover soma para $f12 para impress�o
    li $v0, 2               # C�digo de syscall para print_float
    syscall

    # Sair do programa
    li $v0, 10              # C�digo de syscall para sair
    syscall
