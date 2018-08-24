## Asset transfer

This is   setting up 2 orgs with 2 peers each and Org3 with 1 peer.  All the orgs are joined through node js SDK client


It includes all the requirements  as listed below.
1.  Using Solo orderer
2.  Fabric CA for certificates.
3.  _TLS is enabled_
4. It includes a node.js app for doing all the setup activities:


    * create channels
    * join peers into channels
    * install chaincodes
    * instantiate chaincodes
    * invoke transactions
    * query the ledger



 Node js app is a client invoking all the above activities for all peers/orgs

## Transfer Consortium Setup
1. Org1 and Org2 with 2 peers each and Org3 with one peer.
2. Pre-created Member Service Providers (MSP) for authentication and identification
3. An Orderer using Kafka broker
4. _Testchannel_ – this channel is public blockchain which all three orgs have read and write access to it.


#### Artifacts
* Crypto material has been generated and configured for all peers, the orderering node and CA containers.
* An Orderer genesis block (genesis.block) and channel configuration transaction (test.tx) has been pre generated.

## Testing

##### Terminal Window 1

`cd transferq3app (root folder)`

`./startServer.sh`



* This launches the required network.
* Installs the fabric-client and fabric-ca-client node modules
* And, starts the node app on PORT 4000

##### Terminal Window 2

In order for the following shell script to properly parse the JSON, you must install `jq`


`./setupNetwork.sh`

This scripts goes through and
  * enrolls org users,
  * creates channel,
  * join peers to channel,
  * installs chaincode,
  * instantiates chaincode,
  * invokes chaincode to create assets
  * invokes chaincode to transfer assets
  * and queries chaincode.


A sample output looks like this:

 -----------------------  Enroll  ---------------------------------------------------------
  Org1-
```{
  "success": true,
  "secret": "",
  "message": "Raj enrolled Successfully",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MjM1MjA5OTEsInVzZXJuYW1lIjoiUmFqIiwib3JnTmFtZSI6Im9yZzEiLCJpYXQiOjE1MjM0ODQ5OTF9.lv3FT-KRmMAEldoiGDxDgQ_X97EgZGLSDC__25__M4M"
}```

  Org2-
```{
  "success": true,
  "secret": "",
  "message": "Raj2 enrolled Successfully",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MjM1MjA5OTEsInVzZXJuYW1lIjoiUmFqMiIsIm9yZ05hbWUiOiJvcmcyIiwiaWF0IjoxNTIzNDg0OTkxfQ.niT0fM79bWSg2MIPF87o6DRNLFgxMoVgmyeuevc2koo"
}```

  Org3-
```{
  "success": true,
  "secret": "",
  "message": "Raj3 enrolled Successfully",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MjM1MjA5OTIsInVzZXJuYW1lIjoiUmFqMyIsIm9yZ05hbWUiOiJvcmczIiwiaWF0IjoxNTIzNDg0OTkyfQ.ZUxt_8rYSWR9RrKm6Gk664PgKvuDbSOkiZ9dgvC2F3Y"
}```
----------------------- Create Channel ---------------------------------------------------------

```{
  "success": true,
  "message": "Channel 'test' created Successfully"
}```

----------------------- Join Channel  ---------------------------------------------------------

  Org1-
```{
  "success": true,
  "message": "Successfully joined peers in organization org1 to the channel 'test'"
}```

  Org2-
```{
  "success": true,
  "message": "Successfully joined peers in organization org2 to the channel 'test'"
}```
  Org3-
```{
  "success": true,
  "message": "Successfully joined peers in organization org3 to the channel 'test'"
}```
----------------------- Install chaincode  ---------------------------------------------------------

Successfully Installed chaincode on organization org1

Successfully Installed chaincode on organization org2

Successfully Installed chaincode on organization org3

----------------------- Instantiate chaincode by Org1  ---------------------------------------------------------

Chaincode Instantiation is SUCCESS

-------- Invoke chaincode by Org3 3 times for 3 asset creations ---------------------------------------------------------

Transacton ID is 36fff9dd8de09d423b30cd261f01410b4495fd64d3e4fd0ba2ddffb04fc8ade1

Transacton ID is ae8602ea763c06410f8ba5ba0f607f160fa3f687e7d45b95911348d03622896d

Transacton ID is d71eef4c94f3ebee8618f3f245a5d074d37ebdba32b20c8d440de7abf072caf5

-------- Invoke chaincode by Org3 3 times for 3 asset transfer ---------------------------------------------------------
Transacton ID is 8b350b78fe013f42eb7cff5a0a426164c1091f690499230712f7e8ea714431d0

Transacton ID is 8805e00aacfa37d2b3fbe659af59159d30a52b44eb29097a9f49ca3632603c4a

Transacton ID is 631cfc255020f2f9b848756d1b8879f4e28ce7cf65d1c2ecc0ab5801c2c61194

----------------------- Query chaincode  ---------------------------------------------------------
```{
  "Snumber": "123",
  "Description": "5 High Vista Drive CA 23456",
  "Owner": "Third Owner transfer",
  "Status": "transferred",
  "TransactionHistory": {
    "createAsset": "Wed, 11 Apr 2018 22:17:27 UTC",
    "transferAssetWed, 11 Apr 2018 22:17:34 UTC": "Asset transferred from: John Doe to new owner: First Owner transfer on:Wed, 11 Apr 2018 22:17:34 UTC",
    "transferAssetWed, 11 Apr 2018 22:17:36 UTC": "Asset transferred from: First Owner transfer to new owner: Second Owner transfer on:Wed, 11 Apr 2018 22:17:36 UTC",
    "transferAssetWed, 11 Apr 2018 22:17:39 UTC": "Asset transferred from: Second Owner transfer to new owner: Third Owner transfer on:Wed, 11 Apr 2018 22:17:39 UTC"
  }
}```
----------------------- Dump Ledger  ---------------------------------------------------------
```
[
  {
    "Key": "123",
    "Record": {
      "Snumber": "123",
      "Description": "5 High Vista Drive CA 23456",
      "Owner": "Third Owner transfer",
      "Status": "transferred",
      "TransactionHistory": {
        "createAsset": "Wed, 11 Apr 2018 22:17:27 UTC",
        "transferAssetWed, 11 Apr 2018 22:17:34 UTC": "Asset transferred from: John Doe to new owner: First Owner transfer on:Wed, 11 Apr 2018 22:17:34 UTC",
        "transferAssetWed, 11 Apr 2018 22:17:36 UTC": "Asset transferred from: First Owner transfer to new owner: Second Owner transfer on:Wed, 11 Apr 2018 22:17:36 UTC",
        "transferAssetWed, 11 Apr 2018 22:17:39 UTC": "Asset transferred from: Second Owner transfer to new owner: Third Owner transfer on:Wed, 11 Apr 2018 22:17:39 UTC"
      }
    }
  },
  {
    "Key": "456",
    "Record": {
      "Snumber": "456",
      "Description": "456 Lovers Lane TX 78526",
      "Owner": "Alice",
      "Status": "Created",
      "TransactionHistory": {
        "createAsset": "Wed, 11 Apr 2018 22:17:29 UTC"
      }
    }
  },
  {
    "Key": "789",
    "Record": {
      "Snumber": "789",
      "Description": "556 High Vista Dr MA 78867",
      "Owner": "Katy Perry",
      "Status": "Created",
      "TransactionHistory": {
        "createAsset": "Wed, 11 Apr 2018 22:17:31 UTC"
      }
    }
  }
]```
----------------------- Query ChainInfo  ---------------------------------------------------------

```{"height":{"low":8,"high":0,"unsigned":true},"currentBlockHash":{"buffer":{"type":"Buffer","data":[8,8,18,32,44,7,30,105,44,235,94,6,119,252,112,112,27,39,80,111,0,193,32,32,97,253,53,55,51,41,209,0,36,245,92,221,26,32,94,159,12,150,149,73,223,227,205,10,72,196,139,212,157,124,47,216,147,92,21,166,165,152,33,189,192,25,51,97,41,123]},"offset":4,"markedOffset":-1,"limit":36,"littleEndian":true,"noAssert":false},"previousBlockHash":{"buffer":{"type":"Buffer","data":[8,8,18,32,44,7,30,105,44,235,94,6,119,252,112,112,27,39,80,111,0,193,32,32,97,253,53,55,51,41,209,0,36,245,92,221,26,32,94,159,12,150,149,73,223,227,205,10,72,196,139,212,157,124,47,216,147,92,21,166,165,152,33,189,192,25,51,97,41,123]},"offset":38,"markedOffset":-1,"limit":70,"littleEndian":true,"noAssert":false}}```

-----------------------  Installed Chaincodes  ---------------------------------------------------------

```["name: testchaincode, version: v0, path: github.com/transfer"]```

-----------------------  Instantiated Chaincodes  ---------------------------------------------------------

```["name: testchaincode, version: v0, path: github.com/transfer"]```
