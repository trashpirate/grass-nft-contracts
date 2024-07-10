-include .env

.PHONY: all test clean deploy

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

# install dependencies
install :; forge install foundry-rs/forge-std --no-commit && forge install Cyfrin/foundry-devops --no-commit && forge install https://github.com/chiru-labs/ERC721A.git --no-commit && forge install OpenZeppelin/openzeppelin-contracts --no-commit

# update dependencies
update:; forge update

# compile
build:; forge build

# test
test :; forge test 

# test coverage
coverage:; @forge coverage --contracts src
coverage-report:; @forge coverage --contracts src --report debug > coverage.txt

# take snapshot
snapshot :; forge snapshot

# format
format :; forge fmt

# spin up local test network
anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

# spin up fork
fork :; @anvil --fork-url ${RPC_BASE_MAIN} --fork-block-number 16895866 --fork-chain-id 8453 --chain-id 123

# deployment
deploy-local: 
	@forge script script/deployment/DeployNFTContract.s.sol:DeployNFTContract --rpc-url ${RPC_LOCALHOST} --private-key ${DEFAULT_ANVIL_KEY} --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --broadcast 

deploy-token-testnet: 
	@forge script script/deployment/DeployERC20Token.s.sol:DeployERC20Token --rpc-url $(RPC_BASE_SEPOLIA) --account Grassy-Deployer --sender 0xa25c35fb88b40A8fFA1DeD934d494fc79339Cb1f --broadcast --verify --etherscan-api-key $(BASESCAN_KEY) -vvvv

deploy-testnet: 
	@forge script script/deployment/DeployNFTContract.s.sol:DeployNFTContract --rpc-url $(RPC_BASE_SEPOLIA) --account Grassy-Deployer --sender 0xa25c35fb88b40A8fFA1DeD934d494fc79339Cb1f --broadcast --verify --etherscan-api-key $(BASESCAN_KEY) -vvvv

deploy-mainnet: 
	@forge script script/deployment/DeployNFTContract.s.sol:DeployNFTContract --rpc-url $(RPC_BASE_MAIN) --account Grassy-Deployer --sender 0xa25c35fb88b40A8fFA1DeD934d494fc79339Cb1f --broadcast --verify --etherscan-api-key $(BASESCAN_KEY) -vvvv


# interaction
mint-testnet:
	@forge script script/interactions/Interactions.s.sol:MintNft --rpc-url $(RPC_BASE_SEPOLIA) --account Grassy-Deployer --sender 0xa25c35fb88b40A8fFA1DeD934d494fc79339Cb1f --broadcast

mint-batch-testnet:
	@forge script script/interactions/Interactions.s.sol:BatchMint --rpc-url $(RPC_BASE_SEPOLIA) --account Grassy-Deployer --sender 0xa25c35fb88b40A8fFA1DeD934d494fc79339Cb1f --broadcast


# security
slither :; slither ./src 


-include ${FCT_PLUGIN_PATH}/makefile-external