#!/bin/bash

set -x
cd ../
rm -rf  `ls ./ |grep -v -E 'Readme|src|git|progress'`

cd ./src
rm -rf public
hugo

mv public/* ../

