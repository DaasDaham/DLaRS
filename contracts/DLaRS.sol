pragma solidity >=0.7.0 <0.9.0;

contract DLars{
    
    struct landDetails {
        string city;
        string country;
        string landAdress;
        string pinCode;
        address payable currentOwner;
        uint sellingPrice;
        LandStatus status; // 
    }
    
    enum LandStatus {underBidding, registered, sold}
    
    mapping(uint => landDetails) Land;
    
    address owner; // check how multiple owners can be on the blockchain
    
    mapping(uint => auction) Auction;
    
    struct auction {
	    address highestBidder ;
	    uint highestBid;
	    uint landUnderBid;
    }
    
    mapping(uint => address) Bidder;
    
    function addBidders(){
        // regester new bidder to bidder mapping
    }
    
    function registerLand(){
        // Add a new entry in Land mapping with a new id
        // Status of the land will be registered
    }
    
    function putUpForAuction(){
        // Params: LandId, 
        // Changes land status to underBidding and land is up for auction.
        // Add entry in auction
        // Returns auction Id (for seller)
        
    }
    
    function viewLandForAuctions(){
        // params: 
        // Accessed by bidder
        // Lists out land details which are under bidding
    }
    
    function payable placeBid(){
        // accessible by bidders only
        // params: pass auction Id and 
        // check current bid> last bid, pay amount, update highest bid, 
        // check if there was a last bidder, if yes revert amount of last bidder
        
    }
    
    function viewHighestBid(){
        // params: auction Id
        // accessed by seller
        // returns highest bid value for the current land
    }
    
    function terminateAuction(){
        // accessed by owner/highest bidder, accessible only after 30 days of auction start, 
        // change status of land to sold, change owner address, pay money to previous owner
    }
    
    function acceptBid(){
        // prompts auction contract to stop bidding and complete transaction 
        // (auction will take care of guarantee that money will be transferred), 
        // will internally call the transfer ownership function
        
    }
    
    function removeCompletedAuction(){
        // params: auctionId
        // Remove auction from auctions mapping
    }
    
    function transferOwnership(){
        // params: landId, auctionId
        // change owner and remove from auction 
        // change land status to sold
    }
    
}