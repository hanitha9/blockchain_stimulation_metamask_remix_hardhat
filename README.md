# Blockchain Simulation using Solidity, Remix, and Hardhat

## Introduction
This project is a **Simple Blockchain Simulation** implemented in **Solidity**. It demonstrates core blockchain concepts, including **block structure, hashing, chain validation, and proof-of-work (PoW)**. The project can be tested using **Remix IDE** and deployed locally using **Hardhat**. We also use **MetaMask** to interact with the contract on a simulated Ethereum network.

## Features
- **Block Structure**: Includes index, timestamp, data, previous hash, current hash, and nonce.
- **Hashing**: Uses `keccak256` to generate block hashes.
- **Blockchain Management**: Adds blocks, verifies integrity, and detects tampering.
- **Proof-of-Work**: Requires the block’s hash to meet a difficulty condition.
- **MetaMask Integration**: Connects to a local Hardhat node for testing.

---

## **Prerequisites**
Ensure you have the following installed:
- **Node.js (v16 or higher)** – [Download Here](https://nodejs.org/en/download/)
- **npm (Comes with Node.js)** – Check by running:
  ```sh
  node -v
  npm -v
  ```
- **MetaMask** – [Download Here](https://metamask.io/)

---

## **Step 1: Deploy the Contract Using Remix & MetaMask**

### **1. Open Remix and Paste Solidity Code**
1. Go to [Remix IDE](https://remix.ethereum.org/)
2. Create a new file **`SimpleBlockchain.sol`**
3. Paste the Solidity contract code.

### **2. Compile the Contract**
1. Click on the **Solidity Compiler (⚙️) tab**
2. Set **Compiler Version** to `0.8.x`
3. Click **Compile SimpleBlockchain.sol**

### **3. Deploy the Contract**
1. Go to **Deploy & Run Transactions (💰 tab)**
2. Under **Environment**, select **Injected Web3 (MetaMask)**
3. Click **Deploy**
4. Approve the transaction in MetaMask

### **4. Test the Functions in Remix**
Once deployed, test these functions:

#### **Check Initial Blockchain State**
- Click **getBlockCount()** → Should return `1` (Genesis block)
- Click **isChainValid()** → Should return `true`

#### **Add a Block**
1. In `addBlock()`, enter **`"Transaction: Alice sent 3 ETH to Bob"`**
2. Click **Transact**
3. Click **getBlockCount()** → Should return `2`
4. Click **getBlock(1)** → Shows block details

#### **Tamper with a Block**
1. Click `tamperWithBlock(1, "Hacked Data")`
2. Click **isChainValid()** → Should return `false`

---

## **Step 2: Deploy Using Hardhat & MetaMask**

### **1. Set Up Hardhat Project**
```sh
mkdir blockchain-hardhat
cd blockchain-hardhat
npx hardhat
```
- Select **"Create a JavaScript project"** and accept defaults.

### **2. Install Dependencies**
```sh
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
```

### **3. Create and Edit Solidity Contract**
```sh
cd contracts
notepad SimpleBlockchain.sol
```
Paste the Solidity code and save.

### **4. Create Deployment Script**
Create `deploy.js` in the `scripts/` directory:
```sh
cd ..\scripts
notepad deploy.js
```
Paste the following:
```javascript
const hre = require("hardhat");

async function main() {
    const Blockchain = await hre.ethers.getContractFactory("SimpleBlockchain");
    const blockchain = await Blockchain.deploy();
    await blockchain.deployed();
    console.log("Contract deployed to:", blockchain.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
```
Save and close.

### **5. Start Hardhat Node**
```sh
npx hardhat node
```
Expected output:
```plaintext
Started HTTP and WebSocket JSON-RPC server at http://127.0.0.1:8545/

Accounts:
0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 (10000 ETH)
Private Key: 0xac0974...
```

### **6. Import Hardhat Account into MetaMask**
1. Open **MetaMask**
2. Click **Profile Icon > Import Account**
3. Paste **Private Key** from Hardhat node output
4. Click **Import** → Now MetaMask has test ETH.

### **7. Deploy Contract to Local Hardhat Node**
```sh
npx hardhat run scripts/deploy.js --network localhost
```
Expected output:
```plaintext
Contract deployed to: 0x1234...abcd
```

---

## **Expected Outputs**
| Action | Expected Output |
|--------|----------------|
| `getBlockCount()` | `1` initially, then increases with each block |
| `addBlock("New Block")` | New block is mined and added |
| `getBlock(1)` | Displays block details (index, hash, previous hash, etc.) |
| `isChainValid()` | `true` initially, `false` after tampering |
| `tamperWithBlock(1, "Hacked Data")` | Alters block data and invalidates chain |

---

## **Conclusion**
This project demonstrates:
✅ How a blockchain maintains **linked blocks** using hashes.  
✅ How to deploy a Solidity smart contract using **Remix & Hardhat**.  
✅ How to connect **MetaMask** to a local Hardhat test network.  
✅ How **Proof-of-Work (PoW)** affects mining difficulty.  

🚀 Now you can build and test your own blockchain in Solidity! 🚀

