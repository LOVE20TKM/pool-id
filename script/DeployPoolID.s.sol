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
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address love20TokenAddress = vm.envAddress("LOVE20_TOKEN_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy PoolID contract with LOVE20 token address
        PoolID poolID = new PoolID(love20TokenAddress);
        console2.log("PoolID deployed at:", address(poolID));
        console2.log("LOVE20 token address:", love20TokenAddress);

        vm.stopBroadcast();

        console2.log("\n=== Deployment Summary ===");
        console2.log("PoolID Address:", address(poolID));
        console2.log("LOVE20 Token Address:", love20TokenAddress);
    }
}

