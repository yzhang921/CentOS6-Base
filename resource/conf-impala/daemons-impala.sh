#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
cd $curDir

source ../parser-params.sh

function init_impala() {
  echo "[WARN] init_impala: Do nothing..."
}

function start_impala() {
  echo "[INFO] Start statestored of impala cluster"
  service impala-state-store start

  echo "[INFO] Start catalog of impala cluster"
  service impala-catalog start
  
  echo "[INFO] Start impalad of impala cluster"
  pssh -h slaves -i "service impala-server start" | grep -v "Permanently added"
}

function stop_impala() {
  echo "[INFO] Stop statestored of impala cluster"
  service impala-state-store stop

  echo "[INFO] Stop catalog of impala cluster"
  service impala-catalog stop
  
  echo "[INFO] Stop impalad of impala cluster"
  pssh -h slaves -i "service impala-server stop" | grep -v "Permanently added"
}

if [ "$init" = "y" ]; then
    init_impala
fi

if [ "$start" = "y" ]; then
    start_impala
fi

if [ "$stop" = "y" ]; then
    stop_impala
fi

if [ "$restart" = "y" ]; then
    stop_impala
fi