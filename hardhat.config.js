require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.17",
      },
      {
        version: "0.8.1",
        settings: {},
      },
    ],
  },

  networks: {
    goerli: {
      url: process.env.STAGING_QUICKNODE_KEY,
      accounts: [process.env.PRIVATE_KEY],
    },
    mumbai: {
      url: process.env.ALCHEMY_POLYGON_MUMBAI_TESTNET,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
