#!/bin/bash

CAMINHO_PADRAO=CAMINHO DA PASTA PADRAO
QUANTIDADE_AMBIENTES=1

declare -A ambientes

ambientes[0,0]="DESCRICAO DA IMAGEM"
ambientes[0,1]="NOME DA IMAGEM"
ambientes[0,2]=CAMINHO DO DOCKERFILE
ambientes[0,3]=PORTA HOST:PORTA CONTAINER

for ((i=0;i<$QUANTIDADE_AMBIENTES;i++))
do
    DESCRICAO=${ambientes[$i,0]}
    NOME_IMAGEM=${ambientes[$i,1]}
    CAMINHO=${ambientes[$i,2]}
    PORTAS=${ambientes[$i,3]}

    echo "+--------------------------------------------"
    echo "| ATUALIZANDO DOCKER: $DESCRICAO"
    echo "+--------------------------------------------"

    cd ${CAMINHO_PADRAO}${CAMINHO}

    CONTAINER_ID=$(docker container ls | grep "${NOME_IMAGEM}" | awk '{print $1}')
    if [ -n "$CONTAINER_ID" ];
    then
        echo "***** PARANDO A IMAGEM: $NOME_IMAGEM..."
        docker kill $CONTAINER_ID
    fi

    echo "***** BUILD DA IMAGEM DOCKER: $NOME_IMAGEM..."
    docker build --no-cache -t $NOME_IMAGEM .

    echo "***** RUN DA IMAGEM DOCKER: $NOME_IMAGEM..."
    docker run -d -p $PORTAS $NOME_IMAGEM

    echo ""
    echo "##################################"
    echo ""
done

docker rmi -f $(docker images -f "dangling=true" -q)
