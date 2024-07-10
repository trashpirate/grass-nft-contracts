// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {ERC20Token} from "../../src/ERC20Token.sol";
import {NFTContract} from "./../../src/NFTContract.sol";

contract HelperConfig is Script {
    // deployment arguments

    string public constant NAME = "Touch Grassy";
    string public constant SYMBOL = "GRASSY";
    string public constant BASE_URI = "ipfs://bafybeidunoa4h3e5kvddib6gi53nhmbm32lzvcaxqccdforsiih2mwubky/";
    string public constant CONTRACT_URI = "ipfs://bafkreiez4tklbxcv5e45s5zed5l2x2atmf7d26lfuo42xbbddnlppnzngm";
    uint256 public constant MAX_SUPPLY = 1000;
    uint96 public constant ROYALTY = 500;

    uint256 public constant ETH_FEE = 0;
    uint256 public constant TOKEN_FEE = 200_000 ether;

    // chain configurations
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        NFTContract.ConstructorArguments args;
    }

    constructor() {
        if (block.chainid == 8453 || block.chainid == 123) {
            activeNetworkConfig = getMainnetConfig();
        } else if (block.chainid == 84532 || block.chainid == 84531) {
            activeNetworkConfig = getTestnetConfig();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function getActiveNetworkConfigStruct() public view returns (NetworkConfig memory) {
        return activeNetworkConfig;
    }

    function getMainnetConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            args: NFTContract.ConstructorArguments({
                name: NAME,
                symbol: SYMBOL,
                owner: 0xa25c35fb88b40A8fFA1DeD934d494fc79339Cb1f,
                feeAddress: 0xa839967C96197521C19b6926aeB731A59CaE6E2B,
                tokenAddress: 0xBb4f69A0FCa3f63477B6B3b2A3E8491E5425A356,
                ethFee: ETH_FEE,
                tokenFee: TOKEN_FEE,
                baseURI: BASE_URI,
                contractURI: CONTRACT_URI,
                maxSupply: MAX_SUPPLY,
                royaltyNumerator: ROYALTY
            })
        });
    }

    function getTestnetConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            args: NFTContract.ConstructorArguments({
                name: NAME,
                symbol: SYMBOL,
                owner: 0xa25c35fb88b40A8fFA1DeD934d494fc79339Cb1f,
                feeAddress: 0xa839967C96197521C19b6926aeB731A59CaE6E2B,
                tokenAddress: 0xE9e5d3F02E91B8d3bc74Cf7cc27d6F13bdfc0BB6,
                ethFee: ETH_FEE,
                tokenFee: TOKEN_FEE,
                baseURI: BASE_URI,
                contractURI: CONTRACT_URI,
                maxSupply: MAX_SUPPLY,
                royaltyNumerator: ROYALTY
            })
        });
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        // Deploy mock contracts
        vm.startBroadcast();
        ERC20Token token = new ERC20Token();
        vm.stopBroadcast();

        return NetworkConfig({
            args: NFTContract.ConstructorArguments({
                name: NAME,
                symbol: SYMBOL,
                owner: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
                feeAddress: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
                tokenAddress: address(token),
                ethFee: ETH_FEE,
                tokenFee: TOKEN_FEE,
                baseURI: BASE_URI,
                contractURI: CONTRACT_URI,
                maxSupply: MAX_SUPPLY,
                royaltyNumerator: ROYALTY
            })
        });
    }
}
