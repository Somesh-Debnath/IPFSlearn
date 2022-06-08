//SPDX-License-Identifier: Unlicense

 pragma solidity ^0.8.4;

    import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
    import "@openzeppelin/contracts/access/Ownable.sol";
    import "@openzeppelin/contracts/utils/Strings.sol";
    contract LW3Punks is ERC721Enumerable,Ownable{
        using Strings for uint256;
        string public _baseTokenURI;
        uint256 public tokenID;
       uint256 public _maxTokenID=10;
       bool public _paused;
      uint256 public _price=0.01 ether;
      modifier onlyWhenNotPaused{
          require(!_paused,"Contract Currrently Paused");
          _;
      }
      constructor (string memory baseURI)LRC721("LW3Punks","LWP"){
      _baseTokenURI=baseURI;
    }
    function mint()public payable onlyWhenNotPaused{
        require(tokenID<maxTokenID,"Maximum limit Exceeded");
        require(msg.value>=price,"Ether sent is not correct");
        tokenID+=1;
        _safemint(msg.value,tokenID);
    }
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
            require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

            string memory baseURI = _baseURI();
            // Here it checks if the length of the baseURI is greater than 0, if it is return the baseURI and attach
            // the tokenId and `.json` to it so that it knows the location of the metadata json file for a given 
            // tokenId stored on IPFS
            // If baseURI is empty return an empty string
            return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
        }

        /**
        * @dev setPaused makes the contract paused or unpaused
         */
    
        function setPaused(bool val) public onlyOwner {
            _paused = val;
        }
     function _baseURI()internal view virtual overrride returns (string memory){
         return _baseTokenURI;
         
     }
     function withdraw() public onlyOwner{
         address _owner=owner();
         uint256 amount=address(this).balance;
         (bool sent ,)=owner.call{value: amount}("");
         require(sent,"Failed to send Ether");
     }
     receive() external payable{}
     fallback() external payable {}
    }