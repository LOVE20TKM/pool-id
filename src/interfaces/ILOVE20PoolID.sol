// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import {
    IERC721Enumerable
} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import {
    IERC721Metadata
} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

interface ILOVE20PoolIDEvents {
    // Emitted when a new pool ID is minted
    event PoolIDMinted(
        uint256 indexed tokenId,
        address indexed owner,
        string poolName,
        uint256 mintCost
    );
}

interface ILOVE20PoolIDErrors {
    error InvalidAddress();
    error PoolNameAlreadyExists();
    error PoolNameEmpty();
    error InvalidPoolName();
}

interface ILOVE20PoolID is
    IERC721Metadata,
    IERC721Enumerable,
    ILOVE20PoolIDEvents,
    ILOVE20PoolIDErrors
{
    // Mint a new pool ID with the given pool name
    function mint(string calldata poolName) external returns (uint256 tokenId);

    // Calculate the cost to mint a pool ID with the given pool name
    function calculateMintCost(
        string calldata poolName
    ) external view returns (uint256);

    // Get the pool name for a token ID
    function poolNameOf(uint256 tokenId) external view returns (string memory);

    // Check if a pool name is already used
    function isPoolNameUsed(
        string calldata poolName
    ) external view returns (bool);

    // Get token ID by pool name
    function tokenIdOf(
        string calldata poolName
    ) external view returns (uint256);

    // Get the LOVE20 token address
    function love20Token() external view returns (address);
}
