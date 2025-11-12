#!/bin/bash

# ------ Validate network parameter ------
export network=$1
if [ -z "$network" ] || [ ! -d "../network/$network" ]; then
    echo -e "\033[31mError:\033[0m Network parameter is required."
    echo -e "\nAvailable networks:"
    for net in $(ls ../network); do
        echo "  - $net"
    done
    return 1
fi

echo -e "\n========================================="
echo -e "  One-Click Deploy PoolID"
echo -e "  Network: $network"
echo -e "=========================================\n"

# ------ Step 1: Initialize environment ------
echo -e "\n[Step 1/4] Initializing environment..."
source 00_init.sh $network
if [ $? -ne 0 ]; then
    echo -e "\033[31mError:\033[0m Failed to initialize environment"
    return 1
fi

# ------ Step 2: Deploy PoolID ------
echo -e "\n[Step 2/4] Deploying PoolID..."
forge_script_deploy_pool_id
if [ $? -ne 0 ]; then
    echo -e "\033[31mError:\033[0m Deployment failed"
    return 1
fi

# Load deployed address
source $network_dir/address.poolid.params
if [ -z "$poolIdAddress" ]; then
    echo -e "\033[31mError:\033[0m PoolID address not found"
    return 1
fi
echo -e "\033[32m✓\033[0m PoolID deployed at: $poolIdAddress"

# ------ Step 3: Verify contract (for thinkium70001 networks) ------
if [[ "$network" == thinkium70001* ]]; then
    echo -e "\n[Step 3/4] Verifying contract on explorer..."
    source 03_verify.sh
    if [ $? -ne 0 ]; then
        echo -e "\033[33mWarning:\033[0m Contract verification failed (deployment is still successful)"
    else
        echo -e "\033[32m✓\033[0m Contract verified successfully"
    fi
else
    echo -e "\n[Step 3/4] Skipping contract verification (not a thinkium network)"
fi

# ------ Step 4: Run deployment checks ------
echo -e "\n[Step 4/4] Running deployment checks..."
source 99_check.sh
if [ $? -ne 0 ]; then
    echo -e "\033[31mError:\033[0m Deployment checks failed"
    return 1
fi

echo -e "\n========================================="
echo -e "\033[32m✓ Deployment completed successfully!\033[0m"
echo -e "========================================="
echo -e "PoolID Address: $poolIdAddress"
echo -e "LOVE20 Token Address: $LOVE20_TOKEN_ADDRESS"
echo -e "Network: $network"
echo -e "=========================================\n"