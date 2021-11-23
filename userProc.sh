#!/bin/bash

# PR07_SSOO ADRIAN GONZALEZ EXPOSITO.
# alu0101404813@ull.edu.es

# Variables

# En caso de no especificar N al usar el parametro -t, esta esta predefinica como 1
N=1
numero='^[0-9]+$'
variable_who=$(who | tr -s ' ' ' ' | cut -d ' ' -f1)
# Variables flag
usr=0
u_variable=0
count=0
pid=0
c_variable=0
inv=0
# Conjunto de usuarios // array vacia
users_set=()
variable_users=$(for i in "${users_set[@]}"; do printf $i )
# Variable a imprimir
my_variable=""

# Funcion que imprime los distintos parametros que se pueden ejecutar en nuestro script 
Usage(){
  printf "Usage: userProc [-parametros]\n"
  printf "-->Params:\n"
  printf "[-t N]: Indica el tiempo a partir del que se mostraran los procesos.\n"
  printf "[-usr]: Muestra los usuarios conectados actualmente al sistema.\n"
  printf "[-u [usuarios]+ ]: Seleccionar usuarios a mostrar.\n"
  printf "[-count]: Sacara el numero de procesos por usuario que cumplan x condiciones.\n"
  printf "[-inv]: Ordena en orden inverso.\n"
  printf "[-pid]: Ordenación por pid.\n"
  printf "[-c]: Ordenacion del numero total de procesos del usuario.\n"
}

# Funcion que muestra un mensaje de error en caso de que el parametro sea erróneo
Error_message(){
  echo -n "Parametro invalido, pruebe de nuevo o use [-h o --help] par mas informacion."
}

user_list(){
  echo
  printf "Listado de usuarios que tienen almenos un proceso con tiempo de cpu mayor a 1:\n"
  ps -eo times,user,group,uid,pid |grep -v /snap | tail -n+2 | awk '{if ( $1>1 ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2]} END{for (i in a) print i}' | sort -u
  echo
  printf "Lista de usuario - Grupo del propietario - uid del propietario:\n"
  printf "%10s %10s %10s\n" $user $group $uid 
  ps -eo user,group,uid | grep -v /snap | tail -n+2 | tr -s ' ' ' '  | cut -d ' ' -f1,2,3 | sort -u | uniq
  echo
  printf "Usuario con mas tiempo de pid consumido\n"
  printf "%10s %10s %10s\n" $times $user $pid
  ps -eo times,user,pid | sort -n | tail -1
  echo
  printf "Tiempo total del proceso con mas tiempo consumido\n"
  printf "%10s %10s\n" $times $user  
  ps -eo times,user | sort -n | tail -1
  echo
}

# Funciones cuando se filtra por usuarios conectados
usr_(){
  my_variable=$(ps -eo times,user,group,uid,pid | grep -v /snap | tail -n+2 | awk '{if ( $1>N ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2]} END{for (i in a) print i}' | sort -u | grep "$variable_who")
}
usr_count(){
  my_variable=$(ps -eo times,user,group | grep -v /snap | tail -n+2 | awk '{if ( $1>N ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2] += 1} END{for (i in a) print a[i], i}' | sort -n | grep "$variable_who")
}
usr_count_pid(){
  my_variable=$(ps -eo user,times,group,uid,pid | awk '{if ( $2>N ) print $0}' | grep "$variable_who" | sort -k 1 | uniq -c -w 3 | sort -n -k 6)
}
usr_count_pid_inv(){
  my_variable=$(ps -eo user,times,group,uid,pid | awk '{if ( $2>N ) print $0}' | grep "$variable_who" | sort -k 1 | uniq -c -w 3 | sort -n -k 6 -r)
}
usr_count_inv(){
  my_variable=$(ps -eo etimes,user,group | grep -v /snap | tail -n+2 | awk '{if ( $1>N ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2] += 1} END{for (i in a) print a[i], i}' | sort -n -r | grep "$variable_who")
}
usr_count_c(){
  my_variable=$(ps -eo user,times,group,uid,pid | awk '{if ( $2>N ) print $0}' | grep "$variable_who" | sort -k 1 | uniq -c -w 3 | sort -n -k 1)
}
usr_count_c_inv(){
  my_variable=my_variable=$(ps -eo user,times,group,uid,pid | awk '{if ( $2>N ) print $0}' | grep "$variable_who" | sort -k 1 | uniq -c -w 3 | sort -n -k 1 -r)
}
usr_pid(){
  my_variable=$(ps -eo etimes,user,group,uid,pid | grep -v /snap | tail -n+2 | awk '{if ( $1>"$N" ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2] = $5} END{for (i in a) print i, a[i]}' | sort -u | cut -d ' ' -f1 | grep "$variable_who")
}
usr_pid_inv(){
  my_variable=$(ps -eo etimes,user,group,uid,pid | grep -v /snap | tail -n+2 | awk '{if ( $1>"$N" ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2] = $5} END{for (i in a) print i, a[i]}' | sort -u -r | cut -d ' ' -f1 | grep "$variable_who")
}
usr_c(){
  my_variable=$(ps -eo user,times,group,uid,pid | awk '{if ( $2>N ) print $0}' | grep "$variable_who" | sort -k 1 | uniq -c -w 3 | sort -n -k 1)
}
usr_c_inv(){
  my_variable=$(ps -eo user,times,group,uid,pid | awk '{if ( $2>N ) print $0}' | grep "$variable_who" | sort -k 1 | uniq -c -w 3 | sort -n -k 1 -r)
}
usr_inv(){
  my_variable=$(ps -eo etimes,user,group,uid,pid | grep -v /snap | tail -n+2 | awk '{if ( $1>"$N" ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2]} END{for (i in a) print i}' | sort -u -r | grep "$variable_who")
}

# Funciones cuando se filtra por usuarios especificados
u_(){
  my_variable=$(ps -eo times,user,group,uid,pid | grep -v /snap | tail -n+2 | awk '{if ( $1>N ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2]} END{for (i in a) print i}' | sort -u | grep "$variable_users")
}
u_count(){
  my_variable=$(ps -eo times,user,group | grep -v /snap | tail -n+2 | awk '{if ( $1>N ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2] += 1} END{for (i in a) print a[i], i}' | sort -n | grep "$variable_users")
}
u_count_pid(){
  my_variable=$(ps -eo user,times,group,uid,pid | awk '{if ( $2>N ) print $0}' | grep "$variable_users" | sort -k 1 | uniq -c -w 3 | sort -n -k 6)
}
u_count_pid_inv(){
  my_variable=$(ps -eo user,times,group,uid,pid | awk '{if ( $2>N ) print $0}' | grep "$variable_users" | sort -k 1 | uniq -c -w 3 | sort -n -k 6 -r)
}
u_count_inv(){
  my_variable=$(ps -eo etimes,user,group | grep -v /snap | tail -n+2 | awk '{if ( $1>N ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2] += 1} END{for (i in a) print a[i], i}' | sort -n -r | grep "$variable_users")
}
u_count_c(){
  my_variable=$(ps -eo user,times,group,uid,pid | awk '{if ( $2>N ) print $0}' | grep "$variable_users" | sort -k 1 | uniq -c -w 3 | sort -n -k 1)
}
u_count_c_inv(){
  my_variable=my_variable=$(ps -eo user,times,group,uid,pid | awk '{if ( $2>N ) print $0}' | grep "$variable_users" | sort -k 1 | uniq -c -w 3 | sort -n -k 1 -r)
}
u_pid(){
  my_variable=$(ps -eo etimes,user,group,uid,pid | grep -v /snap | tail -n+2 | awk '{if ( $1>"$N" ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2] = $5} END{for (i in a) print i, a[i]}' | sort -u | cut -d ' ' -f1 | grep "$variable_users")
}
u_pid_inv(){
  my_variable=$(ps -eo etimes,user,group,uid,pid | grep -v /snap | tail -n+2 | awk '{if ( $1>"$N" ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2] = $5} END{for (i in a) print i, a[i]}' | sort -u -r | cut -d ' ' -f1 | grep "$variable_users")
}
u_c(){
  my_variable=$(ps -eo user,times,group,uid,pid | awk '{if ( $2>N ) print $0}' | grep "$variable_users" | sort -k 1 | uniq -c -w 3 | sort -n -k 1)
}
u_c_inv(){
  my_variable=$(ps -eo user,times,group,uid,pid | awk '{if ( $2>N ) print $0}' | grep "$variable_users" | sort -k 1 | uniq -c -w 3 | sort -n -k 1 -r)
}
u_inv(){
  my_variable=$(ps -eo etimes,user,group,uid,pid | grep -v /snap | tail -n+2 | awk '{if ( $1>"$N" ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2]} END{for (i in a) print i}' | sort -u -r | grep "$variable_users")
}

# Menú
# Si se llama a la funcion sin parametros imprime en pantalla la funcion user_list
if ["$1" == ""]; then
  user_list
else
  while [ "$1" != "" ]; do
    case $1 in
      -h | --help )
        Usage
        exit
        ;;
      -t )
        case $2 in 
          *[!0-9]* )
            Error_message
            exit 1
            ;;
          * )
            shift
            N=$1
            ;;
        esac
        shift
        ;;
      -usr )
        usr=1
        shift
        ;;
      -u )
        u_variable=1
        if [ "$2" == "-*" ]; then
          Error_message
          exit 1
        else 
          while [ "$2" != "-*" ]; do
            shift
            users_set=($1 "${users_set[@]}")
          done
        fi
        shift
        ;;
      -count )
        count=1
        shift
        ;;
      -c )
        c_variable=1
        shift
        ;;
      -inv )
        inv=1
        shift
        ;;
      -pid )
        pid=1
        shift
        ;;
      * )
        Error_message
        exit 1
        ;;
    esac
    shift
  done
fi


if [ "$usr" == 1 && "$u_variable" == 0 ];
  usr_
  if [ "$count" == 1 ]; then
    usr_count
    if [ "$pid" == 1 && "$c_variable" == 0 ]; then
      usr_count_pid
      if [ "$inv" == 1 ]; then
        usr_count_pid_inv
      fi
    if [ "$inv" == 1 && "$pid" == 0 && "$c_variable" == 0 ]; then
      usr_count_inv
    fi
    if [ "$c_variable" == 1 && "$pid" == 0 ]; then
      usr_count_c
      if [ "$inv" == 1 ]; then
        usr_count_c_inv
      fi
    fi
  fi
  if [ "$pid" == 1 && "$count" == 0 && "$c_variable" == 0 ]; then
    usr_pid
    if [ "$inv" == 1 ]; then
      usr_pid_inv
    fi
  fi
  if [ "$c_variable" == 1 && "$pid" == 0 && "$count" == 0 ]; then
    usr_c
    if [ "$inv" == 1]; then
      usr_c_inv
    fi
  fi
  if [ "$inv" == 1 && "$c_variable" == 0 && "$pid" == 0 && "$count" == 0 ]; then
    usr_inv
  fi
fi

if [ "$u_variable" == 1 && "$usr" == 0 ]; 
  u_
  if [ "$count" == 1 ]; then
    u_count
    if [ "$pid" == 1 && "$c_variable" == 0 ]; then
      u_count_pid
      if [ "$inv" == 1 ]; then
        u_count_pid_inv
      fi
    fi
    if [ "$inv" == 1 && "$pid" == 0 && "$c_variable" == 0 ]; then
      u_count_inv
    fi
    if [ "$c_variable" == 1 && "$pid" == 0 ]; then
      u_count_c
      if [ "$inv" == 1]; then
        u_count_c_inv
      fi
    fi
  fi
  if [ "$pid" == 1 && "$count" == 0 &&  "$c_variable" == 0 ]; then
    u_pid
    if [ "$inv" == 1 ]; then
      u_pid_inv
    fi
  fi
  if [ "$pid" == 0 && "$count" == 0 &&  "$c_variable" == 1 ]; then
    u_c
    if [ "$inv" == 1]; then
      u_c_inv
    fi
  fi
  if [ "$inv" == 1 && "$c_variable" == 0 && "$pid" == 0 && "$count" == 0 ]; then
    u_inv
  fi
fi

echo "$my_variable"