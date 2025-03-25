// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBlockchain {
    // Block structure representing a single block in the chain
    struct Block {
        uint index;              // Block number in the chain
        uint timestamp;          // Time of block creation
        string[] transactions;   // List of transactions in the block
        bytes32 previousHash;    // Hash of the previous block
        bytes32 hash;            // Hash of this block
        uint nonce;              // Nonce for Proof-of-Work
    }

    Block[] public chain;        // Array storing all blocks
    uint public difficulty = 1;  // PoW difficulty (1 leading zero byte)

    // Events for logging block addition and tampering detection
    event BlockAdded(uint indexed index, bytes32 hash, string[] transactions);
    event TamperingDetected(uint indexed index, bytes32 oldHash, bytes32 newHash);

    constructor() {}

    // Creates the first block (Genesis) with a dummy transaction
    function createGenesisBlock() public {
        require(chain.length == 0, "Genesis block already created");
        string[] memory genesisTransactions = new string[](1);
        genesisTransactions[0] = "Genesis Transaction";
        addBlock(genesisTransactions);
    }

    // Calculates hash of block data using keccak256
    function calculateHash(
        uint _index,
        uint _timestamp,
        string[] memory _transactions,
        bytes32 _previousHash,
        uint _nonce
    ) internal pure returns (bytes32) {
        bytes memory encodedTransactions = abi.encode(_transactions);
        return keccak256(abi.encodePacked(_index, _timestamp, encodedTransactions, _previousHash, _nonce));
    }

    // Mines a block by finding a hash with one leading zero byte
    function mineBlock(
        uint _index,
        string[] memory _transactions,
        bytes32 _previousHash
    ) internal view returns (Block memory) {
        uint timestamp = block.timestamp;
        uint nonce = 0;
        bytes32 hash;
        while (true) {
            hash = calculateHash(_index, timestamp, _transactions, _previousHash, nonce);
            if (isValidHash(hash)) {
                break;
            }
            nonce++;
            if (nonce > 1000) break; // Safety limit to prevent infinite loop
        }
        return Block(_index, timestamp, _transactions, _previousHash, hash, nonce);
    }

    // Checks if hash starts with one zero byte (simple PoW)
    function isValidHash(bytes32 _hash) internal pure returns (bool) {
        bytes memory hashBytes = abi.encodePacked(_hash);
        return hashBytes[0] == 0;
    }

    // Adds a new block to the chain with given transactions
    function addBlock(string[] memory _transactions) public {
        uint index = chain.length;
        bytes32 previousHash = (index == 0) ? bytes32(0) : chain[index - 1].hash;
        Block memory newBlock = mineBlock(index, _transactions, previousHash);
        chain.push();
        chain[index].index = newBlock.index;
        chain[index].timestamp = newBlock.timestamp;
        chain[index].transactions = newBlock.transactions;
        chain[index].previousHash = newBlock.previousHash;
        chain[index].hash = newBlock.hash;
        chain[index].nonce = newBlock.nonce;
        emit BlockAdded(newBlock.index, newBlock.hash, newBlock.transactions);
    }

    // Validates chain integrity by checking hashes and links
    function isChainValid() public view returns (bool) {
        for (uint i = 1; i < chain.length; i++) {
            Block memory current = chain[i];
            Block memory previous = chain[i - 1];
            bytes32 recalculatedHash = calculateHash(
                current.index,
                current.timestamp,
                current.transactions,
                current.previousHash,
                current.nonce
            );
            if (current.hash != recalculatedHash) {
                return false;
            }
            if (current.previousHash != previous.hash) {
                return false;
            }
        }
        return true;
    }

    // Tampers with a block’s transactions to test validation
    function tamperWithBlock(uint _index, string[] memory _newTransactions) public {
        require(_index < chain.length, "Block does not exist");
        Block storage blockToTamper = chain[_index];
        bytes32 oldHash = blockToTamper.hash;
        blockToTamper.transactions = _newTransactions;
        blockToTamper.hash = calculateHash(
            blockToTamper.index,
            blockToTamper.timestamp,
            _newTransactions,
            blockToTamper.previousHash,
            blockToTamper.nonce
        );
        emit TamperingDetected(_index, oldHash, blockToTamper.hash);
    }

    // Returns the current length of the chain
    function getChainLength() public view returns (uint) {
        return chain.length;
    }
}
