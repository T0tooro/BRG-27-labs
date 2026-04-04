#!/bin/bash

# System monitoring script
echo "=============================="
echo "System Monitoring Report"
echo "=============================="
echo "Current User: $(whoami)"
echo ""
echo "--- Disk Usage ---"
df -h
echo ""
echo "--- Memory Usage ---"
free -h
echo "=============================="
