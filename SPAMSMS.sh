#!/bin/bash

detect_distro() {
    if [[ "$OSTYPE" == linux-android* ]]; then
            distro="termux"
    fi

    if [ -z "$distro" ]; then
        distro=$(ls /etc | awk 'match($0, "(.+?)[-_](?:release|version)", groups) {if(groups[1] != "os") {print groups[1]}}')
    fi

    if [ -z "$distro" ]; then
        if [ -f "/etc/os-release" ]; then
            distro="$(source /etc/os-release && echo $ID)"
        elif [ "$OSTYPE" == "darwin" ]; then
            distro="darwin"
        else 
            distro="invalid"
        fi
    fi
}

pause() {
    read -n1 -r -p "Presiona Cualquiera Letra Para Salir..." key
}
banner() {
    clear
    echo -e "\e[1;31m"
    if ! [ -x "$(command -v figlet)" ]; then
        echo 'Introducing SpamX'
    else
        figlet SpamX
    fi
    if ! [ -x "$(command -v toilet)" ]; then
        echo -e "\e[4;34m Este SpammerDeSms Fue Creado Por \e[1;32mBloopy \e[0m"
    else
        echo -e "\e[1;34mCreated By \e[1;34m"
        toilet -f mono12 -F border SpamX
    fi
    echo -e "\e[1;34m For Any Queries Join Me!!!\e[0m"
    echo -e "\e[1;32m           Youtube: https://www.youtube.com/channel/UCGhxXKBmmOW1MRkEzftuh5Q \e[0m"
    echo -e "\e[4;32m   TikTok: https://www.youtube.com/channel/UCGhxXKBmmOW1MRkEzftuh5Q \e[0m"
    echo " "
    echo "NOTa: Free Fire."
    echo " "
}

init_environ(){
    declare -A backends; backends=(
        ["arch"]="pacman -S --noconfirm"
        ["debian"]="apt-get -y install"
        ["ubuntu"]="apt -y install"
        ["termux"]="apt -y install"
        ["fedora"]="yum -y install"
        ["redhat"]="yum -y install"
        ["SuSE"]="zypper -n install"
        ["sles"]="zypper -n install"
        ["darwin"]="brew install"
        ["alpine"]="apk add"
    )

    INSTALL="${backends[$distro]}"

    if [ "$distro" == "termux" ]; then
        PYTHON="python"
        SUDO=""
    else
        PYTHON="python3"
        SUDO="sudo"
    fi
    PIP="$PYTHON -m pip"
}

install_deps(){
    
    packages=(openssl git $PYTHON $PYTHON-pip figlet toilet)
    if [ -n "$INSTALL" ];then
        for package in ${packages[@]}; do
            $SUDO $INSTALL $package
        done
        $PIP install -r requirements.txt
    else
        echo "No pudimos instalar dependencias."
        echo "Asegúrese de tener git, python3, pip3 y los requisitos instalados."
        echo "Entonces puedes ejecutar SpamSms.py ."
        exit
    fi
}

banner
pause
detect_distro
init_environ
if [ -f .update ];then
    echo "All Requirements Found...."
else
    echo 'Installing Requirements....'
    echo .
    echo .
    install_deps
    echo Este script fue creado por Bloopy > .update
    echo 'Requirements Installed....'
    pause
fi
while :
do
    banner
    echo -e "\e[4;31m Please Read Instruction Carefully !!! \e[0m"
    echo " "
    echo "Presiona 1 Para  Iniciar Spam SMS "
    echo "Presiona 2 Para  Iniciar Spam Llamadas "
    echo "Presiona 3 Para  Iniciar MAIL Bomber (No Usable Ahorita)"
    echo "Presiona 4 Para  Update (Funciona en Linux y emuladores de Linux) "
    echo "Presiona 5 Para  Salir "
    read ch
    clear
    if [ $ch -eq 1 ];then
        $PYTHON bomber.py --sms
        exit
    elif [ $ch -eq 2 ];then
        $PYTHON bomber.py --call
        exit
    elif [ $ch -eq 3 ];then
        $PYTHON bomber.py --mail
        exit
    elif [ $ch -eq 4 ];then
        echo -e "\e[1;34m Downloading Latest Files..."
        rm -f .update
        $PYTHON bomber.py --update
        echo -e "\e[1;34m RUN SPAMSMS Otravez..."
        pause
        exit
    elif [ $ch -eq 5 ];then
        banner
        exit
    else
        echo -e "\e[4;32m Invalid Input !!! \e[0m"
        pause
    fi
done
