#!/usr/bin/env bash
set -e
docker run --rm -v "$PWD":/work -w /work ghcr.io/kicad/kicad:10.0-full \
  kicad-cli sch erc --format report --units mm --severity-all \
  --output /work/erc-local.rpt pcb-psu-led.kicad_sch
cat erc-local.rpt
