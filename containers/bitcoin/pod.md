# Run as pod 

podman pod create --name bitcoin-lightning

podman run -dt --pod bitcoin-lightning ubuntu

podman generate kube bitcoin-lightning

podman play kube pod.yaml


## Connect channels

lightning-cli connect 
lightning-cli fundchannel

### SvgPod1

id: 03dcb3f39cac6bb70dd485a4f82df6d32d45c4251bde3868cdc6a3b613848a5fc2
tor: dhm3myqgflypzycxgmk7kjxnrlwuqzq7fvlslbkaoqgkdqdqx7aiedid.onion

03dcb3f39cac6bb70dd485a4f82df6d32d45c4251bde3868cdc6a3b613848a5fc2@dhm3myqgflypzycxgmk7kjxnrlwuqzq7fvlslbkaoqgkdqdqx7aiedid.onion

rest: sey64znroedkalzu4p4sm6v25z3ldrdttaav7c5kmfhp6tabgtb2u3yd.onion
grcp: uzsopitmyytbg7ojz3pnnlwse2o4dhp3usp6wiyiaamy7yxqfcgebmad.onion

### SvgPod2

id: 028f2e7e9b9b230cb2c7cea629f8c71dfa5bc46a11badbd52328bb4219df0d065c
tor: gtrlbqw2s4k2ugjstek6e5boozogbjm2uqrot4d5a6m3n3ajtb7cs5yd.onion:9735

028f2e7e9b9b230cb2c7cea629f8c71dfa5bc46a11badbd52328bb4219df0d065c@gtrlbqw2s4k2ugjstek6e5boozogbjm2uqrot4d5a6m3n3ajtb7cs5yd.onion:9735

rest: qtkqb7w6c5a3s3htrsd2d4xkyuk5v7qncs4w45kq6tiffydsrgtgs4id.onion
grpc: tvc2sg3vk7fyv5qxwaomlqne6f4ce2wpmmiln2wfxlr67bgd2whdgwqd.onion


curl -6 https://ifconfig.co

2a01:799:422:e701:76d4:35ff:fee6:3c64
2a01:799:422:e701:363f:cf6e:39ef:f8a1
2a01:799:422:e701:cc9c:5fa0:e013:9d91

92.221.31.213