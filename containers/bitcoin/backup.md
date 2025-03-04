# Backup of lightning nodes

## LND

(LND backup)[https://github.com/lightningnetwork/lnd/blob/master/docs/recovery.md]

- the seed for on-chain

- ~/.lnd/data/chain/bitcoin/mainnet/channel.backup for static channel backup off-chain

## CLN

(CLN backup)[https://docs.corelightning.org/docs/backup]

- hsm_secret for on-chain
- emergency.recover file for static channel backup off-chain
- sqlite replication for channel state: `wallet=sqlite3:///home/user/.lightning/bitcoin/lightningd.sqlite3:/my/backup/lightningd.sqlite3`