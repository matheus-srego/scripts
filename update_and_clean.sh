#!/bin/bash

line="+`seq -s '-' 91 | tr -d [:digit:]`+"
jump_line="\n"

variable=false

main()
{
    if id_to_execute_now = true ; then
        sudo_enabled
        update
        clean
        space_memory
    fi
}

id_to_execute_now()
{
    while [ $variable = false ] ; do
        echo -e "Deseja executar o script agora? [s/n] \c"
        read option

        if [ -n $option ] ; then
            if [ $option = "s" ] || [ $option = "sim" ] || 
               [ $option = "S" ] || [ $option = "SIM" ] ; then
                variable=true
            elif [ $option = "n" ] || [ $option = "nao" ] || [ $option = "não" ] || 
                 [ $option = "N" ] || [ $option = "NAO" ] || [ $option = "NÃO" ] ; then
                variable=false
            else
                echo "Escolha uma opção válida. [s/n]"
                variable=false
            fi
        fi
        
    done
}

sudo_enabled()
{
    if [ sudo -n true 2>/dev/null ] ; then 
        echo -e "\n> Comando sudo HABILITADO.\n"
    else
        echo -e "\n> Comando sudo DESABILITADO.\n"
        echo -e "> Por favor insira a senha abaixo: "
        sudo -v
    fi
}

update()
{
    echo "Atualizando lista de pacotes (list-sources)."
    echo $line
    sudo apt-get update
    echo -e $line$jump_line

    sleep 2

    echo "Atualizando pacotes."
    echo $line
    sudo apt-get upgrade
    echo -e $line$jump_line

    sleep 2

    echo "Atualização geral (Remover, insalar ou atualizar pacotes, caso necessário)."
    echo $line
    sudo apt-get dist-upgrade -y
    echo -e $line$jump_line

    sleep 2
}

clean()
{
    echo "Limpando o repositório local dos arquivos."
    echo -e $line$jump_line
    sudo apt clean
    # ---

    sleep 2

    echo "Limpando pacotes mortos."
    echo $line
    sudo apt-get autoclean
    echo -e $line$jump_line

    sleep 2

    echo "Limpando dependências sem uso."
    echo $line
    sudo apt-get autoremove
    echo -e $line$jump_line

    sleep 2

    echo "Limpando cache do APT."
    echo $line
    sudo du -sh /var/cache/apt
    sudo du -sh /var/cache/apt/archives
    echo -e $line$jump_line

    sleep 2

    echo "Limpando Thumbnails."
    echo $line
    du -sh ~/.cache/thumbnails
    echo -e $line$jump_line

    sleep 2

    echo "Removendo versões não usadas do Kernel."
    echo $line
    sudo apt-get autoremove --purge
    echo -e $line$jump_line

    sleep 2

    echo "Limpando cache da RAM."
    echo $line

    #sudo sync; echo 1 > /proc/sys/vm/drop_caches
    echo "> Limpando apenas PageCache.."
    sync && sudo sh -c "echo 1 > /proc/sys/vm/drop_caches"
    echo " - - - "
    #sudo sync; echo 2 > /proc/sys/vm/drop_caches
    echo "> Limpando dentries e inodes.."
    sync && sudo sh -c "echo 2 > /proc/sys/vm/drop_caches"
    echo " - - - "
    #sudo sync; echo 3 > /proc/sys/vm/drop_caches
    echo "> Limpando PageCache, dentries e inodes.."
    sync && sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
    echo " - - - "

    echo -e $line$jump_line

    sleep 1
}

space_memory()
{
    echo " - - - Espaço de memória/disco pós limpeza - - - "
    echo "Verificando espaço consumido de cache APT."
    echo $line
    sudo du -sh /var/cache/apt
    echo -e $line$jump_line

    sleep 2

    echo "Espaço de memória disponível no disco."
    echo $line
    free -h
    echo -e $line$jump_line

    sleep 2

    echo "Verificando espaço consumido de cache APT."
    echo $line
    sudo du -sh /var/cache/apt
    echo -e $line$jump_line

    sleep 2

    echo "Espaço de memória disponível no disco."
    echo $line
    free -h
    echo -e $line$jump_line

    sleep 2

    echo "Espaço em disco (GB, MB, B) e informações sobre o sistema de arquivo."
    echo $line
    df -T
    echo $line$jump_line
}

main
