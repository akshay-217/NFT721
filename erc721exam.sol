// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol"; and 
import "@openzeppelin/contracts/access/Ownable.sol"; and
import "@openzeppelin/contracts/utils/Counters.sol";

contract CustomERC721 is ERC721Enumerable, Ownable{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    uint256 public maxsupply;
    uint256 public minitPrice;
    address public minter;

    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI,
        uint256 _maxSupply,
        uint256 _mintprice)
        ERC721(name,symbol){
            _baseTokenURI =baseTokenURI;
            maxSupply = _maxSupply;
            minitPrice = _mintprice;
        }

         string private _baseTokenURI;

        modifier notSoldOut(){
            require(totalSupply()<maxSupply,"no more NFTs available");
            _;
        }
        modifier onlyMinter(){
            require(msg.sender==minter,"caller is not allowed miner");
            _;
        }
        function setBaseURI(string memory baseTokenURI)external onlyOwner{
            _baseTokenURI=baseTokenURI;

        }
        function mint() external payable notSoldOut{
            require(msg.value >= mintPrice,"insufficient payment");
            _internalMint(msg.sender);
        }
        function setMintPrice (uint256 _newMintPrice) external onlyOwner{
            mintPrice=_newMintPrice;
        }
        function setMinter(address _newMInter)external onlyOwner{
            minter=_newMinter;
        }
        function _internalMint(address to)internal{
            _tokenidCounter.increment();
            uint256 newTokenId=_tokenIdCounter.current();
            require(!_exists(newTokenId),"token alreadt exists");
            _mint(to,newTokenId);
        }
        function withdrawn()external onlyOwner{
            uint256 balance=address(this).balance;
            require(balance>0,"no balance to withdrawn");
            (bool success,)=msg.saender.call{value:balance}("");
            require(success,"withdrawn failed");
        }
}


    
