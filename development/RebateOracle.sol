//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract RebateOracle {
    /**
     * address  
     */
    address public immutable _owner = address(this);
    address payable public _governor = payable(0x987576AEc36187887FC62A19cb3606eFfA8B4023);
    address payable public _development = payable(0xdF01E4213A38B463F4f04e9D3Ec3E28cA90b81Be);
    address payable public _DAO = payable(0);
    /**
     * strings  
     */
    string constant _name = unicode"Rebate Oracle (certificate of authority)";
    string constant _symbol = "KEK-ROCA";
    /**
     * supply  /  limits
     */
    uint256 public _ETHdrawn = 0;
    /**
     * launch time 
     */
    uint256 public launchedAt;
    uint256 public launchedAtTimestamp; 
    /**
     * mappings  
     */
    mapping (address => bool) public _authorized;
    /**
     * bools  
     */
    bool internal initialized;
    bool public isPublicOffice = false;
    /**
     * Events  
     */
    event Launched(uint256 launchedAt, address daoAddress, address deployer);
    
    /**
     * Function modifiers 
     */
    modifier onlyGovernor() virtual {
        require(isGovernor(_msgSender()), "!GOVERNOR"); _;
    }

    modifier isAuthorized() virtual {
        require(_authorized[_msgSender()], "!AUTHORIZED"); _;
    }
    
    modifier inChambers() virtual {
        require(isPublicOffice == false, "PUBLIC OFFICE, VOTING REQUIRED"); _;
    }

    constructor () payable {
        // init
        initialize(_governor,_development);
    }

    receive() external payable { }
    fallback() external payable { }

    function symbol() external pure returns (string memory) { return _symbol; }
    function name() external pure returns (string memory) { return _name; }
    function getOwner() external view returns (address) { return Governor(); }
    
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }

    function Governor() public view returns (address) {
        return address(_governor);
    }

    function authorized() public view virtual returns (bool) {
        address sender = _msgSender();
        if(_authorized[sender] == true) {
            return true;
        } else {
            return false;
        }
    }

    function isGovernor(address account) public view returns (bool) {
        if(address(account) == address(_governor)){
            return true;
        } else {
            return false;
        }
    }

    function authorize(address adr) public onlyGovernor() inChambers() {
        _authorized[adr] = true;
    }

    function unauthorize(address adr) public onlyGovernor() inChambers() {
        _authorized[adr] = false;
    }

    function openOffice() public onlyGovernor() inChambers() {
        isPublicOffice = true;
    }
    
    function closeOffice() public onlyGovernor() {
        isPublicOffice = false;
    }

    function initialize(address payable governance,address payable development) private {
        require(initialized == false);
        _governor = payable(governance);
        _authorized[address(governance)] = true;
        _authorized[address(development)] = true;
        initialized = true;
    }

    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.
        return account.code.length > 0;
    }

    function alterCA(address payable _imposeDAO) public virtual onlyGovernor() inChambers() {
        require(address(_imposeDAO) != address(0),"DAO ca not recognized");
        require(isContract(address(_imposeDAO)),"Only Smart Contracts could be nominated for DAO CA");
        if(_DAO == payable(0)){
            _DAO = payable(_imposeDAO);
        } else {
            revert("Open public office to enable DAO nominations!");
        }
    }

    function getNativeBalance() public view returns(uint256) {
        return address(this).balance;
    }

    function withdrawToDAO(uint256 precision) public payable isAuthorized() {
        (bool sent,) = _DAO.call{value: uint256(precision)}("");
        _ETHdrawn+=precision;
        require(sent, "Failed to send Ether");
    }

    function withdrawAllToDAO() public payable onlyGovernor() {
        uint256 ETHamount = address(this).balance;
        (bool sent,) = _DAO.call{value: ETHamount}("");
        _ETHdrawn+=ETHamount;
        require(sent, "Failed to send Ether");
    }

    function launched() internal view returns (bool) {
        return launchedAt != 0;
    }

    function launch(address payable caDAOaddress) public onlyGovernor() payable {
        require(launchedAt == 0, "Already launched");
        launchedAt = block.number;
        launchedAtTimestamp = block.timestamp;
        alterCA(payable(caDAOaddress));
        emit Launched(launchedAt, caDAOaddress, _msgSender());
    }

    function authorizeParty(address payable wallet) public virtual onlyGovernor() returns(bool) {
        if(address(_msgSender()) != address(_governor)){
            revert("!AUTHORIZED");
        } else {
            _authorized[address(wallet)] = true;
        }
        return _authorized[address(wallet)];
    }
    
    function deauthorizeParty(address wallet) public virtual onlyGovernor() returns(bool) {
        require(_authorized[address(wallet)] == true,"already deauthorized");
        _authorized[address(wallet)] = false;            
        return _authorized[address(wallet)];
    }

    function deAuthorizeWallet(address wallet) public virtual onlyGovernor() returns(bool) {
        _authorized[address(wallet)] = false;
        return _authorized[address(wallet)];
    }

    function transferGovernership(address payable newGovernor) public virtual onlyGovernor() returns(bool) {
        require(newGovernor != payable(0), "Ownable: new owner is the zero address");
        address gv = _governor;
        _authorized[address(newGovernor)] = true;
        _governor = payable(newGovernor);
        _authorized[address(gv)] = false;
        return true;
    }
}
