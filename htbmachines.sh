#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c()
{
	echo -e "\n\n${redColour}[!] Saliendo...\n${endColour}\n"
	tput cnorm && exit 1
}

# Ctr+C
trap ctrl_c INT

# Variables gloables
main_url="https://htbmachines.github.io/bundle.js"

function helpPanel()
 {
 	echo -e "\n${yellowColour}[+]${endColour}${grayColour}Uso:${endColour}"
	echo -e "\t${purpleColour}u)${endColour}${grayColour} Descargar o actualizar archivos necesarios${endColour}"
	echo -e "\t${purpleColour}m)${endColour}${grayColour} Buscar por nombre de máquina${endColour}"
	echo -e "\t${purpleColour}i)${endColour}${grayColour} Buscar por dirección IP${endColour}"
	echo -e "\t${purpleColour}d)${endColour}${grayColour} Buscar por dirección dificultad${endColour}"
	echo -e "\t${purpleColour}o)${endColour}${grayColour} Buscar por sistema operativo${endColour}"
	echo -e "\t${purpleColour}y)${endColour}${grayColour} Obetener link de resolución de la máquína${endColour}"
	echo -e "\t${purpleColour}h)${endColour}${grayColour} Mostrar el panel de ayuda${endColour}"
	echo -e ""
 } 



function updateFiles()
{
	if [ ! -f bundle.js ]; then
		tput civis 
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando archivos necesarios...${endColour}"	
		curl -s $main_url > bundle.js
		js-beautify bundle.js | sponge bundle.js 
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Todos los archivos han sido descargados${endColour}"
		tput cnorm 
	else
		tput civis 
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comprobando si hay actualizaicones${endColour}"
		curl -s $main_url > bundle_temp.js
		js-beautify bundle_temp.js | sponge bundle_temp.js
		md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
		md5_original_value=$(md5sum bundle.js | awk '{print $1}')
		
		if [ "$md5_temp_value" == "$md5_original_value" ]; then
			echo -e "${yellowColour}[+]${endColour}${grayColour} No se han detectado actualizaciones${endColour}"
			rm bundle_temp.js
		else
			echo -e "\n${yellowColour}[+]${endColour}${grayColour} Hay actualizaciones disponibles${endColour}"
			sleep 1
			rm bundle.js && mv bundle_temp.js bundle.js
			echo -e "\n${greenColour}[+]${endColour}${grayColour} Los archivos han sido actualizados${endColour}"
		fi

		tput cnorm
	fi
}

function searchMachine()
{
	machineName="$1"
	machineName_checker="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//')"

	if [ "$machineName_checker" ]; then
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando las propiedades de la máquina${endColour}${blueColour} $machineName${endColour}${grayColour}:${endColour}\n"
		cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'
	else
			echo -e "\n${redColour}[!] La máquina proporcionada no existe.${endColour}"
	fi

}

function searchIp()
{
	ipAddress="$1"
	machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"

	if [ "$machineName" ]; then
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} La máquina correspondiente para la IP es${endColour}${blueColour} $ipAddress${endColour}${grayColour} es${endColour}${blueColour} $machineName${endColour}\n"
	else
		echo -e "\n${redColour}[!] La dirección IP proporcionada no existe.${endColour}"
	fi
}

function getYoutubeLink()
{
	machineName="$1"
	youtubeLink="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep youtube | awk 'NF{print $NF}')"
	if [ "$youtubeLink" ]; then
		echo -e "\n${yellowColour}[+]${endColour}${grayColour}El tutorial para la máquina seleccionada está en el siguiente enlace:${endColour}${blueColour} $youtubeLink${endColour}\n"
	else
		echo -e "\n${redColour}[!] La maquína proporcionada no existe${endColour}"
	fi
}

function getMachinesDifficulty()
{
	difficulty="$1"
	results_checks="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
	if [ "$results_checks" ]; then
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representando las máquinas que tienen un nivel de dificultad${endColour}${blueColour} $difficulty${endColour}${grayColour}:${endColour}\n"
		cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
	else
		echo -e "\n${redColour}[!] La dificultad incluida no existe"${endColour}
	fi 
}

function getOSMachines()
{
	os="$1"
	os_results="$(cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
	if [ "$os_results" ]; then
		echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Mostrando las máquinas que tienen el sistema operativo:${endColour} ${blueColour}$os${endColour}"
		# cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
		echo -e "$os_results"
	else
		echo -e "\n${redColour}[!] Sistema operativo no encontrado o no existe${endColour}"
	fi
}

function getOSDifficulty()
{
	difficulty="$1"
	os="$2"
	check_result="$(cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
	if [ "$check_result" ];then
		echo -e "\n${yellowColour}[+]${endColour} ${grayColour} Buscando por dificultad${endColour}${blueColour} $difficulty ${endColour}${grayColour}y sistema operativo${endColour}${blueColour} $os${endColour}"
		cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
	else
	echo -e "\n${redColour}[!] No se encontró ninguna máquina con las características mencionadas.${endColour}"
	fi
}

# Inidcadores
declare -i parameter_counter=0 

# Chivatos 
declare -i chivato_difficulty=0
declare -i chivato_os=0 

while getopts "m:ui:y:d:o:h" arg ; do
	case $arg in
		m) machineName=$OPTARG; let parameter_counter+=1;;
		u) let parameter_counter+=2;;
		i) ipAddress="$OPTARG"; let parameter_counter+=3;;
		y) machineName="$OPTARG"; let parameter_counter+=4;;
		d) difficulty="$OPTARG";chivato_difficulty=1; let parameter_counter+=5;;
		o) os="$OPTARG";chivato_os=1; let parameter_counter+=6;;
		h) ;;
	esac 
done

if [ $parameter_counter -eq 1 ]; then
	searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
	updateFiles
elif [ $parameter_counter -eq 3 ]; then
	searchIp $ipAddress
elif [ $parameter_counter -eq 4 ]; then
	getYoutubeLink $machineName 
elif [ $parameter_counter -eq 5 ]; then
	getMachinesDifficulty $difficulty 
elif [ $parameter_counter -eq 6 ]; then
	getOSMachines $os
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ]; then
	getOSDifficulty $difficulty $os 
else 
	helpPanel
fi 
