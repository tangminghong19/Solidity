// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
    // calldata is somehow similar to memory, but it's only available to external functions.
    require(zombieToOwner[_zombieId] == msg.sender);
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(zombieToOwner[_zombieId] == msg.sender);
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns (uint[] memory) {
    // view functions don't cost any gas when they're called externally by a user.
    // If a view function is called internally from another function in the same contract that is not a view function, 
    // it will still cost gas. 
    // This is because the other function creates a transaction on Ethereum, 
    // and will still need to be verified from every node.

    // One of the more expensive operations in Solidity is using storage — particularly writes.
    // In most programming languages, looping over large data sets is expensive. 
    // But in Solidity, this is way cheaper than using storage if it's in an external view function, 
    // since view functions don't cost your users any gas.
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    // memory arrays must be created with a length argument. 
    // They currently cannot be resized like storage arrays can with array.push().
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if (zombiesToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }
}