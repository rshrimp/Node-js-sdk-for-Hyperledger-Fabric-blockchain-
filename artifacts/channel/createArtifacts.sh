#!/bin/bash

export FABRIC_START_WAIT=5
export FABRIC_CFG_PATH=./


echo -e "\e[5;32;40mgenerating certificates in crypto-config folder for all entities\e[m"
 cryptogen generate --config cryptogen.yaml
sleep ${FABRIC_START_WAIT}

echo -e "\e[5;32;40mgenerating geneis block\e[m "
configtxgen -profile TRANSFEROrdererGenesis -outputBlock genesis.block
sleep ${FABRIC_START_WAIT}
echo -e "\e[5;32;40mcreate the channel configuration blocks with this configuration file, by using the other profiles\e[m "

configtxgen -profile TestChannel -outputCreateChannelTx test.tx -channelID test
