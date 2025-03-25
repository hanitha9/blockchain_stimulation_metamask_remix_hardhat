const hre = require("hardhat");

async function main() {
  const SimpleBlockchain = await hre.ethers.getContractFactory("SimpleBlockchain");
  const blockchain = await SimpleBlockchain.deploy();
  await blockchain.waitForDeployment();
  console.log("SimpleBlockchain deployed to:", blockchain.target);
  console.log("----------------------------------------");

  await blockchain.createGenesisBlock();
  console.log("Genesis block created. Chain length:", (await blockchain.getChainLength()).toString());
  const genesisBlock = await blockchain.chain(0);
  console.log("Genesis Block:");
  console.log("  Index:", genesisBlock.index.toString());
  console.log("  Timestamp:", genesisBlock.timestamp.toString());
  console.log("  Hash:", genesisBlock.hash);
  console.log("----------------------------------------");

  await blockchain.addBlock(["Alice sends 10 ETH to Bob"]);
  console.log("Block #1 added. Chain length:", (await blockchain.getChainLength()).toString());
  const block1 = await blockchain.chain(1);
  console.log("Block #1:");
  console.log("  Index:", block1.index.toString());
  console.log("  Timestamp:", block1.timestamp.toString());
  console.log("  Hash:", block1.hash);
  console.log("  PreviousHash:", block1.previousHash);
  console.log("----------------------------------------");

  await blockchain.addBlock(["Bob sends 5 ETH to Charlie"]);
  console.log("Block #2 added. Chain length:", (await blockchain.getChainLength()).toString());
  const block2 = await blockchain.chain(2);
  console.log("Block #2:");
  console.log("  Index:", block2.index.toString());
  console.log("  Timestamp:", block2.timestamp.toString());
  console.log("  Hash:", block2.hash);
  console.log("  PreviousHash:", block2.previousHash);
  console.log("----------------------------------------");

  const isValidBefore = await blockchain.isChainValid();
  console.log("Chain validity before tampering:", isValidBefore);
  console.log("----------------------------------------");

  await blockchain.tamperWithBlock(1, ["Hacker steals 100 ETH"]);
  console.log("Block #1 tampered. Chain length:", (await blockchain.getChainLength()).toString());
  const tamperedBlock1 = await blockchain.chain(1);
  console.log("Block #1 (Tampered):");
  console.log("  Index:", tamperedBlock1.index.toString());
  console.log("  Timestamp:", tamperedBlock1.timestamp.toString());
  console.log("  Hash:", tamperedBlock1.hash);
  console.log("----------------------------------------");

  const isValidAfter = await blockchain.isChainValid();
  console.log("Chain validity after tampering:", isValidAfter);
  console.log("----------------------------------------");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
