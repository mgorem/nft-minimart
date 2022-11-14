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

    // assert that newly created NFT's token uri is same as the one sent to the createNFT function
    const tokenID = receipt.events[0].args.tokenId;
    const mintedTokenURI = await nftMarket.tokenURI(tokenID);
    expect(mintedTokenURI).to.be.equal(tokenURI);

    // assert that owner of newly created nft is the actual user who initiated the transaction
    const ownerAddress = await nftMarket.ownerOf(tokenID);
    const signers = await ethers.getSigners();
    const currentAddress = await signers[0].getAddress();
    expect(ownerAddress).to.be.equal(currentAddress);
  })
});
