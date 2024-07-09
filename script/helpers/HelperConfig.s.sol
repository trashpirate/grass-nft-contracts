// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {ERC20Token} from "../../src/ERC20Token.sol";
import {NFTContract} from "./../../src/NFTContract.sol";

contract HelperConfig is Script {
    // deployment arguments

    string public constant NAME = "Battlepillars";
    string public constant SYMBOL = "BATTLEPILLAR";
    string public constant BASE_URI = "ipfs://bafybeihvxdrut363rlk65caliu6utzyqo45cm6p5nelbl44hiclo4hhn2i/";
    string public constant CONTRACT_URI =
        "ipfs://bafybeieomuw57yvoi44xkg6zyfzohaxiblr4wv4iafhwnfgprzzc4ot5xa/contractMetadata";
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
                owner: 0x0d8470Ce3F816f29AA5C0250b64BfB6421332829,
                feeAddress: 0x0d8470Ce3F816f29AA5C0250b64BfB6421332829,
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
                owner: 0xA94D468Af30923169e8A146472C03f223dBeB8B0,
                feeAddress: 0x7Bb8be3D9015682d7AC0Ea377dC0c92B0ba152eF,
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
