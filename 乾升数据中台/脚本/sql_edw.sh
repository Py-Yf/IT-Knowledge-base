#!/bin/bash
export PYTHON_EGG_CACHE=./myeggs
impala-shell -f "relate_edw.sql"