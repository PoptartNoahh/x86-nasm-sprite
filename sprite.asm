;------------------------------
;x86 Assembly Sprite Renderer for NASM
;Noah E.
;------------------------------

org 100h
section .data

sbuffer times 4000 db 00h
sbuffer_x dw 00h
sbuffer_y dw 00h
sbuffer_w dw 00h
sbuffer_n dw 00h
sbuffercolor db 00h
scandex dw 00h
scan_x dw 00h
scan_y dw 00h
%macro drawsprite 5
push ax
push bx
mov ax,%1
mov word [scandex],-1
push ax
mov ax,%4
mov [sbuffer_x],ax
mov ax,%5
mov [sbuffer_y],ax
mov ax,%2
mov [sbuffer_w],ax
mov ax,%3
mov [sbuffer_n],ax
pop ax
%%.sprite_draw:
add word [scandex],1
mov bx,[scandex]
add bx,1
mov al,[%1 + bx]
mov bh,00h
push ax
push dx
mov dx,0
mov ax,[scandex]
mov bx,%2
div bx
mov [scan_y],ax
pop ax
pop dx
push cx
push ax
push dx
mov ax,%2
mov cx,[scan_y]
mul cx
mov cx,ax
mov ax,[scandex]
sub ax,cx
mov [scan_x],ax
pop cx
pop ax
pop dx
push cx
push dx
mov cx,[scan_x]
mov dx,[scan_y]
add cx,%4
add dx,%5
mov ah,0Dh
mov [sbuffercolor],al
int 10h
push bx
mov bx,[scandex]
mov [sbuffer + bx],al
pop bx
mov al,[sbuffercolor]
cmp al,00h
je %%.intb
%%.inta
mov ah,0Ch
cmp word [scandex],0
je %%.intb
int 10h
%%.intb
pop cx
pop dx
cmp word [scandex],%3
jne %%.sprite_draw
pop ax
pop bx
%endmacro

_start:
drawsprite mySprite, width, numberOfPixels, positionX, positionY

mov ah,00h
push ax
mov ax,13h
int 10h
pop ax
mov ah,0Bh
mov bh,00h
mov bl,00h
int 10h
mov al,0B6h ;audio
mov ax,0B6h
out 43,al
mov ax,869h
out 42h,al
mov al,ah
out 42,al
in al,61h
or al,93h
out 61h,al
