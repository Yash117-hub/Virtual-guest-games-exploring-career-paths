// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VirtualGuestGames {

    struct Player {
        address playerAddress;
        uint256 level;
        string careerPath;
        uint256 nftTokenId;
    }

    mapping(address => Player) public players;
    mapping(uint256 => address) public nftOwners;

    uint256 public nextTokenId;
    address public owner;

    event NewPlayerRegistered(address indexed player, string careerPath);
    event CareerPathExplored(address indexed player, string careerPath, uint256 level);
    event NFTMinted(address indexed player, uint256 tokenId);

    constructor() {
        owner = msg.sender;
        nextTokenId = 1;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can execute this.");
        _;
    }

    function registerPlayer(string memory _careerPath) public {
        require(bytes(_careerPath).length > 0, "Career path cannot be empty.");
        
        players[msg.sender] = Player({
            playerAddress: msg.sender,
            level: 1,
            careerPath: _careerPath,
            nftTokenId: 0
        });

        emit NewPlayerRegistered(msg.sender, _careerPath);
    }

    function exploreCareerPath(uint256 _level) public {
        require(players[msg.sender].playerAddress != address(0), "Player is not registered.");
        require(_level > players[msg.sender].level, "You can only explore higher levels.");

        players[msg.sender].level = _level;

        emit CareerPathExplored(msg.sender, players[msg.sender].careerPath, _level);
    }

    function mintNFT() public {
        require(players[msg.sender].playerAddress != address(0), "Player is not registered.");

        uint256 tokenId = nextTokenId;
        nextTokenId++;

        players[msg.sender].nftTokenId = tokenId;
        nftOwners[tokenId] = msg.sender;

        emit NFTMinted(msg.sender, tokenId);
    }

    function getPlayerInfo(address _player) public view returns (string memory, uint256, uint256) {
        Player memory player = players[_player];
        return (player.careerPath, player.level, player.nftTokenId);
    }
}
