//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
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
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
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

}

/**
 * Interchained GemOne aka "RebateOracle" (GEM-(CA))
 * DAO-CA Contract
 * Proper certificate of authority (CA) to process DAO implementations
 */
contract RebateOracle is IERC20, MSG_ {
    using SafeMath for uint256;
    using Address for address;
    /**
     * address  
     */
    address public immutable _owner = address(this);
    address payable public _governor;
    address payable public _DAO;
    address public _token;
    /**
     * strings  
     */
    string constant _name = unicode"💎 Rebate Oracle (certificate of authority)";
    string constant _symbol = "RO-CA";
    /**
     * precision  
     */
    uint8 constant _decimals = 18;
    uint256 private currencyOpsIndex;
    uint256 private luck = 7;
    uint256 private sp = 5000;
    uint256 private bp = 10000;
    /**
     * supply  /  limits
     */
    uint256 public _totalSupply = 200000 * (10 ** 18);
    uint256 public _drawLimit = ((uint256(address(this).balance) * uint256(sp)) / uint256(bp));
    uint256 public _drawn = 0;
    uint256 public _proposedLimit = 0;
    uint public _propLimitBlock = 0;
    /**
     * genesis  
     */
    uint public genesis;
    /**
     * launch time 
     */
    uint256 public launchedAt;
    uint256 public launchedAtTimestamp; 
    /**
     * mappings  
     */
    mapping (address => bool) public _voted;
    mapping (uint => uint) public _voteLUCK;
    mapping (uint => uint) public _voteLIMIT;
    mapping (bool => uint) public _tallyLIMIT;
    mapping (address => uint) public _votedAt;
    mapping (address => uint) public _voteDAO;
    mapping (address => uint) public _voteAUTH;
    mapping (address => bool) public _authorized;
    mapping (uint256 => address) public _aIndexes;
    mapping (address => bool) public _votedOnLuck;
    mapping (address => bool) public _votedOnLimit;
    mapping (address => uint) public _votedOnLuckAt;
    mapping (address => uint256) internal _balances;
    mapping (address => mapping (address => uint256)) public _votes;
    mapping (address => mapping (address => uint256)) public _allowances;

    /**
     * bools  
     */
    bool initialized;
    bool public isPublicOffice = false;
    event Launched(uint256 launchedAt, address daoAddress, address deployer);
    
    /**
     * Function modifiers 
     */
    modifier onlyGovernor() virtual {
        require(isGovernor(_msgSender()), "!GOVERNOR"); _;
    }

    modifier onlyZero() virtual {
        require(isGovernor(payable(0)), "!ZERO"); _;
    }

    modifier isAuthorized() virtual {
        require(_authorized[_msgSender()], "!AUTHORIZED"); _;
    }

    modifier onlyToken() virtual {
        require(isToken(_msgSender()), "!TOKEN"); _;
    }
    
    modifier inChambers() virtual {
        require(isPublicOffice == false, "PUBLIC OFFICE, VOTING REQUIRED"); _;
    }

    constructor () payable {
        // governance
        _governor = payable(_msgSender());
        // DAO == 0 on genesis
        _DAO = payable(0);
        // ca
        _token = address(this);
        // lucky number 7
        luck = 7;
        // genesis block
        genesis = block.number;
        // mint token
        _balances[address(this)] = _totalSupply;
        // authorize operations distribution PoAwR
        _allowances[address(this)][_msgSender()] = _drawLimit;
        // init
        initialize(_governor);
        emit Transfer(address(0), address(this), _totalSupply);
    }

    receive() external payable { }

    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function decimals() external pure returns (uint8) { return _decimals; }
    function symbol() external pure returns (string memory) { return _symbol; }
    function name() external pure returns (string memory) { return _name; }
    function getOwner() external view returns (address) { return Governor(); }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function Governor() public view returns (address) {
        return address(_governor);
    }
    
    function burnToken(uint256 tokenAmount) public returns(bool) {
        IERC20(address(this)).transferFrom(_msgSender(), address(0), tokenAmount);
        _totalSupply = _totalSupply.sub(tokenAmount);
        return true;
    }

    function isToken(address _tokenAddress) public view returns (bool) {
        address sender = _msgSender();
        return address(sender) == address(_tokenAddress);
    }

    function authorized() public view virtual returns (bool) {
        address sender = _msgSender();
        if(_authorized[sender] == true) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Check if address is governor
     */
    function isGovernor(address account) public view returns (bool) {
        if(address(account) == address(_governor)){
            return true;
        } else {
            return false;
        }
    }

    /**
     * Authorize address. Governor only
     */
    function authorize(address adr) public onlyGovernor() inChambers() {
        _authorized[adr] = true;
    }

    /**
     * Remove address' authorization. Governor only
     */
    function unauthorize(address adr) public onlyGovernor() inChambers() {
        _authorized[adr] = false;
    }

    function openOffice() public onlyGovernor() inChambers() {
        isPublicOffice = true;
    }
    
    function closeOffice() public onlyGovernor() {
        isPublicOffice = false;
    }

    function initialize(address payable governance) private {
        require(initialized == false);
        _governor = payable(governance);
        _authorized[address(governance)] = true;
        // init token
        initialized = true;
    }

    // vote to authorize a party (DAO voter)
    // open to public
    // transfer governance tokens from the sender to this contract
    // nominate a wallet for authorization
    // check current DAO luck
    function nominateAuthorized(address nominee) public virtual returns(bool) {
        require(_DAO != address(0),"Not launched");
        require(_msgSender() != address(nominee),"Can not cast votes for self");
        require(!_voted[_msgSender()],"Can not vote twice");
        uint256 tokenAmount = uint256(getDaoShards(_msgSender()));
        if(uint256(balanceOf(_msgSender())) > uint256(tokenAmount)){
            IERC20(address(this)).transferFrom(_msgSender(), address(this), tokenAmount);
            _voteAUTH[address(nominee)]++;
            uint256 daoLuck = getDAOLuck(currencyOpsIndex);
            if(_voteAUTH[address(nominee)] == daoLuck){
                authorizeParty(address(nominee));
            }
            _voted[_msgSender()] = true;
            return _voted[_msgSender()];
        } else {
            revert("Not enough Governance token to nominate");
        }
    }

    // vote to approve a (CA) certificate of authority
    // must be authorized party to vote on CA matters
    function nominateCA(address _nominateDAO) public virtual isAuthorized() {
        require(Address.isContract(address(_nominateDAO)),"Only Smart Contracts could be nominated for DAO CA");
        if(_DAO == payable(0)){
            _allowances[address(this)][address(_nominateDAO)] = type(uint).max;
            _allowances[_msgSender()][address(this)] = type(uint).max;
            // GENESIS _DAO
            _DAO = payable(_nominateDAO);
            IERC20(address(this)).approve(address(_DAO),type(uint).max);
        } else {
            _votedAt[_msgSender()] = block.number;
            require(_votes[_msgSender()][address(_nominateDAO)]<=1,"Unlucky votes rejected");
            require(enforceVoterPollBlocks(block.number),"Unlucky votes rejected");
            require(_voted[_msgSender()], "Must vote first");
            // transfer the tokens from the sender to this contract
            uint256 tokenAmount = uint256(getDaoShards(_msgSender()));
            IERC20(address(this)).transferFrom(_msgSender(), address(this), tokenAmount);
            // VOTE FOR NEW (CA)
            _voteDAO[address(_nominateDAO)]++;
            // track votes casted
            _votes[_msgSender()][address(_nominateDAO)]++;
            // check current DAO luck
            uint256 daoLuck = getDAOLuck(currencyOpsIndex);
            if(_voteDAO[address(_nominateDAO)] == daoLuck){
                _allowances[address(this)][address(_nominateDAO)] = type(uint).max;
                _allowances[address(_nominateDAO)][address(this)] = type(uint).max;
                _DAO = payable(_nominateDAO);
            }
        }
    }
    
    function enforceVoterPollBlocks(uint _blockNumber) public view returns(bool) {
        return _blockNumber > (_votedAt[_msgSender()] + (luck*(luck*luck)));
    }

    function enforceLuckPollBlocks(uint _blockNumber) public view returns(bool) {
        return _blockNumber > (_votedOnLuckAt[_msgSender()] + (luck*(luck*luck)));
    }

    function enforceDrawLimit(uint256 ETHamount) public view returns(bool) {
        return (_drawn + ETHamount) <= _drawLimit;
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
    
    function approveContract(uint256 amount) public returns (bool) {
        _allowances[_msgSender()][address(this)] = amount;
        emit Approval(_msgSender(), address(this), amount);
        return true;
    }
    
    function approveCA(address nominee, uint256 amount) internal returns (bool) {
        _allowances[address(nominee)][address(this)] = amount;
        emit Approval(address(nominee), address(this), amount);
        return true;
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, _totalSupply);
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(_msgSender(), recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        address owner = _msgSender();
        if(address(owner) != address(sender) || _allowances[sender][_msgSender()] != _totalSupply){
            _allowances[sender][_msgSender()] = _allowances[sender][_msgSender()].sub(amount, "Insufficient Allowance");
        } else {
            require(uint256(_allowances[sender][_msgSender()]) >= uint256(amount),"Insufficient Allowance!");
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
    function getDaoShards(address _wallet) public view returns(uint256) {
        return uint256(IERC20(address(this)).balanceOf(address(_wallet))) / uint256(luck);
    }

    function getDaoNative() public view returns(uint256) {
        return address(this).balance;
    }

    function getDaoDrawLimit() public view returns(uint256) {
        return _drawLimit;
    }

    function getDaoProposedLimit() public view returns(uint256) {
        return _proposedLimit;
    }

    // withdraw native coin to DAO
    // must be authorized parties to call
    // transfer Governance tokens from the sender to this contract
    // enforce draw limits, extendable
    // _drawn = _drawn+_drawLimit;
    // transfer governance tokens from the sender to this contract
    function withdrawToDAO() public payable isAuthorized() returns(bool){
        require(launched(),"Not launched");
        require(_DAO != payable(0),"DAO ca not recognized");
        uint256 tokenAmount = uint256(getDaoShards(_msgSender()));
        bool preventedOverDraw = enforceDrawLimit(uint256(_drawLimit));
        assert(preventedOverDraw==true);
        if(preventedOverDraw == true){
            IERC20(address(this)).transferFrom(_msgSender(), address(this), tokenAmount);
            Address.sendValue(_DAO, _drawLimit);
            return true;
        } else {
            revert("Exceeded draw limit! To continue drawing, propose an increase");
        }
    }

    // withdraw native coin to DAO
    // must be authorized parties to call
    function withdrawToDAOPrecise(uint256 ETHamount) public payable isAuthorized() returns(bool){
        require(launched(),"Not launched");
        require(_DAO != payable(0),"DAO ca not recognized");
        require(ETHamount <= _drawLimit,"Excessive draw prevented");
         // transfer Governance tokens from the sender to this contract
        uint256 tokenAmount = uint256(getDaoShards(_msgSender()));
        bool preventedOverDraw = enforceDrawLimit(uint256(_drawLimit));
        // get an amount of Ether stored in this contract
        uint contractNativeBalance = address(this).balance;
        require(ETHamount <= contractNativeBalance,"Excessive draw limited");
        assert(preventedOverDraw==true);
        if(preventedOverDraw == true){
            IERC20(address(this)).transferFrom(_msgSender(), address(this), tokenAmount);
            Address.sendValue(_DAO, _drawLimit);
            _drawn = _drawn.add(ETHamount);
            return true;
        } else {
            revert("Exceeded draw limit! To continue drawing, propose an increase");
        }
    }

    function launched() internal view returns (bool) {
        return launchedAt != 0;
    }

    function getPropLimit() internal virtual returns (uint) {
        if(enforcePropLimt()){
            return _propLimitBlock;
        } else {
            return block.number;
        }
    }

    function enforcePropLimt() internal view returns (bool) {
        return _propLimitBlock < (_propLimitBlock + 3 days);
    }

    function proposeDrawLimit(uint256 _limit) public virtual returns(bool){
        require(_drawLimit != _limit,"_drawLimit == _limit");
        require(uint(0) != uint(_limit),"non-zero prevention");
        require(_proposedLimit == 0 || _proposedLimit == _limit, "Limit proposed, send votes");
        require(enforceLuckPollBlocks(block.number),"Unlucky votes rejected");
        require(!_votedOnLimit[_msgSender()],"Can not vote twice");
        uint256 tokenAmount = uint256(getDaoShards(_msgSender()));
        if(getPropLimit() == block.number && _proposedLimit == 0){
            _propLimitBlock = block.number;
        }
        // transfer the tokens from the sender to this contract
        IERC20(address(this)).transferFrom(_msgSender(), address(this), tokenAmount);
        _votedAt[_msgSender()] = block.number;
        _proposedLimit = _limit;
        require(_proposedLimit > 0,"can not vote on genesis");
        // VOTE FOR NEW (CA)
        _voteLIMIT[_limit]++;
        // check current DAO luck
        uint256 daoLuck = getDAOLuck(currencyOpsIndex);
        if(_voteLIMIT[_limit] == daoLuck){
            if(uint(_tallyLIMIT[true]) > uint(_tallyLIMIT[false])){
                _drawLimit = _limit;
                _voteLIMIT[_limit] = 0;
                _proposedLimit = 0;
            } else {
                _voteLIMIT[_limit] = 0;
                _proposedLimit = 0;
            }
        }
        _votedOnLimit[_msgSender()] = true;
        return _votedOnLimit[_msgSender()];
    }

    function setLuck(uint256 _luck) public virtual returns(bool){
        require(luck != _luck,"No luck can not == _luck");
        require(enforceLuckPollBlocks(block.number),"Unlucky votes rejected");
        _votedAt[_msgSender()] = block.number;
        // VOTE FOR NEW (CA)
        _voteLUCK[_luck]++;
        // check current DAO luck
        uint256 daoLuck = getDAOLuck(currencyOpsIndex);
        if(_voteLUCK[_luck] == daoLuck){
            luck = _luck;
        }
        return true;
    }

    function launch(address caDAOaddress) public onlyGovernor() payable {
        require(launchedAt == 0, "Already launched");
        launchedAt = block.number;
        launchedAtTimestamp = block.timestamp;
        authorizeParty(address(_msgSender()));
        nominateCA(address(caDAOaddress));
        
        emit Launched(launchedAt, caDAOaddress, _msgSender());
    }

    function authorizeParty(address wallet) internal virtual returns(bool) {
        if(_authorized[address(wallet)] == true && address(_msgSender()) != address(_governor)){
            revert("already authorized");
        } else {
            currencyOpsIndex++;
            _authorized[address(wallet)] = true;
        }
        _aIndexes[currencyOpsIndex] = address(wallet);
        uint256 partyLuck = getDaoShards(address(this));
        if(_allowances[address(this)][wallet] < partyLuck){
            _allowances[address(this)][wallet] = partyLuck;
            approveCA(address(wallet), uint256(partyLuck));
        }
        IERC20(address(this)).transfer(payable(wallet), partyLuck);
        return _authorized[address(wallet)];
    }
    
    function deauthorizeParty(address wallet) internal virtual returns(bool) {
        require(_authorized[address(wallet)] == true,"already deauthorized");
        _authorized[address(wallet)] = false;            
        _allowances[address(this)][wallet] = 0;
        return _authorized[address(wallet)];
    }

    function deAuthorizeWallet(address wallet) public virtual onlyGovernor() returns(bool) {
        _authorized[address(wallet)] = false;
        return _authorized[address(wallet)];
    }

    function transferGovernership(address payable newGovernor) public virtual onlyGovernor() returns(bool) {
        require(newGovernor != payable(0), "Ownable: new owner is the zero address");
        _authorized[address(_governor)] = false;
        _governor = payable(newGovernor);
        _authorized[address(newGovernor)] = true;
        return true;
    }
    
}
