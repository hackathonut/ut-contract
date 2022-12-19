import "dotenv/config";
import "@typechain/hardhat"
import "@openzeppelin/hardhat-upgrades"
import "hardhat-deploy-ethers"
import "hardhat-deploy"
import "hardhat-watcher"
import "hardhat-gas-reporter"
import "hardhat-contract-sizer"
import "hardhat-tracer"
import "solidity-coverage"
import "hardhat-abi-exporter"
import "@nomicfoundation/hardhat-chai-matchers";
import "@nomiclabs/hardhat-ethers";
import { HardhatUserConfig } from 'hardhat/types'

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.13",
    settings: {
      optimizer: {
        enabled: true,
        runs: 400,
      }
    },
  },
  networks: {
    // hardhat: { // https://hardhat.org/hardhat-network/guides/mainnet-forking.html
    //   forking: {
    //     url: "https://eth-mainnet.alchemyapi.io/v2/<key>",
    //     blockNumber: 11321231
    //   }
    // }
    bsc_testnet: {
      url: 'https://data-seed-prebsc-1-s1.binance.org:8545/',
      chainId: 97,
      gasPrice: 20000000000,
      saveDeployments: true,
      tags: ["staging"],
      accounts: [process.env.DEPLOYER_PK || ""] // account private key 
    }
  },
  typechain: {
    target: "ethers-v5",
    outDir: "typechain/ethers-v5"
  },
  watcher: {
    compilation: {
      tasks: ['compile'],
      files: ['./contracts'],
      verbose: true,
    }
  },
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: false,
    strict: true,
  },
  namedAccounts: {
    deployer: {
      default: 0
    }
  },
  mocha: {
    timeout: 400000
  },
  gasReporter: {
    enabled: true,
    onlyCalledMethods: true,
    rst: true,
  },
  abiExporter: {
    path: './abi',
    runOnCompile: true,
    clear: true,
    spacing: 2,
    format: "json"
  }
}

export default config;