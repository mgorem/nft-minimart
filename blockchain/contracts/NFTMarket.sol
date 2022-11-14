// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";

struct NFTListing {
    uint256 price;
    address seller;
}

contract NFTMarket is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDs;
    using SafeMath for uint256;
    mapping(uint256 => NFTListing) private _listings;

    constructor() ERC721("Orem's NFTs", "ONFT") {}

    // function to create NFT
    function createNFT(string calldata tokenURI) public returns (uint256) {
        _tokenIDs.increment();
        uint256 currentId = _tokenIDs.current();

        _safeMint(msg.sender, currentId);
        _setTokenURI(currentId, tokenURI);
        return currentId;
    }

    // function to create NFT
    function listNFT(uint256 tokenID, uint256 price) public {
        require(price > 0, "NFTMarket: Price must be greater than 0");
        // approving contract to transfer this token ownership
        // asserting that the address initiating this transaction is the owner of the nft
        approve(address(this), tokenID);
        // transfer ownership of NFT to NFTMarket
        transferFrom(msg.sender, address(this), tokenID);
        _listings[tokenID] = NFTListing(price, msg.sender);
    }

    function buyNFT(uint256 tokenID) public payable {
        NFTListing memory listing = _listings[tokenID];
        require(listing.price > 0, "NFTMarket: nft not listed for sale");
        require(msg.value == listing.price, "NFTMarket: incorrect price");
        ERC721(address(this)).transferFrom(address(this), msg.sender, tokenID);
        // clearListing(tokenID);
        payable(listing.seller).transfer(listing.price.mul(95).div(100));
        // emit NFTTransfer(tokenID, address(this), msg.sender, "", 0);
    }
}
