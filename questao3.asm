################# Data Segment #####################
.data
msgEntradaAlunos:  .asciiz "Digite o número de alunos: "
msgEntradaNota:    .asciiz "Digite a nota: "
msgMediaAluno:     .asciiz "Média do aluno: "
msgMediaClasse:    .asciiz "Média da classe: "
msgAprovados:      .asciiz "Número de aprovados: "
msgReprovados:     .asciiz "Número de reprovados: "
novaLinha:         .asciiz "\n"

qtdAlunos:         .word 0
somaClasse:        .float 0.0
numAprovados:      .word 0
numReprovados:     .word 0

################# Code Segment #####################
.text
.globl main
main:
    # Entrada: Número de alunos
    li $v0, 4
    la $a0, msgEntradaAlunos
    syscall

    li $v0, 5
    syscall
    sw $v0, qtdAlunos    # Salva o número de alunos em memória

    # Inicializa variáveis
    li $t0, 0            # Contador de alunos (i = 0)
    lw $t1, qtdAlunos    # Carrega número de alunos (n)
    li $t3, 0            # Contador de notas (para 3 por aluno)
    li $t4, 3            # Número fixo de notas por aluno

    # Inicializa acumuladores em ponto flutuante
    li $t5, 0
    mtc1 $t5, $f5        # Temporário para soma individual das notas (float)

loop_alunos:
    bge $t0, $t1, fim   # Se todos os alunos foram processados, termina

    # Zera soma das notas para o aluno atual
    li $t5, 0
    mtc1 $t5, $f5

loop_notas:
    bge $t3, $t4, calc_media_aluno  # Processou as 3 notas, calcula média

    # Entrada: Notas dos alunos
    li $v0, 4
    la $a0, msgEntradaNota
    syscall

    li $v0, 6            # Syscall para leitura de float
    syscall
    mov.s $f6, $f0       # Move a nota digitada para $f6
    add.s $f5, $f5, $f6  # Soma nota ao acumulador de ponto flutuante
    addi $t3, $t3, 1     # Incrementa contador de notas
    j loop_notas

calc_media_aluno:
    # Calcula média do aluno
    li $t5, 3
    mtc1 $t5, $f6        # Move valor 3 para registrador float
    cvt.s.w $f6, $f6     # Converte inteiro para float
    div.s $f7, $f5, $f6  # Média = soma / 3

    # Exibe média do aluno
    li $v0, 4
    la $a0, msgMediaAluno
    syscall

    li $v0, 2
    mov.s $f12, $f7
    syscall
    
    # Pula uma linha após exibir a média
    li $v0, 4
    la $a0, novaLinha
    syscall

    # Adiciona média à soma total da classe
    lwc1 $f0, somaClasse
    add.s $f0, $f0, $f7
    swc1 $f0, somaClasse

    # Conta aprovados/reprovados
    li $t5, 5
    mtc1 $t5, $f8        # Move valor 5 para registrador float
    cvt.s.w $f8, $f8     # Converte inteiro para float
    c.lt.s $f7, $f8      # Verifica se média < 5.0
    bc1t conta_reprovado

    lw $t8, numAprovados
    addi $t8, $t8, 1
    sw $t8, numAprovados
    j proximo_aluno

conta_reprovado:
    lw $t8, numReprovados
    addi $t8, $t8, 1
    sw $t8, numReprovados

proximo_aluno:
    # Incrementa aluno e reseta contador de notas
    addi $t0, $t0, 1
    li $t3, 0
    j loop_alunos

fim:
    # Calcula média da classe
    lw $t1, qtdAlunos
    mtc1 $t1, $f4
    cvt.s.w $f4, $f4
    lwc1 $f2, somaClasse
    div.s $f6, $f2, $f4

    # Exibe média da classe
    li $v0, 4
    la $a0, msgMediaClasse
    syscall

    li $v0, 2
    mov.s $f12, $f6
    syscall

    li $v0, 4
    la $a0, novaLinha
    syscall

    # Exibe número de aprovados
    li $v0, 4
    la $a0, msgAprovados
    syscall

    li $v0, 1
    lw $a0, numAprovados
    syscall
    
    li $v0, 4
    la $a0, novaLinha
    syscall

    # Exibe número de reprovados
    li $v0, 4
    la $a0, msgReprovados
    syscall

    li $v0, 1
    lw $a0, numReprovados
    syscall

    # Fim do programa
    li $v0, 10
    syscall
