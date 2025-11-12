// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {PoolID} from "../src/PoolID.sol";

/**
 * @title DeployPoolID
 * @notice Deployment script for the PoolID contract
 */
contract DeployPoolID is Script {
    function run() external {
        address love20TokenAddress = vm.envAddress("LOVE20_TOKEN_ADDRESS");

        // Load PoolID parameters from environment (with defaults)
        uint256 baseDivisor = vm.envOr("BASE_DIVISOR", uint256(100000000));
        uint256 bytesThreshold = vm.envOr("BYTES_THRESHOLD", uint256(10));
        uint256 multiplier = vm.envOr("MULTIPLIER", uint256(10));
        uint256 maxPoolNameLength = vm.envOr(
            "MAX_POOL_NAME_LENGTH",
            uint256(64)
        );

        console2.log("=== Deployment Parameters ===");
        console2.log("LOVE20 Token Address:", love20TokenAddress);
        console2.log("Base Divisor:", baseDivisor);
        console2.log("Bytes Threshold:", bytesThreshold);
        console2.log("Multiplier:", multiplier);
        console2.log("Max Pool Name Length:", maxPoolNameLength);

        // Use keystore account (configured via --account flag)
        vm.startBroadcast();

        // Deploy PoolID contract with all parameters
        PoolID poolID = new PoolID(
            love20TokenAddress,
            baseDivisor,
            bytesThreshold,
            multiplier,
            maxPoolNameLength
        );

        console2.log("PoolID deployed at:", address(poolID));

        vm.stopBroadcast();

        // Save the deployed address to params file
        string memory network = vm.envOr("network", string("anvil"));
        string memory addressFile = string.concat(
            "script/network/",
            network,
            "/address.poolid.params"
        );

        string memory content = string.concat(
            "poolIdAddress=",
            vm.toString(address(poolID)),
            "\n"
        );

        vm.writeFile(addressFile, content);
        console2.log("Address saved to:", addressFile);

        console2.log("\n=== Deployment Summary ===");
        console2.log("PoolID Address:", address(poolID));
        console2.log("Network:", network);
        console2.log("\nConfiguration:");
        console2.log("  - LOVE20 Token:", love20TokenAddress);
        console2.log("  - Base Divisor:", baseDivisor);
        console2.log("  - Bytes Threshold:", bytesThreshold);
        console2.log("  - Multiplier:", multiplier);
        console2.log("  - Max Name Length:", maxPoolNameLength);
    }
}
