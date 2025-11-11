// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {PoolID} from "../src/PoolID.sol";

/**
 * @title QueryPoolID
 * @notice Script to query Pool ID information
 */
contract QueryPoolID is Script {
    function run() external view {
        address poolIDAddress = vm.envAddress("POOL_ID_ADDRESS");
        PoolID poolID = PoolID(poolIDAddress);

        console2.log("=== Pool ID Contract Information ===");
        console2.log("Contract Address:", poolIDAddress);
        console2.log("Name:", poolID.name());
        console2.log("Symbol:", poolID.symbol());
        console2.log("LOVE20 Token:", poolID.love20Token());
        console2.log("Total Supply:", poolID.totalSupply());

        // Query specific token if TOKEN_ID is provided
        try vm.envUint("TOKEN_ID") returns (uint256 tokenId) {
            console2.log("\n=== Token Information ===");
            console2.log("Token ID:", tokenId);
            
            try poolID.ownerOf(tokenId) returns (address owner) {
                console2.log("Owner:", owner);
                console2.log("Pool Name:", poolID.poolNameOf(tokenId));
            } catch {
                console2.log("Token does not exist");
            }
        } catch {
            // TOKEN_ID not provided, skip
        }

        // Query specific pool name if POOL_NAME is provided
        try vm.envString("POOL_NAME") returns (string memory poolName) {
            console2.log("\n=== Pool Name Query ===");
            console2.log("Pool Name:", poolName);
            console2.log("Is Used:", poolID.isPoolNameUsed(poolName));
            
            uint256 tokenId = poolID.tokenIdOf(poolName);
            if (tokenId != 0) {
                console2.log("Token ID:", tokenId);
                console2.log("Owner:", poolID.ownerOf(tokenId));
            } else {
                console2.log("Pool name not registered");
            }
        } catch {
            // POOL_NAME not provided, skip
        }

        // Calculate mint cost for a name if CALCULATE_FOR is provided
        try vm.envString("CALCULATE_FOR") returns (string memory nameToCalculate) {
            console2.log("\n=== Mint Cost Calculation ===");
            console2.log("Pool Name:", nameToCalculate);
            console2.log("Byte Length:", bytes(nameToCalculate).length);
            
            uint256 cost = poolID.calculateMintCost(nameToCalculate);
            console2.log("Mint Cost (wei):", cost);
            console2.log("Mint Cost (LOVE20):", cost / 1e18);
        } catch {
            // CALCULATE_FOR not provided, skip
        }
    }
}

