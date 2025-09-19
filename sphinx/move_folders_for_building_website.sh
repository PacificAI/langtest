#!/bin/bash

echo "Move _static"
files=$(grep -RiIl '_static' _build)
if [ -n "$files" ]; then
  echo "$files" | xargs sed -i 's/_static/static/g'
fi
mv _build/html/_static _build/html/static

echo "Move _autosummary"
files=$(grep -RiIl '_autosummary' _build)
if [ -n "$files" ]; then
  echo "$files" | xargs sed -i 's/_autosummary/autosummary/g'
fi
mv _build/html/_autosummary _build/html/autosummary

rm -rf _build/html/_sources
