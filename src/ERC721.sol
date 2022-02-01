// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

// custom errors
error NotAuthorized();
error WrongAddress();

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
    mapping(uint256 => address) public getApproved;
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

        getApproved[_tokenId] = _approved;

        emit Approval(tokenOwner, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        isApprovedForAll[msg.sender][_operator] = _approved;

        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        address owner = _ownerOf[_tokenId];

        // avoid transferring to the current owner or zero address
        if (_to == owner || _to == address(0)) revert WrongAddress();

        if (
            msg.sender != owner ||
            getApproved[_tokenId] != msg.sender ||
            isApprovedForAll[_from][msg.sender]
        ) {
            revert NotAuthorized();
        }

        _ownerOf[_tokenId] = _to;

        unchecked {
            _balanceOf[_from]--;
            _balanceOf[_to]++;
        }

        emit Transfer(_from, _to, _tokenId);
    }
}
