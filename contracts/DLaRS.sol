pragma solidity >=0.7.0 <0.9.0;

contract DLars{

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

    function placeBid(address payable _receiver, uint256 amount) public payable {
        //PaymentReceived[_landId] = true;
        uint256 amntToRed = msg.value - 5;
        _receiver.transfer(amntToRed);
    }
    
    /*function placeBid(uint landId, uint currentBid) public payable{
        //TO BE DONE
        require(msg.sender!=Lands[landId].currentOwner);
        require(Auction[landId].highestBid<currentBid);
        require(Lands[landId].askingPrice<currentBid);
        require(Lands[landId].status==LandStatus.underBidding);
        //if (Auction[landId].highestBid>0){
        //    Auction[landId].highestBidder.transfer(Auction[landId].highestBid);
        //}
        payable(Lands[landId].currentOwner).transfer(currentBid-Auction[landId].highestBid);
        Auction[landId].highestBidder = payable(msg.sender);
        Auction[landId].highestBid = currentBid;
        Auction[landId].highestBidTimestamp = block.timestamp;
        // accessible by bidders only
        // params: pass auction Id and 
        // check current bid > last bid, pay amount, update highest bid, 
        // check if there was a last bidder, if yes revert amount of last bidder    

    }*/

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