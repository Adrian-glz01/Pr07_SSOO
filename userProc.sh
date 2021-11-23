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
u=0
count=0
pid=0
c=0
inv=0
# Conjunto de usuarios
users_set=""
# Variable a imprimir
my_variable=""

# Funcion que imprime los distintos parametros que se pueden ejecutar en nuestro script 
Usage(){
  echo -n "Usage: userProc [-parametros]"
  echo -n "-->Params:"
  echo -n "[-t N]: Indica el tiempo a partir del que se mostraran los procesos."
  echo -n "[-usr]: Muestra los usuarios conectados actualmente al sistema."
  echo -n "[-u [usuarios]+ ]: Seleccionar usuarios a mostrar."
  echo -n "[-count]: Sacara el numero de procesos por usuario que cumplan x condiciones."
  echo -n "[-inv]: Ordena en orden inverso."
  echo -n "[-pid]: Ordenación por pid."
  echo -n "[-c]: Ordenacion del numero total de procesos del usuario."
}

# Funcion que muestra un mensaje de error en caso de que el parametro sea erróneo
Error_message(){
  echo -n "Parametro invalido, pruebe de nuevo o use [-h o --help] par mas informacion."
}

user_list(){
  echo
  echo -n "Listado de usuarios que tienen almenos un proceso con tiempo de cpu mayor a 1:"
  ps -eo etimes,user,group,uid,pid |grep -v /snap | tail -n+2 | awk '{if ( $1>"$N" ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2]} END{for (i in a) print i}' | sort -u  
  echo
  echo -n "Lista de usuario - Grupo del propietario - uid del propietario:"
  printf "%10s" $user "%10s" $group "%10s" $uid
  ps -eo user,group,uid | grep -v /snap | tail -n+2 | tr -s ' ' ' '  | cut -d ' ' -f1,2,3 | sort -u | uniq
  echo
  echo -n "Usuario con mas tiempo de pid consumido"
  printf "%10s" $time "%10s" $user "%10s" $pid
  ps -eo etimes,user,pid | sort -n | tail -1
  echo
  echo -n "Tiempo total del proceso con mas tiempo consumido"
  printf "%10s" $time "%10s" $user
  ps -eo etimes,user | sort -n | tail -1
  echo
}

# Funciones cuando se filtra por usuarios conectados
usr_(){
  my_variable=$(ps -eo etimes,user,group,uid,pid | grep -v /snap | tail -n+2 | awk '{if ( $1>"$N" ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2]} END{for (i in a) print i}' | sort -u | grep "$variable_who")
}
usr_count(){
  my_variable=$(ps -eo etimes,user,group | grep -v /snap | tail -n+2 | awk '{if ( $1>"$N" ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2] += 1} END{for (i in a) print a[i], i}' | sort -n | grep "$variable_who")
}
usr_count_pid(){
  my_variable=
}
usr_count_pid_inv(){
  my_variable=
}
usr_count_inv(){
  my_variable=$(ps -eo etimes,user,group | grep -v /snap | tail -n+2 | awk '{if ( $1>"$N" ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2] += 1} END{for (i in a) print a[i], i}' | sort -n -r | grep "$variable_who")
}
usr_count_c(){
  my_variable=
}
usr_count_c_inv(){
  my_variable=
}
usr_pid(){
  my_variable=$(ps -eo etimes,user,group,uid,pid | grep -v /snap | tail -n+2 | awk '{if ( $1>"$N" ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2] = $5} END{for (i in a) print i, a[i]}' | sort -u | cut -d ' ' -f1 | grep "$variable_who")
}
usr_pid_inv(){
  my_variable=$(ps -eo etimes,user,group,uid,pid | grep -v /snap | tail -n+2 | awk '{if ( $1>"$N" ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2] = $5} END{for (i in a) print i, a[i]}' | sort -u -r | cut -d ' ' -f1 | grep "$variable_who")
}
usr_c(){
  my_variable=
}
usr_c_inv(){
  my_variable=
}
usr_inv(){
  my_variable=$(ps -eo etimes,user,group,uid,pid | grep -v /snap | tail -n+2 | awk '{if ( $1>"$N" ) print $0}' | tr -s ' ' ' ' | awk -F ' ' '{a[$2]} END{for (i in a) print i}' | sort -u -r | grep "$variable_who")
}

# Funciones cuando se filtra por usuarios especificados
u_(){
  my_variable=
}
u_count(){
  my_variable=
}
u_count_pid(){
  my_variable=
}
u_count_pid_inv(){
  my_variable=
}
u_count_inv(){
  my_variable=
}
u_count_c(){
  my_variable=
}
u_count_c_inv(){
  my_variable=
}
u_pid(){
  my_variable=
}
u_pid_inv(){
  my_variable=
}
u_c(){
  my_variable=
}
u_c_inv(){
  my_variable=
}
u_inv(){

}

# Menú
# Si se llama a la funcion sin parametros imprime en pantalla la funcion user_list
if ["$1" == ""]; then
  user_list
  ;;
else
  while [ "$1" != "" ]; do
    case $1 in
      -h | --help )
        Usage
        exit
        ;;
      -t )
        shift
        valor = $1
        if [ "$valor" == numero ]; then
          N = numero
          user_list
          exit 0
        elif [ "$valor" == ""]; then
          user_list
          exit 0
        else
          Usage
          exit
        fi
      -usr )
        System_users
        exit
      -u )

      -count )

      -c )

      -inv )

      -pid )

      * )
        Error_message
        exit 1
    esac
    shift
  done
fi


if [ "$usr" == 1 && "$u" == 0 ];
  usr_
  if [ "$count" == 1 ]; then
    usr_count
    if [ "$pid" == 1 && "$c" == 0 ]; then
      usr_count_pid
      if [ "$inv" == 1 ]; then
        usr_count_pid_inv
      fi
    fi
    elif [ "$inv" == 1 && "$pid" == 0 && "$c" == 0 ]; then
      usr_count_inv
    fi
    elif [ "$c" == 1 && "$pid" == 0]; then
      usr_count_c
      if [ "$inv" == 1]; then
        usr_count_c_inv
      fi
    fi
  fi
  if [ "$pid" == 1 && "$count" == 0 && "$c" == 0 ]; then
    usr_pid
    if [ "$inv" == 1 ]; then
      usr_pid_inv
    fi
  fi
  if [ "$c" == 1 && "$pid" == 0 && "$count" == 0 ]; then
    usr_c
    if [ "$inv" == 1]; then
      usr_c_inv
    fi
  fi
  if [ "$inv" == 1 && "$c" == 0 && "$pid" == 0 && "$count" == 0 ]; then
    usr_inv
  fi
fi

if [ "$u" == 1 && "$usr" == 0 ]; 
  u_
  if [ "$count" == 1 ]; then
    u_count
    if [ "$pid" == 1 && "$c" == 0 ]; then
      u_count_pid
      if [ "$inv" == 1 ]; then
        u_count_pid_inv
      fi
    fi
    elif [ "$inv" == 1 && "$pid" == 0 && "$c" == 0 ]; then
      u_count_inv
    fi
    if [ "$c" == 1 && "$pid" == 0 ]; then
      u_count_c
      if [ "$inv" == 1]; then
        u_count_c_inv
      fi
    fi
  fi
  if [ "$pid" == 1 && "$count" == 0 &&  "$c" == 0 ]; then
    u_pid
    if [ "$inv" == 1 ]; then
      u_pid_inv
    fi
  fi
  if [ "$pid" == 0 && "$count" == 0 &&  "$c" == 1 ]; then
    u_c
    if [ "$inv" == 1]; then
      u_c_inv
    fi
  fi
  if [ "$inv" == 1 && "$c" == 0 && "$pid" == 0 && "$count" == 0 ]; then
    u_inv
  fi
fi

echo "$my_variable"