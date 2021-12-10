pragma solidity ^0.8.0;

import "./Ownable.sol";

contract ZombieFactory is Ownable {

	event NewZombie(uint zombieId, string name, uint dna);

	uint dnaDigits = 16;
	uint dnaModulus = 10 ** dnaDigits;
	uint cooldownTime = 1 days;

	struct Zombie {
		string name;
		uint dna;
		uint32 level; //using smallers uint and putting them together will save gas in structs. 
		uint32 readyTime;
		uint16 winCount;
    uint16 lossCount;
	}

	Zombie[] public zombies;

	mapping (uint => address) public zombieToOwner;
	mapping (address => uint) ownerZombieCount;

	//Function visibility: 
	// - public: function is public, can be called from outside the contract
	// - private: function can only be called inside this contract.
	// - internal: is the same as private, except that it's also accessible to contracts that inherit from this contract.
	// - external is similar to public, except that these functions can ONLY be called outside the contract — they can't be called by other functions inside that contract. 
	
	function _createZombie(string memory _name, uint _dna) internal {
		uint32 nextDay = uint32(now + cooldownTime);
		Zombie memory newZombie = Zombie(_name, _dna, 1, nextDay,0 ,0);
		zombies.push(newZombie); 
		uint id = zombies.length;
		zombieToOwner[id] = msg.sender;
		ownerZombieCount[msg.sender]++;
		emit NewZombie(id, _name, _dna);
	}

	function _generateRandomDna(string memory _str) private view returns (uint) {
		uint rand = uint(keccak256(abi.encodePacked(_str)));
		return rand % dnaModulus;
	}

	function createRandomZombie(string memory _name) public {
		require(ownerZombieCount[msg.sender] == 0);
		uint randDna = _generateRandomDna(_name);
		_createZombie(_name, randDna);
	}

}