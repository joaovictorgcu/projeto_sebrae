#################################################################
# Autor: Joao Victor Guimaraes Cavalcanti Uchoa - 3 PERIODO A
# Email: jvgcu@cesar.school
#
# Descrição: Calculadora de Programador Didática
# Linguagem: Assembly MIPS
# Ambiente: MARS ou SPIM
#
# Histórico de Revisões:
# Data: 04/11/2025 9:55
# Versão: 1.0
# Criação da estrutura principal e menu.
# Implementação das conversões de base (10->2, 10->8, 10->16).
# (Funções: base_10_para_N, print_base_N)
#
# Data: 06/11/2025 21:22
# Versão: 1.1
# Implementação da conversão para BCD (1d). (Função: base_10_para_bcd)
# Implementação da conversão para Complemento a 2 (2). (Função: base_10_para_c2)
#
# Data: 07/11/2025 11:37
# Versão: 1.2
# Implementação da dissecação de Float (3). (Função: dissecar_float)
# Implementação da dissecação de Double (3). (Função: dissecar_double)
# Conclusão e limpeza do código.

.data
    menu_principal: .asciiz "\n--- Calculadora Programador Didatica ---\n"
    menu_1:   .asciiz "1. Base 10 -> Base 2 (Binario)\n"
    menu_2:   .asciiz "2. Base 10 -> Base 8 (Octal)\n"
    menu_3:   .asciiz "3. Base 10 -> Base 16 (Hexadecimal)\n"
    menu_4:   .asciiz "4. Base 10 -> Codigo BCD\n"
    menu_5:   .asciiz "5. Base 10 -> Complemento a 2 (16 bits)\n"
    menu_6:   .asciiz "6. Dissecar Float (IEEE 754)\n"
    menu_7:   .asciiz "7. Dissecar Double (IEEE 754)\n"
    menu_8:   .asciiz "0. Sair\n"
    menu_prompt: .asciiz "Escolha uma opcao: "

    prompt_int:     .asciiz "\nDigite um numero inteiro (base 10): "
    prompt_float:   .asciiz "\nDigite um numero real (ex: 12.34): "
    prompt_double:  .asciiz "\nDigite um numero real (precisao dupla): "
    
    didatico_div:   .asciiz "\n--- Passos (Divisoes Sucessivas) ---\n"
    passo_div:      .asciiz " / "
    passo_igual:    .asciiz " = "
    passo_resto:    .asciiz ", Resto: "
    resultado_str:  .asciiz "\nResultado: "
    
    didatico_bcd:   .asciiz "\n--- Passos (Mapeamento BCD) ---\n"
    passo_bcd_1:    .asciiz "Digito "
    passo_bcd_2:    .asciiz " ("
    passo_bcd_3:    .asciiz ") -> Nibble BCD: "
    
    didatico_c2:    .asciiz "\n--- Passos (Complemento a 2 em 16 bits) ---\n"
    passo_c2_pos:   .asciiz "Numero positivo. Representacao binaria (16 bits): "
    passo_c2_neg_1: .asciiz "1. Numero negativo. Valor absoluto: "
    passo_c2_neg_2: .asciiz "\n2. Absoluto em binario (16 bits): "
    passo_c2_neg_3: .asciiz "\n3. Invertendo bits (Compl. a 1): "
    passo_c2_neg_4: .asciiz "\n4. Somando 1 (Compl. a 2):     "
    
    didatico_ieee:  .asciiz "\n--- Dissecando Bits (IEEE 754) ---\n"
    passo_sinal:    .asciiz "\n1. Bit de Sinal: "
    passo_sinal_0:  .asciiz " (0 = Positivo)"
    passo_sinal_1:  .asciiz " (1 = Negativo)"
    passo_expo:     .asciiz "\n2. Bits de Expoente (com vies): "
    passo_frac:     .asciiz "\n3. Bits de Fracao (Mantissa): "
    hex_repr:       .asciiz "Representacao Hex (32 bits): 0x"
    hex_repr_dbl_1: .asciiz "Representacao Hex (64 bits, Hi): 0x"
    hex_repr_dbl_2: .asciiz "Representacao Hex (64 bits, Lo): 0x"
    
    newline:  .asciiz "\n"
    espaco:   .asciiz " "
    hex_chars: .asciiz "0123456789ABCDEF"

.text
.globl main

main:
    loop_menu:
        li $v0, 4
        la $a0, menu_principal
        syscall
        la $a0, menu_1
        syscall
        la $a0, menu_2
        syscall
        la $a0, menu_3
        syscall
        la $a0, menu_4
        syscall
        la $a0, menu_5
        syscall
        la $a0, menu_6
        syscall
        la $a0, menu_7
        syscall
        la $a0, menu_8
        syscall
        
        la $a0, menu_prompt
        syscall
        
        li $v0, 5  
        syscall
        move $t0, $v0 
        
        beq $t0, $zero, sair
        
        li $t1, 1
        beq $t0, $t1, opt_1 
        li $t1, 2
        beq $t0, $t1, opt_2 
        li $t1, 3
        beq $t0, $t1, opt_3 
        li $t1, 4
        beq $t0, $t1, opt_4 
        li $t1, 5
        beq $t0, $t1, opt_5 
        li $t1, 6
        beq $t0, $t1, opt_6 
        li $t1, 7
        beq $t0, $t1, opt_7 
        
        j loop_menu 

    sair:
        li $v0, 10
        syscall

opt_1:
    jal ler_inteiro 
    move $a0, $v0   
    li $a1, 2       
    jal base_10_para_N
    j loop_menu

opt_2:
    jal ler_inteiro 
    move $a0, $v0   
    li $a1, 8       
    jal base_10_para_N
    j loop_menu

opt_3:
    jal ler_inteiro 
    move $a0, $v0   
    li $a1, 16      
    jal base_10_para_N
    j loop_menu

opt_4:
    jal ler_inteiro 
    move $a0, $v0   
    jal base_10_para_bcd
    j loop_menu

opt_5:
    jal ler_inteiro 
    move $a0, $v0   
    jal base_10_para_c2
    j loop_menu

opt_6:
    li $v0, 4
    la $a0, prompt_float
    syscall
    li $v0, 6       
    syscall
    jal dissecar_float
    j loop_menu

opt_7:
    li $v0, 4
    la $a0, prompt_double
    syscall
    li $v0, 7       
    syscall
    jal dissecar_double
    j loop_menu

base_10_para_N:
    move $t0, $a0   
    move $t1, $a1   
    li $t2, 0       

    li $v0, 4
    la $a0, didatico_div
    syscall
    
    div_loop:
        beq $t0, $zero, div_fim 
        
        div $t0, $t1    
        mflo $t3        
        mfhi $t4        
        
        move $a0, $t0   
        li $v0, 1
        syscall
        
        li $v0, 4
        la $a0, passo_div
        syscall
        
        move $a0, $t1   
        li $v0, 1
        syscall
        
        li $v0, 4
        la $a0, passo_igual
        syscall
        
        move $a0, $t3   
        li $v0, 1
        syscall
        
        li $v0, 4
        la $a0, passo_resto
        syscall
        
        move $a0, $t4   
        li $v0, 1
        syscall
        
        li $v0, 4
        la $a0, newline
        syscall

        addi $sp, $sp, -4
        sw $t4, 0($sp)
        addi $t2, $t2, 1 

        move $t0, $t3   
        j div_loop

    div_fim:
        li $v0, 4
        la $a0, resultado_str
        syscall
        
        move $a0, $t1 
        move $a1, $t2 
        jal print_base_N
        
        jr $ra 

base_10_para_bcd:
    move $t0, $a0 
    li $t1, 0     
    
    invert_loop:
        beq $t0, $zero, invert_fim
        li $t2, 10
        div $t0, $t2
        mflo $t0    
        mfhi $t3    
        
        mul $t1, $t1, 10
        add $t1, $t1, $t3
        j invert_loop
    invert_fim:

    li $v0, 4
    la $a0, didatico_bcd
    syscall
    la $a0, resultado_str
    syscall
    
    move $t0, $t1 
    
    bcd_loop:
        beq $t0, $zero, bcd_fim
        li $t2, 10
        div $t0, $t2
        mflo $t0    
        mfhi $t3    
        
        li $v0, 4
        la $a0, newline
        syscall
        la $a0, passo_bcd_1
        syscall
        move $a0, $t3 
        li $v0, 1
        syscall
        li $v0, 4
        la $a0, passo_bcd_2
        syscall
        move $a0, $t3
        li $v0, 35 
        syscall
        li $v0, 4
        la $a0, passo_bcd_3
        syscall

        move $a0, $t3
        li $a1, 4 
        jal print_bin_padded
        
        li $v0, 4
        la $a0, espaco
        syscall
        
        j bcd_loop
        
    bcd_fim:
        li $v0, 4
        la $a0, newline
        syscall
        jr $ra

base_10_para_c2:
    move $t0, $a0 

    li $v0, 4
    la $a0, didatico_c2
    syscall

    bgez $t0, c2_positivo

    li $v0, 4
    la $a0, passo_c2_neg_1
    syscall
    
    abs $t1, $t0    
    move $a0, $t1
    li $v0, 1
    syscall
    
    li $t2, 0xFFFF
    and $t1, $t1, $t2 
    
    li $v0, 4
    la $a0, passo_c2_neg_2
    syscall
    move $a0, $t1
    li $a1, 16 
    jal print_bin_padded
    
    nor $t3, $t1, $zero 
    and $t3, $t3, $t2   
    
    li $v0, 4
    la $a0, passo_c2_neg_3
    syscall
    move $a0, $t3
    li $a1, 16 
    jal print_bin_padded
    
    addi $t4, $t3, 1    
    and $t4, $t4, $t2   
    
    li $v0, 4
    la $a0, passo_c2_neg_4
    syscall
    move $a0, $t4
    li $a1, 16 
    jal print_bin_padded
    
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra

    c2_positivo:
        li $v0, 4
        la $a0, passo_c2_pos
        syscall
        
        li $t2, 0xFFFF
        and $t1, $t0, $t2 
        
        move $a0, $t1
        li $a1, 16 
        jal print_bin_padded
        
        li $v0, 4
        la $a0, newline
        syscall
        jr $ra

dissecar_float:
    li $v0, 4
    la $a0, didatico_ieee
    syscall

    mfc1 $t0, $f0
    
    li $v0, 4
    la $a0, hex_repr
    syscall
    move $a0, $t0
    li $v0, 34 
    syscall
    
    li $v0, 4
    la $a0, passo_sinal
    syscall
    
    li $t1, 0x80000000 
    and $t2, $t0, $t1
    srl $t2, $t2, 31  
    
    move $a0, $t2
    li $v0, 1 
    syscall
    
    li $v0, 4
    beq $t2, $zero, sinal_0
    la $a0, passo_sinal_1
    j sinal_fim
    sinal_0:
    la $a0, passo_sinal_0
    sinal_fim:
    syscall
    
    li $v0, 4
    la $a0, passo_expo
    syscall
    
    li $t1, 0x7F800000 
    and $t2, $t0, $t1
    srl $t2, $t2, 23  
    
    move $a0, $t2
    li $a1, 8 
    jal print_bin_padded
    
    li $v0, 4
    la $a0, passo_frac
    syscall
    
    li $t1, 0x007FFFFF 
    and $t2, $t0, $t1
    
    move $a0, $t2
    li $a1, 23 
    jal print_bin_padded
    
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra

dissecar_double:
    li $v0, 4
    la $a0, didatico_ieee
    syscall

    mfc1 $t0, $f1  
    mfc1 $t1, $f0  

    li $v0, 4
    la $a0, hex_repr_dbl_1
    syscall
    move $a0, $t0
    li $v0, 34 
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    la $a0, hex_repr_dbl_2
    syscall
    move $a0, $t1
    li $v0, 34 
    syscall
    
    li $v0, 4
    la $a0, passo_sinal
    syscall
    
    li $t2, 0x80000000 
    and $t3, $t0, $t2
    srl $t3, $t3, 31  
    
    move $a0, $t3
    li $v0, 1 
    syscall
    
    li $v0, 4
    beq $t3, $zero, d_sinal_0
    la $a0, passo_sinal_1
    j d_sinal_fim
    d_sinal_0:
    la $a0, passo_sinal_0
    d_sinal_fim:
    syscall
    
    li $v0, 4
    la $a0, passo_expo
    syscall
    
    li $t2, 0x7FF00000 
    and $t3, $t0, $t2
    srl $t3, $t3, 20  
    
    move $a0, $t3
    li $a1, 11 
    jal print_bin_padded
    
    li $v0, 4
    la $a0, passo_frac
    syscall
    
    li $t2, 0x000FFFFF 
    and $t3, $t0, $t2
    move $a0, $t3
    li $a1, 20 
    jal print_bin_padded
    
    move $a0, $t1
    li $a1, 32 
    jal print_bin_padded
    
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra

ler_inteiro:
    li $v0, 4
    la $a0, prompt_int
    syscall
    li $v0, 5
    syscall
    jr $ra

print_base_N:
    move $t0, $a0 
    move $t1, $a1 
    
    print_loop:
        beq $t1, $zero, print_fim
        
        lw $t2, 0($sp)
        addi $sp, $sp, 4
        
        li $t3, 16
        bne $t0, $t3, print_digito
        li $t3, 9
        ble $t2, $t3, print_digito
        
        la $a0, hex_chars
        add $a0, $a0, $t2 
        lb $a0, 0($a0)
        li $v0, 11 
        syscall
        j print_prox
        
    print_digito:
        move $a0, $t2
        li $v0, 1 
        syscall
        
    print_prox:
        addi $t1, $t1, -1 
        j print_loop
        
    print_fim:
        li $v0, 4
        la $a0, newline
        syscall
        jr $ra
        
print_bin_padded:
    move $t0, $a0 
    move $t1, $a1 
    
    li $t2, 1     
    li $t3, 1
    sub $t1, $t1, $t3 
    
    sllv $t2, $t2, $t1 
    
    bin_pad_loop:
        beq $t2, $zero, bin_pad_fim
        
        and $t3, $t0, $t2 
        
        beq $t3, $zero, print_0
        
        li $a0, 1 
        li $v0, 1
        syscall
        j print_shift
        
    print_0:
        li $a0, 0 
        li $v0, 1
        syscall
        
    print_shift:
        srl $t2, $t2, 1 
        j bin_pad_loop
        
    bin_pad_fim:
        jr $ra