// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

// custom errors
error NotAuthorized();
error WrongAddress();
error TokenAlreadyMinted();

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
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed tokenId
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

    function ownerOf(uint256 tokenId) external view returns (address) {
        return _ownerOf[tokenId];
    }

    function approve(address approved, uint256 tokenId) external payable {
        address tokenOwner = _ownerOf[tokenId];

        if (
            tokenOwner != msg.sender || !isApprovedForAll[approved][msg.sender]
        ) {
            revert NotAuthorized();
        }

        getApproved[tokenId] = approved;

        emit Approval(tokenOwner, approved, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `from` is
    ///  not the current owner. Throws if `to` is the zero address. Throws if
    ///  `tokenId` is not a valid NFT.
    /// @param from The current owner of the NFT
    /// @param to The new owner
    /// @param tokenId The NFT to transfer
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual {
        address owner = _ownerOf[tokenId];

        // avoid transferring to the current owner or zero address
        if (to == owner || to == address(0)) revert WrongAddress();

        if (
            msg.sender != owner ||
            getApproved[tokenId] != msg.sender ||
            isApprovedForAll[from][msg.sender]
        ) {
            revert NotAuthorized();
        }

        _ownerOf[tokenId] = to;

        unchecked {
            _balanceOf[from]--;
            _balanceOf[to]++;
        }

        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual {
        transferFrom(from, to, tokenId);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        if (to == address(0)) revert WrongAddress();
        if (_ownerOf[tokenId] != address(0)) revert TokenAlreadyMinted();

        _ownerOf[tokenId] = to;

        unchecked {
            _balanceOf[to]++;
        }

        emit Transfer(address(0), to, tokenId);
    }
}

interface IERC721TokenReceiver {
    /// @notice Handle the receipt of an NFT
    /// @dev The ERC721 smart contract calls this function on the recipient
    ///  after a `transfer`. This function MAY throw to revert and reject the
    ///  transfer. Return of other than the magic value MUST result in the
    ///  transaction being reverted.
    ///  Note: the contract address is always the message sender.
    /// @param _operator The address which called `safeTransferFrom` function
    /// @param from The address which previously owned the token
    /// @param tokenId The NFT identifier which is being transferred
    /// @param _data Additional data with no specified format
    /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    ///  unless throwing
    function onERC721Received(
        address _operator,
        address from,
        uint256 tokenId,
        bytes calldata _data
    ) external returns (bytes4);
}
