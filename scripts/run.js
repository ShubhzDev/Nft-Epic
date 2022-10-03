const main = async () => {
  const contractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  const nftContract = await contractFactory.deploy();
  await nftContract.deployed();

  console.log("contract deployed to : ", nftContract.address);

  let nftTxn = await nftContract.makeEpicNft();
  nftTxn.wait();

  nftTxn = await nftContract.getNftRatio();
  console.log("nftTxn : ", nftTxn);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
