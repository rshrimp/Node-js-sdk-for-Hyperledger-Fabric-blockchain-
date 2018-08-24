#!/bin/bash


jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
	echo
	exit 1
fi
starttime=$(date +%s)
#________________________________________________________________________________

echo -e '-----------------------\e[5;32;40m  Enroll  \e[m---------------------------------------------------------'
echo -e '\e[5;32;40m  Org1\e[m-'
ORG1_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Raj&orgName=org1')
echo $ORG1_TOKEN
ORG1_TOKEN=$(echo $ORG1_TOKEN | jq ".token" | sed "s/\"//g")
echo -e '\e[5;32;40m  Org2\e[m-'
ORG2_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Raj2&orgName=org2')
echo $ORG2_TOKEN
ORG2_TOKEN=$(echo $ORG2_TOKEN | jq ".token" | sed "s/\"//g")
echo -e '\e[5;32;40m  Org3\e[m-'
ORG3_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Raj3&orgName=org3')
echo $ORG3_TOKEN
ORG3_TOKEN=$(echo $ORG3_TOKEN | jq ".token" | sed "s/\"//g")
sleep 5
#________________________________________________________________________________
echo -e '-----------------------\e[5;32;40m Create Channel \e[m---------------------------------------------------------'
curl -s -X POST \
  http://localhost:4000/channels \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"channelName":"test",
	"channelConfigPath":"../artifacts/channel/test.tx"
}'
sleep 5
echo
#________________________________________________________________________________
echo -e '-----------------------\e[5;32;40m Join Channel  \e[m---------------------------------------------------------'
echo -e '\e[5;32;40m  Org1\e[m-'
curl -s -X POST \
  http://localhost:4000/channels/test/peers \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"]
}'
echo
echo -e '\e[5;32;40m  Org2\e[m-'
curl -s -X POST \
  http://localhost:4000/channels/test/peers \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"]
}'
echo
echo  -e '\e[5;32;40m  Org3\e[m-'
curl -s -X POST \
  http://localhost:4000/channels/test/peers \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0"]
}'
echo
#________________________________________________________________________________
echo  -e '-----------------------\e[5;32;40m Install chaincode  \e[m---------------------------------------------------------'
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1", "peer2"],
	"chaincodeName":"testchaincode",
	"chaincodePath":"github.com/transfer",
	"chaincodeVersion":"v0"
}'
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"],
	"chaincodeName":"testchaincode",
	"chaincodePath":"github.com/transfer",
	"chaincodeVersion":"v0"
}'
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0"],
	"chaincodeName":"testchaincode",
	"chaincodePath":"github.com/transfer",
	"chaincodeVersion":"v0"
}'
echo
#________________________________________________________________________________
echo   -e '-----------------------\e[5;32;40m Instantiate chaincode by Org1  \e[m---------------------------------------------------------'
curl -s -X POST \
  http://localhost:4000/channels/test/chaincodes \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"chaincodeName":"testchaincode",
	"chaincodeVersion":"v0",
	"args":[""]
}'
echo
#________________________________________________________________________________
echo  -e '--------\e[5;32;40m Invoke chaincode by Org3 3 times for 3 asset creations \e[m---------------------------------------------------------'
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/test/chaincodes/testchaincode \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"fcn":"createAsset",
	"args":["123","5 High Vista Drive CA 23456","John Doe"]
}')
echo "Transacton ID is $TRX_ID"

TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/test/chaincodes/testchaincode \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"fcn":"createAsset",
	"args":["456","456 Lovers Lane TX 78526","Alice"]
}')
echo "Transacton ID is $TRX_ID"
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/test/chaincodes/testchaincode \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"fcn":"createAsset",
	"args":["789","556 High Vista Dr MA 78867","Katy Perry"]
}')
echo "Transacton ID is $TRX_ID"
echo
#________________________________________________________________________________
#________________________________________________________________________________
echo  -e '--------\e[5;32;40m Invoke chaincode by Org3 3 times for 3 asset transfer \e[m---------------------------------------------------------'
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/test/chaincodes/testchaincode \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"fcn":"transferAsset",
	"args":["123","First Owner transfer"]
}')
echo "Transacton ID is $TRX_ID"

TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/test/chaincodes/testchaincode \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
		"fcn":"transferAsset",
		"args":["123","Second Owner transfer"]
}')
echo "Transacton ID is $TRX_ID"
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/test/chaincodes/testchaincode \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
		"fcn":"transferAsset",
		"args":["123","Third Owner transfer"]
}')
echo "Transacton ID is $TRX_ID"
echo
#________________________________________________________________________________
echo -e '-----------------------\e[5;32;40m Query chaincode  \e[m---------------------------------------------------------'
echo
curl -s -X GET \
  "http://localhost:4000/channels/test/chaincodes/testchaincode?peer=peer0&fcn=queryDetail&args=%5B%22123%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
#________________________________________________________________________________
#________________________________________________________________________________
echo -e '-----------------------\e[5;32;40m Dump Ledger  \e[m---------------------------------------------------------'
echo
curl -s -X GET \
  "http://localhost:4000/channels/test/chaincodes/testchaincode?peer=peer0&fcn=queryAll&args=%5B%22%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
#________________________________________________________________________________

echo -e '-----------------------\e[5;32;40m Query ChainInfo  \e[m---------------------------------------------------------'
echo
curl -s -X GET \
  "http://localhost:4000/channels/test?peer=peer0" \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json"
#________________________________________________________________________________
echo -e '-----------------------\e[5;32;40m  Installed Chaincodes  \e[m---------------------------------------------------------'

curl -s -X GET \
  "http://localhost:4000/chaincodes?peer=peer0&type=installed" \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json"
echo
echo
#________________________________________________________________________________
echo  -e '-----------------------\e[5;32;40m  Instantiated Chaincodes  \e[m---------------------------------------------------------'

curl -s -X GET \
  "http://localhost:4000/chaincodes?peer=peer1&type=instantiated" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
#________________________________________________________________________________
echo   -e '-----------------------\e[5;32;40m  Channels Chaincodes  \e[m---------------------------------------------------------'
echo
curl -s -X GET \
  "http://localhost:4000/channels?peer=peer0" \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json"
