pragma solidity ^0.5.0;

/**
 * @title traceability
 * @dev Contract with abstraction for traceability in a supply chain
 */
 
contract traceability {
  /**
  * @dev Define the structure for a basic product
  */
  struct Property {
    string name;
    string description;
    string location;
    string Producer;
    uint32 salePrice;
    uint256 CreationDate;
    
    bool exist;
  }

  /**
  * @dev Mapping that define the storage of a product
  */
  mapping(string  => Property) private StorageProperty;
  mapping(address => mapping(string => bool)) private wallet;


    /**
  * @dev Declare events according the supply chain operations:
  */
  event CreateProperty(address addressProducer, string id, string Producer, uint256 CreationDate);
  event TransferProperty(address from, address to, string id);
  //event setPrice(string id, uint32 salePrice);
  event TransferReject(address from, address to, string id, string RejectMessage);
  event CreationReject(address addressProducer, string id, string RejectMessage);

  /**
  * @dev Function that create the Product:
  */
  function creationProperty(string memory name, string memory description, string memory id, string memory Producer, string memory location,  uint32 salePrice) public {
 
    if(StorageProperty[id].exist) {
        emit CreationReject(msg.sender, id, "Property on this id already exist");
        return;
      }
 
      StorageProperty[id] = Property(name, description, location, Producer, salePrice, now, true);
      wallet[msg.sender][id] = true;
      emit CreateProperty(msg.sender, id, Producer, now);
    }

  /**
  * @dev Function that makes the transfer of ownership of a Product:
  */
  function transfProperty(address to, string memory id) public{
 
    if(!StorageProperty[id].exist) {
        emit TransferReject(msg.sender, to, id, "It does not exist a Property with this id");
        return;
    }
 
    if(!wallet[msg.sender][id]) {
        emit TransferReject(msg.sender, to, id, "user is not the owner of this Property.");
        return;
    }
 
    wallet[msg.sender][id] = false;
    wallet[to][id] = true;
    emit TransferProperty (msg.sender, to, id);
  }

  /**
  * @dev Getter of the characteristic of a product:
  */
  function getProperty(string memory id) public view returns  (string memory, string memory, string memory, string memory, uint256) {
 
    return (StorageProperty[id].name, StorageProperty[id].description, StorageProperty[id].Producer, StorageProperty[id].location, StorageProperty[id].salePrice);
  }

  /**
  * @dev Funcion to check the ownership of a product:
  */
  function isOwner(address owner, string memory id) public view returns (bool) {
 
    if(wallet[owner][id]) {
        return true;
    }
 
    return false;
  }
}
