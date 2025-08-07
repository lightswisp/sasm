; demo
; ecx -> base
; edx -> exponent
; eax -> result
mov eax, 1
pow:
    mul eax, ecx
    dec edx
    cmp edx, 0
    jne pow
    ret

mov ecx, 5
mov edx, 2
call pow
msg 'pow: ', eax
end
