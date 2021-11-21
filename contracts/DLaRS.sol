pragma solidity >=0.7.0 <0.9.0;

contract DLars{
    
    struct landDetails {
        string city;
        string country;
        string landAdress;
        string pinCode;
        address payable currentOwner;
        uint askingPrice;
        LandStatus status; // 
        uint auctionId;
    }
    
    enum LandStatus {underBidding, registered}
    
    mapping(uint => landDetails) Lands;
    // Land[] lands;
    
    address manager; // check how multiple owners can be on the blockchain
    modifier onlyManager{
        require(msg.sender == manager);
        _;
    }
    modifier onlyOwner(uint landId){
        require(msg.sender == Lands[landId].currentOwner);
        _;
    }
    mapping(uint => auction) Auction;
    //landID and AuctinoID are same
    struct auction {
	    address highestBidder;
	    uint highestBid;
    }
    
    // mapping(uint => address) Bidder;
    
    constructor() public{
        manager = msg.sender;
    }

    // function addBidders() public {
    //     // regester new bidder to bidder mapping
    // }
    function computeIDLand(string memory landAddress, string memory city,string memory pincode) private view returns(uint){
        return uint(keccak256(block.difficulty,now, landAddress, city, pincode))%1000000000;
    }
    function registerLand(string memory landAddress, string memory city, string memory country, 
    string memory pincode, address payable currentOwner, uint askingPrice) public onlyManager{
        // Add a new entry in Land mapping with a new id
        // Status of the land will be registered
        // lands.push(Land(landAddress, city, state, pincode, currentOwner, sellingPrice, LandStatus.registered))
        uint landID = computeId(landAddress, city, pincode);
        Lands[landID].city = city;
        Lands[landID].state = state;
        Lands[landID].pincode = pincode;
        Lands[landID].currentOwner = currentOwner;
        Lands[landID].askingPrice = askingPrice;
        Lands[landID].status = LandStatus.registered;
    }
    
    function putUpForAuction(uint landId) public onlyOwner(landId){
        // Params: LandId 
        // Changes land status to underBidding and land is up for auction.
        // Add entry in auction
        require(Lands[landId].status == LandStatus.registered);
        Auction[landId].highestBid = 0;
        land[landId].status = LandStatus.underBidding;
    }
    
    // function viewLandForAuctions() public {
    //     // params 
    //     // Accessed by bidder
    //     // Lists out land details which are under bidding
    // }
    
    function payable placeBid() public {
        // accessible by bidders only
        // params: pass auction Id and 
        // check current bid > last bid, pay amount, update highest bid, 
        // check if there was a last bidder, if yes revert amount of last bidder    
    }

    function viewHighestBid(uint landId) public onlyOwner(landId){
        // params: auction Id
        // accessed by seller
        // returns highest bid value for the current land
        require(Lands[landId].status == LandStatus.underBidding);
        return Auction[landId].highestBid;
    }
    function terminateAuction() public {
        // accessed by highest bidder, accessible only after 30 days of auction start 
        // change status of land to sold, change owner address, pay money to previous owner
        
    }
    function acceptHighestBid(uint landId) public onlyOwner(landId){
        // prompts auction contract to stop bidding and complete transaction 
        // (auction will take care of guarantee that money will be transferred), 
        // will internally call the transfer ownership function        
        require(Lands[landId].status == LandStatus.underBidding);
        require(Auction[landId].highestBid >= Lands[landId].askingPrice);
        transferOwnership(landId, Auction[landId].highestBidder);  
        Lands[landId].status == LandStatus.registered;     
    }
    // function removeCompletedAuction() private {
    //     // params: LandID
    //     // Remove auction from auctions mapping

    // }
    function transferOwnership(uint landId, address newOwnerId) private onlyOwner(landId){
        // params: landId, newOwnerId
        // change owner and remove from auction 
        // change land status to sold
        require(Lands[landId].owner != newOwnerId);
        Lands[landId].owner = newOwnerId;
        
    }
}
