# Biannce Chain testnet 0.5.8 Run Notes

This binary should be ONLY used for testnet.

For run instrumentation please refer to https://docs.binance.org/fullnode.html

This version only support start with [state sync](https://docs.binance.org/fullnode.html#state-sync) and get synced since height [8773270](https://testnet-explorer.binance.org/block/8773270). (Full node for PROD network would be compatible from height 1).

NOTES:
log might stuck on "start write recovery chunk" during statesync, please be patient, after about 20 min, it would continue print more logs
