// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract NFTMarket is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Orem's NFTs", "ONFT") {}

    // function to create NFT
    function createNFT(string calldata tokenURI) public returns (uint256) {
        _tokenIds.increment();
        uint256 currentId = _tokenIds.current();

        _safeMint(msg.sender, currentId);
        _setTokenURI(currentId, tokenURI);
        return currentId;
    }
}
