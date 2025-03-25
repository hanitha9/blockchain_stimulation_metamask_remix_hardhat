// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBlockchain {
    struct Block {
        uint256 index;
        uint256 timestamp;
        string data;
        bytes32 previousHash;
        bytes32 hash;
        uint256 nonce;
    }

    Block[] public chain;
    uint256 public difficulty = 1; // Reduced difficulty for Remix
    uint256 public maxNonce = 1000; // Lower max nonce for testing

    event BlockAdded(uint256 index, bytes32 hash, string data);
    event ChainValidated(bool isValid);
    event TamperingDetected(uint256 index);

    constructor() {
        // Manually create genesis block (simplified)
        chain.push(Block({
            index: 0,
            timestamp: block.timestamp,
            data: "Genesis Block",
            previousHash: bytes32(0),
            hash: keccak256(abi.encodePacked(0, block.timestamp, "Genesis Block", bytes32(0), 0)),
            nonce: 0
        }));
    }

    function calculateHash(
        uint256 _index,
        uint256 _timestamp,
        string memory _data,
        bytes32 _previousHash,
        uint256 _nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_index, _timestamp, _data, _previousHash, _nonce));
    }

    function mineBlock(
        uint256 _index,
        string memory _data,
        bytes32 _previousHash
    ) internal view returns (Block memory) {
        uint256 nonce = 0;
        bytes32 hash;
        
        while (nonce < maxNonce) {
            hash = calculateHash(_index, block.timestamp, _data, _previousHash, nonce);
            if (uint256(hash) % (10 ** difficulty) == 0) { // Simplified PoW
                return Block(_index, block.timestamp, _data, _previousHash, hash, nonce);
            }
            nonce++;
        }
        revert("Mining failed");
    }

    function addBlock(string memory _data) public {
        uint256 index = chain.length;
        bytes32 previousHash = chain[index - 1].hash;
        
        Block memory newBlock = mineBlock(index, _data, previousHash);
        chain.push(newBlock);
        emit BlockAdded(index, newBlock.hash, _data);
    }

    function isChainValid() public view returns (bool) {
        for (uint256 i = 1; i < chain.length; i++) {
            Block memory current = chain[i];
            Block memory previous = chain[i - 1];
            
            bytes32 calculatedHash = calculateHash(
                current.index,
                current.timestamp,
                current.data,
                current.previousHash,
                current.nonce
            );
            
            if (current.hash != calculatedHash || current.previousHash != previous.hash) {
                return false;
            }
        }
        return true;
    }

    function tamperWithBlock(uint256 _index, string memory _newData) public {
        require(_index > 0 && _index < chain.length, "Invalid index");
        chain[_index].data = _newData;
        emit TamperingDetected(_index);
    }

    function getBlockCount() public view returns (uint256) {
        return chain.length;
    }
}
