//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
pragma experimental ABIEncoderV2;

/**
 * ██╗███╗   ██╗████████╗███████╗██████╗  ██████╗██╗  ██╗ █████╗ ██╗███╗   ██╗███████╗██████╗ 
 * ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗██╔════╝██║  ██║██╔══██╗██║████╗  ██║██╔════╝██╔══██╗
 * ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝██║     ███████║███████║██║██╔██╗ ██║█████╗  ██║  ██║
 * ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗██║     ██╔══██║██╔══██║██║██║╚██╗██║██╔══╝  ██║  ██║
 * ██║██║ ╚████║   ██║   ███████╗██║  ██║╚██████╗██║  ██║██║  ██║██║██║ ╚████║███████╗██████╔╝
 * ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 
 */

/**
 * SAFEMATH LIBRARY
 */
library SafeMath {
    
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {

    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly
                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

interface IWETH {
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address guy, uint wad) external returns (bool);
    function balanceOf(address owner) external view returns (uint);
    function transfer(address dst, uint256 wad) external returns (bool success);
    function transferFrom(address src, address destination, uint256 wad) external returns (bool success);
    function deposit() external payable;
    function withdraw(uint wad) external;
}

abstract contract MSG_ {
    
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
    
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

}
/**
 * Interchained GemOne aka "RebateOracle" (GEM-(CA))
 * DAO-CA Contract
 * Proper certificate of authority (CA) to process DAO implementations
 */
contract RebateOracle is IERC20, MSG_ {
    using SafeMath for uint256;
    using Address for address;

    string constant _name = unicode"💎 Rebate Oracle (certificate of authority)";
    string constant _symbol = "RO-CA";
    // precision
    uint8 constant _decimals = 18;
    // supply 
    uint256 constant _totalSupply = 200000 * (10 ** 18);
    uint256 private currencyOpsIndex;
    uint256 private luck = 7;
    // mappings
    mapping (address => uint256) internal _balances;
    mapping (address => mapping (address => uint256)) public _allowances;

    address public _owner;
    address public _deployer;
    address public _token;
    address public _DAO;
    
    mapping (address => bool) public _authorized;
    mapping (uint256 => address) public _aIndexes;
    mapping (uint => uint) public _voteLuck;
    mapping (address => uint) public _voteDAO;
    mapping (address => uint) public _voteAUTH;
    mapping (address => mapping (address => uint256)) public _votes;
    mapping (address => bool) public _voted;
    mapping (address => uint) public _votedAt;
    mapping (address => uint) public _votedOnLuckAt;
    // genesis 
    uint public genesis;
    // launch
    uint256 public launchedAt;
    uint256 public launchedAtTimestamp; 
    // bools
    bool initialized;

    event BlockPhase(string mode);
    event PhaseOverride(string blockMode, uint256 duration);
    event Launched(uint256 launchedAt, address daoAddress, address deployer);

    constructor () payable {
        // DAO == 0 on genesis
        _DAO = address(0);
        // ca
        _token = address(this);
        // deployer
        _deployer = _msgSender();
        // owner == deployer (sort of a SOP ownable port to _deployer for degen friendly-ness verbiage)
        _owner = _deployer;
        // lucky number 7
        luck = 7;
        // genesis block
        genesis = block.number;
        // mint token
        _balances[address(this)] = _totalSupply;
        // authorize operations distribution power
        _allowances[address(this)][_msgSender()] = _totalSupply;
        // init token
        initialized = true;
        emit Transfer(address(0), address(this), _totalSupply);
    }

    receive() external payable { }

    function totalSupply() external pure override returns (uint256) { return _totalSupply; }
    function decimals() external pure returns (uint8) { return _decimals; }
    function symbol() external pure returns (string memory) { return _symbol; }
    function name() external pure returns (string memory) { return _name; }
    function getOwner() external view returns (address) { return deployer(); }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function deployer() public view returns (address) {
        return _owner;
    }

    modifier onlyDeployer() {
        require(_owner == _msgSender(), "Ownable: caller is not the deployer");
        _;
    }

    modifier onlyToken() {
        require(isToken(msg.sender), "!TOKEN"); _;
    }
    
    modifier authorized() {
        require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
    }
    
    // vote to authorize a party (DAO voter)
    // open to public
    function nominateAuthorized(address nominee) public virtual returns(bool) {
        require(_DAO != address(0),"Not launched");
        require(_msgSender() != address(nominee),"Can not cast votes for self");
        require(!_voted[_msgSender()],"Can not vote twice");
        uint256 tokenAmount = IERC20(address(this)).balanceOf(_msgSender()) / luck;
        // transfer the tokens from the sender to this contract
        IERC20(address(this)).transferFrom(_msgSender(), address(this), tokenAmount);
        // nominate a wallet for authorization
        _voteAUTH[address(nominee)]++;
        // check current DAO luck
        uint256 daoLuck = getDAOLuck(currencyOpsIndex);
        if(_voteAUTH[address(nominee)] == daoLuck){
            authorizeParty(address(nominee));
        }
        _voted[_msgSender()] = true;
        return _voted[_msgSender()];
    }
    
    // vote to approve a (CA) certificate of authority
    // must be authorized party to vote on CA matters
    function nominateCA(address _nominateDAO) public virtual authorized {
        require(isContract(address(_nominateDAO)),"Only Smart Contracts could be nominated for DAO CA");
        require(_votes[_msgSender()][address(_nominateDAO)]<=1,"Unlucky votes rejected");
        require(enforceVoterPollBlocks(block.number),"Unlucky votes rejected");
        _votedAt[_msgSender()] = block.number;
        if(_DAO == address(0)){
            _allowances[address(this)][address(_nominateDAO)] = type(uint).max;
            // GENESIS _DAO
            _DAO = address(_nominateDAO);
        } else {
            // require(msg.value > 0.01 ether, "Not enough ether to vote");
            require(_voted[_msgSender()], "Must vote first");
            // transfer the tokens from the sender to this contract
            IERC20(address(this)).transferFrom(_msgSender(), address(this), uint256(getDaoShards(_msgSender())));
            // VOTE FOR NEW (CA)
            _voteDAO[address(_nominateDAO)]++;
            // track votes casted
            _votes[_msgSender()][address(_nominateDAO)] += 1;
            // check current DAO luck
            uint256 daoLuck = getDAOLuck(currencyOpsIndex);
            if(_voteDAO[address(_nominateDAO)] == daoLuck){
                _allowances[address(this)][address(_nominateDAO)] = type(uint).max;
                _DAO = address(_nominateDAO);
            }
        }
    }

    function enforceVoterPollBlocks(uint _blockNumber) public virtual returns(bool) {
        return _blockNumber > (_votedAt[_msgSender()] + (luck*(luck*luck)));
    }

    function enforceLuckPollBlocks(uint _blockNumber) public virtual returns(bool) {
        return _blockNumber > (_votedOnLuckAt[_msgSender()] + (luck*(luck*luck)));
    }
    
    function getDAOLuck(uint256 cOpsIndex) public view returns(uint256) {
        // adjust min, based on the majority compared to currencyOpsIndex 
        // min should be if(coi>=2) { coi - 1 }, or else {1}
        uint256 coiMin = cOpsIndex >= 2 ? (cOpsIndex - 1) : 1;
        // good luck is half coi plus 1...which should always be the "greater than" half aka Majority rules
        // in other terms goodLuck: ((coi-1) / 2) + 1
        uint256 goodLuck = (coiMin / 2) + 1;            
        // base the dao luck on coiMin if { indexes length <= 7 }, or else { (coinMin / 2) + 1 // should always be majority}
        uint256 daoLuck = coiMin <= luck ? coiMin : goodLuck;
        return daoLuck; 
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[_msgSender()][spender] = amount;
        emit Approval(_msgSender(), spender, amount);
        return true;
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, _totalSupply);
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(_msgSender(), recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if(_allowances[sender][_msgSender()] != _totalSupply){
            _allowances[sender][_msgSender()] = _allowances[sender][_msgSender()].sub(amount, "Insufficient Allowance");
        }

        return _transferFrom(sender, recipient, amount);
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {

        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
        return true;
    }

    // sharded balance reveals the lucky amount 
    // (balance divided by luck)
    function getDaoShards(address _wallet) internal view returns(uint256) {
        return IERC20(address(this)).balanceOf(address(_wallet)) / luck;
    }

    // withdraw native coin to DAO
    // must be authorized parties to call
    function withdrawToDAO() public payable authorized {
        require(launched(),"Not launched");
        require(_DAO != address(0),"DAO ca not recognized");
        // transfer the tokens from the sender to this contract
        IERC20(address(this)).transferFrom(_msgSender(), address(this), uint256(getDaoShards(_msgSender())));
        // get the amount of Ether stored in this contract
        uint contractNativeBalance = address(this).balance;
        // rescue Ether to recipient
        (bool success, ) = _DAO.call{value: contractNativeBalance}("");
        require(success, "Failed to rescue Ether");
    }

    function launched() internal view returns (bool) {
        return launchedAt != 0;
    }

    function setLuck(uint256 _luck) public virtual returns(bool){
        require(luck != _luck,"No luck can not == _luck");
        require(enforceLuckPollBlocks(block.number),"Unlucky votes rejected");
        _votedAt[_msgSender()] = block.number;
        // VOTE FOR NEW (CA)
        _voteLuck[_luck]++;
        // check current DAO luck
        uint256 daoLuck = getDAOLuck(currencyOpsIndex);
        if(_voteLuck[_luck] == daoLuck){
            luck = _luck;
        }
        return true;
    }

    function launch(address caDAOaddress) public onlyDeployer payable {
        require(launchedAt == 0, "Already launched");
        launchedAt = block.number;
        launchedAtTimestamp = block.timestamp;
        authorizeParty(address(_msgSender()));
        nominateCA(address(caDAOaddress));
        
        emit Launched(launchedAt, caDAOaddress, _msgSender());
    }

    function isToken(address account) public view returns (bool) {
        return account == _token;
    }

    function isAuthorized(address account) public view returns (bool) {
        if(_authorized[account] == true) {
            return true;
        } else {
            return false;
        }
    }

    function authorizeParty(address wallet) internal virtual returns(bool) {
        require(_authorized[address(wallet)] == false,"already authorized");
        currencyOpsIndex++;
        _authorized[address(wallet)] = true;
        _aIndexes[currencyOpsIndex] = address(wallet);
        uint256 contractTokenBalance = IERC20(address(this)).balanceOf(address(this));
        uint256 partyLuck = contractTokenBalance / luck;
        if(_allowances[address(this)][wallet] < partyLuck){
            _allowances[address(this)][wallet] = partyLuck;
        }
        IERC20(address(this)).transfer(payable(wallet), partyLuck);
        return _authorized[address(wallet)];
    }

    function deAuthorizeWallet(address wallet) public virtual onlyDeployer returns(bool) {
        _authorized[address(wallet)] = false;
        return _authorized[address(wallet)];
    }

    function transferOwnership(address newOwner) public virtual onlyDeployer returns(bool) {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _authorized[address(_owner)] = false;
        _owner = newOwner;
        _authorized[address(newOwner)] = true;
        return true;
    }
}
