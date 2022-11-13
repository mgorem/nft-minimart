import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("NFTMarket", function () {
  it("Should Deploy NFT Market Contract", async () => {
    // Deploy NFTMarket Contract
    const NFTMarket = await ethers.getContractFactory("NFTMarket");
    const nftMarket = await NFTMarket.deploy();
    await nftMarket.deployed();

    // call createNFT function
    const tokenURI = "https://some-token.uri/";
    const transaction = await nftMarket.createNFT(tokenURI);
    const receipt = await transaction.wait();
    console.log(receipt);

    // assert nft has been created and its tokenURI
    // const tokenId = receipt.events[0].args.tokenID;
  })
});
