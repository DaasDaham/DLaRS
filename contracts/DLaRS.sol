pragma solidity >=0.7.0 <0.9.0;

contract DLars{

    //Structure for all the land Details
    struct landDetails {
        string city;
        string country;
        string landAdress;
        string pinCode;
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
	    address highestBidder;
	    uint highestBid;
    }   
    constructor() public{
        manager = msg.sender;
    }
    
    //This function creates unique landId using its properties
    function computeIdLand(string memory landAddress, string memory city,string memory pincode) private view returns(uint){    
        return uint(keccak256(block.difficulty,now, landAddress, city, pincode))%1000000000;
    }
    //This function registers land on DLaRS and can only be called by manager
    function registerLand(string memory landAddress, string memory city, string memory country, 
    string memory pincode, address payable currentOwner, uint askingPrice) public onlyManager{
        // Add a new entry in Land mapping with a new id
        // Status of the land will be registered
        uint landID = computeIdLand(landAddress, city, pincode);
        Lands[landID].city = city;
        Lands[landID].state = state;
        Lands[landID].pincode = pincode;
        Lands[landID].currentOwner = currentOwner;
        Lands[landID].askingPrice = askingPrice;
        Lands[landID].status = LandStatus.registered;
    }
    //This function puts up the land for auction, can only be called by the current owner    
    function putUpForAuction(uint landId) public onlyOwner(landId){
        // Changes land status to underBidding and land is up for auction.
        // Add entry in auction
        require(Lands[landId].status == LandStatus.registered);
        Auction[landId].highestBid = 0;
        land[landId].status = LandStatus.underBidding;
    }
    
    function payable placeBid() public {
        //TO BE DONE

        // accessible by bidders only
        // params: pass auction Id and 
        // check current bid > last bid, pay amount, update highest bid, 
        // check if there was a last bidder, if yes revert amount of last bidder    
    }

    //This function allows the current owner to view the current highest bid
    function viewHighestBid(uint landId) public onlyOwner(landId){
        // accessed by seller
        // returns highest bid value for the current land
        require(Lands[landId].status == LandStatus.underBidding);
        return Auction[landId].highestBid;
    }

    function terminateAuction() public {
        //TO BE DONE

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
    function transferOwnership(uint landId, address newOwnerId) private onlyOwner(landId){
        // change owner and remove from auction 
        // change land status to sold
        require(Lands[landId].owner != newOwnerId);
        Lands[landId].owner = newOwnerId;
    }
}
