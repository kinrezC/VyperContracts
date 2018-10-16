secret: bytes32
word: bytes[5]
owner: address

@public
def __init__(word: bytes[5]):
	self.secret = sha3(word)
	self.owner = msg.sender	

@public
@payable
def deposit():
	assert self.owner == msg.sender

@public
@payable
def __default__():
	self.deposit()	

