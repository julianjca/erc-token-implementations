// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

// custom errors
error NotAuthorized();

/// @notice an opinionated ERC721 implementation
/// @title ERC721
/// @author Julian <juliancanderson@gmail.com>
contract ERC721 {
    /*///////////////////////////////////////////////////////////////
                            ERC20 METADATA
    //////////////////////////////////////////////////////////////*/
    string public name;
    string public symbol;

    /*///////////////////////////////////////////////////////////////
                                MAPPINGS
    //////////////////////////////////////////////////////////////*/
    mapping(address => uint256) private _balanceOf;
    mapping(uint256 => address) private _ownerOf;
    mapping(uint256 => address) public isApproved;
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    // https://ethereum.stackexchange.com/questions/8658/what-does-the-indexed-keyword-do
    // The indexed parameters for logged events will
    // allow you to search for these events using the indexed parameters as filters.

    /*///////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    /*///////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balanceOf[account];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return _ownerOf[_tokenId];
    }

    function approve(address _approved, uint256 _tokenId) external payable {
        address tokenOwner = _ownerOf[_tokenId];

        if (
            tokenOwner != msg.sender || !isApprovedForAll[_approved][msg.sender]
        ) {
            revert NotAuthorized();
        }

        isApproved[_tokenId] = _approved;

        emit Approval(tokenOwner, _approved, _tokenId);
    }
}
