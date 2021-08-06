pragma solidity 0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

interface ICounter {
    function counter() external view returns (uint256);
}

contract ReactiveNFT is ERC721('Reactive NFT', 'RNFT'){
    uint256 public storageCounter;
    ICounter public counterContract = ICounter(0x9839408CE6434bE0E4C7c1BF9992F427Fa515F85);
    uint8 cooldown = 120;
    uint40 lastTimestamp;
    
    modifier canActivate() {
        require(_checkCooldown(), "On cooldown");
        _;
    }
    
    function checkUpkeep(bytes calldata checkData) external view returns (bool,bytes memory) {
        if (_checkCooldown()) return (true, '');
        return (false, '');
    }
    
    function performUpkeep(bytes calldata performData) external canActivate {
        storageCounter = counterContract.counter();
        lastTimestamp = uint40(block.timestamp);
    }
    
    function _checkCooldown() internal view returns (bool) {
        if (block.timestamp > lastTimestamp + cooldown) return true;
        return false;
    }
}
