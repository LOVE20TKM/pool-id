#!/bin/bash

echo "========================================="
echo "Verifying PoolID Configuration"
echo "========================================="

# Ensure environment is initialized
if [ -z "$poolIdAddress" ]; then
    echo -e "\033[31mError:\033[0m PoolID address not set"
    return 1
fi

echo -e "\nPoolID Address: $poolIdAddress\n"

# Track failures
failed_checks=0

# Check love20Token address
check_equal "PoolID: love20Token" $LOVE20_TOKEN_ADDRESS $(cast_call $poolIdAddress "love20Token()(address)")
[ $? -ne 0 ] && ((failed_checks++))
echo ""

# Check baseDivisor
check_equal "PoolID: baseDivisor" $BASE_DIVISOR $(cast_call $poolIdAddress "baseDivisor()(uint256)")
[ $? -ne 0 ] && ((failed_checks++))
echo ""

# Check bytesThreshold
check_equal "PoolID: bytesThreshold" $BYTES_THRESHOLD $(cast_call $poolIdAddress "bytesThreshold()(uint256)")
[ $? -ne 0 ] && ((failed_checks++))
echo ""

# Check multiplier
check_equal "PoolID: multiplier" $MULTIPLIER $(cast_call $poolIdAddress "multiplier()(uint256)")
[ $? -ne 0 ] && ((failed_checks++))
echo ""

# Check maxPoolNameLength
check_equal "PoolID: maxPoolNameLength" $MAX_POOL_NAME_LENGTH $(cast_call $poolIdAddress "maxPoolNameLength()(uint256)")
[ $? -ne 0 ] && ((failed_checks++))
echo ""

# Check name
actual_name=$(cast_call $poolIdAddress "name()(string)")
echo -e "\033[32m✓\033[0m PoolID: name"
echo -e "  Actual: $actual_name"
echo ""

# Check symbol
actual_symbol=$(cast_call $poolIdAddress "symbol()(string)")
echo -e "\033[32m✓\033[0m PoolID: symbol"
echo -e "  Actual: $actual_symbol"
echo ""

# Check totalSupply
actual_supply=$(cast_call $poolIdAddress "totalSupply()(uint256)")
echo -e "\033[32m✓\033[0m PoolID: totalSupply"
echo -e "  Actual: $actual_supply"
echo ""

# Summary
echo "========================================="
if [ $failed_checks -eq 0 ]; then
    echo -e "\033[32m✓ All checks passed (8/8)\033[0m"
    echo "========================================="
    return 0
else
    echo -e "\033[31m✗ $failed_checks check(s) failed\033[0m"
    echo "========================================="
    return 1
fi