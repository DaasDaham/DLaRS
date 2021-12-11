pragma solidity 0.8.1;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
    
    function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
        uint256 c = add(a,m);
        uint256 d = sub(c,1);
        return mul(div(d,m),m);
    }
}



contract DLars{

    using SafeMath for uint;

    //Structure for all the land Details
    struct landDetails {
        string city;
        string country;
        string landAdress;
        string pincode;
        address payable currentOwner;
        uint askingPrice;
        LandStatus status;
        uint auctionId;
    }
    enum LandStatus {underBidding, registered}
    mapping(uint => landDetails) Lands;
    address manager;
    modifier onlyManager{ 
        //Ensuring only manager can add new Land
        require(msg.sender == manager);
        _;
    }
    modifier onlyOwner(uint landId){
        //Ensuring some features can only be accessed by current owner
        require(msg.sender == Lands[landId].currentOwner);
        _;
    }
    mapping(uint => auction) Auction;
    struct auction {
        //Auction are identified using their landId
	    address payable highestBidder;
	    uint highestBid;
        uint highestBidTimestamp;
    }   
    constructor() public{
        manager = msg.sender;
    }
    
    //This function creates unique landId using its properties
    function computeIdLand(string memory landAddress, string memory city,string memory pincode) private view returns(uint){    
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp, landAddress, city, pincode)))%1000000000;
    }
    //This function registers land on DLaRS and can only be called by manager
    function registerLand(string memory landAddress, string memory city, string memory country, 
    string memory pincode, address payable currentOwner, uint askingPrice) public onlyManager returns(uint256){
        // Add a new entry in Land mapping with a new id
        // Status of the land will be registered
        uint landID = computeIdLand(landAddress, city, pincode);
        Lands[landID].city = city;
        Lands[landID].country = country;
        Lands[landID].pincode = pincode;
        Lands[landID].currentOwner = currentOwner;
        Lands[landID].askingPrice = askingPrice;
        Lands[landID].status = LandStatus.registered;
        return landID;
    }
    //This function puts up the land for auction, can only be called by the current owner    
    function putUpForAuction(uint landId) public onlyOwner(landId){
        // Changes land status to underBidding and land is up for auction.
        // Add entry in auction
        require(Lands[landId].status == LandStatus.registered);
        Auction[landId].highestBid = 0;
        Auction[landId].highestBidTimestamp = block.timestamp;
        Lands[landId].status = LandStatus.underBidding;
    }

    // function placeBid(address payable _receiver1, address payable _receiver2, uint256 amount) public payable {
    //     //PaymentReceived[_landId] = true;
    //     //payable(Lands[landId].currentOwner).transfer(currentBid-Auction[landId].highestBid);
    //     //uint amntToRed = msg.value-5000000000000000000;
    //     //_receiver1.transfer(amntToRed);
    //     //_receiver2.transfer(4000000000000000000);
    // }

    // function receiveBid() public payable{
    //     require(msg.value>0);
    // }

    // function withdraw(uint amnt) public{
    //     msg.sender.transfer(amnt);
    // }
    
    function placeBid(uint landId) public payable{
        //TO BE DONE
        uint currentBid = msg.value;
        require(msg.sender!=Lands[landId].currentOwner);
        require(Auction[landId].highestBid<currentBid);
        require(Lands[landId].askingPrice<currentBid);
        require(Lands[landId].status==LandStatus.underBidding);
        if (Auction[landId].highestBid>0){
            Auction[landId].highestBidder.transfer(Auction[landId].highestBid);
        }
        uint toTransfer = currentBid-Auction[landId].highestBid;
        payable(Lands[landId].currentOwner).transfer(toTransfer);
        Auction[landId].highestBidder = payable(msg.sender);
        Auction[landId].highestBid = currentBid;
        Auction[landId].highestBidTimestamp = block.timestamp;
        // accessible by bidders only
        // params: pass auction Id and 
        // check current bid > last bid, pay amount, update highest bid, 
        // check if there was a last bidder, if yes revert amount of last bidder    

    }

    //This function allows the current owner to view the current highest bid
    function viewHighestBid(uint landId) public onlyOwner(landId) returns(uint){
        // accessed by seller
        // returns highest bid value for the current land
        require(Lands[landId].status == LandStatus.underBidding);
        return Auction[landId].highestBid;
    }

    function terminateAuction(uint landId) public {
        //TO BE DONE
        require(Auction[landId].highestBidder==msg.sender);
        require(Auction[landId].highestBidTimestamp+2592000<block.timestamp);
        require(Lands[landId].status == LandStatus.underBidding);
        Lands[landId].currentOwner = payable(msg.sender);
        Lands[landId].status = LandStatus.registered;
        // accessed by highest bidder, accessible only after 30 days of auction start 
        // change status of land to sold, change owner address, pay money to previous owner
        
    }

    //This function allows the current owner to approve the highest bid and proceed with the transaction
    function acceptHighestBid(uint landId) public onlyOwner(landId){
        // prompts auction contract to stop bidding and complete transaction 
        // (auction will take care of guarantee that money will be transferred)
        // Will internally call the transfer ownership function        
        require(Lands[landId].status == LandStatus.underBidding);
        require(Auction[landId].highestBid >= Lands[landId].askingPrice);
        transferOwnership(landId, Auction[landId].highestBidder);  
        Lands[landId].status == LandStatus.registered;     
    }

    //This function transfers the ownership from current owner to the new owner
    function transferOwnership(uint landId, address payable newOwnerId) private onlyOwner(landId){
        // change owner and remove from auction 
        // change land status to sold
        require(Lands[landId].currentOwner != newOwnerId);
        Lands[landId].currentOwner = newOwnerId;
    }
}