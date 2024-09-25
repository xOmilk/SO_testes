#!/bin/bash

#NUM_ARGUMENTOS=echo $#
msg="Eh preciso digitar pelo menos um argumento"


#Faz com que seja necessario pelo menos um argumento para que rode#
[[ $# < 1 ]] && echo $msg && exit 1; 



RECEBE_1=$1
RECEBE_2=$2

echo "O numero argumentos foi: $#"
echo "O primeiro argumento que voce recebeu foi: $RECEBE_1 "
echo "O segundo argumento que voce recebeu foi: $RECEBE_2 "



exit 0
