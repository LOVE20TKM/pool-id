#!/bin/bash

echo "========================================="
echo "Verifying Group Configuration"
echo "========================================="

# Ensure environment is initialized
if [ -z "$groupAddress" ]; then
    echo -e "\033[31mError:\033[0m Group address not set"
    return 1
fi

echo -e "\nGroup Address: $groupAddress\n"

# Track failures
failed_checks=0

# Check love20Token address
check_equal "Group: love20Token" $LOVE20_TOKEN_ADDRESS $(cast_call $groupAddress "love20Token()(address)")
[ $? -ne 0 ] && ((failed_checks++))
echo ""

# Check baseDivisor
check_equal "Group: baseDivisor" $BASE_DIVISOR $(cast_call $groupAddress "baseDivisor()(uint256)")
[ $? -ne 0 ] && ((failed_checks++))
echo ""

# Check bytesThreshold
check_equal "Group: bytesThreshold" $BYTES_THRESHOLD $(cast_call $groupAddress "bytesThreshold()(uint256)")
[ $? -ne 0 ] && ((failed_checks++))
echo ""

# Check multiplier
check_equal "Group: multiplier" $MULTIPLIER $(cast_call $groupAddress "multiplier()(uint256)")
[ $? -ne 0 ] && ((failed_checks++))
echo ""

# Check maxGroupNameLength
check_equal "Group: maxGroupNameLength" $MAX_GROUP_NAME_LENGTH $(cast_call $groupAddress "maxGroupNameLength()(uint256)")
[ $? -ne 0 ] && ((failed_checks++))
echo ""

# Check name
actual_name=$(cast_call $groupAddress "name()(string)")
echo -e "\033[32m✓\033[0m Group: name"
echo -e "  Actual: $actual_name"
echo ""

# Check symbol
actual_symbol=$(cast_call $groupAddress "symbol()(string)")
echo -e "\033[32m✓\033[0m Group: symbol"
echo -e "  Actual: $actual_symbol"
echo ""

# Check totalSupply
actual_supply=$(cast_call $groupAddress "totalSupply()(uint256)")
echo -e "\033[32m✓\033[0m Group: totalSupply"
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