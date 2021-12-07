pragma solidity ^0.8.0;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {

  modifier aboveLevel (uint _level, uint _zombieId){
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }

  // functions of type "view" that are called outside the contract will cost 0 gas to run 
  // because we are not changing anything in the blockchain
  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    //storage is expensive, memory is cheap, and in a view function, free
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i <= zombies.length; i++) {
      if(zombieToOwner[i] == _owner){
        result[counter] = zombies[i];
        counter++;
      }
    }
    return result;
  }

}
