// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {PoolID} from "../src/PoolID.sol";
import {ILOVE20Token} from "@core/interfaces/ILOVE20Token.sol";

/**
 * @title MintPoolIDExample
 * @notice Example script demonstrating how to mint a Pool ID
 */
contract MintPoolIDExample is Script {
    function run() external {
        uint256 userPrivateKey = vm.envUint("PRIVATE_KEY");
        address poolIDAddress = vm.envAddress("POOL_ID_ADDRESS");
        string memory poolName = vm.envString("POOL_NAME");

        PoolID poolID = PoolID(poolIDAddress);
        address love20Token = poolID.love20Token();

        vm.startBroadcast(userPrivateKey);

        // Calculate mint cost
        uint256 mintCost = poolID.calculateMintCost(poolName);
        console2.log("Pool Name:", poolName);
        console2.log("Mint Cost:", mintCost);
        console2.log("Mint Cost in LOVE20:", mintCost / 1e18);

        // Check if pool name is already used
        bool isUsed = poolID.isPoolNameUsed(poolName);
        if (isUsed) {
            console2.log("ERROR: Pool name already exists!");
            vm.stopBroadcast();
            return;
        }

        // Approve LOVE20 tokens
        ILOVE20Token(love20Token).approve(poolIDAddress, mintCost);
        console2.log("Approved LOVE20 tokens");

        // Mint Pool ID
        uint256 tokenId = poolID.mint(poolName);
        console2.log("Successfully minted Pool ID!");
        console2.log("Token ID:", tokenId);
        console2.log("Owner:", poolID.ownerOf(tokenId));

        vm.stopBroadcast();

        console2.log("\n=== Mint Summary ===");
        console2.log("Pool ID Address:", poolIDAddress);
        console2.log("Token ID:", tokenId);
        console2.log("Pool Name:", poolID.poolNameOf(tokenId));
        console2.log("Owner:", poolID.ownerOf(tokenId));
        console2.log("Total Supply:", poolID.totalSupply());
    }
}

